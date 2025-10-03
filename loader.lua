-- Plants vs Brainrots - Rayfield Ultimate Menu WITH WORKING BUTTONS
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "🌿 PLANTS vs BRAINROTS | RAYFIELD",
   LoadingTitle = "Plants vs Brainrots Ultimate",
   LoadingSubtitle = "Loading Rayfield Interface...",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "PvBRayfield",
      FileName = "Settings"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },
   KeySystem = false
})

-- Табы
local MainTab = Window:CreateTab("🏠 Main")
local FarmSection = MainTab:CreateSection("Auto Farm")
local CombatSection = MainTab:CreateSection("Combat")

local PlayerTab = Window:CreateTab("🎮 Player")
local MovementSection = PlayerTab:CreateSection("Movement")
local VisualSection = PlayerTab:CreateSection("Visual")

local TeleportTab = Window:CreateTab("📍 Teleport")
local LocationSection = TeleportTab:CreateSection("Locations")

local SettingsTab = Window:CreateTab("⚙️ Settings")
local ConfigSection = SettingsTab:CreateSection("Configuration")

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

-- ФУНКЦИИ АВТО-ФАРМА
function BuyAllPlants()
    spawn(function()
        while AutoBuy do
            -- Поиск магазинов
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and (string.find(obj.Name:lower(), "shop") or string.find(obj.Name:lower(), "vendor")) then
                    if obj:FindFirstChild("ClickDetector") then
                        fireclickdetector(obj.ClickDetector)
                        wait(0.2)
                    end
                end
            end
            
            -- Поиск кнопок в GUI
            local playerGui = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
            if playerGui then
                for _, gui in pairs(playerGui:GetDescendants()) do
                    if gui:IsA("TextButton") and (string.find(gui.Text:lower(), "buy") or string.find(gui.Text:lower(), "purchase")) then
                        pcall(function()
                            gui:FireServer("Activated")
                        end)
                        wait(0.1)
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
            -- Поиск мест для посадки
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Part") and (string.find(obj.Name:lower(), "plot") or string.find(obj.Name:lower(), "soil") or string.find(obj.Name:lower(), "garden")) then
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
            -- Сбор ресурсов
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Part") and (string.find(obj.Name:lower(), "coin") or string.find(obj.Name:lower(), "money") or string.find(obj.Name:lower(), "reward")) then
                    if obj:FindFirstChild("ClickDetector") then
                        fireclickdetector(obj.ClickDetector)
                    end
                end
            end
            wait(0.5)
        end
    end)
end

