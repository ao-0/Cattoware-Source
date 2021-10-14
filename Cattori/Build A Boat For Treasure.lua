if type(_G.running) == "function" then _G.running() end 
local running = true
local Material = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/MaterialLua/master/Module.lua"))()

local UI = Material.Load({
     Title = "Build A Boat For Treasure",
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
autofarm = false
local Velocity=Instance.new'BodyVelocity'
Velocity.Parent=nil
Velocity.MaxForce=Vector3.new(math.huge,math.huge,math.huge)
local plr=game:GetService'Players'.LocalPlayer
local Chest=game:GetService("Workspace").BoatStages.NormalStages.TheEnd:WaitForChild('GoldenChest').Trigger
local ChestPos=Chest.Position
local StartCF=CFrame.new(0,40,300)

MainPage.Toggle({
    Text = "Auto Farm",
    Callback = function(bool)
        autofarm = bool
        if autofarm then
            repeat wait()
                local char=plr.Character or plr.CharacterAdded:Wait()
                local HRP=char:FindFirstChild'HumanoidRootPart'
                local Hum=char:FindFirstChildOfClass'Humanoid'
                if HRP and (Hum and Hum.Health>0) and bool then
                    for i,v in pairs(game:GetService("Workspace"):GetDescendants()) do 
                        if v:IsA("Part") then 
                            v.CanCollide = false
                        end
                    end
                HRP.CFrame=StartCF
                Chest.CFrame=CFrame.new(ChestPos)
                Velocity.Parent=HRP
                Velocity.Velocity=Vector3.new(0,0,500)
                repeat wait() until (ChestPos-HRP.Position).Magnitude<=500 or not bool or not HRP or not (Hum or Hum.Health<=0)
                Velocity.Velocity=Vector3.new(0,0,0)
                wait(.25)
                Chest.CFrame=HRP.CFrame
                wait(5)
                if (Hum and Hum.Health>0) then
                    Hum.Health=0
                end
                plr.CharacterAdded:Wait()
                    wait(5)
                end
            until not bool
        elseif autofarm == false then
            Velocity.Parent=nil
            Velocity.Velocity=Vector3.new(0,0,0)
            local char=plr.Character or plr.CharacterAdded:Wait()
            local Hum=char:FindFirstChildOfClass'Humanoid'
            for i,v in pairs(game:GetService("Workspace"):GetDescendants()) do 
                if v:IsA("Part") then 
                    v.CanCollide = true
                end
            end
        end
    end,
    Enabled = false
})
MainPage.Toggle({
    Text = "Anti AFK",
    Callback = function(state)
        for i, v in next, getconnections(game.Players.LocalPlayer.Idled) do
            v:Disable()
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