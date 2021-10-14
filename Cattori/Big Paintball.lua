local lplr = game.Players.LocalPlayer
local camera = game:GetService("Workspace").CurrentCamera
local CurrentCamera = workspace.CurrentCamera
local worldToViewportPoint = CurrentCamera.worldToViewportPoint
local plr = game.Players.LocalPlayer
local players = game:GetService("Players")
local mouse = plr:GetMouse()
local camera = game.Workspace.CurrentCamera
local RainbowsESPEnabled = false
local HeadOff = Vector3.new(0,0.5,0)
local LegOff = Vector3.new(0,3,0)
local TeamCheckEnabled = false
local BoxEnabled = false
local TracerEnabled = false
local SilentAimEnabled = false
local NameEnabled = false
local SkeletonESPEnabled = false
local settings = {
	keybind = Enum.UserInputType.MouseButton2
}
local UIS = game:GetService("UserInputService")
local aiming = false 
local DiscordLib = loadstring(game:HttpGet"https://raw.githubusercontent.com/dawid-scripts/UI-Libs/main/discord%20lib.txt")()
local Window = DiscordLib:Window("Cattoware")
local BigPainBallWindow = Window:Server("Big Paintball", "")
local AimbotEnabled
local SilentAimTeamCheckEnabled

function ClosestPlayerToMouseHook()
    if not SilentAimEnabled then return end
    local target = nil
    local dist = math.huge
    if SilentAimTeamCheckEnabled then
        for i,v in pairs(game:GetService("Players"):GetPlayers()) do
            if v.Name ~= plr.Name then
                if v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health ~= 0 and v.Team ~= plr.Team and SilentAimEnabled and v.Character:FindFirstChild("HumanoidRootPart") then
                    local screenpoint = camera:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
                    local check = (Vector2.new(mouse.X,mouse.Y)-Vector2.new(screenpoint.X,screenpoint.Y)).magnitude
                    if check < dist then
                        target  = v
                        dist = check
                    end
                end
            end
        end
    else
        for i,v in pairs(game:GetService("Players"):GetPlayers()) do
            if v.Name ~= plr.Name then
                if v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health ~= 0 and SilentAimEnabled and v.Character:FindFirstChild("HumanoidRootPart") then
                    local screenpoint = camera:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
                    local check = (Vector2.new(mouse.X,mouse.Y)-Vector2.new(screenpoint.X,screenpoint.Y)).magnitude
                    if check < dist then
                        target  = v
                        dist = check
                    end
                end
            end
        end
    end
    return target 
end

function ClosestPlayerToMouseHook2()
    if not AimbotEnabled then return end
    local target = nil
    local dist = math.huge
    if TeamCheckEnabled then
        for i,v in pairs(game:GetService("Players"):GetPlayers()) do
            if v.Name ~= plr.Name then
                if v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health ~= 0 and AimbotEnabled and v.Team ~= plr.Team and v.Character:FindFirstChild("HumanoidRootPart") then
                    local screenpoint = camera:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
                    local check = (Vector2.new(mouse.X,mouse.Y)-Vector2.new(screenpoint.X,screenpoint.Y)).magnitude
                    if check < dist then
                        target  = v
                        dist = check
                    end
                end
            end
        end
    else
        for i,v in pairs(game:GetService("Players"):GetPlayers()) do
            if v.Name ~= plr.Name then
                if v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health ~= 0 and AimbotEnabled and v.Character:FindFirstChild("HumanoidRootPart") then
                    local screenpoint = camera:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
                    local check = (Vector2.new(mouse.X,mouse.Y)-Vector2.new(screenpoint.X,screenpoint.Y)).magnitude
                    if check < dist then
                        target  = v
                        dist = check
                    end
                end
            end
        end
    end
    return target 
end

local unlockedgun
local MainTab = BigPainBallWindow:Channel("Main")
local GameHookTab = BigPainBallWindow:Channel("Games Hook")
local GunModTab = BigPainBallWindow:Channel("Gun Mod")
local VisualsTab = BigPainBallWindow:Channel("Visuals")

MainTab:Toggle("Aimbot", false, function(bool)
    AimbotEnabled = bool
end)

MainTab:Toggle("Team Check", false, function(bool)
    TeamCheckEnabled = bool
end)

MainTab:Seperator()

