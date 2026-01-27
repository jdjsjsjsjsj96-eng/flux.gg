--// ================= SERVICES =================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--// ================= VARIABLES =================
local holding = false
local target = nil

local KEY = Enum.KeyCode[getgenv().aimbotv1.binds['camera aimbot']]
local CONFIG = getgenv().aimbotv1

--// ================= INPUT =================
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == KEY then
        if CONFIG.camera_aimbot.mode == "Toggle" then
            holding = not holding
        else
            holding = true
        end
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.KeyCode == KEY and CONFIG.camera_aimbot.mode == "Hold" then
        holding = false
    end
end)

--// ================= TARGET SELECTION =================
local function GetClosestTarget()
    local closest, shortest = nil, math.huge
    local center = Vector2.new(
        Camera.ViewportSize.X / 2,
        Camera.ViewportSize.Y / 2
    )

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
    if not CONFIG.camera_aimbot.enabled then
        target = nil
        return
    end

    if holding then
        target = GetClosestTarget()
    else
        target = nil
    end
end)

--// ================= CAMERA AIM =================
RunService.RenderStepped:Connect(function()
    if holding and target and target.Parent then
        local hum = target.Parent:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health > 0 then
            local cf = Camera.CFrame
            local aimCF = CFrame.new(cf.Position, target.Position)
            Camera.CFrame = cf:Lerp(aimCF, 1) -- smoothness = 100
        else
            target = nil
        end
    end
end)
