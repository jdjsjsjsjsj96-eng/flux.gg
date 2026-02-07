--// Made by Endo / @1ay
--// Config-driven rewrite (NO GUI)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local cfg = shared.Config and shared.Config['Silent Aim']
if not cfg then return end

--// Apply config → globals Endo logic expects
getgenv().Prediction = cfg['prediction']
getgenv().ResolveKey = cfg['resolver key']
getgenv().Radius = cfg['distance']
getgenv().JumpSmoothness = cfg['jump smoothing']
getgenv().Diameter = cfg['jump offset']
getgenv().Smoothing = cfg['smoothing']

--// States
local silentAim = cfg['Enabled']
local resolver = cfg['resolver']
local target
local ResolvedVelocity

--// Mode handling
UIS.InputBegan:Connect(function(i, g)
    if g then return end

    if i.KeyCode == Enum.KeyCode[cfg['toggle key']] then
        if cfg['mode'] == 'Toggle' then
            silentAim = not silentAim
        elseif cfg['mode'] == 'Hold' then
            silentAim = true
        end
    end

    if i.KeyCode == Enum.KeyCode[cfg['resolver key']] then
        resolver = not resolver
    end
end)

UIS.InputEnded:Connect(function(i)
    if cfg['mode'] == 'Hold'
    and i.KeyCode == Enum.KeyCode[cfg['toggle key']] then
        silentAim = false
    end
end)

--// Resolver
local Stored, Index = {}, 1
local function resolveVelocity(part)
    local t = tick()
    Stored[Index] = {pos = part.Position, time = t}
    Index = (Index % 5) + 1

    local d = Stored[Index]
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
        Camera.CFrame.Position,
        (pos - Camera.CFrame.Position) * 1000,
        params
    )
end

--// KO check
local function isKO(plr)
    local h = plr.Character and plr.Character:FindFirstChild("Humanoid")
    return h and h.Health <= 1
end

--// Target selector
local function getTarget()
    local closest, dist = nil, getgenv().Radius

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and not isKO(p) then
            local part = p.Character:FindFirstChild(cfg['Hit Part'])
            if part then
                local screen, vis = Camera:WorldToViewportPoint(part.Position)
                if vis then
                    local mag = (
                        Vector2.new(screen.X, screen.Y) -
                        Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
                    ).Magnitude

                    if mag < dist and wallCheck(part.Position) then
                        closest = p
                        dist = mag
                    end
                end
            end
        end
    end

    return closest
end

--// Aim math (Endo-style)
local function aimAt(plr)
    local char = plr.Character
    if not char then return end

    local part = char[cfg['Hit Part']]
    local vel = ResolvedVelocity or part.Velocity

    local jumping = vel.Y > 1
    local pos = part.Position

    if jumping then
        pos += Vector3.new(0, getgenv().Diameter, 0)
    end

    return pos + vel * getgenv().Prediction
end

--// Tool hook
local function hookTool(tool)
    tool.Activated:Connect(function()
        if silentAim and target then
            game.ReplicatedStorage.MAINEVENT:FireServer(
                "MOUSE",
                aimAt(target)
            )
        end
    end)
end

--// Character hook
local function onChar(char)
    char.DescendantAdded:Connect(function(d)
        if d:IsA("Tool") then
            hookTool(d)
        end
    end)
end

if LP.Character then onChar(LP.Character) end
LP.CharacterAdded:Connect(onChar)

--// Main loop
RunService.RenderStepped:Connect(function()
    if silentAim then
        target = getTarget()
    else
        target = nil
    end

    if resolver and target and target.Character then
        ResolvedVelocity = resolveVelocity(
            target.Character[cfg['Hit Part']]
        )
    else
        ResolvedVelocity = nil
    end
end)