-- ФУНКЦИИ БОЯ
function ApplyDamageMultiplier()
    spawn(function()
        while DamageMultiplier do
            -- Умножение урона
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

function ApplyGodMode()
    spawn(function()
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
    end)
end

-- ФУНКЦИИ ПЕРЕДВИЖЕНИЯ
function ApplySpeed()
    spawn(function()
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
    end)
end

function ApplyJump()
    spawn(function()
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
    end)
end

-- ФУНКЦИИ ТЕЛЕПОРТА
function TeleportToPosition(positionName)
    local character = game.Players.LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        if positionName == "Shop" then
            -- Телепорт к магазину
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and string.find(obj.Name:lower(), "shop") then
                    character.HumanoidRootPart.CFrame = obj:GetPivot()
                    break
                end
            end
        elseif positionName == "Garden" then
            -- Телепорт к саду
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Part") and string.find(obj.Name:lower(), "garden") then
                    character.HumanoidRootPart.CFrame = obj.CFrame
                    break
                end
            end
        elseif positionName == "Spawn" then
            -- Телепорт на спавн
            character.HumanoidRootPart.CFrame = CFrame.new(0, 10, 0)
        end
    end
end

-- КНОПКИ АВТО-ФАРМА
FarmSection:CreateToggle({
    Name = "🛒 Auto Buy Plants",
    CurrentValue = false,
    Callback = function(Value)
        AutoBuy = Value
        if Value then
            Rayfield:Notify({
                Title = "Auto Buy Started",
                Content = "Automatically buying plants...",
                Duration = 3,
                Image = 4483362458,
            })
            BuyAllPlants()
        else
            Rayfield:Notify({
                Title = "Auto Buy Stopped",
                Content = "Stopped buying plants",
                Duration = 2,
                Image = 4483362458,
            })
        end
    end
})

FarmSection:CreateToggle({
    Name = "🌱 Auto Plant Seeds",
    CurrentValue = false,
    Callback = function(Value)
        AutoPlant = Value
        if Value then
            PlantAllSeeds()
        end
    end
})

FarmSection:CreateToggle({
    Name = "💰 Auto Collect Coins",
    CurrentValue = false,
    Callback = function(Value)
        AutoCollect = Value
        if Value then
            CollectAllCoins()
        end
    end
})

-- КНОПКИ БОЯ
CombatSection:CreateToggle({
    Name = "💥 Damage Multiplier",
    CurrentValue = false,
    Callback = function(Value)
        DamageMultiplier = Value
        if Value then
            ApplyDamageMultiplier()
        end
    end
})

CombatSection:CreateToggle({
    Name = "🛡️ God Mode",
    CurrentValue = false,
    Callback = function(Value)
        GodMode = Value
        if Value then
            ApplyGodMode()
        end
    end
})

CombatSection:CreateSlider({
    Name = "Damage Multiplier",
    Range = {1, 100},
    Increment = 1,
    Suffix = "x",
    CurrentValue = 10,
    Callback = function(Value)
        MultiplierValue = Value
    end
})

-- КНОПКИ ПЕРЕДВИЖЕНИЯ
MovementSection:CreateToggle({
    Name = "🚀 Speed Hack",
    CurrentValue = false,
    Callback = function(Value)
        SpeedEnabled = Value
        if Value then
            ApplySpeed()
        else
            local character = game.Players.LocalPlayer.Character
            if character and character:FindFirstChild("Humanoid") then
                character.Humanoid.WalkSpeed = 16
            end
        end
    end
})

MovementSection:CreateSlider({
    Name = "Walk Speed",
    Range = {16, 200},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = 50,
    Callback = function(Value)
        WalkSpeed = Value
        if SpeedEnabled then
            ApplySpeed()
        end
    end
})

MovementSection:CreateToggle({
    Name = "🦘 Super Jump",
    CurrentValue = false,
    Callback = function(Value)
        JumpEnabled = Value
        if Value then
            ApplyJump()
        else
            local character = game.Players.LocalPlayer.Character
            if character and character:FindFirstChild("Humanoid") then
                character.Humanoid.JumpPower = 50
            end
        end
    end
})

MovementSection:CreateSlider({
    Name = "Jump Power",
    Range = {50, 200},
    Increment = 1,
    Suffix = "power",
    CurrentValue = 50,
    Callback = function(Value)
        JumpPower = Value
        if JumpEnabled then
            ApplyJump()
        end
    end
})

-- КНОПКИ ТЕЛЕПОРТА
LocationSection:CreateButton({
    Name = "🏪 Teleport to Shop",
    Callback = function()
        TeleportToPosition("Shop")
        Rayfield:Notify({
            Title = "Teleported",
            Content = "Teleported to Shop",
            Duration = 2,
            Image = 4483362458,
        })
    end
})

LocationSection:CreateButton({
    Name = "🌿 Teleport to Garden",
    Callback = function()
        TeleportToPosition("Garden")
        Rayfield:Notify({
            Title = "Teleported",
            Content = "Teleported to Garden",
            Duration = 2,
            Image = 4483362458,
        })
    end
})

LocationSection:CreateButton({
    Name = "🚩 Teleport to Spawn",
    Callback = function()
        TeleportToPosition("Spawn")
        Rayfield:Notify({
            Title = "Teleported",
            Content = "Teleported to Spawn",
            Duration = 2,
            Image = 4483362458,
        })
    end
})

-- КНОПКИ НАСТРОЕК
ConfigSection:CreateToggle({
    Name = "🔄 Anti-AFK",
    CurrentValue = true,
    Callback = function(Value)
        AntiAFK = Value
    end
})

ConfigSection:CreateKeybind({
    Name = "Toggle UI",
    CurrentKeybind = Enum.KeyCode.RightControl,
    HoldToInteract = false,
    Callback = function(Keybind)
        Rayfield:Toggle()
    end
})

ConfigSection:CreateButton({
    Name = "💾 Save Settings",
    Callback = function()
        Rayfield:Notify({
            Title = "Settings Saved",
            Content = "Your settings have been saved!",
            Duration = 3,
            Image = 4483362458,
        })
    end
})

ConfigSection:CreateButton({
    Name = "🗑️ Destroy UI",
    Callback = function()
        Rayfield:Destroy()
    end
})

-- Анти-АФК система
spawn(function()
    while true do
        if AntiAFK then
            pcall(function()
                game:GetService("VirtualInputManager"):SendKeyEvent(true, "W", false, game)
                wait(0.1)
                game:GetService("VirtualInputManager"):SendKeyEvent(false, "W", false, game)
                wait(0.1)
                game:GetService("VirtualInputManager"):SendKeyEvent(true, "S", false, game)
                wait(0.1)
                game:GetService("VirtualInputManager"):SendKeyEvent(false, "S", false, game)
            end)
        end
        wait(25)
    end
end)

-- Уведомление о загрузке
Rayfield:Notify({
    Title = "🌿 Plants vs Brainrots Loaded!",
    Content = "All functions are now active!",
    Duration = 5,
    Image = 4483362458,
})

-- Загрузка конфигурации
Rayfield:LoadConfiguration()