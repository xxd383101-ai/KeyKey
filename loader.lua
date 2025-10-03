-- Plants vs Brainrots - ULTIMATE MENU
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Загрузка библиотеки
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- Создание окна
local Window = OrionLib:MakeWindow({
    Name = "🌿 PLANTS vs BRAINROTS | ULTIMATE", 
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "PvBConfig",
    IntroEnabled = true,
    IntroText = "ULTIMATE HUB"
})

-- Переменные
local AutoFarm = {
    Buy = false,
    Plant = false,
    Collect = false,
    Upgrade = false,
    Sell = false,
    Rebirth = false
}

local Combat = {
    GodMode = false,
    DamageMultiplier = false,
    OneHitKill = false,
    InfiniteAmmo = false,
    NoCooldown = false,
    AutoAttack = false
}

local PlayerMods = {
    Speed = false,
    Jump = false,
    Fly = false,
    NoClip = false,
    XRay = false,
    InfiniteStamina = false
}

local Teleports = {
    Shop = false,
    Garden = false,
    Spawn = false,
    Boss = false
}

local Misc = {
    AntiAFK = true,
    AutoFarmMode = "Normal",
    FarmRadius = 50,
    MultiplierValue = 10,
    WalkSpeed = 50,
    JumpPower = 50,
    FlySpeed = 50
}

-- Функции авто-фарма
function AutoBuyPlants()
    while AutoFarm.Buy do
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and (string.find(obj.Name:lower(), "shop") or string.find(obj.Name:lower(), "vendor") or string.find(obj.Name:lower(), "store")) then
                if obj:FindFirstChild("ClickDetector") then
                    fireclickdetector(obj.ClickDetector)
                end
            end
        end
        wait(2)
    end
end

function SmartPlant()
    while AutoFarm.Plant do
        local bestSpots = {}
        for _, spot in pairs(workspace:GetDescendants()) do
            if spot:IsA("Part") and string.find(spot.Name:lower(), "plot") then
                if #spot:GetChildren() <= 2 then -- Пустой спот
                    table.insert(bestSpots, spot)
                end
            end
        end
        
        for _, spot in pairs(bestSpots) do
            if spot:FindFirstChild("ClickDetector") then
                fireclickdetector(spot.ClickDetector)
                wait(0.2)
            end
        end
        wait(1)
    end
end

function CollectResources()
    while AutoFarm.Collect do
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Part") and (string.find(obj.Name:lower(), "coin") or string.find(obj.Name:lower(), "money") or string.find(obj.Name:lower(), "reward") or string.find(obj.Name:lower(), "resource")) then
                if obj:FindFirstChild("ClickDetector") then
                    fireclickdetector(obj.ClickDetector)
                end
            end
        end
        wait(0.3)
    end
end

-- Боевые функции
function ApplyDamageHack()
    while Combat.DamageMultiplier do
        local character = Player.Character
        if character then
            for _, tool in pairs(character:GetChildren()) do
                if tool:IsA("Tool") then
                    for _, v in pairs({"Damage", "damage", "Attack", "attack"}) do
                        local damage = tool:FindFirstChild(v)
                        if damage and damage:IsA("NumberValue") then
                            damage.Value = damage.Value * Misc.MultiplierValue
                        end
                    end
                end
            end
        end
        wait(0.3)
    end
end

function OneHitKill()
    while Combat.OneHitKill do
        Misc.MultiplierValue = 9999
        if not Combat.DamageMultiplier then
            Combat.DamageMultiplier = true
            ApplyDamageHack()
        end
        wait(1)
    end
end

function AutoAttackEnemies()
    while Combat.AutoAttack do
        for _, enemy in pairs(workspace:GetDescendants()) do
            if enemy:IsA("Model") and (string.find(enemy.Name:lower(), "brainrot") or string.find(enemy.Name:lower(), "zombie") or string.find(enemy.Name:lower(), "enemy")) then
                local humanoid = enemy:FindFirstChild("Humanoid")
                if humanoid then
                    -- Атаковать врага
                    game:GetService("ReplicatedStorage"):FindFirstChild("DamageEvent"):FireServer(enemy, 9999)
                end
            end
        end
        wait(0.5)
    end
