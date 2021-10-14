if type(_G.running) == "function" then _G.running() end 
local running = true
local Material = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/MaterialLua/master/Module.lua"))()

local UI = Material.Load({
     Title = "Cattoware | Elemental Battleground",
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

local GHPage = UI.New({
    Title = "Game Hooks"
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
elementalrn = "Fire"
MainPage.Dropdown({
    Text = "Elemental",
    Callback = function(State)
        elementalrn = State
    end,
    Options = {"Fire", "Grass", "Water"}
})
local autofarm
local spam
MainPage.Toggle({
    Text = "Enable Farm",
    Callback = function(State)
        autofarm = State
    end,
    Enabled = false
})
MainPage.Toggle({
    Text = "Enable Spam",
    Callback = function(State)
        spam = State
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
    
    
        if spam then
            game:GetService("ReplicatedStorage").Remotes.DoClientMagic:FireServer("Grass", "Spore Bombs")
                wait()
                game:GetService("ReplicatedStorage").Remotes.DoMagic:InvokeServer(
                    "Grass",
                    "Spore Bombs",
                    CFrame.new(
                        -1632.29602,
                        40.9587402,
                        921.052429,
                        0.94363457,
                        -0.0706476048,
                        -0.323361903,
                        -0,
                        0.976955473,
                        -0.213443667,
                        0.33098945,
                        0.201412827,
                        0.921888769
                        )
                    )
                wait()
                game:GetService("ReplicatedStorage").Remotes.DoMagic:InvokeServer("Grass", "Poison Needles")
                wait()
                game:GetService("ReplicatedStorage").Remotes.DoMagic:InvokeServer("Grass", "Poison Needles")
                wait()
                game:GetService("ReplicatedStorage").Remotes.DoClientMagic:FireServer("Grass", "Poison Needles")
                wait()
                game:GetService("ReplicatedStorage").Remotes.DoMagic:InvokeServer(
                    "Fire",
                    "Consecutive Fire Bullets",
                        CFrame.new(
                            -1632.29602,
                            40.9587402,
                            921.052429,
                            0.94363457,
                            -0.0706476048,
                            -0.323361903,
                            -0,
                            0.976955473,
                            -0.213443667,
                            0.33098945,
                            0.201412827,
                            0.921888769
                        )
                    )
                wait()
                game:GetService("ReplicatedStorage").Remotes.DoClientMagic:FireServer(
                    "Fire",
                    "Consecutive Fire Bullets"
                )
                wait()
                game:GetService("ReplicatedStorage").Remotes.DoMagic:InvokeServer("Fire", "Blaze Column")
                wait()
                game:GetService("ReplicatedStorage").Remotes.DoClientMagic:FireServer("Fire", "Blaze Column")
                wait()
                game:GetService("ReplicatedStorage").Remotes.DoMagic:InvokeServer("Water", "Water Beam")
                wait()
                game:GetService("ReplicatedStorage").Remotes.DoClientMagic:FireServer("Water", "Water Beam")
                wait()
                game:GetService("ReplicatedStorage").Remotes.DoMagic:InvokeServer("Water", "Water Tornado")
                wait()
                game:GetService("ReplicatedStorage").Remotes.DoClientMagic:FireServer("Water", "Water Tornado")
            end
        fov.component.Color = ESP.Color
        fov.component.Radius = fov.size
        renderStepped:wait()
        
        
        if autofarm then
            if elementalrn == "Water" then
                game:GetService("ReplicatedStorage").Remotes.DoMagic:InvokeServer("Water", "Water Beam")
                wait()
                game:GetService("ReplicatedStorage").Remotes.DoClientMagic:FireServer("Water", "Water Beam")
                wait()
                game:GetService("ReplicatedStorage").Remotes.DoMagic:InvokeServer("Water", "Water Tornado")
                wait()
                game:GetService("ReplicatedStorage").Remotes.DoClientMagic:FireServer("Water", "Water Tornado")
            elseif elementalrn == "Fire" then
                game:GetService("ReplicatedStorage").Remotes.DoMagic:InvokeServer("Fire","Consecutive Fire Bullets",
                    CFrame.new(
                        -1632.29602,
                        40.9587402,
                        921.052429,
                        0.94363457,
                        -0.0706476048,
                        -0.323361903,
                        -0,
                        0.976955473,
                        -0.213443667,
                        0.33098945,
                        0.201412827,
                        0.921888769
                    )
                )
                wait()
                game:GetService("ReplicatedStorage").Remotes.DoClientMagic:FireServer(
                    "Fire",
                    "Consecutive Fire Bullets"
                )
                wait()
                game:GetService("ReplicatedStorage").Remotes.DoMagic:InvokeServer("Fire", "Blaze Column")
                wait()
                game:GetService("ReplicatedStorage").Remotes.DoClientMagic:FireServer("Fire", "Blaze Column")
            elseif elementalrn == "Grass" then
                game:GetService("ReplicatedStorage").Remotes.DoClientMagic:FireServer("Grass", "Spore Bombs")
                wait()
                game:GetService("ReplicatedStorage").Remotes.DoMagic:InvokeServer("Grass","Spore Bombs",
                    CFrame.new(
                        -1632.29602,
                        40.9587402,
                        921.052429,
                        0.94363457,
                        -0.0706476048,
                        -0.323361903,
                        -0,
                        0.976955473,
                        -0.213443667,
                        0.33098945,
                        0.201412827,
                        0.921888769
                    )
                )
                wait()
                game:GetService("ReplicatedStorage").Remotes.DoMagic:InvokeServer("Grass", "Poison Needles")
                wait()
                game:GetService("ReplicatedStorage").Remotes.DoMagic:InvokeServer("Grass", "Poison Needles")
                wait()
                game:GetService("ReplicatedStorage").Remotes.DoClientMagic:FireServer("Grass", "Poison Needles")
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