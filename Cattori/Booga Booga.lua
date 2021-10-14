local Finity = loadstring(game:HttpGet("https://raw.githubusercontent.com/CatzCode/cat/main/Finity%20Dracula"))()

local FinityWindow = Finity.new(false)
FinityWindow.ChangeToggleKey(Enum.KeyCode.RightShift)

local CreditsCategory = FinityWindow:Category("Welcome")
local ComboatCategory = FinityWindow:Category("Combat")
local CameraCategory = FinityWindow:Category("Camera")
local VisualsCategory = FinityWindow:Category("Visuals")

local CharacterSettings = ComboatCategory:Sector("Character Settings")
local BypassSettings = ComboatCategory:Sector("Bypass Settings")
local TeleportSettings = ComboatCategory:Sector("Teleports ( Dangerous )")

-- Camera Sectors

local CameraSettings = CameraCategory:Sector("Camera Settings")

-- Visuals Sectors
local VisualsESPSettings = VisualsCategory:Sector("ESP Settings")
local VisualsPlayerESP = VisualsCategory:Sector("Player ESP")
local VisualsNPCsESP = VisualsCategory:Sector("Misc ESP")


autoheal = false
autoheal_hp = 80
fovcircle = false
fovsize = 50
defaultcolor = Color3.fromRGB(255, 170, 0)
fovthickness = 3
fovfilled_toggle = false
tpspeed = 10

TeleportSettings:Cheat("Slider", "Teleport Speed", function(Value)
	tpspeed = tonumber(Value)
end, {min = 10, max = 40, suffix = " speed"})

TeleportSettings:Cheat("Textbox", "Teleport To Player", function(Value)
	local LP = game.Players.LocalPlayer
            function getRoot(char)
	        local rootPart = char:FindFirstChild('HumanoidRootPart') or char:FindFirstChild('Torso') or char:FindFirstChild('UpperTorso')
	            return rootPart
            end
            if LP.Character:FindFirstChildOfClass('Humanoid') and LP.Character:FindFirstChildOfClass('Humanoid').SeatPart then
                LP.Character:FindFirstChildOfClass('Humanoid').Sit = false
                wait(.1)
            end
            game:GetService("TweenService"):Create(getRoot(LP.Character), TweenInfo.new(tpspeed, Enum.EasingStyle.Linear), {CFrame = game.Players[Value].Character.HumanoidRootPart.CFrame}):Play()
end, {
	placeholder = "Teleport To Player"
})

BypassSettings:Cheat("Button", "Remove Name Tags", function()
    if game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("HealthGui") then
        game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.HealthGui:Destroy()
    end
    if game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("NameGui") then
        game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.NameGui:Destroy()
    end
end)

local FOVCircle = Drawing.new("Circle")
local mouse = game.Players.LocalPlayer:GetMouse()
CameraSettings:Cheat("Checkbox", "FOV Circle Enabled", function(State)
    fovcircle = State
    if fovcircle then
        booling = game:GetService("RunService").RenderStepped:Connect(function()
            FOVCircle.Thickness = fovthickness
            FOVCircle.Color = defaultcolor
            FOVCircle.Radius = fovsize
            FOVCircle.Visible = true
            FOVCircle.Position = Vector2.new(mouse.X, mouse.Y+36)
        end)
    else
        FOVCircle.Visible = false
        booling:Disconnect()
    end
end)
CameraSettings:Cheat("Slider", "FOV Circle Size", function(Value)
	fovsize = tonumber(Value)
end, {min = 20, max = 500, suffix = " size"})

CameraSettings:Cheat("Colorpicker", "ESP Color", function(State)
    defaultcolor = State
end)

CameraSettings:Cheat("Slider", "Field Of View", function(Value)
	game:GetService'Workspace'.Camera.FieldOfView = Value
end, {min = 70, max = 120, suffix = " studs"})

CharacterSettings:Cheat("Slider", "Auto Heal Health", function(Value)
	autoheal_hp = tonumber(Value)
end, {min = 40, max = 90, suffix = " health"})

