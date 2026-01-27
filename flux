--// ================= SERVICES =================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--// ================= CONFIG =================
local CONFIG = getgenv().Configurations
local WS = getgenv().walkSpeedSettings

assert(CONFIG, "Configurations table missing")
assert(WS, "walkSpeedSettings table missing")

--// ================= VARIABLES =================
local holding = false
local target = nil
local lockedTarget = nil

local aimbotKey = Enum.KeyCode[CONFIG.binds['camera aimbot']]
local wsKey = Enum.KeyCode[WS.Activation.WalkSpeedKey]

local wsEnabled = false
local defaultSpeed = 16

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
            if not holding then lockedTarget = nil end
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
        elseif WS.Activation.Mode == "Always" then
            wsEnabled = true
        end
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.KeyCode == aimbotKey and CONFIG.camera_aimbot.mode == "Hold" then
        holding = false
        lockedTarget = nil
    end

    if input.KeyCode == wsKey and WS.Activation.Mode == "Hold" then
        wsEnabled = false
    end
end)

--// ================= TARGETING =================
local function GetClosestTarget()
    local closest, shortest = nil, math.huge
    local center = Camera.ViewportSize / 2

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            local part = plr.Character:FindFirstChild(CONFIG.targeting.hitpart)

            if hum and hum.Health > 0 and part then
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

    return closest
end

--// ================= MAIN LOOP =================
RunService.RenderStepped:Connect(function()
    -- FOV circle update
    FOV.Position = Camera.ViewportSize / 2
    FOV.Radius = CONFIG.fov_circle.size
    FOV.Visible = CONFIG.fov_circle.enabled and CONFIG.fov_circle.visibility == "Show"

    -- WalkSpeed
    if WS.WalkSpeed.Enabled then
        if WS.Activation.Mode == "Always" then
            wsEnabled = true
        end

        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChild("Humanoid")
        if hum then
            hum.WalkSpeed = wsEnabled and WS.WalkSpeed.Speed or defaultSpeed
        end
    end

    -- Camera Aimbot Targeting
    if not CONFIG.camera_aimbot.enabled or not holding then
        target = nil
        return
    end

    if CONFIG.camera_aimbot.sticky and lockedTarget then
        if lockedTarget.Parent and lockedTarget.Parent:FindFirstChildOfClass("Humanoid") then
            target = lockedTarget
        else
            lockedTarget = nil
        end
    else
        local newTarget = GetClosestTarget()
        target = newTarget
        if CONFIG.camera_aimbot.sticky then
            lockedTarget = newTarget
        end
    end
end)

--// ================= CAMERA AIM =================
RunService.RenderStepped:Connect(function()
    if not holding or not target then return end

    local hum = target.Parent:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then
        target = nil
        lockedTarget = nil
        return
    end

    local cf = Camera.CFrame
    local aimCF = CFrame.new(cf.Position, target.Position)
    Camera.CFrame = cf:Lerp(aimCF, 1) -- smoothness = 100
end)

--// ================= CLEANUP =================
LocalPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid")
    lockedTarget = nil
end)
