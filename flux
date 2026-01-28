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

--// ================= NAME ESP =================
if CONFIG.name_esp.enabled then
    local ESPs = {} -- store ESPs per player

    local function createESP(player)
        if ESPs[player] then return end
        local character = player.Character
        if not character then return end

        local hum = character:FindFirstChild("Humanoid")
        local head = character:FindFirstChild("Head")
        if not hum or not head then return end

        -- Create the Drawing text once
        local text = Drawing.new("Text")
        text.Visible = true
        text.Center = true
        text.Outline = true
        text.Font = 3
        text.Size = CONFIG.name_esp.size
        text.Color = Color3.fromRGB(table.unpack(CONFIG.name_esp.color))

        ESPs[player] = {Text = text, Humanoid = hum, Head = head}

        hum.Died:Connect(function()
            text:Remove()
            ESPs[player] = nil
        end)
    end

    local function removeESP(player)
        if ESPs[player] then
            ESPs[player].Text:Remove()
            ESPs[player] = nil
        end
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            createESP(player)
            player.CharacterAdded:Connect(function()
                createESP(player)
            end)
        end
    end

    Players.PlayerAdded:Connect(function(player)
        if player ~= LocalPlayer then
            createESP(player)
            player.CharacterAdded:Connect(function()
                createESP(player)
            end)
        end
    end)

    Players.PlayerRemoving:Connect(removeESP)

    RunService.RenderStepped:Connect(function()
        for player, esp in pairs(ESPs) do
            local hum = esp.Humanoid
            local head = esp.Head
            local text = esp.Text

            if hum and hum.Health > 0 and head and head.Parent then
                local headPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen and headPos.Z > 0 then
                    local offset = Vector2.new(0,0)
                    if CONFIG.name_esp.position == "Above" then offset = Vector2.new(0,-27)
                    elseif CONFIG.name_esp.position == "Below" then offset = Vector2.new(0,27)
                    elseif CONFIG.name_esp.position == "Left" then offset = Vector2.new(-50,0)
                    elseif CONFIG.name_esp.position == "Right" then offset = Vector2.new(50,0)
                    end

                    text.Position = Vector2.new(headPos.X, headPos.Y) + offset
                    text.Text = "[ "..player.Name.." ]"
                    text.Visible = true
                else
                    text.Visible = false
                end
            else
                text.Visible = false
            end
        end
    end)
end

--// ================= SILENT AIM =================
local SilentConfig = CONFIG.silent_aim
local silentEnabled = SilentConfig.mode == "Always" and true or false
local silentKey = Enum.KeyCode[SilentConfig.toggleKey]

-- Create FOV Circle
local circle
pcall(function()
    circle = Drawing.new("Circle")
    circle.Color = Color3.fromRGB(255, 255, 255)
    circle.Thickness = 2
    circle.Filled = false
    circle.Transparency = SilentConfig.FOVTransparency
    circle.Radius = SilentConfig.FOVRadius
    circle.Visible = SilentConfig.FOVVisible and silentEnabled
end)

-- Update FOV Circle
local function updateFOVCircle()
    if not circle then return end
    pcall(function()
        local guiInset = game:GetService("GuiService"):GetGuiInset()
        circle.Position = Vector2.new(Mouse.X, Mouse.Y + guiInset.Y)
        circle.Radius = SilentConfig.FOVRadius
        circle.Transparency = SilentConfig.FOVTransparency
        circle.Visible = SilentConfig.FOVVisible and silentEnabled
    end)
end
RunService.RenderStepped:Connect(updateFOVCircle)

-- Silent Aim input handling
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == silentKey then
        if SilentConfig.mode == "Toggle" then
            silentEnabled = not silentEnabled
        elseif SilentConfig.mode == "Hold" then
            silentEnabled = true
        end
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.KeyCode == silentKey and SilentConfig.mode == "Hold" then
        silentEnabled = false
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
local __index = mt.__index

mt.__index = function(self, key)
    if silentEnabled and self == Mouse and key == "Hit" then
        local target = GetClosestForSilent()
        if target and target.Character and target.Character:FindFirstChild(SilentConfig.targetPart) then
            local part = target.Character[SilentConfig.targetPart]
            return (part.CFrame + (part.Velocity * SilentConfig.prediction))
        end
    end
    return __index(self, key)
end
setreadonly(mt, true)
