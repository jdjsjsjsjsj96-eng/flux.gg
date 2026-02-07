--// ================= SERVICES =================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

--// ================= CONFIG =================
local CONFIG = getgenv().Configurations
assert(CONFIG, "Configurations not found")

local CAM = CONFIG.camera_aimbot
local BINDS = CONFIG.binds
local TARGET = CONFIG.targeting

--// ================= VARIABLES =================
local holding = false
local targetPart = nil
local camKey = Enum.KeyCode[BINDS.camlock] or Enum.KeyCode.C

--// ================= UTILS =================
local function GetClosestTarget()
    local closest, shortest = nil, CAM.radius
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            local part = plr.Character:FindFirstChild(TARGET.hitpart)

            if hum and hum.Health > 0 and part then
                if TARGET.team_check and plr.Team == LocalPlayer.Team then
                    continue
                end

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

--// ================= INPUT =================
UIS.InputBegan:Connect(function(input, gpe)
    if gpe or not CAM.enabled then return end

    if input.KeyCode == camKey then
        if CAM.mode == "Toggle" then
            holding = not holding
            if not holding then targetPart = nil end
        else
            holding = true
        end
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.KeyCode == camKey and CAM.mode == "Hold" then
        holding = false
        targetPart = nil
    end
end)

--// ================= MAIN LOOP =================
RunService.RenderStepped:Connect(function()
    if not CAM.enabled or not holding then
        targetPart = nil
        return
    end

    if not targetPart or not CAM.sticky then
        targetPart = GetClosestTarget()
    end

    if targetPart and targetPart.Parent then
        local root = targetPart.Parent:FindFirstChild("HumanoidRootPart")
        if not root then return end

        local pos = targetPart.Position

        if CAM.prediction.enabled then
            local vel = root.Velocity
            pos = pos + Vector3.new(
                vel.X * CAM.prediction.x,
                vel.Y * CAM.prediction.y,
                vel.Z * CAM.prediction.z
            )
        end

        local cf = Camera.CFrame
        local aimCF = CFrame.new(cf.Position, pos)
        Camera.CFrame = cf:Lerp(aimCF, CAM.smoothness)
    end
end)

--// ================= RESET =================
LocalPlayer.CharacterAdded:Connect(function()
    holding = false
    targetPart = nil
end)
