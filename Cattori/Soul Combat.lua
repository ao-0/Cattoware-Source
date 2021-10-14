if type(_G.running) == "function" then _G.running() end 
local running = true
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Soul Combat", "Midnight")

local GuiInset = game:GetService("GuiService"):GetGuiInset()
local players = game:GetService("Players")
local plr = players.LocalPlayer
local mouse = plr:GetMouse()
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

local CombatTab = Window:NewTab("Combat")
local AimbotSection = CombatTab:NewSection("Aimbot")

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

AimbotSection:NewToggle("Aimbot", "ToggleInfo", function(state)
    _G._aimbot = state
end)

AimbotSection:NewToggle("Team Check", "ToggleInfo", function(state)
    TeamCheck = state
end)

AimbotSection:NewToggle("RightMouse", "ToggleInfo", function(state)
    RightClickAim = state
end)

AimbotSection:NewTextBox("Aimbot Keybind", "TextboxInfo", function(value)
	settings.keybind2 = Enum.KeyCode[value]
end)

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

local VisualsTab = Window:NewTab("Visuals")
local FovESPSection = VisualsTab:NewSection("FOV")
local ESPSettingsSection = VisualsTab:NewSection("ESP Settings")

local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/VaultGitos/Alantic-LUA/main/KiriotESP.lua"))()

ESP.Color = Color3.fromRGB(255, 105, 180)
ESP:Toggle(true)

FovESPSection:NewToggle("Display FOV", "drawing fov", function(State)
    ESP.FOV = State
    fov.component.Visible = State
end)

FovESPSection:NewSlider("FOV Size", "SliderInfo", 600, 100, function(num)
    fov.size = num
end)

local UtilitiesTab = Window:NewTab("Utilities")
local GameHookSection = UtilitiesTab:NewSection("Game Hooks")

GameHookSection:NewButton("No Cooldown (One Click Only)", "click one time or crash", function(state)
    Timer = hookfunction(wait, function(time)
        if time then
            return Timer()
        end
        return Timer(time)
    end)
end)

local parryDist = 16
local blacklist = {}

local plr = game.Players.LocalPlayer
local char = plr.Character
local runService = game:GetService("RunService")

local animIds = {
    "rbxassetid://4954402742";
    "rbxassetid://5473095387";
    "rbxassetid://5410438730";
    "rbxassetid://5132198409";
    "rbxassetid://4849805743";
    "rbxassetid://5361737327";
    "rbxassetid://5473153602";
    "rbxassetid://5410442864";
    "rbxassetid://5136821962";
    "rbxassetid://5136825583";
    "rbxassetid://4849807647";
    "rbxassetid://5023831120";
    "rbxassetid://5473158797";
    "rbxassetid://5410447413";
    "rbxassetid://5410456825";
    "rbxassetid://5410450360";
    "rbxassetid://5170603347";
    "rbxassetid://4949308594";
    "rbxassetid://4963325686";
    "rbxassetid://4849814895";
    "rbxassetid://4963086267";
    "rbxassetid://4963325686";
    "rbxassetid://5621007381";
    "rbxassetid://5473126423";
    "rbxassetid://5410458959";
    "rbxassetid://5188568302";
    "rbxassetid://5260651272";
    "rbxassetid://5191829892";
    "rbxassetid://4850248643";
    "rbxassetid://5061020874";
    "rbxassetid://5644202528";
    "rbxassetid://5062667695";
    "rbxassetid://5062469717";
    "rbxassetid://5473176073";
    "rbxassetid://4895510553";
    "rbxassetid://5510357683";
    "rbxassetid://5510434618";
    "rbxassetid://5510302528";
    "rbxassetid://5199227984";
    "rbxassetid://5402130168";
    "rbxassetid://5401418213";
    "rbxassetid://5401430749";
}

function getParryEvent()
    return game:GetService("ReplicatedStorage").Parry
end

function parry()
    local myParryEvent = getParryEvent()
    if myParryEvent then
        myParryEvent:FireServer()
    end
end

GameHookSection:NewSlider("Parry Distance", "SliderInfo", 14, 22, function(num)
    parryDist = num
end)
local autoparry = false
GameHookSection:NewToggle("Auto Parry", "Auto Parry!!!!!!!", function(state)
    autoparry = state
end)

GameHookSection:NewTextBox("Blacklist Player", "ok", function(Value)
	if game.Players:FindFirstChild(Value) then
        table.insert(blacklist, tostring(Value))
    else
        print("didn't fouund")
    end
end)

GameHookSection:NewTextBox("Remove Blacklist Player", "no", function(Value)
	if game.Players:FindFirstChild(Value) then
        table.remove(blacklist, tostring(Value))
    else
        print("didn't fouund")
    end
end)

local MiscTab = Window:NewTab("Misc")
local WeaponsSection = MiscTab:NewSection("Weapons")

local rainbowsweapons = false

WeaponsSection:NewToggle("Rainbows Weapons", "rainbow but i guess some buggyyyyyyyy :(", function(state)
    rainbowweapons = state
end)

spawn(function()
    local renderStepped = game:GetService("RunService").RenderStepped
    fov.component.Thickness = 3
    fov.component.NumSides = 15
    fov.component.Color = Color3.fromRGB(255, 105, 180)
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

        if autoparry then
            char = plr.Character
            runService.RenderStepped:Wait()
            for i, plrChar in next, game.Players:GetPlayers() do
                if plrChar ~= char and not table.find(blacklist, plrChar.Character.Name) then
                    local anims = plrChar.Character.Humanoid:GetPlayingAnimationTracks()
                    for _, anim in next, anims do
                        if table.find(animIds, anim.Animation.AnimationId) then
                            if (plrChar.Character:FindFirstChild("HumanoidRootPart").Position - char:FindFirstChild("HumanoidRootPart").Position).Magnitude <= parryDist and plrChar.Character.Humanoid.Health > 0 and not plrChar.Character.Humanoid.PlatformStand then
                                parry()
                                wait(1) --Prevents mass event firing
                            end
                        end
                    end
                end
            end
        end

        if rainbowweapons then
               if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Handle") then
                   for i,v in pairs(game:GetService("Players").LocalPlayer.Character.Handle:GetChildren()) do
                       if v:IsA("MeshPart") or v:IsA("Part") or v:IsA("UnionOperation") then
                           v.Color = Color3.fromHSV(tick()%5/5,1,1)
                           v.Material = Enum.Material.Neon
                       end
                   end
               end
       else
           if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Handle") then
               for i,v in pairs(game:GetService("Players").LocalPlayer.Character.Handle:GetChildren()) do
                   if v:IsA("MeshPart") or v:IsA("Part") or v:IsA("UnionOperation") then
                       v.Color = Color3.fromRGB(50, 50, 50)
                       v.Material = Enum.Material.SmoothPlastic
                   end
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