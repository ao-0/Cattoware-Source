if type(_G.running) == "function" then _G.running() end 
local running = true
local Material = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/MaterialLua/master/Module.lua"))()

local UI = Material.Load({
     Title = "Cattoware | Ragdoll System Test",
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
local fov = {
    component = Drawing.new("Circle");
    size = 300;
}
local players = game:GetService("Players")
local plr = players.LocalPlayer
local mouse = plr:GetMouse()
local Cooldown = nil
local ART = nil
local AD = nil

MainPage.TextField({
    Text = "Cooldown",
    Callback = function(value)
        Cooldown = tonumber(value)
    end
})
MainPage.TextField({
    Text = "Attack Rest Time",
    Callback = function(value)
        ART = tonumber(value)
    end
})
MainPage.Button({
    Text = "Apply Mod",
    Callback = function()
        local getplr = game.Players.LocalPlayer
        local no = getplr.Backpack.Punch.Settings
        a = require(no)
        local no2 = getplr.Backpack.Haymaker.Settings
        a1 = require(no2)
        local no3 = getplr.Backpack.Uppercut.Settings
        a2 = require(no3)
        local no4 = getplr.Backpack.Kick.Settings
        a3 = require(no4)
        a.CooldownFrequency = Cooldown
        a.AttackRestTime = ART
        
        a1.CooldownFrequency = Cooldown
        a1.AttackRestTime = ART
        
        a2.CooldownFrequency = Cooldown
        a2.AttackRestTime = ART
        
        a3.CooldownFrequency = Cooldown
        a3.AttackRestTime = ART
    end
})
local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/VaultGitos/Alantic-LUA/main/KiriotESP.lua"))()
ESP.Color = Color3.fromRGB(127, 95, 221)
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
    fov.component.Color = Color3.fromRGB(127, 95, 221)
    fov.component.Visible = false
    fov.component.Position = Vector2.new(mouse.X, mouse.Y+36)
    while running do
        fov.component.Position = Vector2.new(mouse.X, mouse.Y+36)
        fov.component.Color = ESP.Color
        fov.component.Radius = fov.size
        renderStepped:wait()
    end
end)

_G.running = function()
    running = false
    _G.running = nil
    ESP:Toggle(false)
    fov.component.Visible = false
    fov.component:Remove()
end