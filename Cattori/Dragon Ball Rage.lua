if type(_G.running) == "function" then _G.running() end 
local running = true
local Material = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/MaterialLua/master/Module.lua"))()

local UI = Material.Load({
     Title = "Dragon Ball Rage",
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
local autoattack
local autodefense
local ChargeState
local autoki


MainPage.Toggle({
    Text = "Auto Attack",
    Callback = function(value)
        autoattack = value
        while autoattack do
            wait()
            game.ReplicatedStorage.Remotes.Training.Combat:InvokeServer()
        end
    end,
    Enabled = false
})
MainPage.Toggle({
    Text = "Auto Defense",
    Callback = function(value)
        autodefense = value
        while autodefense do
            wait()
            game.ReplicatedStorage.Remotes.Training.Defense:InvokeServer()
        end
    end,
    Enabled = false
})
MainPage.Toggle({
    Text = "Auto Ki Blast",
    Callback = function(value)
        autoki = value
        while autoki do
            wait()
            game.ReplicatedStorage.Remote.KiBlast:InvokeServer()
        end
    end,
    Enabled = false
})
MainPage.Toggle({
    Text = "Auto Charge",
    Callback = function(value)
        ChargeState = value
        if ChargeState == true then
            while ChargeState and wait() do
                game.ReplicatedStorage.Remotes.Training.Charge:InvokeServer()
            end
        elseif ChargeState == false then
            game.ReplicatedStorage.Remotes.Training.ChargeFinish:FireServer()
        end
    end,
    Enabled = false
})
MainPage.Button({
    Text = "Fight Goku",
    Callback = function()
        local args = {
            [1] = 1,
            [2] = {
                ["Messages"] = {
                    [1] = {
                        ["Delay"] = 3,
                        ["Text"] = "cattoware kinda cool :money:"
                    },
                    [2] = {
                        ["Delay"] = 3,
                        ["Text"] = "bruh?"
                    },
                    [3] = {
                        ["Responses"] = {
                            [1] = {
                                [1] = "beat goku ass",
                                [2] = true
                            },
                            [2] = {
                                [1] = "naw",
                                [2] = false
                            }
                        },
                        ["Text"] = "beat my ass"
                    }
                },
                ["Name"] = "Goku",
                ["ModelName"] = "Goku"
            }
        }
        
        game:GetService("ReplicatedStorage").Remote.Battle:FireServer(unpack(args))
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