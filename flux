--// ================= KEY SYSTEM =================
local pastebin_url = "https://pastebin.com/raw/iqUqidPB"

if not script_key then
    warn("[KeySystem] No key provided.")
    return
end

local success, keys_raw = pcall(function()
    return game:HttpGet(pastebin_url)
end)

if not success or not keys_raw then
    warn("[KeySystem] Failed to fetch key list.")
    return
end

local valid = false
for key in keys_raw:gmatch("[^\r\n]+") do
    if key == script_key then
        valid = true
        break
    end
end

if not valid then
    warn("[KeySystem] Invalid key. Script stopped.")
    return
end

print("[KeySystem] Key accepted.")

--// ================= SERVICES =================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local GuiService = game:GetService("GuiService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

--// ================= CONFIG =================
local CONFIG = getgenv().Configurations
local WS = getgenv().walkSpeedSettings
local JS = getgenv().jumpSettings

assert(CONFIG, "Configurations table not found")
assert(WS, "walkSpeedSettings table not found")
assert(JS, "jumpSettings table not found")

--// ================= VARIABLES =================
-- Camera Aimbot
local camHolding = false
local target = nil
local bindName = CONFIG.binds and CONFIG.binds['camera aimbot']
local aimbotKey = Enum.KeyCode[bindName] or Enum.KeyCode.Unknown

-- WalkSpeed
local wsEnabled = false
local defaultSpeed = 16
local wsKey = Enum.KeyCode[WS.Activation.WalkSpeedKey] or Enum.KeyCode.Unknown

-- Jump
local jumpEnabled = false
local defaultJump = 50
local jumpKey = Enum.KeyCode[JS.Activation.JumpKey] or Enum.KeyCode.Unknown

--// ================= FOV CIRCLE =================
local FOV = Drawing.new("Circle")
FOV.Visible = false
FOV.Thickness = CONFIG.fov_circle.thickness
FOV.Filled = CONFIG.fov_circle.filled
FOV.Transparency = CONFIG.fov_circle.transparency
FOV.Color = Color3.fromRGB(table.unpack(CONFIG.fov_circle.color))

--// ================= INPUT =================
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end

    -- Camera Aimbot
    if CONFIG.camera_aimbot.enabled and input.KeyCode == aimbotKey then
        if CONFIG.camera_aimbot.mode == "Toggle" then
            camHolding = not camHolding
            if not camHolding then target = nil end
        else
            camHolding = true
        end
    end

    -- WalkSpeed
    if WS.WalkSpeed.Enabled and input.KeyCode == wsKey then
        if WS.Activation.Mode == "Toggle" then
            wsEnabled = not wsEnabled
        elseif WS.Activation.Mode == "Hold" then
            wsEnabled = true
        end
    end

    -- Jump
    if JS.Jump.Enabled and input.KeyCode == jumpKey then
        if JS.Activation.Mode == "Toggle" then
            jumpEnabled = not jumpEnabled
        elseif JS.Activation.Mode == "Hold" then
            jumpEnabled = true
        end
    end
end)

UIS.InputEnded:Connect(function(input)
    -- Camera Aimbot
    if input.KeyCode == aimbotKey and CONFIG.camera_aimbot.mode == "Hold" then
        camHolding = false
        target = nil
    end

    -- WalkSpeed
    if input.KeyCode == wsKey and WS.Activation.Mode == "Hold" then
        wsEnabled = false
    end

    -- Jump
    if input.KeyCode == jumpKey and JS.Activation.Mode == "Hold" then
        jumpEnabled = false
    end
end)

--// ================= HELPER FUNCTIONS =================
local bodyParts = {
    "Head",
    "HumanoidRootPart",
    "Left Arm",
    "Right Arm",
    "Left Leg",
    "Right Leg"
}