CharacterSettings:Cheat("Checkbox", "Auto Heal Enabled", function(State)
    autoheal = State
    while autoheal do
        if game.Players.LocalPlayer.Character.Humanoid.Health < autoheal_hp then
            game:GetService("ReplicatedStorage").Events.UseBagItem:FireServer("Bloodfruit")
        end
        wait()
    end
end)

local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/VaultGitos/Alantic-LUA/main/KiriotESP.lua"))()

ESP:AddObjectListener(game:GetService("Workspace"), {
    Name = "Magnetite Bar",
    CustomName = "MagnetiteBar",
    Color = Color3.fromRGB(0,124,0),
    IsEnabled = "Mag"
})

ESP:AddObjectListener(workspace.Critters, {
    Color =  Color3.new(1,1,0),
    Type = "Model",
    PrimaryPart = function(obj)
        local hrp = obj:FindFirstChildWhichIsA("BasePart")
        while not hrp do
            wait()
            hrp = obj:FindFirstChildWhichIsA("BasePart")
        end
        return hrp
    end,
    Validator = function(obj)
        return not game.Players:GetPlayerFromCharacter(obj)
    end,
    CustomName = function(obj)
        return obj.Name
    end,
    IsEnabled = "NPCs",
})

ESP:AddObjectListener(workspace.Deployables, {
    Color =  Color3.fromRGB(0,255,0),
    Type = "Model",
    PrimaryPart = function(obj)
        local hrp = obj:FindFirstChildWhichIsA("BasePart")
        while not hrp do
            wait()
            hrp = obj:FindFirstChildWhichIsA("BasePart")
        end
        return hrp
    end,
    Validator = function(obj)
        return not game.Players:GetPlayerFromCharacter(obj)
    end,
    CustomName = function(obj)
        return obj.Name
    end,
    IsEnabled = "Boats",
})

ESP.Tracers = false
ESP.Names = false
ESP.Boxes = false
ESP.TeamColor = false
ESP.Players = false

VisualsESPSettings:Cheat("Checkbox", "ESP Enabled", function(State)
    ESP:Toggle(State)
end)
VisualsESPSettings:Cheat("Colorpicker", "ESP Color", function(State)
    ESP.Color = State
end)
VisualsPlayerESP:Cheat("Checkbox", "ESP Players Enabled", function(State)
    ESP.Players = State
end)
VisualsPlayerESP:Cheat("Checkbox", "Box Enabled", function(State)
	ESP.Boxes = State
end)
VisualsPlayerESP:Cheat("Checkbox", "Tracer Enabled", function(State) 
	ESP.Tracers = State
end)
VisualsPlayerESP:Cheat("Checkbox", "Name Enabled", function(State) 
	ESP.Names = State
end)
VisualsPlayerESP:Cheat("Checkbox", "Team Color Enabled", function(State) 
	ESP.TeamColor = State
end)
VisualsPlayerESP:Cheat("Checkbox", "Face Camera Enabled", function(State) 
	ESP.FaceCamera = State
end)

VisualsNPCsESP:Cheat("Checkbox", "ESP Magetites Bar Enabled", function(State) 
	ESP.Mag = State
end)

VisualsNPCsESP:Cheat("Checkbox", "ESP NPCs Enabled", function(State) 
	ESP.NPCs = State
end)

VisualsNPCsESP:Cheat("Checkbox", "ESP Boats Enabled", function(State) 
	ESP.Boats = State
end)

-- Create category

-- Create sectors
local welcome = CreditsCategory:Sector("Welcome To CatWare")
local CreditsCreator = CreditsCategory:Sector("Finity Library Creator")
local CreditsScripter = CreditsCategory:Sector("Scripter")
local DiscordInvite = CreditsCategory:Sector("Discord Invite")

-- Create labels
welcome:Cheat("Label", "Hello "..game.Players.LocalPlayer.Name.." !")
welcome:Cheat("Label", "Game : Ro Ghoul")
CreditsCreator:Cheat("Label", "detourious @ v3rmillion.net")
CreditsCreator:Cheat("Label", "deto#7612 @ discord.gg")
CreditsScripter:Cheat("Label", "Vault#0001 @ discord.gg")
CreditsScripter:Cheat("Label", "757148941346144256 @ discord.gg")
DiscordInvite:Cheat("Label", "discord.gg/gtASjRW @ CatCodeWare")