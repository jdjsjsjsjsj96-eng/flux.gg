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
local holding = false
local target = nil
local aimbotKey = Enum.KeyCode[CONFIG.binds['camera aimbot']]

-- WalkSpeed
local wsEnabled = false
local defaultSpeed = 16
local wsKey = Enum.KeyCode[WS.Activation.WalkSpeedKey]

-- Jump
local jumpEnabled = false
local defaultJump = 50
local jumpKey = Enum.KeyCode[JS.Activation.JumpKey]

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

--// ================= INPUT =================
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end

    -- Camera Aimbot
    if CONFIG.camera_aimbot.enabled and input.KeyCode == aimbotKey then
        if CONFIG.camera_aimbot.mode == "Toggle" then
            holding = not holding
            if not holding then target = nil end
        else
            holding = true
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
        holding = false
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

--// ================= TARGET SELECTION =================
local function GetClosestTarget()
    local closest, shortest = nil, math.huge
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            local part = plr.Character:FindFirstChild(CONFIG.targeting.hitpart)

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
    -- Camera Aimbot FOV
    if CONFIG.fov_circle.enabled and CONFIG.fov_circle.visibility == "Show" then
        FOV.Visible = true
        FOV.Radius = CONFIG.fov_circle.size
        FOV.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    else
        FOV.Visible = false
    end

    -- Sticky Aimbot
    if CONFIG.camera_aimbot.enabled and holding then
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

--// ================= CAMERA AIM (with X/Y prediction) =================
RunService.RenderStepped:Connect(function()
    if not CONFIG.camera_aimbot.enabled or not holding or not target then return end
    local character = target.Parent
    local hum = character and character:FindFirstChildOfClass("Humanoid")
    local root = character and character:FindFirstChild("HumanoidRootPart")

    if hum and hum.Health > 0 and root then
        local cf = Camera.CFrame

        -- predicted position
        local predictedPosition = target.Position
        if CONFIG.camera_aimbot.prediction and CONFIG.camera_aimbot.prediction.enabled then
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
    holding = false
    target = nil
end)


local function esp(player, character)
    local humanoid = character:WaitForChild("Humanoid")
    local hrp = character:WaitForChild("HumanoidRootPart")

    local text = Drawing.new("Text")
    text.Visible = false
    text.Center = true
    text.Outline = true
    text.Font = 2
    text.Color = Color3.fromRGB(255,255,255)
    text.Size = CONFIG.name_esp.size or 16

    local c1, c2, c3

    local function destroy()
        text.Visible = false
        text:Remove()
        if c1 then c1:Disconnect() end
        if c2 then c2:Disconnect() end
        if c3 then c3:Disconnect() end
    end

    c2 = character.AncestryChanged:Connect(function(_, parent)
        if not parent then destroy() end
    end)

    c3 = humanoid.HealthChanged:Connect(function(hp)
        if hp <= 0 then destroy() end
    end)

    c1 = RunService.RenderStepped:Connect(function()
        if not CONFIG.name_esp.enabled then destroy() return end
        local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
        if onScreen then
            text.Position = Vector2.new(pos.X, pos.Y - 15)
            text.Text = player.Name
            text.Visible = true
        else
            text.Visible = false
        end
    end)
end



--// ================= SILENT AIM =================
local SilentConfig = CONFIG.silent_aim
local silentEnabled = SilentConfig.mode == "Always" and true or false
local holding = false
local silentKey = Enum.KeyCode[SilentConfig.toggleKey]

-- Create FOV Circle (matches aimbot style)
local circle
pcall(function()
    circle = Drawing.new("Circle")
    circle.Color = Color3.fromRGB(table.unpack(CONFIG.fov_circle.color))
    circle.Thickness = CONFIG.fov_circle.thickness
    circle.Filled = CONFIG.fov_circle.filled
    circle.Transparency = SilentConfig.FOVTransparency
    circle.Radius = SilentConfig.FOVRadius
    circle.Visible = SilentConfig.FOVVisible and silentEnabled
end)

-- Function to check if Silent Aim is active
local function SilentActive()
    if not SilentConfig.enabled then return false end
    if SilentConfig.mode == "Always" then return true end
    if SilentConfig.mode == "Toggle" then return silentEnabled end
    if SilentConfig.mode == "Hold" then return holding end
    return false
end

-- Update FOV Circle
RunService.RenderStepped:Connect(function()
    if not circle then return end
    pcall(function()
        local guiInset = game:GetService("GuiService"):GetGuiInset()
        circle.Position = Vector2.new(Mouse.X, Mouse.Y + guiInset.Y)
        circle.Radius = SilentConfig.FOVRadius
        circle.Transparency = SilentConfig.FOVTransparency
        circle.Visible = SilentConfig.FOVVisible and SilentActive()
    end)
end)