-- Finds closest part based on config mode
local function GetClosestTarget()
    local closest, shortest = nil, math.huge
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                local partsToCheck = {}
                if CONFIG.targeting.mode == "Closest" then
                    for _, name in ipairs(bodyParts) do
                        local p = plr.Character:FindFirstChild(name)
                        if p then table.insert(partsToCheck, p) end
                    end
                else
                    local p = plr.Character:FindFirstChild(CONFIG.targeting.hitpart)
                    if p then table.insert(partsToCheck, p) end
                end

                for _, part in ipairs(partsToCheck) do
                    local pos, onScreen = Camera:WorldToScreenPoint(part.Position)
                    if onScreen then
                        local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                        if dist <= CONFIG.fov_circle.size and dist < shortest then
                            shortest = dist
                            closest = part
                        end
                    end
                end
            end
        end
    end
    return closest
end

--// ================= MAIN LOOP =================
RunService.RenderStepped:Connect(function()
    -- Camera Aimbot FOV
    if CONFIG.fov_circle.enabled and CONFIG.fov_circle.visibility == "Show" then
        FOV.Visible = true
        FOV.Radius = CONFIG.fov_circle.size
        FOV.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    else
        FOV.Visible = false
    end

    -- Sticky Aimbot
    if CONFIG.camera_aimbot.enabled and camHolding then
        if not target or not CONFIG.camera_aimbot.sticky then
            target = GetClosestTarget()
        end
    else
        target = nil
    end

    -- WalkSpeed / Jump
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChild("Humanoid")
    if hum then
        if WS.WalkSpeed.Enabled then
            if WS.Activation.Mode == "Always" then wsEnabled = true end
            hum.WalkSpeed = wsEnabled and WS.WalkSpeed.Speed or defaultSpeed
        end
        if JS.Jump.Enabled then
            if JS.Activation.Mode == "Always" then jumpEnabled = true end
            hum.JumpPower = jumpEnabled and JS.Jump.Power or defaultJump
        end
    end
end)

--// ================= CAMERA AIM =================
RunService.RenderStepped:Connect(function()
    if not CONFIG.camera_aimbot.enabled or not camHolding or not target then return end
    local character = target.Parent
    local hum = character and character:FindFirstChildOfClass("Humanoid")
    local root = character and character:FindFirstChild("HumanoidRootPart")

    if hum and hum.Health > 0 and root then
        local cf = Camera.CFrame
        local predictedPosition = target.Position

        if CONFIG.camera_aimbot.prediction.enabled then
            local velocity = root.Velocity
            predictedPosition = predictedPosition
                + Vector3.new(
                    velocity.X * CONFIG.camera_aimbot.prediction.x,
                    velocity.Y * CONFIG.camera_aimbot.prediction.y,
                    velocity.Z * CONFIG.camera_aimbot.prediction.x
                )
        end

        local aimCF = CFrame.new(cf.Position, predictedPosition)
        Camera.CFrame = cf:Lerp(aimCF, CONFIG.camera_aimbot.smoothness)
    else
        target = nil
    end
end)

--// ================= RESET ON RESPAWN =================
LocalPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid")
    char.Humanoid.WalkSpeed = defaultSpeed
    char.Humanoid.JumpPower = defaultJump
    camHolding = false
    target = nil
end)

--// ================= NAME ESP =================
local c = Workspace.CurrentCamera
local ps = Players
local lp = LocalPlayer
local rs = RunService

local function esp(player, character)
    if not CONFIG.name_esp.enabled then return end
    local humanoid = character:WaitForChild("Humanoid")
    local hrp = character:WaitForChild("HumanoidRootPart")

    local text = Drawing.new("Text")
    text.Visible = false
    text.Center = true
    text.Outline = true
    text.Font = 2
    text.Color = Color3.fromRGB(table.unpack(CONFIG.name_esp.color))
    text.Size = CONFIG.name_esp.size or 16

    local c1, c2, c3
    local function destroy()
        text.Visible = false
        text:Remove()
        if c1 then c1:Disconnect() c1 = nil end
        if c2 then c2:Disconnect() c2 = nil end
        if c3 then c3:Disconnect() c3 = nil end
    end

    c2 = character.AncestryChanged:Connect(function(_, parent)
        if not parent then destroy() end
    end)

    c3 = humanoid.HealthChanged:Connect(function(hp)
        if hp <= 0 then destroy() end
    end)

    c1 = rs.RenderStepped:Connect(function()
        if not CONFIG.name_esp.enabled then
            destroy()
            return
        end
        local pos, onScreen = c:WorldToViewportPoint(hrp.Position)
        if onScreen then
            text.Position = Vector2.new(pos.X, pos.Y - 15)
            text.Text = player.Name
            text.Size = CONFIG.name_esp.size
            text.Visible = true
        else
            text.Visible = false
        end
    end)
