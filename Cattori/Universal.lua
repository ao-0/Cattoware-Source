local workspace = game:GetService("Workspace")
local camera = workspace.CurrentCamera
local worldToViewportPoint = camera.worldToViewportPoint
local plr = game:GetService("Players").LocalPlayer
local players = game:GetService("Players")
local mouse = plr:GetMouse()

local ESPSettings = {
    Box2DEnabled = false,
    TracerEnabled = false,
    NameEnabled = false,
    SkeletonESPEnabled = false,
    Box3DEnabled = false,
    ViewTracerEnabled = false,
    RainbowsESPEnabled = false,
    TextOutlineEnabled = false,
    TeamCheckEnabled = false,
    MouseFrom = false,
    CustomColor = true,
    BottomFrom = true,
    HeadFrom = false,
    RoundedCorner = 12,
    Length = 14,
    FOVSize = 300,
    FOVEnabled = false,
    ESPColor = Color3.fromRGB(255,255,255),
    Thickness = 1,
    TextSize = 15,
    Transparency = 1,
    HeadOff = Vector3.new(0,0.5,0),
    LegOff = Vector3.new(0,3,0)
}

local HttpService = game:GetService("HttpService");
local SaveFileName = "Inoria-M.dll";

if not pcall(function()
   readfile(SaveFileName)
end) then
   writefile(SaveFileName, HttpService:JSONEncode(ESPSettings))
end
local Settings = HttpService:JSONDecode(readfile(SaveFileName))
local function SaveSettings()
   writefile(SaveFileName, HttpService:JSONEncode(Settings))
end

local DiscordLib = loadstring(game:HttpGet"https://pastebin.com/raw/Y1i9Pyr2")()
local Window = DiscordLib:Window("Cattoware")
local ESPPage = Window:Server("Universal ESP", "")

local VisualsTab = ESPPage:Channel("Visuals")
local CreditsTab = ESPPage:Channel("Credits")

CreditsTab:Label("Cattoware 1.7.5b")
CreditsTab:Label("Credits : Vault#0690")

VisualsTab:Toggle("2D Box", Settings.Box2DEnabled, function(Enable)
    ESPSettings.Box2DEnabled = Enable
end)

VisualsTab:Toggle("3D Box", Settings.Box3DEnabled, function(Enable)
    ESPSettings.Box3DEnabled = Enable
end)

VisualsTab:Seperator()

VisualsTab:Toggle("Name", Settings.NameEnabled, function(Enable)
    ESPSettings.NameEnabled = Enable
end)

VisualsTab:Toggle("Outline", Settings.TextOutlineEnabled, function(Enable)
    ESPSettings.TextOutlineEnabled = Enable
end)


VisualsTab:Slider("Text Size", 10, 20, Settings.TextSize, function(value)
    ESPSettings.TextSize = value
end)

VisualsTab:Seperator()

VisualsTab:Toggle("Tracer", Settings.TracerEnabled, function(Enable)
    ESPSettings.TracerEnabled = Enable
end)

VisualsTab:Dropdown("Tracers From Options", {"Head","Bottom", "Mouse"}, function(Current)
    if Current == "Head" then
        ESPSettings.HeadFrom = true
        ESPSettings.BottomFrom = false
        ESPSettings.MouseFrom = false
    elseif Current == "Bottom" then
        ESPSettings.HeadFrom = false
        ESPSettings.BottomFrom = true
        ESPSettings.MouseFrom = false
    else
        ESPSettings.HeadFrom = false
        ESPSettings.BottomFrom = false
        ESPSettings.MouseFrom = true
    end
end)

VisualsTab:Seperator()

VisualsTab:Toggle("View Tracer", Settings.ViewTracerEnabled, function(Enable)
    ESPSettings.ViewTracerEnabled = Enable
end)

VisualsTab:Slider("Length", 1, 20, Settings.Length, function(value)
    ESPSettings.Length = value
end)

VisualsTab:Seperator()

