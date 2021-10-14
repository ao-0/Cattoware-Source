if type(_G.running) == "function" then _G.running() end 
local running = true
local Material = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/MaterialLua/master/Module.lua"))()

local UI = Material.Load({
     Title = "Cattoware | Super Power Fighting Simulator",
     Style = 1,
     SizeX = 350,
     SizeY = 300,
     Theme = "Dark"
})

local WelcomePage = UI.New({
    Title = "Welcome"
})

WelcomePage.Button({
    Text = "cattoware.tk/discord (click for invite)",
    Callback = function()
        setclipboard("discord.gg/xjg2KHm")
    end
})

local MainPage = UI.New({
    Title = "Main"
})
local VisualsPage = UI.New({
    Title = "Visuals"
})
local camera = game.Workspace.CurrentCamera
local settings = {
		keybind = Enum.KeyCode.E
	}
local fov = {
    component = Drawing.new("Circle");
    size = 300;
}
local autospeed
local autodurability
local autostrength
local autojumpforce
local autopsychic
MainPage.Toggle({
    Text = "Auto Speed",
    Callback = function(State)
        autospeed = State
    end,
    Enabled = false
})
MainPage.Toggle({
    Text = "Auto Strength",
    Callback = function(State)
        autostrength = State
    end,
    Enabled = false
})
MainPage.Toggle({
    Text = "Auto Durability",
    Callback = function(State)
        autodurability = State
    end,
    Enabled = false
})
MainPage.Toggle({
    Text = "Auto JumpForce",
    Callback = function(State)
        autojumpforce = State
    end,
    Enabled = false
})
MainPage.Toggle({
    Text = "Auto Psychic",
    Callback = function(State)
        autopsychic = State
    end,
    Enabled = false
})
local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/VaultGitos/Alantic-LUA/main/KiriotESP.lua"))()
ESP.Color = Color3.fromRGB(127, 95, 221)
ESP.TeamMates = false
VisualsPage.Toggle({
    Text = "ESP",
    Callback = function(State)
        ESP:Toggle(State)
    end,
    Enabled = false
})
VisualsPage.Toggle({
    Text = "Box",
    Callback = function(State)
        ESP.Boxes = State
    end,
    Enabled = false
})
VisualsPage.Toggle({
    Text = "Name",
    Callback = function(State)
        ESP.Names = State
    end,
    Enabled = false
})
VisualsPage.Toggle({
    Text = "Tracer",
    Callback = function(State)
        ESP.Tracers = State
    end,
    Enabled = false
})
VisualsPage.Toggle({
    Text = "FOV",
    Callback = function(State)
        ESP.FOV = State
        fov.component.Visible = State
    end,
    Enabled = false
})
VisualsPage.Slider({
    Text = "FOV Size",
    Callback = function(num)
        fov.size = num
    end,
    Min = 600,
    Max = 50,
    Def = 100
})
VisualsPage.ColorPicker({
    Text = "ESP Color",
    Default = Color3.fromRGB(127, 95, 221),
    Callback = function(value)
        ESP.Color = value
    end
})
spawn(function()
    local renderStepped = game:GetService("RunService").RenderStepped
    fov.component.Thickness = 3
    fov.component.NumSides = 15
    fov.component.Transparency = .25
    fov.component.Color = Color3.fromRGB(255, 105, 180)
    fov.component.Visible = false
    fov.component.Position = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    while running do
        fov.component.Color = ESP.Color
        fov.component.Radius = fov.size
        renderStepped:wait()
        
        if autospeed then
            wait(1)
            game:GetService("ReplicatedStorage").RemoteEvent:FireServer({"+MS1"})
        end
        if autojumpforce then
            wait(1)
            game:GetService("ReplicatedStorage").RemoteEvent:FireServer({"+JF1"})
        end
        if autodurability then
            wait(1)
            game:GetService("ReplicatedStorage").RemoteEvent:FireServer({"+BT1"})
        end
        if autojumpforce then
            wait(1)
            game:GetService("ReplicatedStorage").RemoteEvent:FireServer({"+JF1"})
        end
        if autopsychic then
            wait(1)
            game:GetService("ReplicatedStorage").RemoteEvent:FireServer({"+PP1"})
        end
        if autostrength then
            wait(1)
            game:GetService("ReplicatedStorage").RemoteEvent:FireServer({"+FS1"})
        end
    end
end)

_G.running = function()
    running = false
    _G.running = nil
    ESP:Toggle(false)
    fov.component.Visible = false
    fov.component:Remove()
end