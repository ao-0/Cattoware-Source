if type(_G.running) == "function" then _G.running() end 
local running = true
local Material = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/MaterialLua/master/Module.lua"))()

local UI = Material.Load({
     Title = "Dragon Blox Ultimate",
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

local GuiInset = game:GetService("GuiService"):GetGuiInset()
local players = game:GetService("Players")
local plr = players.LocalPlayer
local mouse = plr:GetMouse()
local camera = game.Workspace.CurrentCamera
local UIS = game:GetService("UserInputService")
local fov = {
    component = Drawing.new("Circle");
    size = 300;
}
local rainbow = {
    enabled = true;
    originalColor3 = nil;
}
mobs = nil
autofarm = false
hit = false
autofarm = false

local HRT = game.Players.LocalPlayer.Character.HumanoidRootPart

local Character_Table = {}

for i, v in pairs(game:GetService("Workspace").Living:GetChildren()) do
    if v:IsA("Model") then
        table.insert(Character_Table, v.Name)
    end
end

MainPage.Dropdown({
    Text = "Mob",
    Callback = function(value)
        mobs = value
    end,
    Options = Character_Table
})

MainPage.Toggle({
    Text = "Auto Hit",
    Callback = function(value)
        hit = value
        while hit do
            game:GetService("ReplicatedStorage").Package.Events.p:FireServer("Blacknwhite27", 1)
            wait(.5)
            game:GetService("ReplicatedStorage").Package.Events.p:FireServer("Blacknwhite27", 2)
            wait(.5)
            game:GetService("ReplicatedStorage").Package.Events.p:FireServer("Blacknwhite27", 3)
            wait(.5)
            game:GetService("ReplicatedStorage").Package.Events.p:FireServer("Blacknwhite27", 4)
        end
    end,
    Enabled = false
})

MainPage.Toggle({
    Text = "Auto Farm",
    Callback = function(value)
        autofarm = value
        while autofarm do
            for i, v in pairs(game:GetService("Workspace").Living:GetChildren()) do
                if v.Name == mobs and v:FindFirstChild("HumanoidRootPart") then
                    repeat
                        HRT.CFrame =
                        CFrame.new(
                            v.HumanoidRootPart.Position + Vector3.new(0, -5, 0),
                            v.HumanoidRootPart.Position
                        )
                        wait()
                    until v.Humanoid.Health < 0 or autofarm == false
                end
            end
        end
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