-- Input handling
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == silentKey then
        if SilentConfig.mode == "Toggle" then
            silentEnabled = not silentEnabled
        elseif SilentConfig.mode == "Hold" then
            holding = true
        end
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.KeyCode == silentKey and SilentConfig.mode == "Hold" then
        holding = false
    end
end)

-- Find closest target for Silent Aim
local function GetClosestForSilent()
    local closest, distance = nil, SilentConfig.FOVRadius
    for _, v in ipairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild(SilentConfig.targetPart) then
            local pos, onScreen = Camera:WorldToScreenPoint(v.Character[SilentConfig.targetPart].Position)
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

-- Hook Mouse Hit for Silent Aim
local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldIndex = mt.__index

mt.__index = function(self, key)
    if SilentActive() and self == Mouse and key == "Hit" then
        local target = GetClosestForSilent()
        if target and target.Character and target.Character:FindFirstChild(SilentConfig.targetPart) then
            local part = target.Character[SilentConfig.targetPart]
            return part.CFrame + (part.Velocity * SilentConfig.prediction)
        end
    end
    return oldIndex(self, key)
end
setreadonly(mt, true)  replace any esp with this local c = workspace.CurrentCamera
local ps = game:GetService("Players")
local lp = ps.LocalPlayer
local rs = game:GetService("RunService")

local function esp(p,cr)
    local h = cr:WaitForChild("Humanoid")
    local hrp = cr:WaitForChild("HumanoidRootPart")

    local text = Drawing.new("Text")
    text.Visible = false
    text.Center = true
    text.Outline = true 
    text.Font = 2
    text.Color = Color3.fromRGB(255,255,255)
    text.Size = 13

    local c1
    local c2
    local c3

    local function dc()
        text.Visible = false
        text:Remove()
        if c1 then
            c1:Disconnect()
            c1 = nil 
        end
        if c2 then
            c2:Disconnect()
            c2 = nil 
        end
        if c3 then
            c3:Disconnect()
            c3 = nil 
        end
    end

    c2 = cr.AncestryChanged:Connect(function(_,parent)
        if not parent then
            dc()
        end
    end)

    c3 = h.HealthChanged:Connect(function(v)
        if (v<=0) or (h:GetState() == Enum.HumanoidStateType.Dead) then
            dc()
        end
    end)

    c1 = rs.RenderStepped:Connect(function()
        local hrp_pos,hrp_onscreen = c:WorldToViewportPoint(hrp.Position)
        if hrp_onscreen then
            text.Position = Vector2.new(hrp_pos.X, hrp_pos.Y)
            text.Text = p.Name
            text.Visible = true
        else
            text.Visible = false
        end
    end)
end

local function p_added(p)
    if p.Character then
        esp(p,p.Character)
    end
    p.CharacterAdded:Connect(function(cr)
        esp(p,cr)
    end)
end

for i,p in next, ps:GetPlayers() do 
    if p ~= lp then
        p_added(p)
    end
end

ps.PlayerAdded:Connect(p_added)  can we replace that name esp with this? local function esp(player, character)
    if not CONFIG.name_esp.enabled then return end

    local humanoid = character:WaitForChild("Humanoid")
    local hrp = character:WaitForChild("HumanoidRootPart")

    local text = Drawing.new("Text")
    text.Visible = false
    text.Center = true
    text.Outline = true
    text.Font = 2
    text.Color = Color3.fromRGB(255, 255, 255)
    text.Size = CONFIG.name_esp.size or 16

    local c1, c2, c3

    local function destroy()
        text.Visible = false
        text:Remove()
        if c1 then c1:Disconnect() c1 = nil end
        if c2 then c2:Disconnect() c2 = nil end
        if c3 then c3:Disconnect() c3 = nil end
    end

    -- Character removed
    c2 = character.AncestryChanged:Connect(function(_, parent)
        if not parent then destroy() end
    end)

    -- Death cleanup
    c3 = humanoid.HealthChanged:Connect(function(hp)
        if hp <= 0 then destroy() end
    end)

    -- Render loop
    c1 = rs.RenderStepped:Connect(function()
        if not CONFIG.name_esp.enabled then
            destroy()
            return
        end

        local pos, onScreen = c:WorldToViewportPoint(hrp.Position)
        if onScreen then
            text.Position = Vector2.new(pos.X, pos.Y - 15) -- same offset as before
            text.Text = player.Name
            text.Size = CONFIG.name_esp.size
            text.Visible = true
        else
            text.Visible = false
        end
    end)
end
