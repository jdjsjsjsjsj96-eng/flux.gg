-- Protected Script - Mooze
local _0x1 = getfenv()
local _0x2 = {
    [1] = game:GetService("Players"),
    [2] = game:GetService("RunService"),
    [3] = game:GetService("UserInputService"),
    [4] = game:GetService("TweenService"),
    [5] = workspace,
    [6] = game.CoreGui,
    [7] = game:GetService("LogService"),
}

local function _0xA(a,b,c)return a and b or c end
local function _0xB(t,k,v)rawset(t,k,v)return t end
local function _0xC(...)local a={...}local r=""for i=1,#a do r=r..string.char(a[i])end return r end
local _0xD=function(f,...)local s,r=pcall(f,...)return s and r or nil end

-- Capability Detection
local _0xCAP = {
    [1] = _0xD(function() return hookfunction ~= nil end) or false,
    [2] = _0xD(function() return getconnections ~= nil end) or false,
    [3] = _0xD(function() return getupvalues ~= nil end) or false,
    [4] = _0xD(function() return identifyexecutor ~= nil end) or false,
    [5] = _0xD(function() return getrawmetatable ~= nil end) or false,
}

local _0xEXE, _0xVER = "Unknown", "1.0"
if _0xCAP[4] then
    _0xEXE, _0xVER = identifyexecutor()
end

local function _0xNOTIFY(t, m, d)
    local n = Instance.new("ScreenGui")
    n.Name = "MoozeNotif"
    n.Parent = _0x2[6]
    
    local f = Instance.new("Frame")
    f.Size = UDim2.new(0, 300, 0, 80)
    f.Position = UDim2.new(1, -310, 0, 10)
    f.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    f.BorderSizePixel = 2
    f.BorderColor3 = Color3.fromRGB(255, 0, 0)
    f.Parent = n
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = f
    
    local tL = Instance.new("TextLabel")
    tL.Size = UDim2.new(1, -10, 0, 25)
    tL.Position = UDim2.new(0, 5, 0, 5)
    tL.BackgroundTransparency = 1
    tL.Text = t
    tL.Font = Enum.Font.SourceSansBold
    tL.TextColor3 = Color3.fromRGB(255, 255, 255)
    tL.TextSize = 16
    tL.TextXAlignment = Enum.TextXAlignment.Left
    tL.Parent = f
    
    local mL = Instance.new("TextLabel")
    mL.Size = UDim2.new(1, -10, 0, 45)
    mL.Position = UDim2.new(0, 5, 0, 30)
    mL.BackgroundTransparency = 1
    mL.Text = m
    mL.Font = Enum.Font.SourceSans
    mL.TextColor3 = Color3.fromRGB(200, 200, 200)
    mL.TextSize = 14
    mL.TextWrapped = true
    mL.TextXAlignment = Enum.TextXAlignment.Left
    mL.TextYAlignment = Enum.TextYAlignment.Top
    mL.Parent = f
    
    f.Position = UDim2.new(1, 10, 0, 10)
    _0x2[4]:Create(f, TweenInfo.new(0.3), {Position = UDim2.new(1, -310, 0, 10)}):Play()
    
    task.delay(d or 5, function()
        _0x2[4]:Create(f, TweenInfo.new(0.3), {Position = UDim2.new(1, 10, 0, 10)}):Play()
        task.wait(0.3)
        n:Destroy()
    end)
end

print("[Mooze] Running on:", _0xEXE)
print("[Mooze] Hooking:", _0xCAP[1] and "✓" or "✗")
print("[Mooze] Metatable:", _0xCAP[5] and "✓" or "✗")

task.delay(1, function()
    _0xNOTIFY("Mooze Loaded", "Running on: " .. _0xEXE, 4)
end)

-- Config Presets
local _0xPRESET = {
    ["Semi-Legit FOV"] = {
        ["Silent Aimbot"] = {
            FOV = { Enabled = true, Size = { X = 40 } },
            ["Movement Modifications"] = {
                ["Speed Modifications"] = {
                    Enabled = false,
                    Normal = { Multiplier = 30 }
                }
            }
        }
    },
    ["Semi-Legit No FOV"] = {
        ["Silent Aimbot"] = {
            FOV = { Enabled = false, Size = { X = 40 } },
            ["Movement Modifications"] = {
                ["Speed Modifications"] = {
                    Enabled = false,
                    Normal = { Multiplier = 30 }
                }
            }
        }
    },
    ["Blatant FOV"] = {
        ["Silent Aimbot"] = {
            FOV = { Enabled = true, Size = { X = 100 } },
            ["Movement Modifications"] = {
                ["Speed Modifications"] = {
                    Enabled = false,
                    Normal = { Multiplier = 150 }
                }
            }
        }
    },
    ["Blatant No FOV"] = {
        ["Silent Aimbot"] = {
            FOV = { Enabled = false, Size = { X = 100 } },
            ["Movement Modifications"] = {
                ["Speed Modifications"] = {
                    Enabled = false,
                    Normal = { Multiplier = 150 }
                }
            }
        }
    }
}

getgenv().Mooze = {
    Global = {
        Enabled = true,
        Keybind = "C"
    },
    ["Trigger Bot"] = {
        Enabled = false,
        Activation = {
            ["Activation Bind"] = "V"
        },
        FOV = {
            X = 5
        },
        Prediction = {
            X = 0.131,
            Y = 0.131,
            Z = 0.131  
        },
        ["Click Cooldown"] = 0.1,
        Weapons = {
            "Revolver",
            "Double Barrel",
            "Tactical SG",
            "Shotgun"
        }
    },
    ["Velocity Calculation"] = {
        Enabled = true,
        Magnitude = 10
    },
    ["Camera Aimbot"] = {
        Enabled = false,
        Keybind = "C",
        ["Hit Part"] = "HumanoidRootPart",
        Prediction = {
            X = 0,
            Y = 0,
            Z = 0
        },
        Snappiness = 1
    },
    ["Silent Aimbot"] = {
        Enabled = true,
        ["Hit Part"] = "Closest Point",
        FOV = {
            Enabled = true,
            Size = {
                X = 40
            },
            ["Weapons Configuration"] = {
                Enabled = false,
                Shotguns = {
                    X = 15
                },
                Pistols = {
                    X = 8
                }
            }
        },
        Prediction = {
            X = 0,
            Y = 0,
            Z = 0
        },
        ["Closest Point"] = {
            ["Point Scale"] = 1.0
        },
        ["Client Bullet Redirection"] = {
            Enabled = false,
            Prediction = {
                X = 0.131,
                Y = 0.131,
                Z = 0.131  
            },
            Weapons = {
                "M4A1",
                "AK47"
            }
        }
    },
    ["Movement Modifications"] = {
        ["Slowdown Modifications"] = {
            Enabled = false,
            Weapons = {
                ["M4A1"] = {
                    Multiplier = 0.1
                },
                ["AK47"] = {
                    Multiplier = 0.12
                },
                ["Pistol"] = {
                    Multiplier = 0.08
                },
                ["Shotgun"] = {
                    Multiplier = 0.15
                }
            }
        },
        ["Speed Modifications"] = {
            Enabled = false,
            Normal = {
                Multiplier = 30
            },
            ["Low Health"] = {
                Multiplier = 35
            },
            Reloading = {
                Multiplier = 35
            },
            Shooting = {
                Multiplier = 35
            }
        }
    },
    ["Weapon Modifications"] = {
        ["Spread Modifications"] = {
            Enabled = true,
            M4A1 = {
                Multiplier = 0.5
            },
            AK47 = {
                Multiplier = 0.7
            },
            Pistol = {
                Multiplier = 0.4
            },
            Shotgun = {
                Multiplier = 1.9
            }
        }
    }
}

