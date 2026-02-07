--// Silent Aim Logic (Config Based)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local LP = Players.LocalPlayer
local Cam = workspace.CurrentCamera
local CFG = shared.Config['Silent Aim']

local target
local silentActive = false
local resolverActive = CFG['resolver']
local resolvedVelocity

--// Target line
local line
if CFG['Target Line'] then
    line = Drawing.new("Line")
    line.Color = Color3.fromRGB(255,255,255)
    line.Thickness = 1
    line.Visible = false
end

--// Input handling
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end

    if input.KeyCode == Enum.KeyCode[CFG['toggle key']] then
        if CFG['mode'] == 'Toggle' then
            silentActive = not silentActive
        elseif CFG['mode'] == 'Hold' then
            silentActive = true
        end
    end

    if input.KeyCode == Enum.KeyCode[CFG['resolver key']] then
        resolverActive = not resolverActive
    end
end)

UIS.InputEnded:Connect(function(input)
    if CFG['mode'] == 'Hold' and input.KeyCode == Enum.KeyCode[CFG['toggle key']] then
        silentActive = false
    end
end)

--// Velocity resolver
local stored, idx = {}, 1
local function resolveVelocity(part)
    local t = tick()
    stored[idx] = {pos = part.Position, time = t}
    idx = (idx % 5) + 1

    local d = stored[idx]
    if d then
        return (part.Position - d.pos) / (t - d.time)
    end
end

--// Wall check
local function wallCheck(pos)
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {LP.Character}
    params.FilterType = Enum.RaycastFilterType.Blacklist

    return not workspace:Raycast(
        Cam.CFrame.Position,
        (pos - Cam.CFrame.Position) * 1000,
        params
    )
end

--// Get closest target
local function getTarget()
    local closest, dist = nil, CFG['distance']

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character and plr.Character:FindFirstChild(CFG['Hit Part']) then
            local part = plr.Character[CFG['Hit Part']]
            local screen, vis = Cam:WorldToViewportPoint(part.Position)

            if vis then
                local mag = (Vector2.new(screen.X, screen.Y) -
                    Vector2.new(Cam.ViewportSize.X/2, Cam.ViewportSize.Y/2)).Magnitude

                if mag < dist and wallCheck(part.Position) then
                    closest = plr
                    dist = mag
                end
            end
        end
    end

    return closest
end

--// Aim position
local function getAim(plr)
    local char = plr.Character
    if not char then return end

    local part = char[CFG['Hit Part']]
    local vel = (resolverActive and resolvedVelocity) or part.Velocity

    local jumping = vel.Y > 1
    local pos = part.Position

    if jumping then
        pos += Vector3.new(0, CFG['jump offset'], 0)
    end

    return pos + vel * CFG['prediction']
end

--// Tool hook
local function hookTool(tool)
    tool.Activated:Connect(function()
        if (CFG['mode'] == 'Always' or silentActive) and target then
            local pos = getAim(target)
            if pos then
                game.ReplicatedStorage.MAINEVENT:FireServer("MOUSE", pos)
            end
        end
    end)
end

--// Character hook
local function onChar(char)
    char.ChildAdded:Connect(function(c)
        if c:IsA("Tool") then
            hookTool(c)
        end
    end)
end

if LP.Character then onChar(LP.Character) end
LP.CharacterAdded:Connect(onChar)

--// Main loop
RunService.RenderStepped:Connect(function()
    if CFG['mode'] == 'Always' or silentActive then
        target = getTarget()
    else
        target = nil
    end

    if resolverActive and target and target.Character then
        resolvedVelocity = resolveVelocity(target.Character[CFG['Hit Part']])
    end

    -- Target line
    if line then
        if target and (CFG['mode'] == 'Always' or silentActive) then
            local part = target.Character[CFG['Hit Part']]
            local screen = Cam:WorldToViewportPoint(part.Position)

            line.From = Vector2.new(Cam.ViewportSize.X/2, Cam.ViewportSize.Y/2)
            line.To = Vector2.new(screen.X, screen.Y)
            line.Visible = true
        else
            line.Visible = false
        end
    end
end)
