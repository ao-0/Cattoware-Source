local is_protected_closure = is_protected_closure or function(f) return false end
repeat wait() until game.Loaded
repeat wait() until game:GetService("Players").LocalPlayer
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
local NameEnabled = false
local SkeletonESPEnabled = false
local index_list = {7}
	local tweenservice = game:GetService("TweenService")
	local workspace = game:GetService("Workspace")
	local Players = game:GetService("Players")
	local client = Players.LocalPlayer
	local plrrem = client.Character:FindFirstChild("Remotes")
	local npcs = workspace.NPCSpawns:GetChildren()
	local selected_key = 5
	local pressrem = plrrem.KeyEvent
	local tp_offset = Vector3.new(1, 0, 0)
	local remotepw
	local mouse = client:GetMouse()
	local teleporting = false
	local team = client:WaitForChild("PlayerFolder").Customization.Team.Value
	_G.AntiAfk = false

	local VirtualUser = game:service'VirtualUser'
	game:service'Players'.LocalPlayer.Idled:connect(function()
		if _G.AntiAfk then
			VirtualUser:CaptureController()
			VirtualUser:ClickButton2(Vector2.new())
		end
	end)

	client.CharacterAdded:Connect(function()
		for i = 1,10 do wait()
			pcall(function()
				plrrem = client.Character:WaitForChild("Remotes", 9e9)
				pressrem = plrrem.KeyEvent
			end)
		end
	end)


	local npc_table = {
		[1] = "Low Rank Aogiri Member",
		[2] = "Mid Rank Aogiri Member",
		[3] = "High Rank Aogiri Member",
		[4] = "Rank 1 Investigator",
		[5] = "Rank 2 Investigator",
		[6] = "First Class Investigator",
		[7] = "Human",
		[8] = "Athlete",
	}

	local key_list = {
		[1] = "C",
		[2] = "E",
		[3] = "F",
		[4] = "R",
		[5] = "Mouse1",
	}


	local toggles = {
		["autofarm"] = false,
		["q_autofarm"] = false,
	}


	function grabKey()
		local key
		for i,v in next,(getreg()) do 
			if type(v) == "function" and islclosure(v) and (not is_protected_closure(v)) and getfenv(v).script and getfenv(v).script.Name == "ClientControl" then 
				if getconstants(v)[35] == "Up" then
					key = getconstants(v)[34]
				end
			end
		end
		return key
	end

	remotepw = grabKey()

	if remotepw == nil then
		error("remote key is nil! report this to hattori devs.")
	end


	function checkOff(remotes)
		if remotes:FindFirstChild("GetPos") and remotes:FindFirstChild("StatUpdate") and remotes:FindFirstChild("UpdateAll") then
			remotes:FindFirstChild("StatUpdate").RobloxLocked = true
		else
			--warn("checks are off")
		end
	end

	function pressKey(key)
		pressrem:FireServer(remotepw, key_list[key], "Down", mouse.Hit) 
	end


	function getNPC(indexes)
		local npc_grab = {}
		local index = indexes
		if type(indexes) == 'table' then
			for x,c in next, (indexes) do
				index = c
			end
		end

		for i,v in next, (npcs) do
			if index == "All Aogiri" or index == "All Investigator" then
				for i,c in pairs(v:GetChildren()) do
					if c.Name:lower():find("aogiri") and index == "All Aogiri" then
						table.insert(npc_grab, c)
					elseif c.Name:lower():find("investigator") and index == "All Investigator" then
						table.insert(npc_grab, c)
					end
				end
			elseif v:FindFirstChild(npc_table[index]) then
				table.insert(npc_grab, v:FindFirstChild(npc_table[index]))
			end
		end
		return npc_grab
	end

	function eatCorpse(model)
		for i, corpse in pairs(model:GetChildren()) do
			if corpse.Name:lower():find("corpse") and corpse:FindFirstChild("ClickPart") then
					wait(0.5)
					for i = 1, 5 do wait()
						if corpse:FindFirstChild("ClickPart") and corpse:FindFirstChild("ClickPart"):FindFirstChildOfClass("ClickDetector") then
							fireclickdetector(corpse:FindFirstChild("ClickPart"):FindFirstChildOfClass("ClickDetector"))
						end
					end
					wait(0.5)
			end
		end
	end

	function tweenMove(model, target, isCFrame)
		spawn(function()
				if model and model.PrimaryPart then
					local CFrameValue = Instance.new("CFrameValue")
					CFrameValue.Value = model:GetPrimaryPartCFrame()

					CFrameValue:GetPropertyChangedSignal("Value"):connect(function()
						if model and model.PrimaryPart then
							model:SetPrimaryPartCFrame(CFrameValue.Value)
						end
					end)

					local Info = TweenInfo.new(
						((model:GetPrimaryPartCFrame().Position - target.Position).magnitude)/ 250, -- Length
						Enum.EasingStyle.Linear, -- Easing Style
						Enum.EasingDirection.Out, -- Easing Direction
						0, -- Times repeated
						false, -- Reverse
						0 -- Delay
					)

					local tween
					if not isCFrame then
						tween = tweenservice:Create(CFrameValue, Info, {Value = (target.CFrame) * CFrame.new(0,0,5)})
					else
						tween = tweenservice:Create(CFrameValue, Info, {Value = (target) * CFrame.new(0,0,5)})
					end
					if tween then
						tween:Play()
						--warn(teleporting)
						if teleporting then
							--warn'Teleporting'
							tween.Completed:Connect(function()
								--print'Tween Ended'
								teleporting = false
							end)
						end
					end
				end
		end)
	end

	--// MAIN LOOP 

	local char = client.Character
	char.PrimaryPart = char.HumanoidRootPart

	checkOff(plrrem)
	wait()

	spawn(function()
		while true do
			repeat wait() until client.Character:FindFirstChild("Remotes")
			plrrem = client.Character:FindFirstChild("Remotes")
			repeat wait() until plrrem:FindFirstChild("KeyEvent")
			local char = client.Character
			pressrem = plrrem.KeyEvent
			if toggles["autofarm"] then
				for i,o in next, getNPC(index_list) do
					if toggles["autofarm"] and client.Character then
						while toggles["autofarm"] and o:FindFirstChild("HumanoidRootPart") do
							if client.Character and client.Character:FindFirstChild("HumanoidRootPart") then
								pcall(function()
									if client.Character and not client.Character:FindFirstChild("Kagune") and not client.Character:FindFirstChild("Quinque")  then
										pressrem:FireServer(remotepw, "One", "Down", mouse.Hit)
									end
								end)
								tweenMove(client.Character, o:FindFirstChild("HumanoidRootPart"))
								if (client.Character.HumanoidRootPart.Position - o:FindFirstChild("HumanoidRootPart").Position).magnitude < 10 then
									pressKey(selected_key)
								end
							end
							wait()
						end
						eatCorpse(o)
					end
				end
			end
			wait()
		end
	end)
