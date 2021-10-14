if type(_G.running) == "function" then _G.running() end 
local running = true
local Material = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/MaterialLua/master/Module.lua"))()

local UI = Material.Load({
     Title = "Cattoware | Skywar",
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

MainPage.Dropdown({
    Text = "Teleport To",
    Callback = function(value)
        if value == "Mega VIP" then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0.123065561, 264, 65.6255341)
        elseif value == "VIP" then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-0.00651532412, 264, -64.903862)
        elseif value == "Lobby" then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0.00607604114, 268, -0.304446399)
        else
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(125.994354, 264, -0.291718572)
        end
    end,
    Options = {"Mega VIP", "VIP", "Lobby", "Group"}
})
local autoheal_hp = 50
local autoheal
MainPage.Slider({
    Text = "Auto Heal Trigger",
    Callback = function(value)
        autoheal_hp = tonumber(value)
    end,
    Min = 30,
    Max = 90,
    Def = 50
})
MainPage.Toggle({
    Text = "Auto Heal",
    Callback = function(state)
        autoheal = state
        while autoheal and wait() do
            if autoheal then
                if game.Players.LocalPlayer.Character.Humanoid.Health < autoheal_hp then
                    local healtool = game.Players.LocalPlayer.Backpack:FindFirstChild("Heal")
                    game.Players.LocalPlayer.Character.Humanoid:EquipTool(healtool)
                    game.Players.LocalPlayer.Character.Heal:Activate()
                end
            end
        end
    end,
    Enabled = false
})
local reachthing
MainPage.Slider({
    Text = "Reach Sword Trigger",
    Callback = function(value)
        reachthing = tonumber(value)
    end,
    Min = 20,
    Max = 300,
    Def = 100
})
MainPage.Button({
    Text = "Apply Reach",
    Callback = function()
        currentToolSize = game.Players.LocalPlayer.Character.Sword.Handle.Size
		local a = Instance.new("SelectionBox")
		a.Name = "SelectionBoxCreated"
		a.Parent = game.Players.LocalPlayer.Character.Sword.Handle
		a.Adornee = game.Players.LocalPlayer.Character.Sword.Handle
		game.Players.LocalPlayer.Character.Sword.Handle.Massless = true
		game.Players.LocalPlayer.Character.Sword.Handle.Size = Vector3.new(0.5,0.5,tonumber(reachthing))
		game.Players.LocalPlayer.Character.Sword.GripPos = Vector3.new(0,0,0)
		game.Players.LocalPlayer.Character.Humanoid:UnequipTools()  
    end
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

while true and wait(4) do
    if game:GetService("Players").LocalPlayer.PlayerGui.Extra:FindFirstChild("AntiSploitClient") and game:GetService("Players").LocalPlayer.PlayerGui.Extra:FindFirstChild("AntiSploitClient2") then
        game:GetService("Players").LocalPlayer.PlayerGui.Extra:FindFirstChild("AntiSploitClient"):Destroy()
        game:GetService("Players").LocalPlayer.PlayerGui.Extra:FindFirstChild("AntiSploitClient2"):Destroy()
    end
end