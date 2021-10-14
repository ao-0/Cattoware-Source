if type(_G.running) == "function" then _G.running() end 
local running = true
local Material = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/MaterialLua/master/Module.lua"))()

local UI = Material.Load({
     Title = "Cattoware | Saber Simulator",
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
local MiscPage = UI.New({
    Title = "Misc"
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
local lifting
local selling
local autosabers
local autopets
local autoaura
local autoDNA
MainPage.Toggle({
    Text = "Auto Swing",
    Callback = function(State)
        lifting = State
    end,
    Enabled = false
})
MainPage.Toggle({
    Text = "Auto Sell",
    Callback = function(State)
        selling = State
    end,
    Enabled = false
})
MainPage.Toggle({
    Text = "Auto Buy All Sabers",
    Callback = function(State)
        autosabers = State
    end,
    Enabled = false
})
MainPage.Toggle({
    Text = "Auto Buy All DNA",
    Callback = function(State)
        autoDNA = State
    end,
    Enabled = false
})
MainPage.Toggle({
    Text = "Auto Buy All Pets",
    Callback = function(State)
        autopets = State
    end,
    Enabled = false
})
MainPage.Toggle({
    Text = "Auto Buy All Auras",
    Callback = function(State)
        autoaura = State
    end,
    Enabled = false
})
MiscPage.Button({
    Text = "Hide Tags",
    Callback = function()
        if game.Players.LocalPlayer.Character.Head.RankingGui:FindFirstChild("PName") and game.Players.LocalPlayer.Character.Head.RankingGui:FindFirstChild("Tag1") then
            game.Players.LocalPlayer.Character.Head.RankingGui.PName:Destroy()
            game.Players.LocalPlayer.Character.Head.RankingGui.Tag1:Destroy()
        end
    end
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
        
        if lifting then
            wait(1)
            game:GetService("ReplicatedStorage").Events.Clicked:FireServer()
        end
        if selling then
            wait(1)
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =CFrame.new(536.941833, 183.987778, 146.277451)
            wait(.8)
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(539.263245, 183.987839, 137.771301)
        end
        if autosabers then
            wait(1)
            game:GetService("ReplicatedStorage").Events.BuyAll:FireServer("Swords")
        end
        if autopets then
            wait(1)
            game:GetService("ReplicatedStorage").Events.BuyAll:FireServer("PetAuras")
        end
        if autoaura then
            wait(1)
            game:GetService("ReplicatedStorage").Events.BuyAll:FireServer("Auras")
        end
        if autoDNA then
            wait(1)
            game:GetService("ReplicatedStorage").Events.BuyAll:FireServer("Backpacks")
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