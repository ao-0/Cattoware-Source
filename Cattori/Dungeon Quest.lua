if type(_G.running) == "function" then _G.running() end 
local running = true
local Material = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/MaterialLua/master/Module.lua"))()

local UI = Material.Load({
     Title = "Dungeon Quest",
     Style = 1,
     SizeX = 350,
     SizeY = 300,
     Theme = "Dark"
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
local localplayer = game.Players.LocalPlayer
local mouse = localplayer:GetMouse()
local autofarm

MainPage.Toggle({
    Text = "Auto Clear Enemy",
    Callback = function(State)
        autofarm = State
        print(autofarm)
    end,
    Enabled = false
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
    fov.component.Color = Color3.fromRGB(255, 105, 180)
    fov.component.Visible = false
    fov.component.Position = Vector2.new(mouse.X, mouse.Y+36)
    while running do
        fov.component.Position = Vector2.new(mouse.X, mouse.Y+36)
        fov.component.Color = ESP.Color
        fov.component.Radius = fov.size
        renderStepped:wait()

        if autofarm then
            for i, v in next, workspace:GetDescendants() do
                if v ~= localplayer then
                    if v:FindFirstChildOfClass("Humanoid") and v ~= localplayer.Character then
                        repeat wait()
                            target.Humanoid.Health = 0
                        until target.Humanoid.Health < 0.1
                    end
                end
            end
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