end

local function onPlayerAdded(player)
    if player == lp then return end
    if player.Character then esp(player, player.Character) end
    player.CharacterAdded:Connect(function(char)
        esp(player, char)
    end)
end

for _, p in ipairs(ps:GetPlayers()) do onPlayerAdded(p) end
ps.PlayerAdded:Connect(onPlayerAdded)

--// ================= SILENT AIM =================
local SilentConfig = CONFIG.silent_aim
local silentEnabled = SilentConfig.mode == "Always"
local silentHolding = false
local silentKey = Enum.KeyCode[SilentConfig.toggleKey] or Enum.KeyCode.Unknown

-- Create FOV Circle
local circle = Drawing.new("Circle")
circle.Color = Color3.fromRGB(table.unpack(CONFIG.fov_circle.color))
circle.Thickness = CONFIG.fov_circle.thickness
circle.Filled = CONFIG.fov_circle.filled
circle.Transparency = SilentConfig.FOVTransparency
circle.Radius = SilentConfig.FOVRadius
circle.Visible = SilentConfig.FOVVisible and silentEnabled

-- Create Tracer (HumanoidRootPart)
local tracer = Drawing.new("Line")
tracer.Visible = false
tracer.Thickness = 1
tracer.Color = Color3.fromRGB(255, 255, 255)
tracer.Transparency = 1

local function SilentActive()
    if not SilentConfig.enabled then return false end
    if SilentConfig.mode == "Always" then return true end
    if SilentConfig.mode == "Toggle" then return silentEnabled end
    if SilentConfig.mode == "Hold" then return silentHolding end
    return false
end

-- Closest target for Silent Aim
local function GetClosestForSilent()
    local closest, distance = nil, SilentConfig.FOVRadius
    for _, v in ipairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = v.Character.HumanoidRootPart
            local pos, onScreen = Camera:WorldToScreenPoint(hrp.Position)
            if onScreen then
                local diff = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if diff < distance then
                    distance = diff
                    closest = v
                end
            end
        end
    end
    return closest
end

-- Update FOV & Tracer
RunService.RenderStepped:Connect(function()
    local guiInset = GuiService:GetGuiInset()

    -- FOV Circle
    circle.Position = Vector2.new(Mouse.X, Mouse.Y + guiInset.Y)
    circle.Radius = SilentConfig.FOVRadius
    circle.Visible = SilentConfig.FOVVisible and SilentActive()

    -- Tracer
    local target = GetClosestForSilent()
    if SilentActive() and target and target.Character then
        local hrp = target.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            if onScreen then
                local mousePos = Vector2.new(Mouse.X, Mouse.Y)
                local diff = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                if diff <= SilentConfig.FOVRadius then
                    tracer.From = mousePos
                    tracer.To = Vector2.new(pos.X, pos.Y)
                    tracer.Visible = true
                else
                    tracer.Visible = false
                end
            else
                tracer.Visible = false
            end
        else
            tracer.Visible = false
        end
    else
        tracer.Visible = false
    end
end)

-- Silent Aim input
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == silentKey then
        if SilentConfig.mode == "Toggle" then
            silentEnabled = not silentEnabled
        elseif SilentConfig.mode == "Hold" then
            silentHolding = true
        end
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.KeyCode == silentKey and SilentConfig.mode == "Hold" then
        silentHolding = false
    end
end)

-- Hook Mouse Hit for perfect tapping
local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldIndex = mt.__index

mt.__index = function(self, key)
    if SilentActive() and self == Mouse and key == "Hit" then
        local target = GetClosestForSilent()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = target.Character.HumanoidRootPart
            local vel = hrp.Velocity
            local prediction = SilentConfig.prediction or 0
            return CFrame.new(hrp.Position + vel * prediction)
        end
    end
    return oldIndex(self, key)
end
setreadonly(mt, true)
