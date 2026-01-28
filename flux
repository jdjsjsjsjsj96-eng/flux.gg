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
FOV.Color = Color3.fromRGB(
    CONFIG.fov_circle.color[1],
    CONFIG.fov_circle.color[2],
    CONFIG.fov_circle.color[3]
)

--// ================= INPUT HANDLING =================
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
    if input.KeyCode == aimbotKey and CONFIG.camera_aimbot.mode == "Hold" then
        camHolding = false
        target = nil
    end

    if input.KeyCode == wsKey and WS.Activation.Mode == "Hold" then
        wsEnabled = false
    end

    if input.KeyCode == jumpKey and JS.Activation.Mode == "Hold" then
        jumpEnabled = false
    end
end)

--// ================= UTILITY FUNCTIONS =================
local function GetClosestPart(character)
    local hitPartName = CONFIG.targeting.hitpart
    local mode = CONFIG.targeting.mode
    local parts = CONFIG.camera_aimbot.parts

    if not character then return nil end

    if mode == "Closest" then
        local closest, shortest = nil, math.huge
        local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

        for _, partName in ipairs(parts) do
            local part = character:FindFirstChild(partName)
            if part then
                local pos, onScreen = Camera:WorldToScreenPoint(part.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if dist < shortest then
                        shortest = dist
                        closest = part
                    end
                end
            end
        end
        return closest
    else
        return character:FindFirstChild(hitPartName)
    end
end

local function GetClosestTarget()
    local closest, shortest = nil, math.huge
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            local part = GetClosestPart(plr.Character)
            if hum and hum.Health > 0 and part then
                local pos, onscreen = Camera:WorldToScreenPoint(part.Position)
                if onscreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if dist <= CONFIG.fov_circle.size and dist < shortest then
                        shortest = dist
                        closest = part
                    end
                end
            end
        end
    end
    return closest
end

--// ================= MAIN LOOP =================
RunService.RenderStepped:Connect(function()
    -- Camera FOV
    if CONFIG.fov_circle.enabled and CONFIG.fov_circle.visibility == "Show" then
        FOV.Visible = true
        FOV.Radius = CONFIG.fov_circle.size
        FOV.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    else
        FOV.Visible = false
    end

    -- Sticky Camera Aimbot
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

--// ================= CAMERA AIM WITH PREDICTION =================
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

--// ================= SILENT AIM =================
local SilentConfig = CONFIG.silent_aim
local silentEnabled = SilentConfig.mode == "Always"
local silentHolding = false
local silentKey = Enum.KeyCode[SilentConfig.toggleKey] or Enum.KeyCode.Unknown

-- FOV Circle for Silent Aim
local circle = Drawing.new("Circle")
circle.Color = Color3.fromRGB(table.unpack(CONFIG.fov_circle.color))
circle.Thickness = CONFIG.fov_circle.thickness
circle.Filled = CONFIG.fov_circle.filled
circle.Transparency = SilentConfig.FOVTransparency
circle.Radius = SilentConfig.FOVRadius
circle.Visible = SilentConfig.FOVVisible and silentEnabled

-- Tracer
local tracer = Drawing.new("Line")
tracer.Visible = false
tracer.Thickness = 1
tracer.Color = Color3.fromRGB(255, 255, 255)
tracer.Transparency = 1

-- Silent Aim Active Check
local function SilentActive()
    if not SilentConfig.enabled then return false end
    if SilentConfig.mode == "Always" then return true end
    if SilentConfig.mode == "Toggle" then return silentEnabled end
    if SilentConfig.mode == "Hold" then return silentHolding end
    return false
end

-- Get Closest Part for Silent Aim
local function GetClosestPartSilent(character)
    local targetPart = SilentConfig.targetPart
    local mode = CONFIG.targeting.mode
    local parts = SilentConfig.parts

    if not character then return nil end

    if mode == "Closest" then
        local closest, shortest = nil, math.huge
        local mousePos = Vector2.new(Mouse.X, Mouse.Y)

        for _, partName in ipairs(parts) do
            local part = character:FindFirstChild(partName)
            if part then
                local pos, onScreen = Camera:WorldToScreenPoint(part.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                    if dist < shortest then
                        shortest = dist
                        closest = part
                    end
                end
            end
        end
        return closest
    else
        return character:FindFirstChild(targetPart)
    end
end

-- Get Closest Target for Silent Aim
local function GetClosestForSilent()
    local closest, distance = nil, SilentConfig.FOVRadius
    for _, v in ipairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character then
            local part = GetClosestPartSilent(v.Character)
            if part then
                local pos, onScreen = Camera:WorldToScreenPoint(part.Position)
                if onScreen then
                    local diff = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                    if diff < distance then
                        distance = diff
                        closest = v
                    end
                end
            end
        end
    end
    return closest
end

-- Update Silent Aim FOV & Tracer (Perfect Mouse Alignment)
RunService.RenderStepped:Connect(function()
    -- FOV Circle
    circle.Position = Vector2.new(Mouse.X, Mouse.Y) -- directly on mouse
    circle.Radius = SilentConfig.FOVRadius
    circle.Visible = SilentConfig.FOVVisible and SilentActive()

    -- Tracer
    local targetPlayer = GetClosestForSilent()
    if SilentActive() and targetPlayer and targetPlayer.Character then
        local part = GetClosestPartSilent(targetPlayer.Character) -- use closest part function
        if part then
            local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
            if onScreen then
                local mousePos = Vector2.new(Mouse.X, Mouse.Y) -- no offsets at all
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



-- Silent Aim Input
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

-- Hook Mouse Hit for Silent Aim
local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldIndex = mt.__index

mt.__index = function(self, key)
    if SilentActive() and self == Mouse and key == "Hit" then
        local targetPlayer = GetClosestForSilent()
        if targetPlayer and targetPlayer.Character then
            local part = GetClosestPartSilent(targetPlayer.Character)
            if part then
                local vel = part.Velocity
                local pred = SilentConfig.prediction or 0
                return CFrame.new(part.Position + vel * pred)
            end
        end
    end
    return oldIndex(self, key)
end
setreadonly(mt, true)
