--// ================= SERVICES =================
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

--// ================= CONFIG =================
local jumpConfig = getgenv().jumpSettings
assert(jumpConfig, "JumpSettings table not found")

--// ================= VARIABLES =================
local jumpEnabled = false
local defaultJumpPower = 50
local jumpKey = Enum.KeyCode[jumpConfig.Activation.JumpKey]

--// ================= INPUT =================
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if not jumpConfig.Jump.Enabled then return end

    if input.KeyCode == jumpKey then
        if jumpConfig.Activation.Mode == "Toggle" then
            jumpEnabled = not jumpEnabled
        elseif jumpConfig.Activation.Mode == "Hold" then
            jumpEnabled = true
        elseif jumpConfig.Activation.Mode == "Always" then
            jumpEnabled = true
        end
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.KeyCode == jumpKey and jumpConfig.Activation.Mode == "Hold" then
        jumpEnabled = false
    end
end)

--// ================= MAIN LOOP =================
RunService.RenderStepped:Connect(function()
    if not jumpConfig.Jump.Enabled then return end

    if jumpConfig.Activation.Mode == "Always" then
        jumpEnabled = true
    end

    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        if jumpEnabled then
            char.Humanoid.JumpPower = jumpConfig.Jump.Power
        else
            char.Humanoid.JumpPower = defaultJumpPower
        end
    end
end)

--// ================= RESET ON RESPAWN =================
LocalPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid")
    char.Humanoid.JumpPower = defaultJumpPower
end)