MainTab:Button("Unlock All Gun", function()
    if unlockedgun then return end
    local kek = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"))
    kek.GunCmds.DoesOwnGun = function()
        return true
    end
    local mt1 = getrawmetatable(game)
    local namecallmod = mt1.__namecall
    setreadonly(mt1, false)
    mt1.__namecall = newcclosure(function(self,...)
        local args = {...}
        local method = getnamecallmethod()
        if tostring(self) == "request respawn" and tostring(method) == "FireServer" then
            if args[1] then
                if args[1][1] then
                    args[1][1][1] = "1"
                end
            end
        end
        return namecallmod(self, ...)
    end)
    setreadonly(mt1, true)
    unlockedgun = true
end)

GameHookTab:Toggle("Silent Aim", false, function(bool)
    SilentAimEnabled = bool
end)

GameHookTab:Toggle("Team Check", false, function(bool)
    SilentAimTeamCheckEnabled = bool
end)

local InfAmmoVar = false
local NoRecoilVar = false
local AutomaticModeVar = false
local NoSpreadVar = false
local FastFiringVar = false

local checks={"Ammo", "ammo", "Damage", "damage", "Firerate", "firerate", "FireRate", "fireRate", "Recoil", "recoil", "Spread", "spread", "ability", "Ability"}
local raw_table
for i,v in pairs(getgc(true)) do
    for x = 1,#checks do
        if (type(v) == 'table') and rawget(v, checks[x]) then
            raw_table = v
        end
    end
end

GunModTab:Toggle("Inf Ammo", false, function(bool)
    InfAmmoVar = bool
end)
GunModTab:Toggle("No Recoil", false, function(bool)
    NoRecoilVar = bool
end)
GunModTab:Toggle("Automatic", false, function(bool)
    AutomaticModeVar = bool
end)
GunModTab:Toggle("No Spread", false, function(bool)
    NoSpreadVar = bool
end)
GunModTab:Toggle("Fast Firing", false, function(bool)
    FastFiringVar = bool
end)

local mt = getrawmetatable(game)
local namecallold = mt.__namecall
local index = mt.__index
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    if tostring(self) == "new projectile" and tostring(method) == "FireServer" then
        if SilentAimEnabled then
            local A_1 = {
                [1] = {
                    [1] = ClosestPlayerToMouseHook().Character.Humanoid,
                    [2] = args[1][1][2],
                    [3] = 235,
                    [4] = ClosestPlayerToMouseHook().Character.Head.Position,
                    [5] = false,
                    [6] = false,
                    [7] = false
                },
                [2] = {
                    [1] = false,
                    [2] = false,
                    [3] = false,
                    [4] = false,
                    [5] = false,
                    [6] = 2,
                    [7] = 2
                }
            }
            game:GetService("Workspace")["__THINGS"]["__REMOTES"]["do damage"]:FireServer(A_1)
        end
    end
    return namecallold(self, ...)
end)
setreadonly(mt, true)

VisualsTab:Toggle("Box", false, function(bool)
    BoxEnabled = bool
end)
VisualsTab:Toggle("Name", false, function(bool)
    NameEnabled = bool
end)
VisualsTab:Toggle("Tracer", false, function(bool)
    TracerEnabled = bool
end)
VisualsTab:Toggle("Skeleton", false, function(bool)
    SkeletonESPEnabled = bool
end)
VisualsTab:Seperator()
local FOVEnabled = false
VisualsTab:Toggle("FOV", false, function(bool)
    FOVEnabled = bool
end)
local FOVSize = 300
local FOVSizeSlider = VisualsTab:Slider("FOV Size", 100, 600, 300, function(value)
    FOVSize = value
end)
VisualsTab:Button("Reset FOV Size", function()
    FOVSize = 300
    FOVSizeSlider:Change(300)
    DiscordLib:Notification("Cattoware Notification!", "Reseted FOV Size", "Okay!")
end)

VisualsTab:Seperator()

local CustomColor = false
local ESPColor = Color3.fromRGB(255,255,255)
local ESPColorOptionDrop = VisualsTab:Dropdown("ESP Color Options",{"Custom Color","Rainbow"}, function(Current)
    if Current == "Custom Color" then
        CustomColor = true
        RainbowsESPEnabled = false
    else
        CustomColor = false
        RainbowsESPEnabled = true
    end
end)
VisualsTab:Colorpicker("ESP Color", Color3.fromRGB(255,255,255), function(t)
    ESPColor = t
end)
VisualsTab:Toggle("Team Check", false, function(bool)
    TeamCheckEnabled = bool
end)