VisualsTab:Toggle("Skeleton", Settings.SkeletonESPEnabled, function(Enable)
    ESPSettings.SkeletonESPEnabled = Enable
end)

VisualsTab:Seperator()

VisualsTab:Slider("Line Thickness", 1, 6, Settings.Thickness, function(value)
    ESPSettings.Thickness = value
end)

VisualsTab:Toggle("Team Check", Settings.TeamCheckEnabled, function(bool)
    ESPSettings.TeamCheckEnabled = bool
end)

VisualsTab:Seperator()

VisualsTab:Toggle("FOV Circle", Settings.FOVEnabled, function(Enable)
    ESPSettings.FOVEnabled = Enable
end)

VisualsTab:Slider("Size", 100, 600, Settings.FOVSize, function(value)
    ESPSettings.FOVSize = value
end)

VisualsTab:Slider("Round Corner", 12, 100, Settings.RoundedCorner, function(value)
    ESPSettings.RoundedCorner = value
end)
VisualsTab:Seperator()

local ESPColorOptionDrop = VisualsTab:Dropdown("ESP Color Options", {"Custom Color","Rainbow"}, function(Current)
    if Current == "Custom Color" then
        ESPSettings.CustomColor = true
        ESPSettings.RainbowsESPEnabled = false
    else
        ESPSettings.CustomColor = false
        ESPSettings.RainbowsESPEnabled = true
    end
end)

VisualsTab:Colorpicker("ESP Color", Color3.fromRGB(255,255,255), function(color)
    ESPSettings.ESPColor = color
end)

