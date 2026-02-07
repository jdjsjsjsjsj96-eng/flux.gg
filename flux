local Players = game:GetService("Players")
local Uis = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local Client = Players.LocalPlayer
local Mouse = Client:GetMouse()
local CF, Vec3, Vec2 = CFrame.new, Vector3.new, Vector2.new

-- Load config
local Config = shared.Ecco['Camlock']

-- Variables
local Aimlock, MousePressed = true, false
local AimlockTarget
local CanNotify = false

-- Helper functions
local function WorldToViewportPoint(P) return Camera:WorldToViewportPoint(P) end
local function WorldToScreenPoint(P) return Camera:WorldToScreenPoint(P) end

local function GetNearestTarget()
    local players, PLAYER_HOLD, DISTANCES = {}, {}, {}
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= Client and v.Character and v.Character:FindFirstChild("Head") then
            table.insert(players, v)
        end
    end

    for i, v in pairs(players) do
        local AIM = v.Character:FindFirstChild("Head")
        if AIM then
            if (Config.TeamCheck == false or v.Team ~= Client.Team) then
                local DISTANCE = (AIM.Position - Camera.CFrame.Position).Magnitude
                local RAY = Ray.new(Camera.CFrame.Position, (Mouse.Hit.Position - Camera.CFrame.Position).Unit * DISTANCE)
                local HIT, POS = workspace:FindPartOnRay(RAY, workspace)
                local DIFF = math.floor((POS - AIM.Position).Magnitude)

                PLAYER_HOLD[v.Name .. i] = {dist = DISTANCE, plr = v, diff = DIFF}
                table.insert(DISTANCES, DIFF)
            end
        end
    end

    if #DISTANCES == 0 then return nil end
    local L_DISTANCE = math.min(unpack(DISTANCES))
    if L_DISTANCE > Config.AimRadius then return nil end

    for _, v in pairs(PLAYER_HOLD) do
        if v.diff == L_DISTANCE then
            return v.plr
        end
    end
end

-- Keybind to toggle aimlock
Mouse.KeyDown:Connect(function(a)
    if not Uis:GetFocusedTextBox() then
        if a == Config.AimlockKey and not AimlockTarget then
            MousePressed = true
            AimlockTarget = GetNearestTarget()
        elseif a == Config.AimlockKey and AimlockTarget then
            AimlockTarget = nil
            MousePressed = false
        end
    end
end)

-- RenderStepped loop
RunService.RenderStepped:Connect(function()
    -- Determine CanNotify based on camera mode
    if Config.ThirdPerson and Config.FirstPerson then
        CanNotify = true
    elseif Config.ThirdPerson and not Config.FirstPerson then
        CanNotify = (Camera.Focus.Position - Camera.CFrame.Position).Magnitude > 1
    elseif not Config.ThirdPerson and Config.FirstPerson then
        CanNotify = true
    end

    if Aimlock and MousePressed and AimlockTarget and AimlockTarget.Character and AimlockTarget.Character:FindFirstChild(Config.AimPart) then
        if Config.FirstPerson and CanNotify then
            local TargetPos = AimlockTarget.Character[Config.AimPart].Position
            if Config.PredictMovement then
                TargetPos = TargetPos + AimlockTarget.Character[Config.AimPart].Velocity / Config.PredictionVelocity
            end

            if Config.Smoothness then
                local Main = CF(Camera.CFrame.Position, TargetPos)
                Camera.CFrame = Camera.CFrame:Lerp(Main, Config.SmoothnessAmount, Enum.EasingStyle.Elastic, Enum.EasingDirection.InOut)
            else
                Camera.CFrame = CF(Camera.CFrame.Position, TargetPos)
            end
        end
    end

    -- Jump check to swap aim part
    if Config.CheckIfJumped and AimlockTarget and AimlockTarget.Character then
        local HRP = AimlockTarget.Character:FindFirstChild("HumanoidRootPart")
        local Hum = AimlockTarget.Character:FindFirstChildOfClass("Humanoid")
        if HRP and Hum then
            if Hum.FloorMaterial == Enum.Material.Air then
                Config.AimPart = "HumanoidRootPart"
            else
                Config.AimPart = Config.OldAimPart
            end
        end
    end
end)
