--// ================= SERVICES =================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--// ================= VARIABLES =================
-- Aimbot
local holding = false
local target = nil
local aimbotKey = Enum.KeyCode[getgenv().aimbotv1.binds['camera aimbot']]
local CONFIG = getgenv().aimbotv1

-- WalkSpeed
local wsEnabled = false
local defaultSpeed = 16
local wsConfig = getgenv().walkSpeedSettings
local wsKey = Enum.KeyCode[wsConfig.Activation.WalkSpeedKey]

--// ================= INPUT =================
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    -- Camera Aimbot
    if input.KeyCode == aimbotKey then
        if CONFIG.camera_aimbot.mode == "Toggle" then
            holding = not holding
        else -- Hold mode
            holding = true
        end
    end

    -- WalkSpeed
    if input.KeyCode == wsKey then
        if wsConfig.Activation.Mode == "Toggle" then
            wsEnabled = not wsEnabled
        elseif wsConfig.Activation.Mode == "Hold" then
            wsEnabled = true
        end
    end
end)

UIS.InputEnded:Connect(function(input)
    -- Camera Aimbot
    if input.KeyCode == aimbotKey and CONFIG.camera_aimbot.mode == "Hold" then
        holding = false
    end

    -- WalkSpeed
    if input.KeyCode == wsKey and wsConfig.Activation.Mode == "Hold" then
        wsEnabled = false
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
                    if dist < shortest then
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
    -- Camera Aimbot
    if not CONFIG.camera_aimbot.enabled then
        target = nil
        holding = false
    elseif holding then
        target = GetClosestTarget()
    else
        target = nil
    end

    -- WalkSpeed
    if wsConfig.WalkSpeed.Enabled then
        if wsConfig.Activation.Mode == "Always" then
            wsEnabled = true
        end

        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            if wsEnabled then
                LocalPlayer.Character.Humanoid.WalkSpeed = wsConfig.WalkSpeed.Speed
            else
                LocalPlayer.Character.Humanoid.WalkSpeed = defaultSpeed
            end
        end
    end
end)

-- Reset walkspeed on respawn
LocalPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid")
    if wsEnabled and wsConfig.WalkSpeed.Enabled then
        char.Humanoid.WalkSpeed = wsConfig.WalkSpeed.Speed
    else
        char.Humanoid.WalkSpeed = defaultSpeed
    end
end)

--// ================= CAMERA AIM =================
RunService.RenderStepped:Connect(function()
    if not CONFIG.camera_aimbot.enabled or not holding or not target then return end
    if target.Parent:FindFirstChildOfClass("Humanoid") then
        local cf = Camera.CFrame
        local aimCF = CFrame.new(cf.Position, target.Position)
        Camera.CFrame = cf:Lerp(aimCF, 1) -- smoothness = 100
    end
end)
