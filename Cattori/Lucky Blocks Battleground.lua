local Material = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/MaterialLua/master/Module.lua"))()
local UI = Material.Load({
     Title = "Cattoware | Lucky Blocks Battleground",
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

local Main = UI.New({
    Title = "Main"
})

local SetBlock = "Block"
local rep = game:GetService("ReplicatedStorage")
local BlockEV = rep.SpawnLuckyBlock
local SBlockEV = rep.SpawnSuperBlock
local DBlockEV = rep.SpawnDiamondBlock
local RBlockEV = rep.SpawnRainbowBlock
Main.Dropdown({
    Text = "Block to Spawn:",
    Callback = function(value)
        SetBlock = value
    end,
    Options = {"Lucky Block", "Super Block", "Diamond Block", "Rainbow Block"}
})

Main.Button({
    Text = "Spawn Block",
    Callback = function()
        if SetBlock == "Lucky Block" then
            BlockEV:FireServer()
        elseif SetBlock == "Super Block" then
            SBlockEV:FireServer()
        elseif SetBlock == "Diamond Block" then
            DBlockEV:FireServer()
        elseif SetBlock == "Rainbow Block" then
            RBlockEV:FireServer()
        else
            warn("Cattoware error: Block not specified!")
        end
    end
})