-- AC Bypass
if _0xCAP[1] and _0xCAP[2] and _0xCAP[3] then
    print("[Mooze] Initializing AC bypass...")
    
    local _0xLOG = _0x2[7]
    local _0xMSG = _0xLOG.MessageOut
    
    local function _0xBYPASS(c)
        local s, e = pcall(function()
            local t = getupvalues(c.Function)[9]
            if t then
                local f = t[1]
                
                setupvalue(f, 14, function(...)
                    return function(...)
                        local a = {...}
                        if type(a[1]) == "table" and a[1][1] then
                            pcall(function()
                                if type(a[1][1]) == "userdata" then
                                    a[1][1]:Disconnect()
                                    a[1][2]:Disconnect()
                                    a[1][3]:Disconnect()
                                    a[1][4]:Disconnect()
                                end
                            end)
                        end 
                    end
                end)
                
                setupvalue(f, 1, function(...)
                    task.wait(200)
                end)
                
                hookfunction(f, function(...)
                    return {}
                end)
            end
        end)
        if not s then
            warn("[Mooze] AC bypass failed (non-critical):", e)
        end
    end
    
    local _0xLU = 0
    local _0xINT = 10
    local _0xCONN = {}
    
    _0x2[2].Heartbeat:Connect(function()
        if tick() - _0xLU >= _0xINT then
            _0xLU = tick()
            
            local s, c = pcall(function()
                return getconnections(_0xMSG)
            end)
            
            if s and c then
                for _, v in ipairs(c) do
                    if not table.find(_0xCONN, v) then
                        table.insert(_0xCONN, v)
                        task.spawn(_0xBYPASS, v)
                    end
                end
            end
        end
    end)
else
    warn("[Mooze] AC bypass disabled - executor doesn't support required functions")
end

-- GUI Variables
local _0xACCESS = false
local _0xCFGSEL = false
local _0xSELCFG = nil
local _0xLOADED = false
local _0xMOBILE = false

spawn(function()
    wait(1)
    _0xLOADED = true
end)

local _0xGUI = Instance.new("ScreenGui")
local _0xFRAME = Instance.new("Frame")
local _0xTBAR = Instance.new("Frame")
local _0xICON = Instance.new("ImageLabel")
local _0xTTXT = Instance.new("TextLabel")
local _0xCLOSE = Instance.new("TextButton")
local _0xMIN = Instance.new("TextButton")
local _0xMAX = Instance.new("TextButton")
local _0xASCII = Instance.new("TextLabel")
local _0xKEY = Instance.new("TextLabel")
local _0xMBTN = Instance.new("TextButton")

local _0xUIS = _0x2[3]
local _0xTWEEN = _0x2[4]
local _0xPLR = _0x2[1].LocalPlayer
local _0xCHAR = _0xPLR.Character or _0xPLR.CharacterAdded:Wait()
local _0xHUM = _0xCHAR:WaitForChild("Humanoid")
local _0xOWS = _0xHUM.WalkSpeed
local _0xOJP = _0xHUM.JumpPower

local _0xCORRECT = "traced"
local _0xCURCOL = Color3.fromRGB(255, 255, 255)
local _0xTYPCOL = Color3.fromRGB(128, 128, 128)
local _0xULEN = 1
local _0xUCHAR = "▄"
local _0xBLINK = 0.5
local _0xADELAY = 5
local _0xHDELAY = 5
local _0xTYPED = ""
local _0xSHOW = true
local _0xCANTYPE = false
local _0xAUTH = false

_0xGUI.Name = "CST"
_0xGUI.Parent = _0x2[6]

_0xFRAME.Name = "MoozeFrame"
_0xFRAME.Parent = _0xGUI
_0xFRAME.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
_0xFRAME.Size = UDim2.new(0, 600, 0, 300)
_0xFRAME.Position = UDim2.new(0.5, -300, 0.5, -150)
_0xFRAME.ClipsDescendants = true

_0xTBAR.Name = "TitleBar"
_0xTBAR.Parent = _0xFRAME
_0xTBAR.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
_0xTBAR.BorderSizePixel = 0
_0xTBAR.Size = UDim2.new(1, 0, 0, 28)
_0xTBAR.Position = UDim2.new(0, 0, 0, 0)
_0xTBAR.Active = true

_0xICON.Name = "TitleIcon"
_0xICON.Parent = _0xTBAR
_0xICON.BackgroundTransparency = 1
_0xICON.Size = UDim2.new(0, 16, 0, 16)
_0xICON.Position = UDim2.new(0, 6, 0, 6)
_0xICON.Image = "rbxassetid://128024012812354"

_0xTTXT.Name = "TitleText"
_0xTTXT.Parent = _0xTBAR
_0xTTXT.BackgroundTransparency = 1
_0xTTXT.Size = UDim2.new(0, 100, 1, 0)
_0xTTXT.Position = UDim2.new(0, 28, 0, 0)
_0xTTXT.Text = "Mooze"
_0xTTXT.Font = Enum.Font.SourceSans
_0xTTXT.TextColor3 = Color3.fromRGB(255, 255, 255)
_0xTTXT.TextSize = 18
_0xTTXT.TextXAlignment = Enum.TextXAlignment.Left

local _0xWM = Instance.new("TextLabel")
_0xWM.Name = "TitleWatermark"
_0xWM.Parent = _0xTBAR
_0xWM.BackgroundTransparency = 1
_0xWM.Size = UDim2.new(0, 300, 1, 0)
_0xWM.Position = UDim2.new(0.5, -150, 0, 0)
_0xWM.Text = "improved by .gg/traced | " .. _0xEXE
_0xWM.Font = Enum.Font.SourceSansBold
_0xWM.TextColor3 = Color3.fromRGB(255, 255, 255)
_0xWM.TextSize = 14
_0xWM.TextXAlignment = Enum.TextXAlignment.Center

_0xCLOSE.Name = "CloseButton"
_0xCLOSE.Parent = _0xTBAR
_0xCLOSE.Size = UDim2.new(0, 40, 0, 28)
_0xCLOSE.Position = UDim2.new(1, -40, 0, 0)
_0xCLOSE.BackgroundTransparency = 1
_0xCLOSE.Text = "X"
_0xCLOSE.Font = Enum.Font.SourceSansBold
_0xCLOSE.TextColor3 = Color3.fromRGB(255, 255, 255)
_0xCLOSE.TextSize = 18

_0xMIN.Name = "MinimizeButton"
_0xMIN.Parent = _0xTBAR
_0xMIN.Size = UDim2.new(0, 40, 0, 28)
_0xMIN.Position = UDim2.new(1, -120, 0, 0)
_0xMIN.BackgroundTransparency = 1
_0xMIN.Text = "-"
_0xMIN.Font = Enum.Font.SourceSansBold
_0xMIN.TextColor3 = Color3.fromRGB(255, 255, 255)
_0xMIN.TextSize = 24

_0xMAX.Name = "MaximizeButton"
_0xMAX.Parent = _0xTBAR
_0xMAX.Size = UDim2.new(0, 40, 0, 28)
_0xMAX.Position = UDim2.new(1, -80, 0, 0)
_0xMAX.BackgroundTransparency = 1
_0xMAX.Text = "▢"
_0xMAX.Font = Enum.Font.SourceSansBold
_0xMAX.TextColor3 = Color3.fromRGB(255, 255, 255)
_0xMAX.TextSize = 18
_0xMAX.Visible = false

_0xMBTN.Name = "MobileButton"
_0xMBTN.Parent = _0xGUI
_0xMBTN.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
_0xMBTN.BorderSizePixel = 0
_0xMBTN.Size = UDim2.new(0, 140, 0, 50)
_0xMBTN.Font = Enum.Font.SourceSansBold
_0xMBTN.Text = "Mobile Mode"
_0xMBTN.TextColor3 = Color3.fromRGB(255, 255, 255)
_0xMBTN.TextSize = 14
_0xMBTN.AutoButtonColor = false

local function _0xUPDATEMBTN()
    local fp = _0xFRAME.AbsolutePosition
    local fs = _0xFRAME.AbsoluteSize
    _0xMBTN.Position = UDim2.new(0, fp.X + fs.X + 10, 0, fp.Y)
end

_0xUPDATEMBTN()
_0xFRAME:GetPropertyChangedSignal("AbsolutePosition"):Connect(_0xUPDATEMBTN)

local _0xDRAG = false
local _0xDINP, _0xDSTART, _0xSPOS
local function _0xUPDATE(i)
    local d = i.Position - _0xDSTART
    _0xFRAME.Position = UDim2.new(_0xFRAME.Position.X.Scale, _0xSPOS.X.Offset + d.X, _0xFRAME.Position.Y.Scale, _0xSPOS.Y.Offset + d.Y)
end

_0xTBAR.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        _0xDRAG = true
        _0xDSTART = i.Position
        _0xSPOS = _0xFRAME.Position
        i.Changed:Connect(function()
            if i.UserInputState == Enum.UserInputState.End then
                _0xDRAG = false
            end
        end)
    end
end)

_0xTBAR.InputChanged:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
        _0xDINP = i
    end
end)

_0xUIS.InputChanged:Connect(function(i)
    if _0xDRAG and i == _0xDINP then
        _0xUPDATE(i)
    end
end)

local _0xNSIZE = _0xFRAME.Size
local _0xVIS = true