local DiscordLib = loadstring(game:HttpGet"https://raw.githubusercontent.com/dawid-scripts/UI-Libs/main/discord%20lib.txt")()

local win = DiscordLib:Window("Cattoware")

local serv = win:Server("Ro Ghoul", "")

local MainChannel = serv:Channel("Main")
local VisualsTab = serv:Channel("Visuals")
local MiscChannel = serv:Channel("Misc")

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

local drop = MainChannel:Dropdown("Select Mob", {"All Aogiri", "Low Rank Aogiri Member", "Mid Rank Aogiri Member", "High Rank Aogiri Member", "All Investigator", "Rank 1 Investigator", "Rank 2 Investigator", "First Class Investigator", "Human", "Athlete",}, function(selectedASD)
    local found = false
		for i,v in pairs(npc_table) do
			if v == selectedASD then
				found = true
				index_list = {i}
			end
		end
		if not found then
			index_list = selectedASD
		end
end)

MainChannel:Toggle("Auto Farm",false, function(bool)
    toggles["autofarm"] = bool
end)

local TrainersTable = {}
for i,v in pairs(game:service'Players'.LocalPlayer.PlayerFolder.Trainers:GetChildren()) do
	table.insert(TrainersTable, v.Name)
end


local SelectedTrainer = "ken"

	local function train()
		local TrainerVal = ""
		for i,v in pairs(game:service'Players'.LocalPlayer.PlayerFolder.Trainers:GetChildren()) do
			if v.Name:lower():find(SelectedTrainer:lower()) then
				TrainerVal = v.Name
			end
		end

		game:service'Players'.LocalPlayer.Backpack.ChildAdded:Connect(function(p)
			if p.Name == "ClientTrain" then
				spawn(function()
					local c = p:WaitForChild("TSCodeVal", 2e99)
					local a = c.Value
					shared.TSCodeVal = a
				end)

				p.ChildAdded:Connect(function(s)
					if s.Name == "TSCodeVal" then
						shared.TSCodeVal = s.Value
					end
				end)
			end
		end)

		local returned = game.ReplicatedStorage.Remotes.Trainers.RequestTraining:InvokeServer(TrainerVal)

		spawn(function()
			while asd do wait(1)

				local tSes = workspace.TrainingSessions:GetChildren()
				for i,v in pairs(tSes) do
					if v then
						repeat wait() until v:FindFirstChild("Player")
						if tostring(v.Player.Value) == game:service'Players'.LocalPlayer.Name then
							v.Comm:FireServer("Finished", shared.TSCodeVal, false)
							asd = false
						end
					end
				end

			end
		end)
	end
	
local drop2 = MainChannel:Dropdown("Select Trainner", TrainersTable, function(selectedASD)
    SelectedTrainer = selectedASD
end)

MainChannel:Button("Complete Trainner", function()
    if toggles["autofarm"] == false and teleporting == false then
		train()
	end
end)

MiscChannel:Button("Remove NameTags (ServerSided)", function()
    if game:GetService("Players").LocalPlayer.Character.Head:FindFirstChild("PlayerStatus") then
        
        game:GetService("Players").LocalPlayer.Character.Head:FindFirstChild("PlayerStatus"):Destroy()
    end
end)

MiscChannel:Button("Unlock Events Mask (Reset Needed)", function()
    if game:GetService("Players").LocalPlayer.PlayerFolder:FindFirstChild("Settings") then
        game:GetService("Players").LocalPlayer.PlayerFolder.Settings["Oversized Spooky Sheet"].Value = true
        game:GetService("Players").LocalPlayer.PlayerFolder.Settings["2020 Vision Baby"].Value = true
        game:GetService("Players").LocalPlayer.PlayerFolder.Settings["Masked Santa Hat"].Value = true
        game:GetService("Players").LocalPlayer.PlayerFolder.Settings["Colorful 2021"].Value = true
    end
end)