local function CattoriESP(v)
    local BoxOutline = Drawing.new("Square")
    BoxOutline.Visible = false
    BoxOutline.Color = Color3.new(0,0,0)
    BoxOutline.Thickness = 3
    BoxOutline.Transparency = 1
    BoxOutline.Filled = false

    local Box = Drawing.new("Square")
    Box.Visible = false
    Box.Color = Color3.fromRGB(255,255,255)
    Box.Thickness = 1
    Box.Transparency = 1
    Box.Filled = false

    local HealthBarOutline = Drawing.new("Square")
    HealthBarOutline.Thickness = 3
    HealthBarOutline.Filled = false
    HealthBarOutline.Color = Color3.new(0,0,0)
    HealthBarOutline.Transparency = 1
    HealthBarOutline.Visible = false

    local HealthBar = Drawing.new("Square")
    HealthBar.Thickness = 1
    HealthBar.Filled = false
    HealthBar.Transparency = 1
    HealthBar.Visible = false
    
    local TracerOutline = Drawing.new("Line")
    TracerOutline.Visible = false
    TracerOutline.Color = Color3.new(0,0,0)
    TracerOutline.Thickness = 3
    TracerOutline.Transparency = 1
    
    local Tracer = Drawing.new("Line")
    Tracer.Visible = false
    Tracer.Color = Color3.fromRGB(255,255,255)
    Tracer.Thickness = 1
    Tracer.Transparency = 1
    
    local Name = Drawing.new("Text")
    Name.Transparency = 1
    Name.Visible = false
    Name.Color = Color3.fromRGB(255,255,255)
    Name.Size = 15
    Name.Center = true
    Name.Outline = true
    Name.Font = 0
    
    local FOVCircleOutline = Drawing.new("Circle")
    FOVCircleOutline.Thickness = 3
    FOVCircleOutline.Radius = 300
    FOVCircleOutline.NumSides = 12
    FOVCircleOutline.Color = Color3.new(0,0,0)
    FOVCircleOutline.Visible = false
    
    local FOVCircle = Drawing.new("Circle")
    FOVCircle.Thickness = 1
    FOVCircle.Radius = 300
    FOVCircle.NumSides = 12
    FOVCircle.Color = Color3.fromRGB(255,255,255)
    FOVCircle.Visible = false
    
    local MessageNotification = Drawing.new("Text")
    MessageNotification.Transparency = 1
    MessageNotification.Visible = false
    MessageNotification.Color = Color3.fromRGB(255,255,255)
    MessageNotification.Size = 18
    MessageNotification.Center = true
    MessageNotification.Outline = true
    MessageNotification.Font = 1
    MessageNotification.Position = Vector2.new(300,100)

    local SkeletonTorso = Drawing.new("Line")
    SkeletonTorso.Visible = false
    SkeletonTorso.From = Vector2.new(0, 0)
    SkeletonTorso.To = Vector2.new(200, 200)
    SkeletonTorso.Color = Color3.fromRGB(255,255,255)
    SkeletonTorso.Thickness = 1
    SkeletonTorso.Transparency = 1

    local SkeletonHead = Drawing.new("Line")
    SkeletonHead.Visible = false
    SkeletonHead.From = Vector2.new(0, 0)
    SkeletonHead.To = Vector2.new(200, 200)
    SkeletonHead.Color = Color3.fromRGB(255,255,255)
    SkeletonHead.Thickness = 1
    SkeletonHead.Transparency = 1

    local SkeletonLeftLeg = Drawing.new("Line")
    SkeletonLeftLeg.Visible = false
    SkeletonLeftLeg.From = Vector2.new(0, 0)
    SkeletonLeftLeg.To = Vector2.new(200, 200)
    SkeletonLeftLeg.Color = Color3.fromRGB(255,255,255)
    SkeletonLeftLeg.Thickness = 1
    SkeletonLeftLeg.Transparency = 1

    local SkeletonRightLeg = Drawing.new("Line")
    SkeletonRightLeg.Visible = false
    SkeletonRightLeg.From = Vector2.new(0, 0)
    SkeletonRightLeg.To = Vector2.new(200, 200)
    SkeletonRightLeg.Color = Color3.fromRGB(255,255,255)
    SkeletonRightLeg.Thickness = 1
    SkeletonRightLeg.Transparency = 1

    local SkeletonLeftArm = Drawing.new("Line")
    SkeletonLeftArm.Visible = false
    SkeletonLeftArm.From = Vector2.new(0, 0)
    SkeletonLeftArm.To = Vector2.new(200, 200)
    SkeletonLeftArm.Color = Color3.fromRGB(255,255,255)
    SkeletonLeftArm.Thickness = 1
    SkeletonLeftArm.Transparency = 1

    local SkeletonRightArm = Drawing.new("Line")
    SkeletonRightArm.Visible = false
    SkeletonRightArm.From = Vector2.new(0, 0)
    SkeletonRightArm.To = Vector2.new(200, 200)
    SkeletonRightArm.Color = Color3.fromRGB(255,255,255)
    SkeletonRightArm.Thickness = 1
    SkeletonRightArm.Transparency = 1
    
    game:GetService("RunService").RenderStepped:Connect(function()
        if FOVEnabled then
            FOVCircle.Visible = true
            FOVCircleOutline.Visible = true
            FOVCircle.Position = Vector2.new(mouse.X, mouse.Y + 36)
            FOVCircleOutline.Position = Vector2.new(mouse.X, mouse.Y + 36)
            FOVCircle.Radius = FOVSize
            FOVCircleOutline.Radius = FOVSize
            if RainbowsESPEnabled then
                FOVCircle.Color = Color3.fromHSV(tick()%5/5,1,1)
            elseif CustomColor then
                FOVCircle.Color = ESPColor
            end
        else
            FOVCircleOutline.Visible = false
            FOVCircle.Visible = false
        end
        if v.Character ~= nil and v.Character:FindFirstChild("Humanoid") ~= nil and v.Character:FindFirstChild("HumanoidRootPart") ~= nil and v ~= lplr and v.Character.Humanoid.Health > 0 then
            local Vector, onScreen = camera:worldToViewportPoint(v.Character.HumanoidRootPart.Position)
            local Distance = (CurrentCamera.CFrame.p - v.Character.HumanoidRootPart.Position).Magnitude
            local RootPart = v.Character.HumanoidRootPart
            local Head = v.Character.Head
            local RootPosition, RootVis = worldToViewportPoint(CurrentCamera, RootPart.Position)
            local HeadPosition = worldToViewportPoint(CurrentCamera, Head.Position + HeadOff)
            local LegPosition = worldToViewportPoint(CurrentCamera, RootPart.Position - LegOff)

            if onScreen then
                if BoxEnabled then
                    BoxOutline.Size = Vector2.new(2000 / RootPosition.Z, HeadPosition.Y - LegPosition.Y)
                    BoxOutline.Position = Vector2.new(RootPosition.X - BoxOutline.Size.X / 2, RootPosition.Y - BoxOutline.Size.Y / 2)
                    BoxOutline.Visible = true
    
                    Box.Size = Vector2.new(2000 / RootPosition.Z, HeadPosition.Y - LegPosition.Y)
                    Box.Position = Vector2.new(RootPosition.X - Box.Size.X / 2, RootPosition.Y - Box.Size.Y / 2)
                    Box.Visible = true
                        
                    HealthBarOutline.Size = Vector2.new(2, HeadPosition.Y - LegPosition.Y)
                    HealthBarOutline.Position = BoxOutline.Position - Vector2.new(6,0)
                    HealthBarOutline.Visible = true
    
                    HealthBar.Size = Vector2.new(2, (HeadPosition.Y - LegPosition.Y) / (v.Character.Humanoid.MaxHealth / math.clamp(v.Character.Humanoid.Health, 0, v.Character.Humanoid.MaxHealth)))
                    HealthBar.Position = Vector2.new(Box.Position.X - 6, Box.Position.Y + (1 / HealthBar.Size.Y))
                    HealthBar.Color = Color3.fromRGB(255 - 255 / (v.Character.Humanoid.MaxHealth / v.Character.Humanoid.Health), 255 / (v.Character.Humanoid.MaxHealth / v.Character.Humanoid.Health), 0)
                    HealthBar.Visible = true
                    if v.TeamColor == lplr.TeamColor then
                        if TeamCheckEnabled then
                            HealthBarOutline.Visible = false
                            HealthBar.Visible = false
                        end
                    else
                        HealthBarOutline.Visible = true
                        HealthBar.Visible = true
                    end
                    if RainbowsESPEnabled then
                        Box.Color = Color3.fromHSV(tick()%5/5,1,1)
                    elseif CustomColor then
                        Box.Color = ESPColor
                    end
                    if v.TeamColor == lplr.TeamColor then
                        if TeamCheckEnabled then
                            BoxOutline.Visible = false
                            Box.Visible = false
                        end
                    else
                        BoxOutline.Visible = true
                        Box.Visible = true
                    end
                else
                    BoxOutline.Visible = false
                    Box.Visible = false
                    HealthBarOutline.Visible = false
                    HealthBar.Visible = false
                end
                if TracerEnabled then
                    TracerOutline.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 1)
                    TracerOutline.To = Vector2.new(Vector.X, Vector.Y)
                    TracerOutline.Visible = true
                    Tracer.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 1)
                    Tracer.To = Vector2.new(Vector.X, Vector.Y)
                    Tracer.Visible = true
                    if RainbowsESPEnabled then
                        Tracer.Color = Color3.fromHSV(tick()%5/5,1,1)
                    elseif CustomColor then
                        Tracer.Color = ESPColor
                    end
                    if v.TeamColor == lplr.TeamColor then
                        if TeamCheckEnabled then
                            TracerOutline.Visible = false
                            Tracer.Visible = false
                        end
                    else
                        TracerOutline.Visible = true
                        Tracer.Visible = true
                    end
                else
                    TracerOutline.Visible = false
                    Tracer.Visible = false
                end
                if NameEnabled then
                    Name.Text = tostring("["..math.floor(Distance).."] "..v.Name.." ["..math.floor(v.Character.Humanoid.MaxHealth).."/"..math.floor(v.Character.Humanoid.Health).."]")
                    Name.Position = Vector2.new(RootPosition.X - BoxOutline.Size.X / 2, RootPosition.Y - BoxOutline.Size.Y / 2)
                    Name.Size = 16
                    Name.Visible = true
                    if RainbowsESPEnabled then
                        Name.Color = Color3.fromHSV(tick()%5/5,1,1)
                    elseif CustomColor then
                        Name.Color = ESPColor
                    end
                    if v.TeamColor == lplr.TeamColor then
                        if TeamCheckEnabled then
                            Name.Visible = false
                        end
                    else
                        Name.Visible = true
                    end
                else
                    Name.Visible = false
                end
                if SkeletonESPEnabled then
                    local UpperTorso = camera:WorldToViewportPoint(v.Character.UpperTorso.Position)
                    local LowerTorso = camera:WorldToViewportPoint(v.Character.LowerTorso.Position)
    
                    local LeftLeg = camera:WorldToViewportPoint(v.Character.LeftFoot.Position)
                    local RightLeg = camera:WorldToViewportPoint(v.Character.RightFoot.Position)
    
                    local LeftArm = camera:WorldToViewportPoint(v.Character.LeftHand.Position)
                    local RightArm = camera:WorldToViewportPoint(v.Character.RightHand.Position)
    
                    local Head = camera:WorldToViewportPoint(v.Character.Head.Position)
                    
                    SkeletonTorso.Visible = true
                    SkeletonHead.Visible = true
                    SkeletonLeftArm.Visible = true
                    SkeletonLeftLeg.Visible = true
                    SkeletonRightArm.Visible = true
                    SkeletonRightLeg.Visible = true
                    
                    SkeletonTorso.From = Vector2.new(UpperTorso.X, UpperTorso.Y)
                    SkeletonTorso.To = Vector2.new(LowerTorso.X, LowerTorso.Y)
    
                    SkeletonHead.From = Vector2.new(UpperTorso.X, UpperTorso.Y)
                    SkeletonHead.To = Vector2.new(Head.X, Head.Y)
    
                    SkeletonLeftLeg.From = Vector2.new(LeftLeg.X, LeftLeg.Y)
                    SkeletonLeftLeg.To = Vector2.new(LowerTorso.X, LowerTorso.Y)
    
                    SkeletonRightLeg.From = Vector2.new(RightLeg.X, RightLeg.Y)
                    SkeletonRightLeg.To = Vector2.new(LowerTorso.X, LowerTorso.Y)
    
                    SkeletonLeftArm.From = Vector2.new(LeftArm.X, LeftArm.Y)
                    SkeletonLeftArm.To = Vector2.new(UpperTorso.X, UpperTorso.Y)
    
                    SkeletonRightArm.From = Vector2.new(RightArm.X, RightArm.Y)
                    SkeletonRightArm.To = Vector2.new(UpperTorso.X, UpperTorso.Y)
                    if RainbowsESPEnabled then
                        SkeletonTorso.Color = Color3.fromHSV(tick()%5/5,1,1)
                        SkeletonHead.Color = Color3.fromHSV(tick()%5/5,1,1)
                        SkeletonLeftArm.Color = Color3.fromHSV(tick()%5/5,1,1)
                        SkeletonLeftLeg.Color = Color3.fromHSV(tick()%5/5,1,1)
                        SkeletonRightArm.Color = Color3.fromHSV(tick()%5/5,1,1)
                        SkeletonRightLeg.Color = Color3.fromHSV(tick()%5/5,1,1)
                    elseif CustomColor then
                        SkeletonTorso.Color = ESPColor
                        SkeletonHead.Color = ESPColor
                        SkeletonLeftArm.Color = ESPColor
                        SkeletonLeftLeg.Color = ESPColor
                        SkeletonRightArm.Color = ESPColor
                        SkeletonRightLeg.Color = ESPColor
                    end
                    if v.TeamColor == lplr.TeamColor then
                        if TeamCheckEnabled then
                            SkeletonTorso.Visible = false
                            SkeletonHead.Visible = false
                            SkeletonLeftArm.Visible = false
                            SkeletonLeftLeg.Visible = false
                            SkeletonRightArm.Visible = false
                            SkeletonRightLeg.Visible = false
                        end
                    else
                        SkeletonTorso.Visible = true
                        SkeletonHead.Visible = true
                        SkeletonLeftArm.Visible = true
                        SkeletonLeftLeg.Visible = true
                        SkeletonRightArm.Visible = true
                        SkeletonRightLeg.Visible = true
                    end
                else
                    SkeletonTorso.Visible = false
                    SkeletonHead.Visible = false
                    SkeletonLeftArm.Visible = false
                    SkeletonLeftLeg.Visible = false
                    SkeletonRightArm.Visible = false
                    SkeletonRightLeg.Visible = false
                end
            else
                BoxOutline.Visible = false
                Box.Visible = false
                HealthBarOutline.Visible = false
                HealthBar.Visible = false
                TracerOutline.Visible = false
                Tracer.Visible = false
                Name.Visible = false
                SkeletonTorso.Visible = false
                SkeletonHead.Visible = false
                SkeletonLeftArm.Visible = false
                SkeletonLeftLeg.Visible = false
                SkeletonRightArm.Visible = false
                SkeletonRightLeg.Visible = false
            end
        else
            BoxOutline.Visible = false
            Box.Visible = false
            HealthBarOutline.Visible = false
            HealthBar.Visible = false
            TracerOutline.Visible = false
            Tracer.Visible = false
            Name.Visible = false
            SkeletonTorso.Visible = false
            SkeletonHead.Visible = false
            SkeletonLeftArm.Visible = false
            SkeletonLeftLeg.Visible = false
            SkeletonRightArm.Visible = false
            SkeletonRightLeg.Visible = false
        end
    end)
end

for i,v in pairs(game.Players:GetChildren()) do
    CattoriESP(v)
end

game.Players.PlayerAdded:Connect(function(v)
    CattoriESP(v)
end)
	
UIS.InputBegan:Connect(function(inp)
	if inp.UserInputType == settings.keybind then
		aiming = true
	end
end)
	
UIS.InputEnded:Connect(function(inp)
	if inp.UserInputType == settings.keybind then 
		aiming = false
	end
end)
	
game:GetService("RunService").RenderStepped:Connect(function()
	if aiming then
		camera.CFrame = CFrame.new(camera.CFrame.Position,ClosestPlayerToMouseHook2().Character.Head.Position)
	end
end)

game:GetService("RunService").Heartbeat:Connect(function()
	if InfAmmoVar then
		raw_table.LoadedAmmo = math.huge
	end
	if FastFiringVar then
		raw_table.firerate = 0
        raw_table.burstDelay = 0
	end
	if NoSpreadVar then
		raw_table.currentspread = 0
	end
	if NoRecoilVar then
		raw_table.velocity = 1000000
	end
	if AutomaticModeVar then
		raw_table.automatic = true
	end
end)