local function ApplyESP(Player)
    local Box = Drawing.new("Square")
    Box.Visible = false
    Box.Color = Color3.fromRGB(255,255,255)
    Box.Thickness = ESPSettings.Thickness
    Box.Transparency = ESPSettings.Transparency
    Box.Filled = false

    local HealthBar = Drawing.new("Square")
    HealthBar.Thickness = ESPSettings.Thickness
    HealthBar.Filled = false
    HealthBar.Transparency = ESPSettings.Transparency
    HealthBar.Visible = false
    
    local Tracer = Drawing.new("Line")
    Tracer.Visible = false
    Tracer.Color = Color3.fromRGB(255,255,255)
    Tracer.Thickness = ESPSettings.Thickness
    Tracer.Transparency = ESPSettings.Transparency
    
    local Name = Drawing.new("Text")
    Name.Visible = false
    Name.Color = Color3.fromRGB(255,255,255)
    Name.Size = 15
    Name.Center = true
    Name.Outline = true
    Name.Transparency = ESPSettings.Transparency
    
    local FOVCircle = Drawing.new("Circle")
    FOVCircle.Thickness = 1
    FOVCircle.Radius = 300
    FOVCircle.NumSides = 12
    FOVCircle.Color = Color3.fromRGB(255,255,255)
    FOVCircle.Visible = false
    FOVCircle.Transparency = ESPSettings.Transparency

    local SkeletonTorso = Drawing.new("Line")
    SkeletonTorso.Visible = false
    SkeletonTorso.From = Vector2.new(0, 0)
    SkeletonTorso.To = Vector2.new(200, 200)
    SkeletonTorso.Color = Color3.fromRGB(255,255,255)
    SkeletonTorso.Thickness = 1
    SkeletonTorso.Transparency = ESPSettings.Transparency

    local SkeletonHead = Drawing.new("Line")
    SkeletonHead.Visible = false
    SkeletonHead.From = Vector2.new(0, 0)
    SkeletonHead.To = Vector2.new(200, 200)
    SkeletonHead.Color = Color3.fromRGB(255,255,255)
    SkeletonHead.Thickness = 1
    SkeletonHead.Transparency = ESPSettings.Transparency

    local SkeletonLeftLeg = Drawing.new("Line")
    SkeletonLeftLeg.Visible = false
    SkeletonLeftLeg.From = Vector2.new(0, 0)
    SkeletonLeftLeg.To = Vector2.new(200, 200)
    SkeletonLeftLeg.Color = Color3.fromRGB(255,255,255)
    SkeletonLeftLeg.Thickness = 1
    SkeletonLeftLeg.Transparency = ESPSettings.Transparency

    local SkeletonRightLeg = Drawing.new("Line")
    SkeletonRightLeg.Visible = false
    SkeletonRightLeg.From = Vector2.new(0, 0)
    SkeletonRightLeg.To = Vector2.new(200, 200)
    SkeletonRightLeg.Color = Color3.fromRGB(255,255,255)
    SkeletonRightLeg.Thickness = 1
    SkeletonRightLeg.Transparency = ESPSettings.Transparency

    local SkeletonLeftArm = Drawing.new("Line")
    SkeletonLeftArm.Visible = false
    SkeletonLeftArm.From = Vector2.new(0, 0)
    SkeletonLeftArm.To = Vector2.new(200, 200)
    SkeletonLeftArm.Color = Color3.fromRGB(255,255,255)
    SkeletonLeftArm.Thickness = 1
    SkeletonLeftArm.Transparency = ESPSettings.Transparency

    local SkeletonRightArm = Drawing.new("Line")
    SkeletonRightArm.Visible = false
    SkeletonRightArm.From = Vector2.new(0, 0)
    SkeletonRightArm.To = Vector2.new(200, 200)
    SkeletonRightArm.Color = Color3.fromRGB(255,255,255)
    SkeletonRightArm.Thickness = 1
    SkeletonRightArm.Transparency = ESPSettings.Transparency

    local line1 = Drawing.new("Line")
    line1.Visible = false
    line1.Color = Color3.fromRGB(255,255,255)
    line1.Thickness = ESPSettings.Thickness
    line1.Transparency = ESPSettings.Transparency

    local line2 = Drawing.new("Line")
    line2.Visible = false
    line2.Color = Color3.fromRGB(255,255,255)
    line2.Thickness = ESPSettings.Thickness
    line2.Transparency = ESPSettings.Transparency

    local line3 = Drawing.new("Line")
    line3.Visible = false
    line3.Color = Color3.fromRGB(255,255,255)
    line3.Thickness = ESPSettings.Thickness
    line3.Transparency = ESPSettings.Transparency

    local line4 = Drawing.new("Line")
    line4.Visible = false
    line4.Color = Color3.fromRGB(255,255,255)
    line4.Thickness = ESPSettings.Thickness
    line4.Transparency = ESPSettings.Transparency

    local line5 = Drawing.new("Line")
    line5.Visible = false
    line5.Color = Color3.fromRGB(255,255,255)
    line5.Thickness = ESPSettings.Thickness
    line5.Transparency = ESPSettings.Transparency

    local line6 = Drawing.new("Line")
    line6.Visible = false
    line6.Color = Color3.fromRGB(255,255,255)
    line6.Thickness = ESPSettings.Thickness
    line6.Transparency = ESPSettings.Transparency

    local line7 = Drawing.new("Line")
    line7.Visible = false
    line7.Color = Color3.fromRGB(255,255,255)
    line7.Thickness = ESPSettings.Thickness
    line7.Transparency = ESPSettings.Transparency

    local line8 = Drawing.new("Line")
    line8.Visible = false
    line8.Color = Color3.fromRGB(255,255,255)
    line8.Thickness = ESPSettings.Thickness
    line8.Transparency = ESPSettings.Transparency

    local line9 = Drawing.new("Line")
    line9.Visible = false
    line9.Color = Color3.fromRGB(255,255,255)
    line9.Thickness = ESPSettings.Thickness
    line9.Transparency = ESPSettings.Transparency

    local line10 = Drawing.new("Line")
    line10.Visible = false
    line10.Color = Color3.fromRGB(255,255,255)
    line10.Thickness = ESPSettings.Thickness
    line10.Transparency = ESPSettings.Transparency

    local line11 = Drawing.new("Line")
    line11.Visible = false
    line11.Color = Color3.fromRGB(255,255,255)
    line11.Thickness = ESPSettings.Thickness
    line11.Transparency = ESPSettings.Transparency

    local line12 = Drawing.new("Line")
    line12.Visible = false
    line12.Color = Color3.fromRGB(255,255,255)
    line12.Thickness = ESPSettings.Thickness
    line12.Transparency = ESPSettings.Transparency

    local Viewline = Drawing.new("Line") --// Parse and Set the line for tracer
    Viewline.Visible = false
    Viewline.From = Vector2.new(0, 0)
    Viewline.To = Vector2.new(0, 0)
    Viewline.Color = Color3.fromRGB(255,255,255)
    Viewline.Thickness = ESPSettings.Thickness
    Viewline.Transparency = ESPSettings.Transparency
    
    game:GetService("RunService").RenderStepped:Connect(function()
        if ESPSettings.FOVEnabled then
            FOVCircle.Visible = true
            FOVCircle.Position = Vector2.new(mouse.X, mouse.Y + 36)
            FOVCircle.Thickness = ESPSettings.Thickness
            FOVCircle.NumSides = ESPSettings.RoundedCorner
            FOVCircle.Radius = ESPSettings.FOVSize
            if ESPSettings.RainbowsESPEnabled then
                FOVCircle.Color = Color3.fromHSV(tick()%5/5,1,1)
            elseif ESPSettings.CustomColor then
                FOVCircle.Color = ESPSettings.ESPColor
            end
        else
            FOVCircle.Visible = false
        end
        if Player.Character ~= nil and Player.Character:FindFirstChild("Humanoid") ~= nil and Player.Character:FindFirstChild("HumanoidRootPart") ~= nil and Player ~= plr and Player.Character.Humanoid.Health > 0 then
            local Vector, onScreen = camera:worldToViewportPoint(Player.Character.HumanoidRootPart.Position)
            local pos, vis = camera:worldToViewportPoint(Player.Character.HumanoidRootPart.Position)
            local Distance = (camera.CFrame.p - Player.Character.HumanoidRootPart.Position).Magnitude
            local RootPart = Player.Character.HumanoidRootPart
            local Head = Player.Character.Head
            local RootPosition, RootVis = worldToViewportPoint(camera, RootPart.Position)
            local HeadPosition = worldToViewportPoint(camera, Head.Position + ESPSettings.HeadOff)
            local LegPosition = worldToViewportPoint(camera, RootPart.Position - ESPSettings.LegOff)
            local offsetCFrame = CFrame.new(0, 0, -ESPSettings.Length)
            local headpos, OnScreen = camera:WorldToViewportPoint(Player.Character.Head.Position)
            local localheadpos, headposonscreen = camera:WorldToViewportPoint(plr.Character.Head.Position)
            local dir = Player.Character.Head.CFrame:ToWorldSpace(offsetCFrame)
            local dirpos, vis = camera:WorldToViewportPoint(Vector3.new(dir.X, dir.Y, dir.Z))

            if onScreen then
                if ESPSettings.Box2DEnabled then
                    Box.Size = Vector2.new(2000 / RootPosition.Z, HeadPosition.Y - LegPosition.Y)
                    Box.Position = Vector2.new(RootPosition.X - Box.Size.X / 2, RootPosition.Y - Box.Size.Y / 2)
                    Box.Visible = true
    
                    HealthBar.Size = Vector2.new(2, (HeadPosition.Y - LegPosition.Y) / (Player.Character.Humanoid.MaxHealth / math.clamp(Player.Character.Humanoid.Health, 0,Player.Character.Humanoid.MaxHealth)))
                    HealthBar.Position = Vector2.new(Box.Position.X - 6, Box.Position.Y + (1 / HealthBar.Size.Y))
                    HealthBar.Color = Color3.fromRGB(255 - 255 / (Player.Character.Humanoid.MaxHealth / Player.Character.Humanoid.Health), 255 / (Player.Character.Humanoid.MaxHealth / Player.Character.Humanoid.Health), 0)
                    HealthBar.Visible = true

                    Box.Thickness = ESPSettings.Thickness
                    HealthBar.Thickness = ESPSettings.Thickness
                    Box.Transparency = ESPSettings.Transparency
                    HealthBar.Transparency = ESPSettings.Transparency

                    if ESPSettings.RainbowsESPEnabled then
                        Box.Color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                    elseif ESPSettings.CustomColor then
                        Box.Color = ESPSettings.ESPColor
                    end

                    if Player.TeamColor == plr.TeamColor and ESPSettings.TeamCheckEnabled then
                        HealthBar.Visible = false
                        Box.Visible = false
                    else
                        Box.Visible = true
                        HealthBar.Visible = true
                    end
                else
                    Box.Visible = false
                    HealthBar.Visible = false
                end
                if ESPSettings.TracerEnabled then
                    if ESPSettings.BottomFrom then
                        Tracer.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 1)
                    elseif ESPSettings.HeadFrom then
                        Tracer.From = Vector2.new(localheadpos.X, localheadpos.Y)
                    elseif ESPSettings.MouseFrom then
                        Tracer.From = Vector2.new(mouse.X, mouse.Y+36)
                    end
                    Tracer.To = Vector2.new(Vector.X, Vector.Y)
                    Tracer.Visible = true
                    Tracer.Transparency = ESPSettings.Transparency

                    Tracer.Thickness = ESPSettings.Thickness

                    if ESPSettings.RainbowsESPEnabled then
                        Tracer.Color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                    elseif ESPSettings.CustomColor then
                        Tracer.Color = ESPSettings.ESPColor
                    end

                    if Player.TeamColor == plr.TeamColor and ESPSettings.TeamCheckEnabled then
                        Tracer.Visible = false
                    else
                        Tracer.Visible = true
                    end
                else
                    Tracer.Visible = false
                end
                if ESPSettings.ViewTracerEnabled then
                    Viewline.From = Vector2.new(headpos.X, headpos.Y)
                    offsetCFrame = offsetCFrame * CFrame.new(0, 0, 0.01)
                    Viewline.To = Vector2.new(dirpos.X, dirpos.Y)
                    Viewline.Visible = true
                    offsetCFrame = CFrame.new(0, 0, -ESPSettings.Length)
                    Viewline.Thickness = ESPSettings.Thickness
                    if ESPSettings.RainbowsESPEnabled then
                        Viewline.Color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                    elseif ESPSettings.CustomColor then
                        Viewline.Color = ESPSettings.ESPColor
                    end

                    if Player.TeamColor == plr.TeamColor and ESPSettings.TeamCheckEnabled then
                        Viewline.Visible = false
                    else
                        Viewline.Visible = true
                    end
                else
                    Viewline.Visible = false
                end
                if ESPSettings.NameEnabled then
                    Name.Text = tostring("["..math.floor(Distance).."] "..Player.Name.." ["..math.floor(Player.Character.Humanoid.MaxHealth).."/"..math.floor(Player.Character.Humanoid.Health).."]")
                    Name.Position = Vector2.new(RootPosition.X - Box.Size.X / 2, RootPosition.Y - Box.Size.Y / 2)
                    Name.Size = ESPSettings.TextSize
                    Name.Transparency = ESPSettings.Transparency
                    Name.Visible = true
                    Name.Outline = ESPSettings.TextOutlineEnabled

                    if ESPSettings.RainbowsESPEnabled then
                        Name.Color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                    elseif ESPSettings.CustomColor then
                        Name.Color = ESPSettings.ESPColor
                    end

                    if Player.TeamColor == plr.TeamColor and ESPSettings.TeamCheckEnabled then
                        Name.Visible = false
                    else
                        Name.Visible = true
                    end
                else
                    Name.Visible = false
                end
                if ESPSettings.Box3DEnabled then
                    local Scale = Player.Character.Head.Size.Y/2
                    local Size = Vector3.new(2, 3, 1.5) * (Scale * 2)

                    local Top1 = camera:WorldToViewportPoint((Player.Character.HumanoidRootPart.CFrame * CFrame.new(-Size.X, Size.Y, -Size.Z)).p)
                    local Top2 = camera:WorldToViewportPoint((Player.Character.HumanoidRootPart.CFrame * CFrame.new(-Size.X, Size.Y, Size.Z)).p)
                    local Top3 = camera:WorldToViewportPoint((Player.Character.HumanoidRootPart.CFrame * CFrame.new(Size.X, Size.Y, Size.Z)).p)
                    local Top4 = camera:WorldToViewportPoint((Player.Character.HumanoidRootPart.CFrame * CFrame.new(Size.X, Size.Y, -Size.Z)).p)

                    local Bottom1 = camera:WorldToViewportPoint((Player.Character.HumanoidRootPart.CFrame * CFrame.new(-Size.X, -Size.Y, -Size.Z)).p)
                    local Bottom2 = camera:WorldToViewportPoint((Player.Character.HumanoidRootPart.CFrame * CFrame.new(-Size.X, -Size.Y, Size.Z)).p)
                    local Bottom3 = camera:WorldToViewportPoint((Player.Character.HumanoidRootPart.CFrame * CFrame.new(Size.X, -Size.Y, Size.Z)).p)
                    local Bottom4 = camera:WorldToViewportPoint((Player.Character.HumanoidRootPart.CFrame * CFrame.new(Size.X, -Size.Y, -Size.Z)).p)

                    --// Top:
                    line1.From = Vector2.new(Top1.X, Top1.Y)
                    line1.To = Vector2.new(Top2.X, Top2.Y)

                    line2.From = Vector2.new(Top2.X, Top2.Y)
                    line2.To = Vector2.new(Top3.X, Top3.Y)

                    line3.From = Vector2.new(Top3.X, Top3.Y)
                    line3.To = Vector2.new(Top4.X, Top4.Y)

                    line4.From = Vector2.new(Top4.X, Top4.Y)
                    line4.To = Vector2.new(Top1.X, Top1.Y)

                    --// Bottom:
                    line5.From = Vector2.new(Bottom1.X, Bottom1.Y)
                    line5.To = Vector2.new(Bottom2.X, Bottom2.Y)

                    line6.From = Vector2.new(Bottom2.X, Bottom2.Y)
                    line6.To = Vector2.new(Bottom3.X, Bottom3.Y)

                    line7.From = Vector2.new(Bottom3.X, Bottom3.Y)
                    line7.To = Vector2.new(Bottom4.X, Bottom4.Y)

                    line8.From = Vector2.new(Bottom4.X, Bottom4.Y)
                    line8.To = Vector2.new(Bottom1.X, Bottom1.Y)

                    --//S ides:
                    line9.From = Vector2.new(Bottom1.X, Bottom1.Y)
                    line9.To = Vector2.new(Top1.X, Top1.Y)

                    line10.From = Vector2.new(Bottom2.X, Bottom2.Y)
                    line10.To = Vector2.new(Top2.X, Top2.Y)

                    line11.From = Vector2.new(Bottom3.X, Bottom3.Y)
                    line11.To = Vector2.new(Top3.X, Top3.Y)

                    line12.From = Vector2.new(Bottom4.X, Bottom4.Y)
                    line12.To = Vector2.new(Top4.X, Top4.Y)

                    line1.Thickness = ESPSettings.Thickness
                    line2.Thickness = ESPSettings.Thickness
                    line3.Thickness = ESPSettings.Thickness
                    line4.Thickness = ESPSettings.Thickness
                    line5.Thickness = ESPSettings.Thickness
                    line6.Thickness = ESPSettings.Thickness
                    line7.Thickness = ESPSettings.Thickness
                    line8.Thickness = ESPSettings.Thickness
                    line9.Thickness = ESPSettings.Thickness
                    line10.Thickness = ESPSettings.Thickness
                    line11.Thickness = ESPSettings.Thickness
                    line12.Thickness = ESPSettings.Thickness

                    line1.Transparency = ESPSettings.Transparency
                    line2.Transparency = ESPSettings.Transparency
                    line3.Transparency = ESPSettings.Transparency
                    line4.Transparency = ESPSettings.Transparency
                    line5.Transparency = ESPSettings.Transparency
                    line6.Transparency = ESPSettings.Transparency
                    line7.Transparency = ESPSettings.Transparency
                    line8.Transparency = ESPSettings.Transparency
                    line9.Transparency = ESPSettings.Transparency
                    line10.Transparency = ESPSettings.Transparency
                    line11.Transparency = ESPSettings.Transparency
                    line12.Transparency = ESPSettings.Transparency

                    line1.Visible = true
                    line2.Visible = true
                    line3.Visible = true
                    line4.Visible = true
                    line5.Visible = true
                    line6.Visible = true
                    line7.Visible = true
                    line8.Visible = true
                    line9.Visible = true
                    line10.Visible = true
                    line11.Visible = true
                    line12.Visible = true

                    if ESPSettings.RainbowsESPEnabled then
                        line1.Color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                        line2.Color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                        line3.Color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                        line4.Color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                        line5.Color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                        line6.Color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                        line7.Color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                        line8.Color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                        line9.Color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                        line10.Color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                        line11.Color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                        line12.Color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                    elseif ESPSettings.CustomColor then
                        line1.Color = ESPSettings.ESPColor
                        line2.Color = ESPSettings.ESPColor
                        line3.Color = ESPSettings.ESPColor
                        line4.Color = ESPSettings.ESPColor
                        line5.Color = ESPSettings.ESPColor
                        line6.Color = ESPSettings.ESPColor
                        line7.Color = ESPSettings.ESPColor
                        line8.Color = ESPSettings.ESPColor
                        line9.Color = ESPSettings.ESPColor
                        line10.Color = ESPSettings.ESPColor
                        line11.Color = ESPSettings.ESPColor
                        line12.Color = ESPSettings.ESPColor
                    end

                    if Player.TeamColor == plr.TeamColor and ESPSettings.TeamCheckEnabled then
                        line1.Visible = false
                        line2.Visible = false
                        line3.Visible = false
                        line4.Visible = false
                        line5.Visible = false
                        line6.Visible = false
                        line7.Visible = false
                        line8.Visible = false
                        line9.Visible = false
                        line10.Visible = false
                        line11.Visible = false
                        line12.Visible = false
                    else
                        line1.Visible = true
                        line2.Visible = true
                        line3.Visible = true
                        line4.Visible = true
                        line5.Visible = true
                        line6.Visible = true
                        line7.Visible = true
                        line8.Visible = true
                        line9.Visible = true
                        line10.Visible = true
                        line11.Visible = true
                        line12.Visible = true
                    end
                else
                    line1.Visible = false
                    line2.Visible = false
                    line3.Visible = false
                    line4.Visible = false
                    line5.Visible = false
                    line6.Visible = false
                    line7.Visible = false
                    line8.Visible = false
                    line9.Visible = false
                    line10.Visible = false
                    line11.Visible = false
                    line12.Visible = false
                end
                if ESPSettings.SkeletonESPEnabled then
                    local UpperTorso = camera:WorldToViewportPoint(Player.Character.UpperTorso.Position)
                    local LowerTorso = camera:WorldToViewportPoint(Player.Character.LowerTorso.Position)
    
                    local LeftLeg = camera:WorldToViewportPoint(Player.Character.LeftFoot.Position)
                    local RightLeg = camera:WorldToViewportPoint(Player.Character.RightFoot.Position)
    
                    local LeftArm = camera:WorldToViewportPoint(Player.Character.LeftHand.Position)
                    local RightArm = camera:WorldToViewportPoint(Player.Character.RightHand.Position)
    
                    local Head = camera:WorldToViewportPoint(Player.Character.Head.Position)
                    
                    SkeletonTorso.Visible = true
                    SkeletonHead.Visible = true
                    SkeletonLeftArm.Visible = true
                    SkeletonLeftLeg.Visible = true
                    SkeletonRightArm.Visible = true
                    SkeletonRightLeg.Visible = true

                    SkeletonTorso.Transparency = ESPSettings.Transparency
                    SkeletonHead.Transparency = ESPSettings.Transparency
                    SkeletonLeftArm.Transparency = ESPSettings.Transparency
                    SkeletonLeftLeg.Transparency = ESPSettings.Transparency
                    SkeletonRightArm.Transparency = ESPSettings.Transparency
                    SkeletonRightLeg.Transparency = ESPSettings.Transparency

                    SkeletonTorso.Thickness = ESPSettings.Thickness
                    SkeletonHead.Thickness = ESPSettings.Thickness
                    SkeletonLeftArm.Thickness = ESPSettings.Thickness
                    SkeletonLeftLeg.Thickness = ESPSettings.Thickness
                    SkeletonRightArm.Thickness = ESPSettings.Thickness
                    SkeletonRightLeg.Thickness = ESPSettings.Thickness
                    
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

                    if ESPSettings.RainbowsESPEnabled then
                        SkeletonTorso.Color = Color3.fromHSV(tick()%5/5,1,1)
                        SkeletonHead.Color = Color3.fromHSV(tick()%5/5,1,1)
                        SkeletonLeftArm.Color = Color3.fromHSV(tick()%5/5,1,1)
                        SkeletonLeftLeg.Color = Color3.fromHSV(tick()%5/5,1,1)
                        SkeletonRightArm.Color = Color3.fromHSV(tick()%5/5,1,1)
                        SkeletonRightLeg.Color = Color3.fromHSV(tick()%5/5,1,1)
                    elseif ESPSettings.CustomColor then
                        SkeletonTorso.Color = ESPSettings.ESPColor
                        SkeletonHead.Color = ESPSettings.ESPColor
                        SkeletonLeftArm.Color = ESPSettings.ESPColor
                        SkeletonLeftLeg.Color = ESPSettings.ESPColor
                        SkeletonRightArm.Color = ESPSettings.ESPColor
                        SkeletonRightLeg.Color = ESPSettings.ESPColor
                    end

                    if Player.TeamColor == plr.TeamColor and ESPSettings.TeamCheckEnabled then
                        SkeletonTorso.Visible = false
                        SkeletonHead.Visible = false
                        SkeletonLeftArm.Visible = false
                        SkeletonLeftLeg.Visible = false
                        SkeletonRightArm.Visible = false
                        SkeletonRightLeg.Visible = false
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
                Box.Visible = false
                HealthBar.Visible = false
                Tracer.Visible = false
                Name.Visible = false
                SkeletonTorso.Visible = false
                SkeletonHead.Visible = false
                SkeletonLeftArm.Visible = false
                SkeletonLeftLeg.Visible = false
                SkeletonRightArm.Visible = false
                SkeletonRightLeg.Visible = false
                line1.Visible = false
                line2.Visible = false
                line3.Visible = false
                line4.Visible = false
                line5.Visible = false
                line6.Visible = false
                line7.Visible = false
                line8.Visible = false
                line9.Visible = false
                line10.Visible = false
                line11.Visible = false
                line12.Visible = false
                Viewline.Visible = false
            end
        else
            Box.Visible = false
            HealthBar.Visible = false
            Tracer.Visible = false
            Name.Visible = false
            SkeletonTorso.Visible = false
            SkeletonHead.Visible = false
            SkeletonLeftArm.Visible = false
            SkeletonLeftLeg.Visible = false
            SkeletonRightArm.Visible = false
            SkeletonRightLeg.Visible = false
            line1.Visible = false
            line2.Visible = false
            line3.Visible = false
            line4.Visible = false
            line5.Visible = false
            line6.Visible = false
            line7.Visible = false
            line8.Visible = false
            line9.Visible = false
            line10.Visible = false
            line11.Visible = false
            line12.Visible = false
            Viewline.Visible = false
        end
    end)
end

for i,v in pairs(game.Players:GetChildren()) do
    ApplyESP(v)
end

game.Players.PlayerAdded:Connect(function(v)
    ApplyESP(v)
end)

while true do
    SaveSettings()
    wait(60)
end