_0xMIN.MouseButton1Click:Connect(function()
    if _0xVIS then
        _0xTWEEN:Create(_0xFRAME, TweenInfo.new(0.2), {Size = UDim2.new(_0xNSIZE.X.Scale, _0xNSIZE.X.Offset, 0, _0xTBAR.Size.Y.Offset)}):Play()
        _0xASCII.Visible = false
        _0xKEY.Visible = false
        _0xMAX.Visible = true
        _0xVIS = false
    end
end)

_0xMAX.MouseButton1Click:Connect(function()
    if not _0xVIS then
        _0xTWEEN:Create(_0xFRAME, TweenInfo.new(0.2), {Size = _0xNSIZE}):Play()
        _0xASCII.Visible = true
        _0xKEY.Visible = true
        _0xMAX.Visible = false
        _0xVIS = true
    end
end)

_0xCLOSE.MouseButton1Click:Connect(function()
    _0xGUI:Destroy()
end)

_0xASCII.Name = "MoozeASCII"
_0xASCII.Parent = _0xFRAME
_0xASCII.BackgroundTransparency = 1
_0xASCII.Size = UDim2.new(1, 0, 0.6, 0)
_0xASCII.Position = UDim2.new(0, 0, 0.12, 0)
_0xASCII.Font = Enum.Font.Code
_0xASCII.Text = [[
ooo        ooooo     .oooooo.      .oooooo.      oooooooooooo   oooooooooooo
`88.       .888'    d8P'  `Y8b    d8P'  `Y8b    d'''""""'888'        `888'     
 888b     d'888    888      888  888      888         .888P         888       
 8 Y88. .P  888    888      888  888      888        d888'          888oooo8  
 8  `888'   888    888      888  888      888      .888P            888    "  
 8    Y     888    `88b    d88'  `88b    d88'     d888'    .P       888       
o8o        o888o    `Y8bood8P'    `Y8bood8P'    .8888888888P      o888ooooood8
]]
_0xASCII.TextColor3 = Color3.fromRGB(128, 128, 128)
_0xASCII.TextSize = 12
_0xASCII.TextWrapped = true
_0xASCII.TextXAlignment = Enum.TextXAlignment.Center
_0xASCII.TextYAlignment = Enum.TextYAlignment.Center

_0xKEY.Name = "KeyLabel"
_0xKEY.Parent = _0xFRAME
_0xKEY.BackgroundTransparency = 1
_0xKEY.Position = UDim2.new(0, 29, 0, 200)
_0xKEY.Size = UDim2.new(0.7, 0, 0.1, 0)
_0xKEY.Font = Enum.Font.Code
_0xKEY.RichText = true
_0xKEY.TextColor3 = Color3.fromRGB(128, 128, 128)
_0xKEY.TextSize = 12
_0xKEY.TextXAlignment = Enum.TextXAlignment.Left
_0xKEY.TextYAlignment = Enum.TextYAlignment.Center
_0xKEY.Active = true

local function _0xUPDKEY()
    if _0xAUTH then return end
    local u = _0xSHOW and string.rep(_0xUCHAR, _0xULEN) or ""
    _0xKEY.Text = string.format('[<font color="rgb(255,0,0)">-</font>] Key: <font color="rgb(%d,%d,%d)">%s</font><font color="rgb(%d,%d,%d)">%s</font>', 
        _0xTYPCOL.R*255, _0xTYPCOL.G*255, _0xTYPCOL.B*255, _0xTYPED, 
        _0xCURCOL.R*255, _0xCURCOL.G*255, _0xCURCOL.B*255, u)
end

task.spawn(function()
    while true do
        if not _0xAUTH then
            _0xSHOW = not _0xSHOW
            _0xUPDKEY()
        end
        wait(_0xBLINK)
    end
end)

local function _0xPROCEED()
    _0xAUTH = true
    _0xKEY.Text = '[<font color="rgb(255,0,0)">-</font>] Authenticating...'
    wait(_0xADELAY)
    repeat task.wait() until _0xLOADED
    
    _0xASCII.Visible = false
    _0xKEY.Visible = false
    _0xMBTN.Visible = false
    
    showExecutorInfo()
end

_0xMBTN.MouseButton1Click:Connect(function()
    _0xMOBILE = true
    print("[Mooze] Mobile Mode button clicked - isMobileMode set to TRUE")
    _0xPROCEED()
end)

local _0xKMAP = {
    Zero="0", One="1", Two="2", Three="3", Four="4", Five="5", Six="6", Seven="7", Eight="8", Nine="9", 
    Comma=",", Period=".", Slash="/", BackSlash="\\", Semicolon=";", Quote="'", Minus="-", Equal="=", 
    Grave="`", LeftBracket="[", RightBracket="]", 
    F1="F1", F2="F2", F3="F3", F4="F4", F5="F5", F6="F6", F7="F7", F8="F8", F9="F9", F10="F10", F11="F11", F12="F12", 
    Space=" ", Tab="\t", CapsLock="CapsLock", Insert="Insert", Delete="Delete", Home="Home", End="End", 
    PageUp="PageUp", PageDown="PageDown", Up="↑", Down="↓", Left="←", Right="→"
}

_0xUIS.InputBegan:Connect(function(i, g)
    if g then return end
    if _0xCANTYPE and i.UserInputType == Enum.UserInputType.Keyboard then
        if i.KeyCode == Enum.KeyCode.Return then
            _0xCANTYPE = false
            _0xHUM.WalkSpeed = _0xOWS
            _0xHUM.JumpPower = _0xOJP
            if _0xTYPED == _0xCORRECT then
                _0xMOBILE = false
                print("[Mooze] PC Mode (typed key) - isMobileMode set to FALSE")
                _0xPROCEED()
            else
                _0xPLR:Kick("Invalid Key")
            end
            _0xUPDKEY()
        elseif i.KeyCode == Enum.KeyCode.Backspace then
            _0xTYPED = _0xTYPED:sub(1, -2)
            _0xUPDKEY()
        else
            local k = i.KeyCode.Name
            if #k == 1 then
                _0xTYPED = _0xTYPED .. k:lower()
            elseif _0xKMAP[k] then
                _0xTYPED = _0xTYPED .. _0xKMAP[k]
            end
            _0xUPDKEY()
        end
    end
end)

_0xUIS.InputBegan:Connect(function(i, g)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        local m = i.Position
        local ap = _0xKEY.AbsolutePosition
        local as = _0xKEY.AbsoluteSize
        if m.X >= ap.X and m.X <= ap.X + as.X and m.Y >= ap.Y and m.Y <= ap.Y + as.Y then
            _0xCANTYPE = true
            _0xTYPED = ""
            _0xUPDKEY()
            _0xOWS = _0xHUM.WalkSpeed
            _0xOJP = _0xHUM.JumpPower
            _0xHUM.WalkSpeed = 0
            _0xHUM.JumpPower = 0
        else
            if _0xCANTYPE then
                _0xHUM.WalkSpeed = _0xOWS
                _0xHUM.JumpPower = _0xOJP
            end
            _0xCANTYPE = false
            _0xUPDKEY()
        end
    end
end)

_0xUPDKEY()

function showExecutorInfo()
    for _, c in pairs(_0xFRAME:GetChildren()) do
        if c ~= _0xTBAR then
            c:Destroy()
        end
    end
    
    local et = Instance.new("TextLabel")
    et.Name = "ExecutorTitle"
    et.Parent = _0xFRAME
    et.BackgroundTransparency = 1
    et.Position = UDim2.new(0, 0, 0, 40)
    et.Size = UDim2.new(1, 0, 0, 30)
    et.Font = Enum.Font.SourceSansBold
    et.Text = "Executor: " .. _0xEXE
    et.TextColor3 = Color3.fromRGB(255, 0, 0)
    et.TextSize = 20
    et.TextXAlignment = Enum.TextXAlignment.Center
    
    local sf = Instance.new("ScrollingFrame")
    sf.Name = "FeaturesList"
    sf.Parent = _0xFRAME
    sf.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    sf.BorderSizePixel = 0
    sf.Position = UDim2.new(0.5, -260, 0, 80)
    sf.Size = UDim2.new(0, 520, 0, 150)
    sf.CanvasSize = UDim2.new(0, 0, 0, 0)
    sf.ScrollBarThickness = 6
    sf.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 0)
    
    local sc = Instance.new("UICorner")
    sc.CornerRadius = UDim.new(0, 8)
    sc.Parent = sf
    
    local ll = Instance.new("UIListLayout")
    ll.Parent = sf
    ll.SortOrder = Enum.SortOrder.LayoutOrder
    ll.Padding = UDim.new(0, 5)
    
    local _0xFEAT = {
        {name = "Silent Aimbot", status = _0xCAP[5], detail = _0xCAP[5] and "Full metatable hooking" or "Limited mode (basic)"},
        {name = "Trigger Bot", status = true, detail = "Fully functional"},
        {name = "Camera Aimbot", status = true, detail = "Fully functional"},
        {name = "FOV Circle", status = true, detail = "Visual indicator"},
        {name = "Walkspeed Modifications", status = true, detail = "Event-based system"},
        {name = "Spread Modifications", status = true, detail = "Weapon accuracy control"},
        {name = "Rapid Fire", status = true, detail = "Auto fire system"},
        {name = "Anti-Cheat Bypass", status = _0xCAP[1] and _0xCAP[2] and _0xCAP[3], detail = _0xCAP[1] and "AC protection enabled" or "Disabled - executor limited"}
    }
    
    local yo = 5
    for i, f in ipairs(_0xFEAT) do
        local ff = Instance.new("Frame")
        ff.Name = "Feature" .. i
        ff.Parent = sf
        ff.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
        ff.BorderSizePixel = 0
        ff.Size = UDim2.new(1, -10, 0, 45)
        ff.LayoutOrder = i
        
        local fc = Instance.new("UICorner")
        fc.CornerRadius = UDim.new(0, 6)
        fc.Parent = ff
        
        local si = Instance.new("Frame")
        si.Name = "StatusIndicator"
        si.Parent = ff
        si.BackgroundColor3 = f.status and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        si.BorderSizePixel = 0
        si.Position = UDim2.new(0, 10, 0.5, -8)
        si.Size = UDim2.new(0, 16, 0, 16)
        
        local ic = Instance.new("UICorner")
        ic.CornerRadius = UDim.new(1, 0)
        ic.Parent = si
        
        local fn = Instance.new("TextLabel")
        fn.Name = "FeatureName"
        fn.Parent = ff
        fn.BackgroundTransparency = 1
        fn.Position = UDim2.new(0, 35, 0, 5)
        fn.Size = UDim2.new(1, -40, 0, 18)
        fn.Font = Enum.Font.SourceSansBold
        fn.Text = f.name
        fn.TextColor3 = Color3.fromRGB(255, 255, 255)
        fn.TextSize = 14
        fn.TextXAlignment = Enum.TextXAlignment.Left
        
        local fd = Instance.new("TextLabel")
        fd.Name = "FeatureDetail"
        fd.Parent = ff
        fd.BackgroundTransparency = 1
        fd.Position = UDim2.new(0, 35, 0, 23)
        fd.Size = UDim2.new(1, -40, 0, 16)
        fd.Font = Enum.Font.SourceSans
        fd.Text = f.detail
        fd.TextColor3 = Color3.fromRGB(150, 150, 150)
        fd.TextSize = 12
        fd.TextXAlignment = Enum.TextXAlignment.Left
        
        yo = yo + 50
    end
    
    sf.CanvasSize = UDim2.new(0, 0, 0, yo)
    
    local cb = Instance.new("TextButton")
    cb.Name = "ContinueButton"
    cb.Parent = _0xFRAME
    cb.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    cb.BorderColor3 = Color3.fromRGB(255, 0, 0)
    cb.BorderSizePixel = 2
    cb.Position = UDim2.new(0.5, -100, 0, 240)
    cb.Size = UDim2.new(0, 200, 0, 40)
    cb.Font = Enum.Font.SourceSansBold
    cb.Text = "CONTINUE"
    cb.TextColor3 = Color3.fromRGB(255, 255, 255)
    cb.TextSize = 16
    cb.AutoButtonColor = false
    
    local cc = Instance.new("UICorner")
    cc.CornerRadius = UDim.new(0, 10)
    cc.Parent = cb
    
    cb.MouseEnter:Connect(function()
        _0xTWEEN:Create(cb, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(20, 20, 20)}):Play()
    end)
    
    cb.MouseLeave:Connect(function()
        _0xTWEEN:Create(cb, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(10, 10, 10)}):Play()
    end)
    
    cb.MouseButton1Click:Connect(function()
        showConfigSelection()
    end)
end

function showConfigSelection()
    for _, c in pairs(_0xFRAME:GetChildren()) do
        if c ~= _0xTBAR then
            c:Destroy()
        end
    end
    
    local st = Instance.new("TextLabel")
    st.Name = "SelectTitle"
    st.Parent = _0xFRAME
    st.BackgroundTransparency = 1
    st.Position = UDim2.new(0, 0, 0, 55)
    st.Size = UDim2.new(1, 0, 0, 30)
    st.Font = Enum.Font.SourceSansBold
    st.Text = "Select Configuration"
    st.TextColor3 = Color3.fromRGB(255, 0, 0)
    st.TextSize = 20
    st.TextXAlignment = Enum.TextXAlignment.Center
    
    local bc = Instance.new("Frame")
    bc.Name = "ButtonContainer"
    bc.Parent = _0xFRAME
    bc.BackgroundTransparency = 1
    bc.Position = UDim2.new(0.5, -250, 0, 90)
    bc.Size = UDim2.new(0, 500, 0, 180)
    
    local _0xCFGS = {
        {name = "Semi-Legit FOV", preset = "Semi-Legit FOV"},
        {name = "Semi-Legit No FOV", preset = "Semi-Legit No FOV"},
        {name = "Blatant FOV", preset = "Blatant FOV"},
        {name = "Blatant No FOV", preset = "Blatant No FOV"}
    }
    
    for i, cfg in ipairs(_0xCFGS) do
        local r = math.floor((i - 1) / 2)
        local c = (i - 1) % 2
        
        local cfgb = Instance.new("TextButton")
        cfgb.Name = cfg.name
        cfgb.Parent = bc
        cfgb.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
        cfgb.BorderColor3 = Color3.fromRGB(255, 0, 0)
        cfgb.BorderSizePixel = 2
        cfgb.Position = UDim2.new(c * 0.52, 0, r * 0.52, 0)
        cfgb.Size = UDim2.new(0.46, 0, 0.46, 0)
        cfgb.Font = Enum.Font.SourceSansBold
        cfgb.Text = cfg.name
        cfgb.TextColor3 = Color3.fromRGB(255, 255, 255)
        cfgb.TextSize = 14
        cfgb.TextWrapped = true
        cfgb.AutoButtonColor = false
        
        local cor = Instance.new("UICorner")
        cor.CornerRadius = UDim.new(0, 10)
        cor.Parent = cfgb
        
        cfgb.MouseEnter:Connect(function()
            _0xTWEEN:Create(cfgb, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(20, 20, 20)}):Play()
        end)
        
        cfgb.MouseLeave:Connect(function()
            _0xTWEEN:Create(cfgb, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(10, 10, 10)}):Play()
        end)
        
        cfgb.MouseButton1Click:Connect(function()
            _0xSELCFG = cfg.preset
            showWalkspeedSelection(cfg.preset)
        end)
    end
end

function showWalkspeedSelection(p)
    for _, c in pairs(_0xFRAME:GetChildren()) do
        if c ~= _0xTBAR then
            c:Destroy()
        end
    end
    
    local wt = Instance.new("TextLabel")
    wt.Name = "WalkspeedTitle"
    wt.Parent = _0xFRAME
    wt.BackgroundTransparency = 1
    wt.Position = UDim2.new(0, 0, 0, 55)
    wt.Size = UDim2.new(1, 0, 0, 30)
    wt.Font = Enum.Font.SourceSansBold
    wt.Text = "Enable Walkspeed?"
    wt.TextColor3 = Color3.fromRGB(255, 0, 0)
    wt.TextSize = 20
    wt.TextXAlignment = Enum.TextXAlignment.Center
    
    local bc = Instance.new("Frame")
    bc.Name = "ButtonContainer"
    bc.Parent = _0xFRAME
    bc.BackgroundTransparency = 1
    bc.Position = UDim2.new(0.5, -200, 0, 120)
    bc.Size = UDim2.new(0, 400, 0, 80)
    
    local yb = Instance.new("TextButton")
    yb.Name = "YesButton"
    yb.Parent = bc
    yb.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    yb.BorderColor3 = Color3.fromRGB(0, 255, 0)
    yb.BorderSizePixel = 2
    yb.Position = UDim2.new(0, 0, 0, 0)
    yb.Size = UDim2.new(0.48, 0, 1, 0)
    yb.Font = Enum.Font.SourceSansBold
    yb.Text = "YES"
    yb.TextColor3 = Color3.fromRGB(0, 255, 0)
    yb.TextSize = 18
    yb.AutoButtonColor = false
    
    local yc = Instance.new("UICorner")
    yc.CornerRadius = UDim.new(0, 10)
    yc.Parent = yb
    
    local nb = Instance.new("TextButton")
    nb.Name = "NoButton"
    nb.Parent = bc
    nb.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    nb.BorderColor3 = Color3.fromRGB(255, 0, 0)
    nb.BorderSizePixel = 2
    nb.Position = UDim2.new(0.52, 0, 0, 0)
    nb.Size = UDim2.new(0.48, 0, 1, 0)
    nb.Font = Enum.Font.SourceSansBold
    nb.Text = "NO"
    nb.TextColor3 = Color3.fromRGB(255, 0, 0)
    nb.TextSize = 18
    nb.AutoButtonColor = false
    
    local nc = Instance.new("UICorner")
    nc.CornerRadius = UDim.new(0, 10)
    nc.Parent = nb
    
    yb.MouseEnter:Connect(function()
        _0xTWEEN:Create(yb, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(20, 20, 20)}):Play()
    end)
    
    yb.MouseLeave:Connect(function()
        _0xTWEEN:Create(yb, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(10, 10, 10)}):Play()
    end)
    
    nb.MouseEnter:Connect(function()
        _0xTWEEN:Create(nb, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(20, 20, 20)}):Play()
    end)
    
    nb.MouseLeave:Connect(function()
        _0xTWEEN:Create(nb, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(10, 10, 10)}):Play()
    end)
    
    yb.MouseButton1Click:Connect(function()
        applyConfig(p, true)
        finishAuthentication()
    end)
    
    nb.MouseButton1Click:Connect(function()
        applyConfig(p, false)
        finishAuthentication()
    end)
end

function applyConfig(p, e)
    local pr = _0xPRESET[p]
    if pr then
        if pr["Silent Aimbot"] then
            getgenv().Mooze["Silent Aimbot"]["FOV"]["Enabled"] = pr["Silent Aimbot"].FOV.Enabled
            getgenv().Mooze["Silent Aimbot"]["FOV"]["Size"]["X"] = pr["Silent Aimbot"].FOV.Size.X
        end
        
        if pr["Silent Aimbot"]["Movement Modifications"] then
            local sm = pr["Silent Aimbot"]["Movement Modifications"]["Speed Modifications"]
            getgenv().Mooze["Movement Modifications"]["Speed Modifications"]["Enabled"] = e
            getgenv().Mooze["Movement Modifications"]["Speed Modifications"]["Normal"]["Multiplier"] = sm.Normal.Multiplier
            getgenv().Mooze["Movement Modifications"]["Speed Modifications"]["Low Health"]["Multiplier"] = sm.Normal.Multiplier + 5
            getgenv().Mooze["Movement Modifications"]["Speed Modifications"]["Reloading"]["Multiplier"] = sm.Normal.Multiplier + 5
            getgenv().Mooze["Movement Modifications"]["Speed Modifications"]["Shooting"]["Multiplier"] = sm.Normal.Multiplier + 5
        end
    end
    
    print("[Mooze] Applied config:", p)
    print("[Mooze] Walkspeed enabled:", e)
    print("[Mooze] Speed multiplier:", getgenv().Mooze["Movement Modifications"]["Speed Modifications"]["Normal"]["Multiplier"])
end

function finishAuthentication()
    for _, c in pairs(_0xFRAME:GetChildren()) do
        if c ~= _0xTBAR then
            c:Destroy()
        end
    end
    
    local cl = Instance.new("TextLabel")
    cl.Name = "ClosingLabel"
    cl.Parent = _0xFRAME
    cl.BackgroundTransparency = 1
    cl.Position = UDim2.new(0, 0, 0, 100)
    cl.Size = UDim2.new(1, 0, 0, 100)
    cl.Font = Enum.Font.Code
    cl.RichText = true
    cl.Text = '[<font color="rgb(255,0,0)">-</font>] Hiding console in <font color="rgb(255,0,0)">5.00</font> seconds!'
    cl.TextColor3 = Color3.fromRGB(128, 128, 128)
    cl.TextSize = 14
    cl.TextXAlignment = Enum.TextXAlignment.Center
    
    wait(_0xHDELAY)
    
    local function _0xFADE(g, d)
        for _, o in ipairs(g:GetDescendants()) do
            if o:IsA("TextLabel") then
                _0xTWEEN:Create(o, TweenInfo.new(d), {TextTransparency = 1}):Play()
            elseif o:IsA("TextButton") then
                _0xTWEEN:Create(o, TweenInfo.new(d), {TextTransparency = 1}):Play()
            elseif o:IsA("ImageLabel") then
                _0xTWEEN:Create(o, TweenInfo.new(d), {ImageTransparency = 1}):Play()
            elseif o:IsA("Frame") then
                _0xTWEEN:Create(o, TweenInfo.new(d), {BackgroundTransparency = 1}):Play()
            end
        end
    end
    
    _0xFADE(_0xGUI, 2)
    wait(2)
    _0xGUI:Destroy()
    _0xACCESS = true
    _0xCFGSEL = true
end

repeat task.wait() until _0xACCESS and _0xCFGSEL

if not getgenv().Mooze or not getgenv().Mooze["Global"] or not getgenv().Mooze["Global"]["Enabled"] then
    return
end

print("[Mooze] Mobile Mode:", _0xMOBILE)

-- Mobile Lock & FOV
local _0xLOCKED = false
local _0xLOCKTGT = nil
local _0xLBTN = nil
local _0xMFOV = nil
local _0xCURFOV = 40

if _0xMOBILE then
    _0xMFOV = Drawing.new("Circle")
    _0xMFOV.Visible = true
    _0xMFOV.Transparency = 1
    _0xMFOV.Thickness = 2
    _0xMFOV.Color = Color3.new(1, 1, 1)
    _0xMFOV.NumSides = 100
    _0xMFOV.Filled = false
    
    local lg = Instance.new("ScreenGui")
    lg.Name = "MoozeLockGui"
    lg.Parent = _0x2[6]
    lg.ResetOnSpawn = false

    _0xLBTN = Instance.new("TextButton")
    _0xLBTN.Name = "MobileLockButton"
    _0xLBTN.Parent = lg
    _0xLBTN.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    _0xLBTN.BorderColor3 = Color3.fromRGB(255, 0, 0)
    _0xLBTN.BorderSizePixel = 2
    _0xLBTN.Position = UDim2.new(0, 10, 0, 60)
    _0xLBTN.Size = UDim2.new(0, 80, 0, 40)
    _0xLBTN.Font = Enum.Font.SourceSansBold
    _0xLBTN.Text = "LOCK"
    _0xLBTN.TextColor3 = Color3.fromRGB(255, 255, 255)
    _0xLBTN.TextSize = 16
    _0xLBTN.AutoButtonColor = false
    _0xLBTN.ZIndex = 10

    local lc = Instance.new("UICorner")
    lc.CornerRadius = UDim.new(0, 8)
    lc.Parent = _0xLBTN
    
    local sf = Instance.new("Frame")
    sf.Name = "SliderFrame"
    sf.Parent = lg
    sf.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    sf.BorderColor3 = Color3.fromRGB(255, 0, 0)
    sf.BorderSizePixel = 2
    sf.Position = UDim2.new(0, 10, 0, 110)
    sf.Size = UDim2.new(0, 150, 0, 80)
    
    local sfc = Instance.new("UICorner")
    sfc.CornerRadius = UDim.new(0, 8)
    sfc.Parent = sf
    
    local fl = Instance.new("TextLabel")
    fl.Name = "FOVLabel"
    fl.Parent = sf
    fl.BackgroundTransparency = 1
    fl.Position = UDim2.new(0, 0, 0, 5)
    fl.Size = UDim2.new(1, 0, 0, 20)
    fl.Font = Enum.Font.SourceSansBold
    fl.Text = "FOV: " .. _0xCURFOV
    fl.TextColor3 = Color3.fromRGB(255, 255, 255)
    fl.TextSize = 14
    
    local sb = Instance.new("Frame")
    sb.Name = "SliderBar"
    sb.Parent = sf
    sb.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    sb.BorderSizePixel = 0
    sb.Position = UDim2.new(0.1, 0, 0, 35)
    sb.Size = UDim2.new(0.8, 0, 0, 6)
    
    local sbc = Instance.new("UICorner")
    sbc.CornerRadius = UDim.new(1, 0)
    sbc.Parent = sb
    
    local sfill = Instance.new("Frame")
    sfill.Name = "SliderFill"
    sfill.Parent = sb
    sfill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    sfill.BorderSizePixel = 0
    sfill.Size = UDim2.new(0.2, 0, 1, 0)
    
    local sfc2 = Instance.new("UICorner")
    sfc2.CornerRadius = UDim.new(1, 0)
    sfc2.Parent = sfill
    
    local sbtn = Instance.new("TextButton")
    sbtn.Name = "SliderButton"
    sbtn.Parent = sb
    sbtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sbtn.BorderSizePixel = 0
    sbtn.Position = UDim2.new(0.2, -8, 0.5, -8)
    sbtn.Size = UDim2.new(0, 16, 0, 16)
    sbtn.Text = ""
    sbtn.AutoButtonColor = false
    
    local sbc2 = Instance.new("UICorner")
    sbc2.CornerRadius = UDim.new(1, 0)
    sbc2.Parent = sbtn
    
    local _0xMIN = 10
    local _0xMAX = 200
    local _0xDRAGS = false
    
    local function _0xUPDSLIDER(pos)
        local rp = math.clamp((pos.X - sb.AbsolutePosition.X) / sb.AbsoluteSize.X, 0, 1)
        _0xCURFOV = math.floor(_0xMIN + (_0xMAX - _0xMIN) * rp)
        
        sfill.Size = UDim2.new(rp, 0, 1, 0)
        sbtn.Position = UDim2.new(rp, -8, 0.5, -8)
        fl.Text = "FOV: " .. _0xCURFOV
        
        getgenv().Mooze["Silent Aimbot"]["FOV"]["Size"]["X"] = _0xCURFOV
    end
    
    sbtn.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            _0xDRAGS = true
        end
    end)
    
    sbtn.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            _0xDRAGS = false
        end
    end)
    
    _0xUIS.InputChanged:Connect(function(i)
        if _0xDRAGS and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            _0xUPDSLIDER(i.Position)
        end
    end)
    
    sb.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            _0xUPDSLIDER(i.Position)
        end
    end)
    
    print("[Mooze] Mobile lock button and FOV slider created!")
end

-- Target System
local _0xPLRS = _0x2[1]
local _0xLPLR = _0xPLRS.LocalPlayer
local _0xCAM = _0x2[5].CurrentCamera
local _0xRS = _0x2[2]

local _0xTCACHE = {
    target = nil,
    targetPart = nil,
    lastUpdate = 0,
    updateInterval = 0.033
}

local _0xPARTS = {
    "Head","UpperTorso","HumanoidRootPart","LowerTorso",
    "LeftHand","RightHand","LeftLowerArm","RightLowerArm",
    "LeftUpperArm","RightUpperArm","LeftFoot","LeftLowerLeg",
    "LeftUpperLeg","RightLowerLeg","RightFoot","RightUpperLeg"
}

local _0xBPCACHE = {}
local _0xCTO = 2

local function _0xGETBP(c)
    local n = tick()
    if not _0xBPCACHE[c] or (n - (_0xBPCACHE[c].time or 0)) > _0xCTO then
        local p = {}
        for _, pn in ipairs(_0xPARTS) do
            local pt = c:FindFirstChild(pn)
            if pt then
                table.insert(p, pt)
            end
        end
        _0xBPCACHE[c] = {parts = p, time = n}
    end
    return _0xBPCACHE[c].parts
end

-- Trigger Bot
local _0xCFG = getgenv().Mooze
local _0xTCFG = _0xCFG["Trigger Bot"]
local _0xVCFG = _0xCFG["Velocity Calculation"]

local _0xCIRC = Drawing.new("Circle")
_0xCIRC.Visible = false
_0xCIRC.Transparency = 1
_0xCIRC.Color = Color3.new(1,1,1)
_0xCIRC.Filled = true
_0xCIRC.Radius = _0xTCFG["FOV"]["X"] * 5
_0xCIRC.NumSides = math.clamp(math.floor(_0xCIRC.Radius * 2), 20, 100)
_0xCIRC.Position = Vector2.new(_0xCAM.ViewportSize.X/2, _0xCAM.ViewportSize.Y/2)

local _0xLTS = 0
local _0xTSI = 0.05
local _0xLAT = 0

local function _0xGETINFOV()
    local cd = math.huge
    local bp = nil
    local cp = _0xCIRC.Position
    local r = _0xCIRC.Radius
    local pr = _0xTCFG.Prediction
    local ve = _0xVCFG.Enabled
    local vm = _0xVCFG.Magnitude
    
    for _, p in ipairs(_0xPLRS:GetPlayers()) do
        if p ~= _0xLPLR and p.Character then
            local pts = _0xGETBP(p.Character)
            for _, pt in ipairs(pts) do
                if pt.Transparency < 1 then
                    local pos = pt.Position
                    if pt.Name == "HumanoidRootPart" then
                        pos = pos + Vector3.new(pr.X, pr.Y, pr.Z)
                        if ve then
                            local v = pt.Velocity
                            if v.Magnitude > vm then
                                pos = pos + v * 0.1
                            end
                        end
                    end
                    
                    local sp, os = _0xCAM:WorldToScreenPoint(pos)
                    if os and sp.Z > 0 then
                        local d = (Vector2.new(sp.X, sp.Y) - cp).Magnitude
                        if d <= r and d < cd then
                            cd = d
                            bp = p
                        end
                    end
                end
            end
        end
    end
    
    return bp
end

local _0xTK = Enum.KeyCode[_0xTCFG.Activation["Activation Bind"]:upper()]
_0xUIS.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == _0xTK then
        _0xTCFG.Enabled = not _0xTCFG.Enabled
        print("[Trigger Bot]", _0xTCFG.Enabled and "Enabled" or "Disabled")
        _0xNOTIFY("Trigger Bot", _0xTCFG.Enabled and "Enabled" or "Disabled", 3)
    end
end)

_0xRS.Heartbeat:Connect(function(dt)
    _0xLTS = _0xLTS + dt
    if _0xLTS < _0xTSI then return end
    _0xLTS = 0
    
    if _0xTCFG.Enabled then
        local tgt = _0xGETINFOV()
        local ac = _0xLPLR:FindFirstChildOfClass("PlayerGui")
            and _0xLPLR.PlayerGui:FindFirstChild("Aim")
        if ac then
            _0xCIRC.Position = ac.AbsolutePosition
            _0xCIRC.Radius = _0xTCFG["FOV"]["X"] * 5
            _0xCIRC.NumSides = math.clamp(math.floor(_0xCIRC.Radius * 2), 20, 100)
        end
        
        if tgt and _0xLPLR.Character then
            local tl = _0xLPLR.Character:FindFirstChildOfClass("Tool")
            if tl and tl:FindFirstChild("Handle") then
                local cl = function(t)
                    return t:lower():gsub("[%[%]%- ]","")
                end
                local tn = cl(tl.Name)
                local al = false
                for _, w in ipairs(_0xTCFG.Weapons) do
                    if tn:find(cl(w), 1, true) then
                        al = true
                        break
                    end
                end
                
                if al and tick() - _0xLAT >= _0xTCFG["Click Cooldown"] then
                    tl:Activate()
                    tl:Deactivate()
                    _0xLAT = tick()
                end
            end
        end
    end
end)

-- Camera Aimbot with Lock
do
    local _0xCACFG = getgenv().Mooze["Camera Aimbot"]
    local _0xGK = getgenv().Mooze["Global"]["Keybind"] or "E"
    _0xCACFG["Keybind"] = _0xGK
    _0xCACFG["Snappiness"] = 1
    _0xCACFG["Prediction"]["X"] = 0
    _0xCACFG["Prediction"]["Y"] = 0
    _0xCACFG["Prediction"]["Z"] = 0
    
    local _0xCCAM = _0x2[5].CurrentCamera
    local _0xAK = Enum.KeyCode[_0xCACFG["Keybind"]:upper()]
    
    local function _0xISKO(c)
        if not c then return false end
        
        local be = c:FindFirstChild("BodyEffects")
        if be then
            local ko = be:FindFirstChild("K.O")
            if ko and ko.Value == true then
                return true
            end
        end
        
        local h = c:FindFirstChildOfClass("Humanoid")
        if h then
            local s = h:GetState()
            if s == Enum.HumanoidStateType.Dead or 
               s == Enum.HumanoidStateType.Physics or
               s == Enum.HumanoidStateType.Ragdoll then
                return true
            end
        end
        
        local rp = c:FindFirstChild("HumanoidRootPart")
        if rp then
            local g = rp:FindFirstChild("GRABBING_CONSTRAINT")
            if g then
                return true
            end
        end
        
        return false
    end
    
    local function _0xGETTGT()
        if _0xLOCKED and _0xLOCKTGT then
            if _0xLOCKTGT.Parent and _0xLOCKTGT.Parent:FindFirstChild("Humanoid") then
                local h = _0xLOCKTGT.Parent:FindFirstChild("Humanoid")
                local c = _0xLOCKTGT.Parent
                
                if h and h.Health > 0 and not _0xISKO(c) then
                    return _0xLOCKTGT
                end
            end
            
            _0xLOCKED = false
            _0xLOCKTGT = nil
            if _0xLBTN then
                _0xLBTN.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                _0xLBTN.BorderColor3 = Color3.fromRGB(255, 0, 0)
            end
            _0xNOTIFY("Target Lost", "Target died or knocked - unlocked", 2)
            _0xCACFG["Enabled"] = false
            return nil
        end
        
        return nil
    end
    
    local function _0xFINDM()
        local bt = nil
        local sd = math.huge
        local mp = _0xUIS:GetMouseLocation()
        
        for _, p in ipairs(_0xPLRS:GetPlayers()) do
            if p ~= _0xLPLR and p.Character then
                if not _0xISKO(p.Character) then
                    local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local sp, os = _0xCCAM:WorldToViewportPoint(hrp.Position)
                        if os and sp.Z > 0 then
                            local d = (Vector2.new(sp.X, sp.Y) - mp).Magnitude
                            if d < sd then
                                sd = d
                                bt = hrp
                            end
                        end
                    end
                end
            end
        end
        
        return bt
    end
    
    local function _0xFINDC()
        local bt = nil
        local sd = math.huge
        local cs = Vector2.new(_0xCCAM.ViewportSize.X / 2, _0xCCAM.ViewportSize.Y / 2)
        
        for _, p in ipairs(_0xPLRS:GetPlayers()) do
            if p ~= _0xLPLR and p.Character then
                if not _0xISKO(p.Character) then
                    local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local sp, os = _0xCCAM:WorldToViewportPoint(hrp.Position)
                        if os and sp.Z > 0 then
                            local d = (Vector2.new(sp.X, sp.Y) - cs).Magnitude
                            if d < sd then
                                sd = d
                                bt = hrp
                            end
                        end
                    end
                end
            end
        end
        
        return bt
    end
    
    if _0xMOBILE and _0xLBTN then
        print("[Mooze] Setting up mobile lock button click handler")
        _0xLBTN.MouseButton1Click:Connect(function()
            if not _0xLOCKED then
                local bt = _0xFINDC()
                
                if bt then
                    _0xLOCKED = true
                    _0xLOCKTGT = bt
                    _0xLBTN.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
                    _0xLBTN.BorderColor3 = Color3.fromRGB(0, 255, 0)
                    _0xTWEEN:Create(_0xLBTN, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 150, 0)}):Play()
                    
                    local p = _0xPLRS:GetPlayerFromCharacter(bt.Parent)
                    if p then
                        _0xNOTIFY("Locked On", p.Name .. " (Mobile Mode)", 3)
                    end
                    
                    _0xCACFG["Enabled"] = true
                else
                    _0xNOTIFY("No Target", "No valid player found", 2)
                end
            else
                _0xLOCKED = false
                _0xLOCKTGT = nil
                _0xCACFG["Enabled"] = false
                _0xLBTN.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                _0xLBTN.BorderColor3 = Color3.fromRGB(255, 0, 0)
                _0xNOTIFY("Unlocked", "Lock disabled", 2)
            end
        end)
    end
    
    if not _0xMOBILE then
        _0xUIS.InputBegan:Connect(function(i, pr)
            if pr then return end
            if i.KeyCode == _0xAK then
                if not _0xLOCKED then
                    local bt = _0xFINDM()
                    
                    if bt then
                        _0xLOCKED = true
                        _0xLOCKTGT = bt
                        
                        local p = _0xPLRS:GetPlayerFromCharacter(bt.Parent)
                        if p then
                            _0xNOTIFY("Locked On", p.Name .. " (PC Mode)", 3)
                        end
                        
                        _0xCACFG["Enabled"] = true
                    else
                        _0xNOTIFY("No Target", "No valid player near mouse", 2)
                    end
                else
                    _0xLOCKED = false
                    _0xLOCKTGT = nil
                    _0xCACFG["Enabled"] = false
                    _0xNOTIFY("Unlocked", "Lock disabled", 2)
                end
            end
        end)
    end
    
    _0xRS.RenderStepped:Connect(function()
        if _0xCACFG["Enabled"] then
            local tp = _0xGETTGT()
            if tp then
                local tpos = tp.Position
                _0xCCAM.CFrame = CFrame.new(_0xCCAM.CFrame.Position, tpos)
            end
        end
    end)
end

-- Silent Aimbot (FIXED FOR MOBILE/SHIFTLOCK)
do
    local _0xSACFG = getgenv().Mooze["Silent Aimbot"]
    local _0xLP = _0xPLRS.LocalPlayer
    local _0xC = _0x2[5].CurrentCamera
    local _0xM = _0xLP:GetMouse()
    local _0xLMP = Vector2.new(0,0)
    local _0xCT = nil
    
    local function _0xGETCP(p)
        local bp, bd = nil, math.huge
        local ps = _0xSACFG["Closest Point"] and _0xSACFG["Closest Point"]["Point Scale"] or 1.0
        if p.Character then
            local pts = _0xGETBP(p.Character)
            for _, pt in ipairs(pts) do
                local sp, os = _0xC:WorldToViewportPoint(pt.Position)
                if os and sp.Z > 0 then
                    local pp = Vector2.new(sp.X, sp.Y)
                    local d = (_0xLMP - pp).Magnitude * ps
                    if d < bd then
                        bp, bd = pt, d
                    end
                end
            end
        end
        return bp
    end
    
    local _0xFOVC = Drawing.new("Circle")
    _0xFOVC.Visible = _0xSACFG["FOV"]["Enabled"] and not _0xMOBILE
    _0xFOVC.Transparency = 1
    _0xFOVC.Thickness = 2
    _0xFOVC.Color = Color3.new(1, 1, 1)
    _0xFOVC.NumSides = 100
    _0xFOVC.Filled = false
    
    local _0xLFU = 0
    local _0xFUI = 0.033
    
    local function _0xISSL()
        if _0xLP.Character then
            local tool = _0xLP.Character:FindFirstChildOfClass("Tool")
            if tool and tool:FindFirstChild("Ammo") then
                return true
            end
        end
        
        local pg = _0xLP:FindFirstChildOfClass("PlayerGui")
        if pg then
            local ag = pg:FindFirstChild("Aim")
            if ag and ag.Visible then
                return true
            end
        end
        
        local m = _0xLP:GetMouse()
        if m.Icon == "rbxasset://SystemCursors/Cross" then
            return true
        end
        
        local pm = _0xLP.PlayerScripts:FindFirstChild("PlayerModule")
        if pm then
            local cm = pm:FindFirstChild("CameraModule")
            if cm then
                local mlc = cm:FindFirstChild("MouseLockController")
                if mlc then
                    local iml = mlc:FindFirstChild("isMouseLocked")
                    if iml and iml.Value then
                        return true
                    end
                end
            end
        end
        
        return false
    end
    
    local function _0xUPDFOV()
        if _0xMOBILE or _0xISSL() then
            local cs = Vector2.new(_0xC.ViewportSize.X / 2, _0xC.ViewportSize.Y / 2)
            _0xLMP = cs
        else
            _0xLMP = _0xUIS:GetMouseLocation()
        end
        
        local fc = _0xSACFG["FOV"]
        local ct = nil
        if _0xLP.Character then
            ct = _0xLP.Character:FindFirstChildOfClass("Tool")
        end
        local r = fc["Size"].X * 5
        
        if fc["Weapons Configuration"] and fc["Weapons Configuration"]["Enabled"] and ct then
            local wn = string.lower(ct.Name or "")
            if string.find(wn, "shotgun") then
                r = fc["Weapons Configuration"]["Shotguns"].X * 5
            elseif string.find(wn, "pistol") then
                r = fc["Weapons Configuration"]["Pistols"].X * 5
            end
        end
        
        if _0xMOBILE then
            r = _0xCURFOV * 5
        end
        
        _0xFOVC.Radius = r
        _0xFOVC.NumSides = math.clamp(math.floor(r * 2), 20, 100)
        _0xFOVC.Position = _0xLMP
        _0xFOVC.Visible = _0xSACFG["FOV"]["Enabled"] and not _0xMOBILE
        
        if _0xMOBILE and _0xMFOV then
            local cs = Vector2.new(_0xC.ViewportSize.X / 2, _0xC.ViewportSize.Y / 2)
            _0xMFOV.Position = cs
            _0xMFOV.Radius = _0xCURFOV * 5
            _0xMFOV.NumSides = math.clamp(math.floor(_0xCURFOV * 2), 20, 100)
            _0xMFOV.Visible = _0xSACFG["FOV"]["Enabled"]
        end
        
        local bp, bd = nil, math.huge
        for _, p in pairs(_0xPLRS:GetPlayers()) do
            if p ~= _0xLP and p.Character then
                local pt = nil
                if _0xSACFG["Hit Part"] == "Closest Point" then
                    pt = _0xGETCP(p)
                else
                    pt = p.Character:FindFirstChild("Head")
                end
                if pt then
                    local sp, os = _0xC:WorldToViewportPoint(pt.Position)
                    if os and sp.Z > 0 then
                        local pp = Vector2.new(sp.X, sp.Y)
                        local d = (_0xLMP - pp).Magnitude
                        if d < bd and d <= r then
                            bp, bd = pt, d
                        end
                    end
                end
            end
        end
        _0xCT = bp
    end
    
    _0xRS.Heartbeat:Connect(function(dt)
        _0xLFU = _0xLFU + dt
        if _0xLFU >= _0xFUI then
            _0xLFU = 0
            _0xUPDFOV()
        end
    end)
    
    local function _0xAPRED(cf, off)
        return cf * CFrame.new(off.X, off.Y, off.Z)
    end
    
    if _0xCAP[5] then
        local s = pcall(function()
            local mt = getrawmetatable(game)
            setreadonly(mt, false)
            local oi = mt.__index
            mt.__index = newcclosure(function(o, pr)
                if o:IsA("Mouse") and (pr == "Hit" or pr == "Target") then
                    local t = _0xCT
                    if t then
                        local pred = _0xSACFG["Prediction"]
                        local red = _0xSACFG["Client Bullet Redirection"]
                        local curt = (_0xLP.Character and _0xLP.Character:FindFirstChildOfClass("Tool")) or nil
                        if red["Enabled"] and curt then
                            local tn = tostring(curt.Name)
                            for _, w in ipairs(red["Weapons"]) do
                                if string.find(string.lower(tn), string.lower(w)) then
                                    pred = red["Prediction"]
                                    break
                                end
                            end
                        end
                        local pm = Vector3.new(pred.X, pred.Y, pred.Z)
                        local off = t.Velocity * pm
                        if pr == "Hit" then
                            return _0xAPRED(t.CFrame, off)
                        else
                            return t
                        end
                    end
                end
                return oi(o, pr)
            end)
        end)
        
        if s then
            print("[Silent Aimbot] Metatable hooking enabled with shiftlock fix")
        else
            warn("[Silent Aimbot] Metatable hooking failed, using basic mode")
            _0xNOTIFY("Silent Aimbot", "Running in basic mode", 5)
        end
    else
        warn("[Silent Aimbot] Metatable hooking not supported on this executor")
        _0xNOTIFY("Silent Aimbot", "Limited mode (no metatable)", 5)
    end
end

-- Rapid Fire
local _0xFIRING = false
local _0xU = {}

_0xU.get_gun = function()
    for _, t in next, game.Players.LocalPlayer.Character:GetChildren() do
        if t:IsA("Tool") and t:FindFirstChild("Ammo") then
            return t
        end
    end
end

_0xU.rapid = function(t)
    t:Activate()
end

game:GetService("UserInputService").InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        local g = _0xU.get_gun()
        if g and not _0xFIRING then
            _0xFIRING = true
            local gn = g.Name
            local m = 1
            local sc = getgenv().Mooze["Movement Modifications"]["Slowdown Modifications"]
            if sc and sc["Enabled"] then
                local wc = sc["Weapons"][gn]
                if wc then
                    m = wc["Multiplier"] or 1
                end
            end
            local frd = m
            while _0xFIRING do
                _0xU.rapid(g)
                task.wait(frd)
            end
        end
    end
end)

game:GetService("UserInputService").InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        _0xFIRING = false
    end
end)

-- Spread Modifications
local _0xSPCFG = getgenv().Mooze
    and getgenv().Mooze['Weapon Modifications']
    and getgenv().Mooze['Weapon Modifications']['Spread Modifications']

local _0xOH = 0.1
local _0xOV = 0.1

local function _0xNORM(s)
    return tostring(s):lower():gsub("%W", "")
end

local function _0xAPSP()
    if not _0xSPCFG or not _0xSPCFG.Enabled then
        return
    end
    
    for wk, st in pairs(_0xSPCFG) do
        if wk ~= "Enabled" and type(st) == "table" then
            local m = st.Multiplier
            local hs = _0xOH * m
            local vs = _0xOV * m
            local kn = _0xNORM(wk)
            
            for _, fn in ipairs(getgc(true)) do
                if type(fn) == "function"
                and islclosure(fn)
                and not isexecutorclosure(fn)
                then
                    local inf = debug.getinfo(fn)
                    if inf and inf.short_src then
                        local sn = _0xNORM(inf.short_src)
                        if sn:find(kn, 1, true) then
                            for idx, c in ipairs(debug.getconstants(fn)) do
                                if type(c) == "number" then
                                    if c > 0 and c < 0.1 then
                                        debug.setconstant(fn, idx, hs)
                                    elseif c >= 0.1 and c < 0.3 then
                                        debug.setconstant(fn, idx, vs)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

_0xAPSP()

if _0xPLR.Character then
    _0xAPSP()
end
_0xPLR.CharacterAdded:Connect(function()
    task.wait(1)
    _0xAPSP()
    _0xBPCACHE = {}
end)

-- Walkspeed
local _0xMZ = getgenv().Mooze
local _0xSPCFG2 = _0xMZ["Movement Modifications"]["Speed Modifications"]

print("[Walkspeed] Config Enabled:", _0xSPCFG2.Enabled)
if _0xSPCFG2.Enabled then
    print("[Walkspeed] Normal Multiplier:", _0xSPCFG2.Normal.Multiplier)
end

if _0xSPCFG2.Enabled then
    local _0xC = _0xPLR.Character or _0xPLR.CharacterAdded:Wait()
    local _0xH = _0xC:FindFirstChildOfClass("Humanoid") or _0xC:WaitForChild("Humanoid")
    
    local _0xSHOOT = false
    local _0xRELOAD = false
    local _0xLHT = 50
    
    local _0xMS = _0xPLR:GetMouse()
    
    _0xMS.Button1Down:Connect(function()
        _0xSHOOT = true
    end)
    
    _0xMS.Button1Up:Connect(function()
        _0xSHOOT = false
    end)
    
    _0xUIS.InputBegan:Connect(function(i, g)
        if g then return end
        if i.KeyCode == Enum.KeyCode.R and not _0xRELOAD then
            _0xRELOAD = true
            task.delay(1.5, function()
                _0xRELOAD = false
            end)
        end
    end)
    
    _0xPLR.CharacterAdded:Connect(function(c)
        _0xC = c
        _0xH = c:FindFirstChildOfClass("Humanoid") or c:WaitForChild("Humanoid")
        _0xSHOOT = false
        _0xRELOAD = false
    end)
    
    _0xRS.RenderStepped:Connect(function()
        if not _0xSPCFG2.Enabled then return end
        if not _0xH or _0xH.Health <= 0 then return end
        
        local sp = _0xSPCFG2.Normal and _0xSPCFG2.Normal.Multiplier or _0xH.WalkSpeed
        
        if _0xH.Health < _0xLHT and _0xSPCFG2["Low Health"] then
            sp = _0xSPCFG2["Low Health"].Multiplier
        elseif _0xRELOAD and _0xSPCFG2.Reloading then
            sp = _0xSPCFG2.Reloading.Multiplier
        elseif _0xSHOOT and _0xSPCFG2.Shooting then
            sp = _0xSPCFG2.Shooting.Multiplier
        end
        
        if _0xH.WalkSpeed ~= sp then
            _0xH.WalkSpeed = sp
        end
    end)
    
    print("[Walkspeed] WalkSpeed-based system enabled")
    print("[Walkspeed] Speed:", _0xSPCFG2.Normal.Multiplier)
else
    print("[Walkspeed] Disabled by config")
end
