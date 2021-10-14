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
local BigPainBallWindow = Window:Server("Ragdoll Engine", "")
function BombRemote()
    temp_bombs = {}
    for i,v in pairs(game:GetService('Players'):GetPlayers()) do
        if v:FindFirstChild('Backpack') and v.Backpack:FindFirstChild('ImpulseGrenade') then
            table.insert(temp_bombs,v.Backpack.ImpulseGrenade.CreateGrenade)
        end
    end
    return temp_bombs[math.random(1,#temp_bombs)]
end
function InvisRemote()
    temp_bombs = {}
    for i,v in pairs(game:GetService('Players'):GetPlayers()) do
        if v:FindFirstChild('Backpack') and v.Backpack:FindFirstChild('OddPotion') then
            table.insert(temp_bombs,v.Backpack.OddPotion.TransEvent)
        end
    end
    return temp_bombs[math.random(1,#temp_bombs)]
end
function PotionRemote()
    temp_bombs = {}
    for i,v in pairs(game:GetService('Players'):GetPlayers()) do
        if v:FindFirstChild('Backpack') and v.Backpack:FindFirstChild('OddPotion') then
            table.insert(temp_bombs,v.Backpack.OddPotion.PotionEvent)
        end
    end
    return temp_bombs[math.random(1,#temp_bombs)]
end

local getname = function(str)
    for i,v in next, game:GetService("Players"):GetChildren() do
        if string.find(string.lower(v.Name), string.lower(str)) then
            return v.Name
        end
    end
end

local MainTab = BigPainBallWindow:Channel("Main")
local GameHookTab = BigPainBallWindow:Channel("Fun")
local VisualsTab = BigPainBallWindow:Channel("Visuals")
local SpawnBombEnabled

local WSSlider = MainTab:Slider("WalkSpeed", 16, 500, 16, function(t)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = t
end)

local WSSlider = MainTab:Slider("JumpPower", 50, 500, 50, function(t)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = t
end)

MainTab:Toggle("Spawn Bomb", false, function(bool)
    SpawnBombEnabled = bool
    if SpawnBombEnabled then 
        mouse.Button1Down:connect(function()
            for i,v in pairs(game.Players:GetChildren())do
                if v.Backpack:FindFirstChild("ImpulseGrenade") then
                    v.Backpack.ImpulseGrenade.CreateGrenade:FireServer(Vector3.new(0, 0, 0), CFrame.new(mouse.Hit.Position))
                end
            end
        end)
    end
end)
local PushFlingEnabled
MainTab:Toggle("OP Push", false, function(bool)
    PushFlingEnabled = bool
    if PushFlingEnabled then
        booling = game:GetService("RunService").RenderStepped:Connect(function()
            for i,v in pairs(game.Players:GetChildren())do
                if v.Backpack:FindFirstChild("Push") then
                    v.Backpack.Push.PushEvent:FireServer()
                end
            end
        end)
    else
        if booling then
            booling:Disconnect()
        end
    end
end)

MainTab:Button("R15 Potion", function(bool)
    PotionRemote():FireServer()
end)
MainTab:Button("Delete Ragdoll", function(bool)
    if game.Players.LocalPlayer.Character:FindFirstChild("Local Ragdoll") then
        game.Players.LocalPlayer.Character:FindFirstChild("Local Ragdoll"):Remove()
    end
end)

MainTab:Seperator()

local TargetValue
MainTab:Textbox("Target", "Name", false, function(val)
    if game:GetService("Players"):FindFirstChild(getname(val)) then
        TargetValue = getname(val)
    end
end)

MainTab:Button("Bomb", function()
    for i,v in pairs(game.Players:GetChildren())do
        if v.Backpack:FindFirstChild("ImpulseGrenade") then
            v.Backpack.ImpulseGrenade.CreateGrenade:FireServer(Vector3.new(0, 0, 0), CFrame.new(game.Players[TargetValue].Character.Head.Position))
        end
    end
end)

MainTab:Button("Headless", function()
    local OneAgurment = {}
    for i,v in pairs(game:GetService('Players'):GetPlayers()) do
        if v:FindFirstChild('Backpack') and v.Backpack:FindFirstChild('OddPotion') then
            table.insert(OneAgurment, v.Backpack.OddPotion.TransEvent)
            wait(.1)
            OneAgurment[math.random(1,  #OneAgurment)]:FireServer(game.Players[TargetValue].Character.Head, 1)
        end
    end
end)

MainTab:Button("Fix Head", function()
    local OneAgurment = {}
    for i,v in pairs(game:GetService('Players'):GetPlayers()) do
        if v:FindFirstChild('Backpack') and v.Backpack:FindFirstChild('OddPotion') then
            table.insert(OneAgurment, v.Backpack.OddPotion.TransEvent)
            wait(.1)
            OneAgurment[math.random(1,  #OneAgurment)]:FireServer(game.Players[TargetValue].Character.Head, 0)
        end
    end
end)

MainTab:Button("Invisible", function()
    for i,v in pairs(game:GetService('Players'):GetPlayers()) do
        if v:FindFirstChild('Backpack') and v.Backpack:FindFirstChild('OddPotion') then
            for k,v2 in pairs(game:GetService("Players")[TargetValue].Character:GetDescendants()) do
                if not v2:FindFirstChild("HumanoidRootPart") then
                    local OneAgurment = {}
                    table.insert(OneAgurment, v.Backpack.OddPotion.TransEvent)
                    OneAgurment[math.random(1,  #OneAgurment)]:FireServer(v2, 1)
                    OneAgurment[math.random(1,  #OneAgurment)]:FireServer(game.Players[TargetValue].Character.HumanoidRootPart, 1)
                end
            end
        end
    end
end)

MainTab:Button("Visible", function()
    local OneAgurment = {}
    for i,v in pairs(game:GetService('Players'):GetPlayers()) do
        if v:FindFirstChild('Backpack') and v.Backpack:FindFirstChild('OddPotion') then
            for k,v2 in pairs(game:GetService("Players")[TargetValue].Character:GetDescendants()) do
                if not v2:FindFirstChild("HumanoidRootPart") then
                    local OneAgurment = {}
                    table.insert(OneAgurment, v.Backpack.OddPotion.TransEvent)
                    OneAgurment[math.random(1,  #OneAgurment)]:FireServer(v2, 0)
                    OneAgurment[math.random(1,  #OneAgurment)]:FireServer(game.Players[TargetValue].Character.HumanoidRootPart, 0)
                end
            end
        end
    end
end)


GameHookTab:Button("Invisible Map", function()
    for i,v in pairs(game.Workspace:GetDescendants()) do
        if v:IsA('Part') or v:IsA('BasePart') and v.Name ~= 'HumanoidRootPart' then
            local v1 = v
            local v2 = 1
            local rem = InvisRemote()
            rem:FireServer(v1, v2)
        end
    end
end)

GameHookTab:Button("Visible Map", function()
    for i,v in pairs(game.Workspace:GetDescendants()) do
        if v:IsA('Part') or v:IsA('BasePart') and v.Name ~= 'HumanoidRootPart' then
            local v1 = v
            local v2 = 0
            local rem = InvisRemote()
            rem:FireServer(v1, v2)
        end
    end
end)

function BombAll()
    pcall(function()
        if not BombRemote() then
        end
        for i = 1,3 do
            for i,v in pairs(game:GetService('Players'):GetPlayers()) do
                if v ~= game.Players.LocalPlayer then    
                    local v1 = Vector3.new(0, 0, 0)
                    local v2 = v.Character.Head.CFrame
                    local rem = BombRemote()
                    rem:FireServer(v1, v2)
                end
            end
        end
    end)
end

GameHookTab:Button("Trigger Mines", function()
    for i,v in pairs(game:GetService("Workspace").NewerMap.Obstacles.Minefield.Mines:GetChildren()) do
        if v.Name == "Landmine" then
            if v:FindFirstChild("Hitbox") then
                firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v.Hitbox, 0)
                wait()
                firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v.Hitbox, 1)
            end
        end
    end
end)

GameHookTab:Button("Crash Server", function()
    while wait() do
        BombAll()
    end
end)

VisualsTab:Toggle("Box", false, function(bool)
    BoxEnabled = bool
end)
VisualsTab:Toggle("Name", false, function(bool)
    NameEnabled = bool
end)
VisualsTab:Toggle("Tracer", false, function(bool)
    TracerEnabled = bool
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
        if v.Character ~= nil and v.Character:FindFirstChild("Humanoid") ~= nil and v.Character:FindFirstChild("HumanoidRootPart") ~= nil and v.Character:FindFirstChild("Head") ~= nil and v ~= lplr and v.Character.Humanoid.Health > 0 then
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
            else
                BoxOutline.Visible = false
                Box.Visible = false
                HealthBarOutline.Visible = false
                HealthBar.Visible = false
                TracerOutline.Visible = false
                Tracer.Visible = false
                Name.Visible = false
            end
        else
            BoxOutline.Visible = false
            Box.Visible = false
            HealthBarOutline.Visible = false
            HealthBar.Visible = false
            TracerOutline.Visible = false
            Tracer.Visible = false
            Name.Visible = false
        end
    end)
end

for i,v in pairs(game.Players:GetChildren()) do
    CattoriESP(v)
end

game.Players.PlayerAdded:Connect(function(v)
    CattoriESP(v)
end)
