local Camera = game:GetService("Workspace").CurrentCamera
    local RunService = game:GetService("RunService")
    local plr = game.Players.LocalPlayer
    local mouse = plr:GetMouse()
    local UserInputService = game:GetService("UserInputService")
    local DiscordLib = loadstring(game:HttpGet"https://raw.githubusercontent.com/dawid-scripts/UI-Libs/main/discord%20lib.txt")()
    local Window = DiscordLib:Window("Cattoware")
    local MainPage = Window:Server("Main", "http://www.roblox.com/asset/?id=6031075938")
    local ESPPage = Window:Server("ESP", "http://www.roblox.com/asset/?id=6031075938")
    local RainbowsESPEnabled = false
    local BoxEnabled = false
    local NameEnabled = false
    local TracerEnabled = false
    local FlyEnabled = false
    local MainPage = MainPage:Channel("Misc")
    local VisualsTab = ESPPage:Channel("Visuals")
    
    MainPage:Toggle("Fly", false, function(bool)
        FlyEnabled = bool
    end)
    
    local Inoria = "Part"
    local catori = Instance.new(Inoria)
    catori.Name = "uwu"
    catori.Anchored = true
    catori.Parent = game.Workspace
    catori.Shape = Enum.PartType.Ball
    catori.Color = Color3.new(1, 1, 1)
    catori.CanCollide = false
    catori.Transparency = 1
    local UIs = game:GetService("UserInputService")
    UIs.InputBegan:Connect(function(k,c)
        if k.KeyCode == Enum.KeyCode.W and not c then
            catori.CanCollide = true
        end
    end)
    UIs.InputEnded:Connect(function(k,c)
        if k.KeyCode == Enum.KeyCode.W and not c then
            catori.CanCollide = false
        end
    end)
    local offset = Vector3.new(0,0.8,1)
    
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
    
    local function ModelTemplate()
            local Objects = {
                BoxOutline = Drawing.new("Quad"),
                Box = Drawing.new("Quad"),
                TracerOutline = Drawing.new("Line"),
                Tracer = Drawing.new("Line"),
                Name = Drawing.new("Text"),
                FOVCircleOutline = Drawing.new("Circle"),
                FOVCircle = Drawing.new("Circle"),
            }
           
           return Objects
        end
    
        local function GetPartCorners(Part)
        	local Size = Part.Size * Vector3.new(1, 1.5)
        	return {
                TR = (Part.CFrame * CFrame.new(-Size.X, -Size.Y, 0)).Position,
        		BR = (Part.CFrame * CFrame.new(-Size.X, Size.Y, 0)).Position,
        		TL = (Part.CFrame * CFrame.new(Size.X, -Size.Y, 0)).Position,
        		BL = (Part.CFrame * CFrame.new(Size.X, Size.Y, 0)).Position,
        	}
        end
        
        local function ApplyModel(Model)
            local Objects = ModelTemplate()
            local CurrentParent = Model.Parent
            
            spawn(function()
                Objects.BoxOutline.Visible = true
                Objects.BoxOutline.Transparency = 1
                Objects.BoxOutline.Color = Color3.new(0,0,0)
                Objects.BoxOutline.Thickness = 3
                
                Objects.Box.Visible = true
                Objects.Box.Transparency = 1
                Objects.Box.Color = Color3.fromRGB(255,255,255)
                Objects.Box.Thickness = 1
                
                Objects.TracerOutline.Visible = true
                Objects.TracerOutline.Color = Color3.new(0,0,0)
                Objects.TracerOutline.Thickness = 3
                Objects.TracerOutline.Transparency = 1
                
                Objects.Tracer.Visible = true
                Objects.Tracer.Color = Color3.fromRGB(255,255,255)
                Objects.Tracer.Thickness = 1
                Objects.Tracer.Transparency = 1
                
                Objects.Name.Center = true
                Objects.Name.Visible = true
                Objects.Name.Outline = true
                Objects.Name.Transparency = 1
                Objects.Name.Color = Color3.fromRGB(255,255,255)
                Objects.Name.Size = 16
                Objects.Name.Font = 0
               
                while Model.Parent == CurrentParent do
                    local Vector, OnScreen = Camera:WorldToScreenPoint(Model.Head.Position)
                    local RootPart = Camera:WorldToScreenPoint(Model.HumanoidRootPart.Position)
                    local Distance = (Camera.CFrame.Position - Model.HumanoidRootPart.Position).Magnitude
                    local PartCorners = GetPartCorners(Model.HumanoidRootPart)
                    local VectorTR, OnScreenTR = Camera:WorldToScreenPoint(PartCorners.TR)
                    local VectorBR, OnScreenBR = Camera:WorldToScreenPoint(PartCorners.BR)
                    local VectorTL, OnScreenTL = Camera:WorldToScreenPoint(PartCorners.TL)
                    local VectorBL, OnScreenBL = Camera:WorldToScreenPoint(PartCorners.BL)
                    
                    if (OnScreenBL or OnScreenTL or OnScreenBR or OnScreenTR) and Model.Parent.Name ~= game:GetService("Players").LocalPlayer.Team.Name and BoxEnabled then
                        Objects.BoxOutline.PointA = Vector2.new(VectorTR.X, VectorTR.Y + 36)
                        Objects.BoxOutline.PointB = Vector2.new(VectorTL.X, VectorTL.Y + 36)
                        Objects.BoxOutline.PointC = Vector2.new(VectorBL.X, VectorBL.Y + 36)
                        Objects.BoxOutline.PointD = Vector2.new(VectorBR.X, VectorBR.Y + 36)
                        Objects.BoxOutline.Visible = true
                        Objects.Box.PointA = Vector2.new(VectorTR.X, VectorTR.Y + 36)
                        Objects.Box.PointB = Vector2.new(VectorTL.X, VectorTL.Y + 36)
                        Objects.Box.PointC = Vector2.new(VectorBL.X, VectorBL.Y + 36)
                        Objects.Box.PointD = Vector2.new(VectorBR.X, VectorBR.Y + 36)
                        Objects.Box.Visible = true
                        
                        if RainbowsESPEnabled then
                            Objects.Box.Color = Color3.fromHSV(tick()%5/5,1,1)
                        elseif CustomColor then
                            Objects.Box.Color = ESPColor
                        end
                    else
                        Objects.BoxOutline.Visible = false
                        Objects.Box.Visible = false
                    end
                    
                    if OnScreen and Model.Parent.Name ~= game:GetService("Players").LocalPlayer.Team.Name and TracerEnabled then
                        Objects.TracerOutline.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 1)
                        Objects.TracerOutline.To = Vector2.new(RootPart.X, RootPart.Y + 30)
                        Objects.TracerOutline.Visible = true
                        Objects.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 1)
                        Objects.Tracer.To = Vector2.new(RootPart.X, RootPart.Y + 30)
                        Objects.Tracer.Visible = true
                        if RainbowsESPEnabled then
                            Objects.Tracer.Color = Color3.fromHSV(tick()%5/5,1,1)
                        elseif CustomColor then
                            Objects.Tracer.Color = ESPColor
                        end
                    else
                        Objects.TracerOutline.Visible = false
                        Objects.Tracer.Visible = false
                    end
                    
                    if OnScreen and Model.Parent.Name ~= game:GetService("Players").LocalPlayer.Team.Name and NameEnabled then
                        Objects.Name.Position = Vector2.new(RootPart.X, RootPart.Y + 25)
                        Objects.Name.Visible = true
                        if RainbowsESPEnabled then
                            Objects.Name.Color = Color3.fromHSV(tick()%5/5,1,1)
                        elseif CustomColor then
                            Objects.Name.Color = ESPColor
                        end
                    else
                        Objects.Name.Visible = false
                    end
        
                    Objects.Name.Text = "["..tostring(math.floor(Distance)).."]"
                    
                    RunService.RenderStepped:Wait()
                end
                
                Objects.Box:Remove()
                Objects.BoxOutline:Remove()
                Objects.TracerOutline:Remove()
                Objects.Tracer:Remove()
                Objects.Name:Remove()
            end)
        end
        
        for _, Player in next, game:GetService("Workspace").Players.Phantoms:GetChildren() do
            ApplyModel(Player)
        end
        
        for _, Player in next, game:GetService("Workspace").Players.Ghosts:GetChildren() do
            ApplyModel(Player)
        end
        
        game:GetService("Workspace").Players.Phantoms.ChildAdded:Connect(function(Player)
            delay(0.5, function()
                ApplyModel(Player)
            end)
        end)
        
        game:GetService("Workspace").Players.Ghosts.ChildAdded:Connect(function(Player)
            delay(0.5, function()
                ApplyModel(Player)
            end)
        end)
    
    local Objects = ModelTemplate()
    Objects.FOVCircleOutline.Thickness = 3
    Objects.FOVCircleOutline.Radius = 300
    Objects.FOVCircleOutline.NumSides = 12
    Objects.FOVCircleOutline.Color = Color3.new(0,0,0)
    Objects.FOVCircleOutline.Visible = false
            
    Objects.FOVCircle.Thickness = 1
    Objects.FOVCircle.Radius = 300
    Objects.FOVCircle.NumSides = 12
    Objects.FOVCircle.Color = Color3.fromRGB(255,255,255)
    Objects.FOVCircle.Visible = false
    game:GetService("RunService").RenderStepped:Connect(function()
        if FOVEnabled then
            Objects.FOVCircle.Visible = true
            Objects.FOVCircleOutline.Visible = true
            Objects.FOVCircle.Position = Vector2.new(mouse.X, mouse.Y + 36)
            Objects.FOVCircleOutline.Position = Vector2.new(mouse.X, mouse.Y + 36)
            Objects.FOVCircle.Radius = FOVSize
            Objects.FOVCircleOutline.Radius = FOVSize
            if RainbowsESPEnabled then
                Objects.FOVCircle.Color = Color3.fromHSV(tick()%5/5,1,1)
            elseif CustomColor then
                Objects.FOVCircle.Color = ESPColor
            end
        else
            Objects.FOVCircleOutline.Visible = false
            Objects.FOVCircle.Visible = false
        end
    end)
while wait() do 
    if FlyEnabled then
            catori.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame*CFrame.new(offset)
    end
end