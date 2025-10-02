-- Plants vs Brainrots AFK Farm Script
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- GUI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Plants vs Brainrots AFK Farm", "DarkTheme")

-- Variables
local AutoBuyEnabled = false
local AntiAFKEnabled = true
local MultiplierEnabled = false
local CurrentMultiplier = 1
local AutoPlantEnabled = false

-- Main Tab
local MainTab = Window:NewTab("Main")
local MainSection = MainTab:NewSection("Auto Farm Features")

MainSection:NewToggle("Auto Buy All Plants", "Automatically buys all plants in stock", function(state)
    AutoBuyEnabled = state
    if state then
        spawn(function()
            while AutoBuyEnabled do
                AutoBuyPlants()
                wait(5)
            end
        end)
    end
end)

MainSection:NewToggle("Anti AFK", "Prevents you from being kicked for AFK", function(state)
    AntiAFKEnabled = state
end)

MainSection:NewToggle("Club Multiplier", "Multiplies your club damage", function(state)
    MultiplierEnabled = state
    if state then
        EnableClubMultiplier()
    end
end)

MainSection:NewSlider("Multiplier Value", "Set club multiplier value", 100, 1, function(value)
    CurrentMultiplier = value
end)

MainSection:NewToggle("Auto Plant", "Automatically plants in empty spots", function(state)
    AutoPlantEnabled = state
    if state then
        spawn(function()
            while AutoPlantEnabled do
                AutoPlant()
                wait(3)
            end
        end)
    end
end)

-- Stats Tab
local StatsTab = Window:NewTab("Stats")
local StatsSection = StatsTab:NewSection("Player Statistics")

StatsSection:NewButton("Refresh Stats", "Update player statistics", function()
    UpdateStats()
end)

-- Misc Tab
local MiscTab = Window:NewTab("Misc")
local MiscSection = MiscTab:NewSection("Additional Features")

MiscSection:NewButton("Collect All Coins", "Collect all coins on the map", function()
    CollectCoins()
end)

MiscSection:NewButton("Upgrade All Plants", "Upgrade all planted plants", function()
    UpgradeAllPlants()
end)

MiscSection:NewKeybind("Toggle Menu", "Toggle the menu visibility", Enum.KeyCode.RightControl, function()
	Library:ToggleUI()
end)

-- Auto Buy Function
function AutoBuyPlants()
    if not AutoBuyEnabled then return end
    
    -- Look for plant shops or vending machines
    local shops = workspace:FindFirstChild("Shops") or workspace:FindFirstChild("VendingMachines")
    if shops then
        for _, shop in pairs(shops:GetChildren()) do
            if shop:FindFirstChild("ClickDetector") then
                fireclickdetector(shop.ClickDetector)
                wait(0.5)
            end
        end
    end
    
    -- Alternative method: look for buy buttons in GUI
    local playerGui = Player:FindFirstChild("PlayerGui")
    if playerGui then
        for _, gui in pairs(playerGui:GetDescendants()) do
            if gui:IsA("TextButton") and (string.find(string.lower(gui.Text), "buy") or string.find(string.lower(gui.Text), "purchase")) then
                gui:FireServer("Activated")
                wait(0.2)
            end
        end
    end
end

-- Club Multiplier Function
function EnableClubMultiplier()
    spawn(function()
        while MultiplierEnabled do
            -- Method 1: Modify local damage values
            local character = Player.Character
            if character then
                local tool = character:FindFirstChildOfClass("Tool")
                if tool and tool:FindFirstChild("Damage") then
                    tool.Damage.Value = tool.Damage.Value * CurrentMultiplier
                end
            end
            
            -- Method 2: Use remote events for damage multiplication
            local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
            if remotes then
                for _, remote in pairs(remotes:GetDescendants()) do
                    if remote:IsA("RemoteEvent") and (string.find(string.lower(remote.Name), "damage") or string.find(string.lower(remote.Name), "hit")) then
                        -- Intercept damage calls
                        local oldFireServer = remote.FireServer
                        remote.FireServer = function(self, ...)
                            local args = {...}
                            if type(args[1]) == "number" then
                                args[1] = args[1] * CurrentMultiplier
                            end
                            return oldFireServer(self, unpack(args))
                        end
                    end
                end
            end
            wait(1)
        end
    end)
end

-- Auto Plant Function
function AutoPlant()
    if not AutoPlantEnabled then return end
    
    -- Look for empty planting spots
    local garden = workspace:FindFirstChild("Garden") or workspace:FindFirstChild("PlantingSpots")
    if garden then
        for _, spot in pairs(garden:GetChildren()) do
            if spot:FindFirstChild("ClickDetector") and #spot:GetChildren() <= 2 then -- Assuming empty spot has few children
                fireclickdetector(spot.ClickDetector)
                wait(0.3)
            end
        end
    end
end

-- Collect Coins Function
function CollectCoins()
    local coins = workspace:FindFirstChild("Coins") or workspace:FindFirstChild("Currency")
    if coins then
        for _, coin in pairs(coins:GetDescendants()) do
            if coin:IsA("Part") and coin:FindFirstChild("ClickDetector") then
                fireclickdetector(coin.ClickDetector)
            end
        end
    end
end

-- Upgrade All Plants Function
function UpgradeAllPlants()
    local playerGui = Player.PlayerGui
    if playerGui then
        for _, gui in pairs(playerGui:GetDescendants()) do
            if gui:IsA("TextButton") and (string.find(string.lower(gui.Text), "upgrade") or string.find(string.lower(gui.Text), "level")) then
                gui:FireServer("Activated")
                wait(0.2)
            end
        end
    end
end

-- Update Stats Function
function UpdateStats()
    -- This would need to be customized based on the game's stat system
    print("Stats refreshed - Customize this function based on game structure")
end

-- Anti AFK System
spawn(function()
    while true do
        if AntiAFKEnabled then
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.W, false, game)
            wait(0.1)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.W, false, game)
            wait(0.1)
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.S, false, game)
            wait(0.1)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.S, false, game)
        end
        wait(30) -- Move every 30 seconds
    end
end)

-- Auto Reconnect if Disconnected
game:GetService("Players").PlayerRemoving:Connect(function(player)
    if player == Player then
        -- Attempt to rejoin
        game:GetService("TeleportService"):Teleport(game.PlaceId, Player)
    end
end)

-- Initialization
print("by cheat t.me/TurboHackMods Plants vs Brainrots AFK Farm loaded!")
print("Features: Auto Buy Plants, Anti AFK, Club Multiplier, Auto Plant, and more!")