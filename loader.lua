-- Plants vs Brainrots - Working Kavo UI Menu
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua'))()

local Window = Library.CreateLib("PLANTS vs BRAINROTS", "DarkTheme")

-- Переменные
local AutoBuy = false
local AutoPlant = false
local AutoCollect = false
local GodMode = false
local SpeedEnabled = false
local JumpEnabled = false
local DamageMultiplier = false
local AntiAFK = true

local MultiplierValue = 10
local WalkSpeed = 50
local JumpPower = 50

-- Функции
function BuyAllPlants()
    spawn(function()
        while AutoBuy do
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and (string.find(obj.Name:lower(), "shop") or string.find(obj.Name:lower(), "vendor")) then
                    if obj:FindFirstChild("ClickDetector") then
                        fireclickdetector(obj.ClickDetector)
                        wait(0.2)
                    end
                end
            end
            wait(2)
        end
    end)
end

function PlantAllSeeds()
    spawn(function()
        while AutoPlant do
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Part") and (string.find(obj.Name:lower(), "plot") or string.find(obj.Name:lower(), "soil")) then
                    if obj:FindFirstChild("ClickDetector") then
                        fireclickdetector(obj.ClickDetector)
                        wait(0.1)
                    end
                end
            end
            wait(1)
        end
    end)
end

function CollectAllCoins()
    spawn(function()
        while AutoCollect do
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Part") and (string.find(obj.Name:lower(), "coin") or string.find(obj.Name:lower(), "money")) then
                    if obj:FindFirstChild("ClickDetector") then
                        fireclickdetector(obj.ClickDetector)
                    end
                end
            end
            wait(0.5)
        end
    end)
end

function ApplyDamageMultiplier()
    spawn(function()
        while DamageMultiplier do
            local character = game.Players.LocalPlayer.Character
            if character then
                for _, tool in pairs(character:GetChildren()) do
                    if tool:IsA("Tool") then
                        local damage = tool:FindFirstChild("Damage")
                        if damage and damage:IsA("NumberValue") then
                            damage.Value = damage.Value * MultiplierValue
                        end
                    end
                end
            end
            wait(0.3)
        end
    end)
end

-- Табы
local MainTab = Window:NewTab("Main")
local FarmSection = MainTab:NewSection("Auto Farm")
local CombatSection = MainTab:NewSection("Combat")

local PlayerTab = Window:NewTab("Player")
local MovementSection = PlayerTab:NewSection("Movement")

local SettingsTab = Window:NewTab("Settings")
local ConfigSection = SettingsTab:NewSection("Configuration")

-- Кнопки Auto Farm
FarmSection:NewToggle("Auto Buy Plants", "Automatically buy plants", function(state)
    AutoBuy = state
    if state then
        BuyAllPlants()
    end
end)

FarmSection:NewToggle("Auto Plant Seeds", "Automatically plant seeds", function(state)
    AutoPlant = state
    if state then
        PlantAllSeeds()
    end
end)

FarmSection:NewToggle("Auto Collect Coins", "Automatically collect coins", function(state)
    AutoCollect = state
    if state then
        CollectAllCoins()
    end
end)

-- Кнопки Combat
CombatSection:NewToggle("Damage Multiplier", "Multiply weapon damage", function(state)
    DamageMultiplier = state
    if state then
        ApplyDamageMultiplier()
    end
end)

CombatSection:NewSlider("Multiplier Value", "Set damage multiplier", 100, 1, function(value)
    MultiplierValue = value
end)

CombatSection:NewToggle("God Mode", "Become invincible", function(state)
    GodMode = state
    if state then
        while GodMode do
            local character = game.Players.LocalPlayer.Character
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.MaxHealth = math.huge
                    humanoid.Health = math.huge
                end
            end
            wait(0.5)
        end
    end
end)

-- Кнопки Movement
MovementSection:NewToggle("Speed Hack", "Increase movement speed", function(state)
    SpeedEnabled = state
    if state then
        while SpeedEnabled do
            local character = game.Players.LocalPlayer.Character
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = WalkSpeed
                end
            end
            wait(0.1)
        end
    else
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.WalkSpeed = 16
        end
    end
end)

MovementSection:NewSlider("Walk Speed", "Set walk speed", 100, 16, function(value)
    WalkSpeed = value
end)

MovementSection:NewToggle("Super Jump", "Increase jump power", function(state)
    JumpEnabled = state
    if state then
        while JumpEnabled do
            local character = game.Players.LocalPlayer.Character
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.JumpPower = JumpPower
                end
            end
            wait(0.1)
        end
    else
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.JumpPower = 50
        end
    end
end)

MovementSection:NewSlider("Jump Power", "Set jump power", 200, 50, function(value)
    JumpPower = value
end)

-- Кнопки Settings
ConfigSection:NewToggle("Anti-AFK", "Prevent AFK kick", function(state)
    AntiAFK = state
end)

ConfigSection:NewKeybind("Toggle Menu", "Toggle menu visibility", Enum.KeyCode.RightControl, function()
    Library:ToggleUI()
end)

-- Анти-АФК система
spawn(function()
    while true do
        if AntiAFK then
            game:GetService("VirtualInputManager"):SendKeyEvent(true, "W", false, game)
            wait(0.1)
            game:GetService("VirtualInputManager"):SendKeyEvent(false, "W", false, game)
            wait(0.1)
            game:GetService("VirtualInputManager"):SendKeyEvent(true, "S", false, game)
            wait(0.1)
            game:GetService("VirtualInputManager"):SendKeyEvent(false, "S", false, game)
        end
        wait(30)
    end
end)

print("Plants vs Brainrots menu loaded successfully!")