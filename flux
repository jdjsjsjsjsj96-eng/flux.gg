--// ================= SERVICES =================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--// ================= CONFIG =================
local CONFIG = getgenv().Configurations
local WS = getgenv().walkSpeedSettings
local JS = getgenv().jumpSettings

assert(CONFIG, "Configurations table not found")
assert(WS, "walkSpeedSettings table not found")
assert(JS, "jumpSettings table not found")

--// ================= VARIABLES =================
-- Aimbot
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
    if input.KeyCode == aimbotKey and CONFIG.camera_aimbot.mode == "Hold" then
        holding = false
        target = nil
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
    if CONFIG.camera_aimbot.enabled and holding then
        if not target or not CONFIG.camera_aimbot.sticky then
            target = GetClosestTarget()
        end
    else
        target = nil
    end

    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChild("Humanoid")

    if hum then
        -- WalkSpeed
        if WS.WalkSpeed.Enabled then
            if WS.Activation.Mode == "Always" then wsEnabled = true end
            hum.WalkSpeed = wsEnabled and WS.WalkSpeed.Speed or defaultSpeed
        end

        -- JumpPower
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
                    velocity.X * CONFIG.camera_aimbot.prediction.x, -- horizontal
                    velocity.Y * CONFIG.camera_aimbot.prediction.y, -- vertical
                    velocity.Z * CONFIG.camera_aimbot.prediction.x  -- horizontal/depth
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
        if ESPs[player] then return end -- already exists
        local character = player.Character
        if not character then return end

        local hum = character:FindFirstChild("Humanoid")
        local head = character:FindFirstChild("Head")
        if not hum or not head then return end

        local text = Drawing.new("Text")
        text.Visible = false
        text.Center = true
        text.Outline = true
        text.Font = 3
        text.Size = CONFIG.name_esp.size
        text.Color = Color3.fromRGB(table.unpack(CONFIG.name_esp.color))

        ESPs[player] = {Text = text, Humanoid = hum, Head = head}

        -- clean up when character dies
        hum.Died:Connect(function()
            if text then text:Remove() end
            ESPs[player] = nil
        end)
    end

    local function removeESP(player)
        if ESPs[player] then
            if ESPs[player].Text then ESPs[player].Text:Remove() end
            ESPs[player] = nil
        end
    end

    -- create ESP for existing players
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            createESP(player)
            player.CharacterAdded:Connect(function()
                createESP(player)
            end)
        end
    end

    -- auto-create/remove ESP when players join/leave
    Players.PlayerAdded:Connect(function(player)
        if player ~= LocalPlayer then
            createESP(player)
            player.CharacterAdded:Connect(function()
                createESP(player)
            end)
        end
    end)
    Players.PlayerRemoving:Connect(removeESP)

    -- update ESPs every 0.5 seconds
    spawn(function()
        while true do
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
            task.wait(0.5) -- refresh every 0.5s
        end
    end)
end
