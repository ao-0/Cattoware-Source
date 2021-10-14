local Finity = loadstring(game:HttpGet("https://pastebin.com/raw/KFBs02vs"))()

local FinityWindow = Finity.new(true)
FinityWindow.ChangeToggleKey(Enum.KeyCode.RightShift)

local VisualsCategory = FinityWindow:Category("Visuals")
local AimbotCategory = FinityWindow:Category("Aimbot")

-- Visuals Sectors
local VisualsESPSettings = VisualsCategory:Sector("ESP Settings")
local VisualsPlayerESP = VisualsCategory:Sector("Player ESP")
local VisualsNPCsESP = VisualsCategory:Sector("NPCs ESP")

-- Aimbot Sectors
local AimbotColors = AimbotCategory:Sector("Aimbot Colors")
local AimbotHotkeys = AimbotCategory:Sector("Aimbot Hotkeys")
local AimbotConfigurations = AimbotCategory:Sector("Aimbot Configurations")

local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/VaultGitos/Alantic-LUA/main/KiriotESP.lua"))()

local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/VaultGitos/Alantic-LUA/main/KiriotESP.lua"))()
ESP:AddObjectListener(game:GetService("Workspace")["Zombie Storage"], {
    Color =  Color3.fromRGB(255,0,0),
    Type = "Model",
    PrimaryPart = function(obj)
        local hrp = obj:FindFirstChild("HumanoidRootPart")
        while not hrp do
            wait()
            hrp = obj:FindFirstChild("HumanoidRootPart")
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

ESP.NPCs = false
ESP.Tracers = false
ESP.Names = false
ESP.Boxes = false
ESP.TeamColor = false

VisualsESPSettings:Cheat("Checkbox", "ESP Enabled", function(State)
    ESP:Toggle(State)
end)
VisualsPlayerESP:Cheat("Checkbox", "ESP Players Enabled", function(State)
    ESP.Players = State
end)
VisualsPlayerESP:Cheat("Checkbox", "Players Box Enabled", function(State)
	ESP.Boxes = State
end)
VisualsPlayerESP:Cheat("Checkbox", "Players Tracer Enabled", function(State) 
	ESP.Tracers = State
end)
VisualsPlayerESP:Cheat("Checkbox", "Players Name Enabled", function(State) 
	ESP.Names = State
end)
VisualsPlayerESP:Cheat("Checkbox", "Team Color Enabled", function(State) 
	ESP.TeamColor = State
end)
VisualsNPCsESP:Cheat("Checkbox", "ESP NPCs Enabled", function(State) 
	ESP.NPCs = State
end)
VisualsPlayerESP:Cheat("Checkbox", "Face Camera Enabled", function(State) 
	ESP.FaceCamera = State
end)

AimbotConfigurations:Cheat(
	"Checkbox", 
	"Aimbot Enabled", 
	function(State) 
		print("Checkbox state changed:", State)
	end
)

VisualsESPSettings:Cheat("Colorpicker", "ESP Color", function(Value)
	ESP.Color = Value
end, {})

AimbotConfigurations:Cheat("Slider", "Aimbot FOV", function(Value)
	print("Silder value changed:", Value)
end, {min = 0, max = 120, suffix = "°"})

AimbotConfigurations:Cheat("Dropdown", "Aimbot Mode", function(Option)
	print("Dropdown option changed:", Option)
end, {
	options = {
		"FOV",
		"Distance",
		"Visibility"
	}
})
local mouse = game.Players.LocalPlayer:GetMouse()

local FOVCircle = Drawing.new("Circle")
FOVCircle.Radius = 50
FOVCircle.Color = Color3.fromRGB(255, 170, 0)
FOVCircle.Thickness = 3
FOVCircle.Filled = false

local CircleTbl = {
    Update = function()
        FOVCircle.Position = Vector2.new(mouse.X, mouse.Y+36)
    end
}
table.insert(ESP.Objects, CircleTbl)

-- Aimbot Textboxes
AimbotColors:Cheat("Textbox", "BrickColor Input", function(Value)
	print("Textbox value changed:", Value)
end, {
	placeholder = "BrickColor"
})
AimbotHotkeys:Cheat("Textbox", "Quick Toggle Hotkey", function(Value)
	print("Textbox value changed:", Value)
end, {
	placeholder = "KeyCode"
})
AimbotHotkeys:Cheat("Textbox", "Panic Hotkey", function(Value)
	print("Textbox value changed:", Value)
end, {
	placeholder = "KeyCode"
})

VisualsPlayerESP:Cheat("Button", "Reset Whitelist", function()
	print("Button pressed")
end)

AimbotColors:Cheat("Button", "Reset Color", function()
	print("Button pressed")
end)

AimbotHotkeys:Cheat("Button", "Reset Key", function()
	print("Button pressed")
end)

-- Create category
local CreditsCategory = FinityWindow:Category("Credits")

-- Create sectors
local CreditsCreator = CreditsCategory:Sector("Finity Library Creator")
local CreditsSpecialThanks = CreditsCategory:Sector("Special Thanks")
local CreditsTesters = CreditsCategory:Sector("Testers")

-- Create labels
CreditsCreator:Cheat("Label", "detourious @ v3rmillion.net")
CreditsCreator:Cheat("Label", "deto#7612 @ discord.gg")

CreditsSpecialThanks:Cheat("Label", "wallythebird - held me hostage")
CreditsSpecialThanks:Cheat("Label", "Jan - some inspiration from his lib showcase")
CreditsSpecialThanks:Cheat("Label", "& all of you for supporting me <3")

CreditsTesters:Cheat("Label", "detourious - made the darn thing")