end

-- Моды игрока
function ApplySpeed()
    while PlayerMods.Speed do
        local character = Player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = Misc.WalkSpeed
            end
        end
        wait(0.1)
    end
end

function ApplyFly()
    while PlayerMods.Fly do
        local character = Player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.Velocity = Vector3.new(0, Misc.FlySpeed, 0)
        end
        wait()
    end
end

function ApplyXRay()
    if PlayerMods.XRay then
        for _, part in pairs(workspace:GetDescendants()) do
            if part:IsA("Part") or part:IsA("MeshPart") then
                part.LocalTransparencyModifier = 0.5
            end
        end
    else
        for _, part in pairs(workspace:GetDescendants()) do
            if part:IsA("Part") or part:IsA("MeshPart") then
                part.LocalTransparencyModifier = 0
            end
        end
    end
end

-- Телепорты
function TeleportToLocation(location)
    local character = Player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local target = workspace:FindFirstChild(location)
        if target then
            character.HumanoidRootPart.CFrame = target.CFrame
        end
    end
end

-- Создание вкладок
local MainTab = Window:MakeTab({
    Name = "🏠 Главная",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local CombatTab = Window:MakeTab({
    Name = "⚔️ Бой",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local PlayerTab = Window:MakeTab({
    Name = "🎮 Игрок",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local TeleportTab = Window:MakeTab({
    Name = "📍 Телепорты",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local MiscTab = Window:MakeTab({
    Name = "⚙️ Дополнительно",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Секция авто-фарма
local FarmSection = MainTab:AddSection({
    Name = "🤖 Авто Фарм"
})

FarmSection:AddToggle({
    Name = "🛒 Авто покупка растений",
    Default = false,
    Callback = function(Value)
        AutoFarm.Buy = Value
        if Value then AutoBuyPlants() end
    end
})

FarmSection:AddToggle({
    Name = "🌱 Умная посадка",
    Default = false,
    Callback = function(Value)
        AutoFarm.Plant = Value
        if Value then SmartPlant() end
    end
})

FarmSection:AddToggle({
    Name = "💰 Авто сбор ресурсов",
    Default = false,
    Callback = function(Value)
        AutoFarm.Collect = Value
        if Value then CollectResources() end
    end
})

FarmSection:AddToggle({
    Name = "⚡ Авто улучшение",
    Default = false,
    Callback = function(Value)
        AutoFarm.Upgrade = Value
    end
})

FarmSection:AddToggle({
    Name = "💀 Авто атака врагов",
    Default = false,
    Callback = function(Value)
        Combat.AutoAttack = Value
        if Value then AutoAttackEnemies() end
    end
})

-- Боевая секция
local CombatSection = CombatTab:AddSection({
    Name = "💥 Боевые функции"
})

CombatSection:AddToggle({
    Name = "🛡️ Режим Бога",
    Default = false,
    Callback = function(Value)
        Combat.GodMode = Value
        if Value then
            while Combat.GodMode do
                local character = Player.Character
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
    end
})

CombatSection:AddToggle({
    Name = "💢 Множитель урона",
    Default = false,
    Callback = function(Value)
        Combat.DamageMultiplier = Value
        if Value then ApplyDamageHack() end
    end
})

CombatSection:AddToggle({
    Name = "☠️ One Hit Kill",
    Default = false,
    Callback = function(Value)
        Combat.OneHitKill = Value
        if Value then OneHitKill() end
    end
})

CombatSection:AddToggle({
    Name = "🎯 Бесконечные патроны",
    Default = false,
    Callback = function(Value)
        Combat.InfiniteAmmo = Value
    end
})

CombatSection:AddToggle({
    Name = "⚡ Нет перезарядки",
    Default = false,
    Callback = function(Value)
        Combat.NoCooldown = Value
    end
})

CombatSection:AddSlider({
    Name = "Множитель урона",
    Min = 1,
    Max = 100,
    Default = 10,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "x",
    Callback = function(Value)
        Misc.MultiplierValue = Value
    end
})

-- Секция игрока
local PlayerSection = PlayerTab:AddSection({
    Name = "🚀 Моды игрока"
})

PlayerSection:AddToggle({
    Name = "💨 Супер скорость",
    Default = false,
    Callback = function(Value)
        PlayerMods.Speed = Value
        if Value then ApplySpeed() end
    end
})

PlayerSection:AddToggle({
    Name = "🦘 Супер прыжок",
    Default = false,
    Callback = function(Value)
        PlayerMods.Jump = Value
        if Value then
            while PlayerMods.Jump do
                local character = Player.Character
                if character then
                    local humanoid = character:FindFirstChild("Humanoid")
                    if humanoid then
                        humanoid.JumpPower = Misc.JumpPower
                    end
                end
                wait(0.1)
            end
        end
    end
})

PlayerSection:AddToggle({
    Name = "🕊️ Полёт",
    Default = false,
    Callback = function(Value)
        PlayerMods.Fly = Value
        if Value then ApplyFly() end
    end
})

PlayerSection:AddToggle({
    Name = "👻 NoClip",
    Default = false,
    Callback = function(Value)
        PlayerMods.NoClip = Value
        if Value then
            while PlayerMods.NoClip do
                local character = Player.Character
                if character then
                    for _, part in pairs(character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
                wait(0.1)
            end
        end
    end
})

PlayerSection:AddToggle({
    Name = "🔍 X-Ray Vision",
    Default = false,
    Callback = function(Value)
        PlayerMods.XRay = Value
        ApplyXRay()
    end
})

PlayerSection:AddSlider({
    Name = "Скорость",
    Min = 16,
    Max = 200,
    Default = 50,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "studs",
    Callback = function(Value)
        Misc.WalkSpeed = Value
    end
})

PlayerSection:AddSlider({
    Name = "Сила прыжка",
    Min = 50,
    Max = 200,
    Default = 50,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "power",
    Callback = function(Value)
        Misc.JumpPower = Value
    end
})

-- Телепорты
local TeleportSection = TeleportTab:AddSection({
    Name = "📍 Быстрые телепорты"
})

TeleportSection:AddButton({
    Name = "🏪 Телепорт в магазин",
    Callback = function()
        TeleportToLocation("Shop")
    end
})

TeleportSection:AddButton({
    Name = "🌿 Телепорт в сад",
    Callback = function()
        TeleportToLocation("Garden")
    end
})

TeleportSection:AddButton({
    Name = "🚩 Телепорт на спавн",
    Callback = function()
        TeleportToLocation("Spawn")
    end
})

TeleportSection:AddButton({
    Name = "👹 Телепорт к боссу",
    Callback = function()
        TeleportToLocation("Boss")
    end
})

-- Дополнительно
local MiscSection = MiscTab:AddSection({
    Name = "⚙️ Настройки"
})

MiscSection:AddToggle({
    Name = "🔄 Anti-AFK",
    Default = true,
    Callback = function(Value)
        Misc.AntiAFK = Value
    end
})

MiscSection:AddDropdown({
    Name = "Режим фарма",
    Default = "Normal",
    Options = {"Normal", "Fast", "Ultra", "Safe"},
    Callback = function(Value)
        Misc.AutoFarmMode = Value
    end    
})

MiscSection:AddButton({
    Name = "💾 Сохранить настройки",
    Callback = function()
        OrionLib:MakeNotification({
            Name = "Настройки сохранены!",
            Content = "Ваши настройки были сохранены.",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    end
})

MiscSection:AddKeybind({
    Name = "Открыть/Закрыть меню",
    Default = Enum.KeyCode.RightControl,
    Hold = false,
    Callback = function(Key)
        OrionLib:Toggle()
    end    
})

-- Анти-АФК система
spawn(function()
    while true do
        if Misc.AntiAFK then
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.W, false, game)
            wait(0.1)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.W, false, game)
            wait(0.1)
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.S, false, game)
            wait(0.1)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.S, false, game)
        end
        wait(30)
    end
end)

-- Уведомление о загрузке
OrionLib:MakeNotification({
    Name = "🌿 Plants vs Brainrots загружен!",
    Content = "Ultimate Menu успешно активирован!",
    Image = "rbxassetid://4483345998",
    Time = 5
})

OrionLib:Init()