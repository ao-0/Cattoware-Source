if type(_G.running) == "function" then _G.running() end 
local running = true
local Material = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/MaterialLua/master/Module.lua"))()

local UI = Material.Load({
     Title = "Cattoware | Blacklands",
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
local GuiInset = game:GetService("GuiService"):GetGuiInset()
local players = game:GetService("Players")
local plr = players.LocalPlayer
local mouse = plr:GetMouse()
local Mouse = plr:GetMouse()
local camera = game.Workspace.CurrentCamera
local settings = {
	keybind = Enum.UserInputType.MouseButton2,
	keybind2 = Enum.KeyCode.E
}
local UIS = game:GetService("UserInputService")
local fov = {
    component = Drawing.new("Circle");
    size = 300;
}
local rainbow = {
    enabled = true;
    originalColor3 = nil;
}
local aiming = false
local RightClickAim = false
local TeamCheck = false
_G._aimbot = false

MainPage.Toggle({
    Text = "Aimbot",
    Callback = function(State)
        _G._aimbot = State
    end,
    Enabled = false
})
local TeamCheck = false
MainPage.Toggle({
    Text = "RightClick Aim",
    Callback = function(State)
        RightClickAim = State
    end,
    Enabled = false
})
MainPage.TextField({
    Text = "Aimbot KeyBind (E)",
    Callback = function(value)
        keybindthingy = value
    end
})
MainPage.Button({
    Text = "Apply Config",
    Callback = function()
        settings.keybind2 = Enum.KeyCode[keybindthingy]
    end,
    Enabled = false
})
function ClosestPlayerToMouse()
    if not _G._aimbot then return end
    local target = nil
    local dist = math.huge
    local sp = nil
    for i,v in next, game:GetService("Players"):GetPlayers() do
        if i ~= 1 and v.Character then
            local character = v.Character
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if rootPart and humanoid and humanoid.Health > 0 and (not TeamCheck or v.Team ~= plr.Team) then
                local screenpoint, inview = camera:WorldToScreenPoint(rootPart.Position)
                local check = (Vector2.new(mouse.X,mouse.Y)-Vector2.new(screenpoint.X,screenpoint.Y)).magnitude

                if inview and check < dist then
                    dist = check
                    target  = v
                    sp = screenpoint
                end
            end
        end
    end
    return target, sp
end
local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/VaultGitos/Alantic-LUA/main/KiriotESP.lua"))()
ESP.Color = Color3.fromRGB(127, 95, 221)
ESP.TeamMates = true
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
UIS.InputBegan:Connect(function(inp)
	if inp.UserInputType == settings.keybind then
	    if RightClickAim then
		    aiming = true
	    end
    end
	if inp.KeyCode == settings.keybind2 then
	    aiming = true
	end
end)
	
UIS.InputEnded:Connect(function(inp)
    if inp.UserInputType == settings.keybind then
		if RightClickAim then
            aiming = false
		end
	end
	if inp.KeyCode == settings.keybind2 then
	    aiming = false
	end
end)

spawn(function()
    local renderStepped = game:GetService("RunService").RenderStepped
    fov.component.Thickness = 3
    fov.component.Color = Color3.fromRGB(255, 105, 180)
    fov.component.NumSides = 15
    fov.component.Visible = false
    fov.component.Position = Vector2.new(mouse.X, mouse.Y+36)
    while running do
        if aiming and ClosestPlayerToMouse then
            local player, screenpoint = ClosestPlayerToMouse()
            if type(player) == "userdata" and player.Character and type(screenpoint) == "userdata" then
                local head = player.Character:FindFirstChild("Head")
                if head then
                    local pos = Vector2.new(screenpoint.X, screenpoint.Y)-Vector2.new(mouse.X,mouse.Y)
                    pos = pos - Vector2.new(GuiInset.X, GuiInset.Y) -- offset stuff
                    mousemoverel(pos.X * .05, pos.Y * .05)
                end
            end
        end
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