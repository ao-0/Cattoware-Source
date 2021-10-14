local Finity = loadstring(game:HttpGet("https://raw.githubusercontent.com/CatzCode/cat/main/Finity%20Dracula"))()

local FinityWindow = Finity.new(false)
FinityWindow.ChangeToggleKey(Enum.KeyCode.RightShift)

local CreditsCategory = FinityWindow:Category("Welcome")
local ComboatCategory = FinityWindow:Category("Combat")
local VisualsCategory = FinityWindow:Category("Visuals")

local TeleportSettings = ComboatCategory:Sector("Farm")

-- Visuals Sectors
local FOVESP = VisualsCategory:Sector("FOV")
local VisualsESPSettings = VisualsCategory:Sector("ESP Settings")
local VisualsPlayerESP = VisualsCategory:Sector("Player ESP")

local CreditsCreator = CreditsCategory:Sector("Credits")
local DiscordInvite = CreditsCategory:Sector("Discord Invite")

CreditsCreator:Cheat("Label", "deto#7612 | User Interface")
CreditsCreator:Cheat("Label", "Vault#0001 | Scripter")
CreditsCreator:Cheat("Label", "falseopx#2012 | Scripter")
DiscordInvite:Cheat("Label", "discord.gg/gtASjRW | Catto Hub uwu")

_G.silentaim = false

TeleportSettings:Cheat("Checkbox", "Silent Aim Enabled", function(bool)
    _G.silentaim = bool
end)
    
    local players = game:GetService("Players")
	local plr = players.LocalPlayer
	local mouse = plr:GetMouse()
	local camera = game.Workspace.CurrentCamera
local function ClosestPlayerToMouse()
    local target = nil
    local dist = math.huge
for i,v in pairs(players:GetPlayers()) do
    if v.Name ~= plr.Name then
        if v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health ~= 0 and v.Character:FindFirstChild("HumanoidRootPart") and _G.silentaim then
            local screenpoint = camera:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
					local check = (Vector2.new(mouse.X,mouse.Y)-Vector2.new(screenpoint.X,screenpoint.Y)).magnitude

            if check < dist then
                target  = v
                dist = check
            end
        end
    end
end

return target 
end
	
	local mt = getrawmetatable(game)
	local namecall = mt.__namecall
	setreadonly(mt,false)

	mt.__namecall = function(self,...)
		local args = {...}
		local method = getnamecallmethod()

		if tostring(self) == "ThrowKnife" and method == "FireServer" then
            args[1] = ClosestPlayerToMouse().Character.HumanoidRootPart.Position
			return self.FireServer(self, unpack(args))
		end
		return namecall(self,...)
	end

FOVESP:Cheat("Label", "if visuals not work prob ur exploit")

local FOVCircle = Drawing.new("Circle")
local mouse = game.Players.LocalPlayer:GetMouse()
FOVESP:Cheat("Checkbox", "FOV Circle Enabled", function(State)
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
FOVESP:Cheat("Slider", "FOV Circle Size", function(Value)
	fovsize = tonumber(Value)
end, {min = 20, max = 500, suffix = " size"})

FOVESP:Cheat("Colorpicker", "ESP Color", function(State)
    defaultcolor = State
end)

FOVESP:Cheat("Slider", "Field Of View", function(Value)
	game:GetService'Workspace'.Camera.FieldOfView = Value
end, {min = 70, max = 120, suffix = " studs"})

local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/VaultGitos/Alantic-LUA/main/KiriotESP.lua"))()

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