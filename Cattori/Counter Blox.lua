if type(_G.running) == "function" then _G.running() end 
local running = true
local Material = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/MaterialLua/master/Module.lua"))()

local UI = Material.Load({
     Title = "Cattoware | Counter Blox",
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
local localPlayer = game:GetService("Players").LocalPlayer
local camera = game.Workspace.CurrentCamera
local UIS = game:GetService("UserInputService")
local aim = false
local aimbot
local settings = {
		keybind = Enum.KeyCode.E
	}
local fov = {
    component = Drawing.new("Circle");
    size = 300;
}
local localplayer = game.Players.LocalPlayer
local mouse = localplayer:GetMouse()
local aimbot
local players = game:GetService("Players")
local plr = players.LocalPlayer
local RightClickAim
local keybindthingy = E
_G.silentaim = false
_G.recoil = false
_G.currentspread = false
_G.infammo = false
_G.alwaysauto = false
_G.fastfiring = false

MainPage.Toggle({
    Text = "Aimbot",
    Callback = function(State)
        aimbot = State
    end,
    Enabled = false
})
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
        settings.keybind = Enum.KeyCode[keybindthingy]
    end,
    Enabled = false
})
function ClosestPlayerToMouseHook()
    if not _G.silentaim then return end
    local target = nil
    local dist = math.huge
    for i,v in pairs(players:GetPlayers()) do
        if v.Name ~= plr.Name then
            if v.Character and v.Character:FindFirstChild("Humanoid") and v.Team ~= plr.Team and v.Character.Humanoid.Health ~= 0 and v.Character:FindFirstChild("HumanoidRootPart") then
                local screenpoint = camera:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
                        local check = (Vector2.new(mouse.X,mouse.Y)-Vector2.new(screenpoint.X,screenpoint.Y)).magnitude

                if check < dist then
                    target  = v
                    dist = check
                end
            end
        end
    end
    return target 
end
function ClosestPlayerToMouseHook2()
    if not aimbot then return end
    local target = nil
    local dist = math.huge
    for i,v in pairs(players:GetPlayers()) do
        if v.Name ~= plr.Name then
            if v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health ~= 0 and v.Team ~= plr.Team and v.Character:FindFirstChild("HumanoidRootPart") then
                local screenpoint = camera:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
                        local check = (Vector2.new(mouse.X,mouse.Y)-Vector2.new(screenpoint.X,screenpoint.Y)).magnitude

                if check < dist then
                    target  = v
                    dist = check
                end
            end
        end
    end
    return target 
end
local thirdp
GHPage.Toggle({
    Text = "Third Person",
    Callback = function(state)
        thirdp = state
    end,
    Enabled = false
})
local antiaim
GHPage.Toggle({
    Text = "Anti Aim",
    Callback = function(state)
        antiaim = state
    end,
    Enabled = false
})
local nocdcrouch
GHPage.Toggle({
    Text = "No Cooldown Crouch",
    Callback = function(state)
        nocdcrouch = state
    end,
    Enabled = false
})
local ignoresmoke
GHPage.Toggle({
    Text = "Ignore Smoke",
    Callback = function(state)
        ignoresmoke = state
    end,
    Enabled = false
})
local noflashbag
GHPage.Toggle({
    Text = "Ignore Flashbag",
    Callback = function(state)
        noflashbag = state
        if noflashbag then
            game.Players.LocalPlayer.PlayerGui.Blnd.Blind.Visible=true
        else
            game.Players.LocalPlayer.PlayerGui.Blnd.Blind.Visible=false
        end
    end,
    Enabled = false
})
local infcash
GHPage.Toggle({
    Text = "Inf Cash",
    Callback = function(state)
        infcash = state
    end,
    Enabled = false
})
local forceheadshot
GHPage.Toggle({
    Text = "Force Headshot",
    Callback = function(state)
        forceheadshot = state
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
UIS.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton2 then
        if RightClickAim then
            aim = true
        end
    end
    if inp.KeyCode == settings.keybind then
        aim = true
    end
end)

UIS.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton2 then
        if RightClickAim then
            aim = false
        end
    end
    if inp.KeyCode == settings.keybind then
        aim = false
    end
end)

workspace["Ray_Ignore"].Smokes.ChildAdded:Connect(function(p)
    if ignoresmoke then
        wait()
        p:Destroy()
    end
end)

game:GetService("RunService").RenderStepped:Connect(function()
    if aim then
        camera.CFrame = CFrame.new(camera.CFrame.Position,ClosestPlayerToMouseHook2().Character.Head.Position)
    end
end)
local client = getsenv(game.Players.LocalPlayer.PlayerGui.Client)
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
        
        if thirdp then
            game.Players.LocalPlayer.CameraMode = "Classic"
            game.Players.LocalPlayer.CameraMaxZoomDistance = 10
            game.Players.LocalPlayer.CameraMinZoomDistance = 10
            for _,v in pairs(workspace.Camera:GetDescendants()) do 
                pcall(function() 
                    v.Transparency = 1
                end)
            end
        else
            game.Players.LocalPlayer.CameraMode = "LockFirstPerson"
            game.Players.LocalPlayer.CameraMaxZoomDistance = 0
            game.Players.LocalPlayer.CameraMinZoomDistance = 0
        end

        if antiaim then
            game:GetService("ReplicatedStorage").Events.ControlTurn:FireServer("2.5")
        end
        
        if nocdcrouch then
            client.crouchcooldown = 0
        end
        
        if infcash then
            game.Players.LocalPlayer.Cash.Value = 9e9
        else
            game.Players.LocalPlayer.Cash.Value = 3000
        end
        
        if forceheadshot then
            local Remote = game.ReplicatedStorage.Events['HitPart']
            local Arguments = {
                [1] = workspace[v.Name]["Head"],
                [2] = workspace[v.Name]["Head"].Position,
                [3] = workspace[game.Players.LocalPlayer.Name].EquippedTool.Value,
                [4] = 100,
                [5] = workspace[game.Players.LocalPlayer.Name].Gun,
                [8] = 1,
                [9] = false,
                [10] = false,
                [11] = Vector3.new(),
                [12] = 100,
                [13] = Vector3.new()
                }
                Remote:FireServer(unpack(Arguments))
            client.firebullet()
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