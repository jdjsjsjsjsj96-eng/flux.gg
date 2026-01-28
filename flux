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
local camTarget = nil
local aimbotKey = Enum.KeyCode[CONFIG.binds['camera aimbot']]

-- WalkSpeed
local wsEnabled = false
local defaultSpeed = 16
local wsKey = Enum.KeyCode[WS.Activation.WalkSpeedKey]

-- Jump
local jumpEnabled = false
local defaultJump = 50
local jumpKey = Enum.KeyCode[JS.Activation.JumpKey]

-- expose cam target for ESP lock inspection
_G.currentCameraTarget = nil

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
            camHolding = not camHolding
            if not camHolding then camTarget = nil end
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
        camTarget = nil
    end

    if input.KeyCode == wsKey and WS.Activation.Mode == "Hold" then
        wsEnabled = false
    end

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
    -- FOV
    if CONFIG.fov_circle.enabled and CONFIG.fov_circle.visibility == "Show" then
        FOV.Visible = true
        FOV.Radius = CONFIG.fov_circle.size
        FOV.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    else
        FOV.Visible = false
    end

    -- Sticky Aimbot
    if CONFIG.camera_aimbot.enabled and camHolding then
        if not camTarget or not CONFIG.camera_aimbot.sticky then
            camTarget = GetClosestTarget()
        end
    else
        camTarget = nil
    end

    _G.currentCameraTarget = camTarget

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
    if not CONFIG.camera_aimbot.enabled or not camHolding or not camTarget then return end

    local char = camTarget.Parent
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")

    if hum and hum.Health > 0 and root then
        local cf = Camera.CFrame
        local predicted = camTarget.Position

        if CONFIG.camera_aimbot.prediction.enabled then
            local vel = root.Velocity
            predicted += Vector3.new(
                vel.X * CONFIG.camera_aimbot.prediction.x,
                vel.Y * CONFIG.camera_aimbot.prediction.y,
                vel.Z * CONFIG.camera_aimbot.prediction.x
            )
        end

        Camera.CFrame = cf:Lerp(CFrame.new(cf.Position, predicted), CONFIG.camera_aimbot.smoothness)
    else
        camTarget = nil
    end
end)

--// ================= RESET =================
LocalPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid")
    char.Humanoid.WalkSpeed = defaultSpeed
    char.Humanoid.JumpPower = defaultJump
    camHolding = false
    camTarget = nil
end)

--// ================= NAME ESP (LOCK INSPECTION) =================
if CONFIG.name_esp.enabled then
    local LOCK = CONFIG.lock_inspection -- ✅ CORRECT SOURCE

    local function esp(player, char)
        local hum = char:WaitForChild("Humanoid", 5)
        local hrp = char:WaitForChild("HumanoidRootPart", 5)
        if not hum or not hrp then return end

        local text = Drawing.new("Text")
        text.Center = true
        text.Outline = true
        text.Font = 2
        text.Size = CONFIG.name_esp.size
        text.Text = player.Name
        text.Visible = false

        local function setColor(tbl)
            text.Color = Color3.fromRGB(tbl[1], tbl[2], tbl[3])
        end

        local function offset()
            if CONFIG.name_esp.position == "Above" then
                return Vector2.new(0, -27)
            elseif CONFIG.name_esp.position == "Below" then
                return Vector2.new(0, 27)
            elseif CONFIG.name_esp.position == "Left" then
                return Vector2.new(-50, 0)
            elseif CONFIG.name_esp.position == "Right" then
                return Vector2.new(50, 0)
            end
            return Vector2.zero
        end

        RunService.RenderStepped:Connect(function()
            if not char.Parent or hum.Health <= 0 then
                text.Visible = false
                return
            end

            local pos, vis = Camera:WorldToViewportPoint(hrp.Position)
            if not vis then
                text.Visible = false
                return
            end

            text.Position = Vector2.new(pos.X, pos.Y) + offset()
            text.Visible = true

            -- 🔵 LOCK INSPECTION COLOR LOGIC (FIXED)
            if LOCK
            and LOCK.enabled
            and _G.currentCameraTarget == hrp then
                setColor(LOCK.locked_color)
            else
                setColor(LOCK.normal_color)
            end
        end)
    end

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            if p.Character then
                esp(p, p.Character)
            end
            p.CharacterAdded:Connect(function(c)
                esp(p, c)
            end)
        end
    end

    Players.PlayerAdded:Connect(function(p)
        if p ~= LocalPlayer then
            p.CharacterAdded:Connect(function(c)
                esp(p, c)
            end)
        end
    end)
end
