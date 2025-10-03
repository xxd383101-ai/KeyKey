-- Plants vs Brainrots - Rayfield Ultimate Menu
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
   KeySystem = false,
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"Hello"}
   }
})

-- Табы
local MainTab = Window:CreateTab("🏠 Main", 4483362458)
local FarmSection = MainTab:CreateSection("Auto Farm")
local CombatSection = MainTab:CreateSection("Combat")

local PlayerTab = Window:CreateTab("🎮 Player", 4483362458)
local MovementSection = PlayerTab:CreateSection("Movement")
local VisualSection = PlayerTab:CreateSection("Visual")

local TeleportTab = Window:CreateTab("📍 Teleport", 4483362458)
local LocationSection = TeleportTab:CreateSection("Locations")
local AutoSection = TeleportTab:CreateSection("Auto Teleport")

local SettingsTab = Window:CreateTab("⚙️ Settings", 4483362458)
local ConfigSection = SettingsTab:CreateSection("Configuration")
local UISection = SettingsTab:CreateSection("UI Settings")

-- Переменные
local AutoBuy = false
local AutoPlant = false
local AutoCollect = false
local AutoUpgrade = false
local AutoAttack = false
local GodMode = false
local SpeedEnabled = false
local JumpEnabled = false
local FlyEnabled = false
local NoClipEnabled = false
local XRayEnabled = false
local DamageMultiplier = false
local OneHitKill = false
local InfiniteAmmo = false
local AntiAFK = true
local AutoFarmMode = "Normal"

local MultiplierValue = 10
local WalkSpeed = 50
local JumpPower = 50
local FlySpeed = 50

-- Функции Auto Farm
function BuyAllPlants()
    while AutoBuy do
        -- Умный поиск магазинов
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and (string.find(obj.Name:lower(), "shop") or string.find(obj.Name:lower(), "vendor") or string.find(obj.Name:lower(), "store")) then
                if obj:FindFirstChild("ClickDetector") then
                    fireclickdetector(obj.ClickDetector)
                    wait(0.2)
                end
            end
        end
        
        -- Поиск в GUI
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
end

function SmartPlant()
    while AutoPlant do
        -- Поиск лучших мест для посадки
        local emptyPlots = {}
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Part") and (string.find(obj.Name:lower(), "plot") or string.find(obj.Name:lower(), "soil") or string.find(obj.Name:lower(), "garden")) then
                if #obj:GetChildren() <= 2 then -- Пустой спот
                    table.insert(emptyPlots, obj)
                end
            end
        end
        
        for _, plot in pairs(emptyPlots) do
            if plot:FindFirstChild("ClickDetector") then
                fireclickdetector(plot.ClickDetector)
                wait(0.1)
            end
        end
        wait(1)
    end
end

function CollectAllResources()
    while AutoCollect do
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

function AutoAttackEnemies()
    while AutoAttack do
        for _, enemy in pairs(workspace:GetDescendants()) do
            if enemy:IsA("Model") and (string.find(enemy.Name:lower(), "brainrot") or string.find(enemy.Name:lower(), "zombie") or string.find(enemy.Name:lower(), "enemy")) then
                local humanoid = enemy:FindFirstChild("Humanoid")
                if humanoid then
                    -- Атака врага
                    local args = {enemy, 9999}
                    pcall(function()
                        game:GetService("ReplicatedStorage"):FindFirstChild("DamageEvent"):FireServer(unpack(args))
                    end)
                end
            end
        end
        wait(0.5)
    end
end

-- Combat Functions
function ApplyDamageMultiplier()
    while DamageMultiplier do
        local character = game.Players.LocalPlayer.Character
        if character then
            for _, tool in pairs(character:GetChildren()) do
                if tool:IsA("Tool") then
                    for _, damageName in pairs({"Damage", "damage", "Attack", "attack"}) do
                        local damage = tool:FindFirstChild(damageName)
                        if damage and damage:IsA("NumberValue") then
                            damage.Value = damage.Value * MultiplierValue
                        end
                    end
                end
            end
        end
        wait(0.3)
    end
end

function ApplyOneHitKill()
    while OneHitKill do
        MultiplierValue = 9999
        if not DamageMultiplier then
            DamageMultiplier = true
            ApplyDamageMultiplier()
        end
        wait(1)
    end
end

-- Player Mods
function ApplySpeed()
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
end

function ApplyJump()
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
end

function ApplyFly()
    while FlyEnabled do
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.Velocity = Vector3.new(0, FlySpeed, 0)
        end
        wait()
    end
end

function ApplyNoClip()
    while NoClipEnabled do
        local character = game.Players.LocalPlayer.Character
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

function ApplyXRay()
    if XRayEnabled then
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

-- Teleport Functions
function TeleportToPosition(positionName)
    local locations = {
        Shop = CFrame.new(50, 10, 50),
        Garden = CFrame.new(0, 10, 0),
        Spawn = CFrame.new(0, 5, 0),
        Boss = CFrame.new(100, 10, 100)
    }
    
    local character = game.Players.LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = locations[positionName] or CFrame.new(0, 10, 0)
    end
end

-- Auto Farm Section
FarmSection:CreateToggle({
    Name = "🛒 Auto Buy Plants",
    CurrentValue = false,
    Flag = "AutoBuyToggle",
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
        end
    end
})

FarmSection:CreateToggle({
    Name = "🌱 Smart Auto Plant",
    CurrentValue = false,
    Flag = "AutoPlantToggle",
    Callback = function(Value)
        AutoPlant = Value
        if Value then
            SmartPlant()
        end
    end
})

FarmSection:CreateToggle({
    Name = "💰 Auto Collect Resources",
    CurrentValue = false,
    Flag = "AutoCollectToggle",
    Callback = function(Value)
        AutoCollect = Value
        if Value then
            CollectAllResources()
        end
    end
})

FarmSection:CreateToggle({
    Name = "⚡ Auto Upgrade Plants",
    CurrentValue = false,
    Flag = "AutoUpgradeToggle",
    Callback = function(Value)
        AutoUpgrade = Value
    end
})

FarmSection:CreateToggle({
    Name = "💀 Auto Attack Enemies",
    CurrentValue = false,
    Flag = "AutoAttackToggle",
    Callback = function(Value)
        AutoAttack = Value
        if Value then
            AutoAttackEnemies()
        end
    end
})

-- Combat Section
CombatSection:CreateToggle({
    Name = "🛡️ God Mode",
    CurrentValue = false,
    Flag = "GodModeToggle",
    Callback = function(Value)
        GodMode = Value
        if Value then
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
    end
})

CombatSection:CreateToggle({
    Name = "💥 Damage Multiplier",
    CurrentValue = false,
    Flag = "DamageMultiplierToggle",
    Callback = function(Value)
        DamageMultiplier = Value
        if Value then
            ApplyDamageMultiplier()
        end
    end
})

CombatSection:CreateToggle({
    Name = "☠️ One Hit Kill",
    CurrentValue = false,
    Flag = "OneHitKillToggle",
    Callback = function(Value)
        OneHitKill = Value
        if Value then
            ApplyOneHitKill()
        end
    end
})

CombatSection:CreateToggle({
    Name = "🎯 Infinite Ammo",
    CurrentValue = false,
    Flag = "InfiniteAmmoToggle",
    Callback = function(Value)
        InfiniteAmmo = Value
    end
})

CombatSection:CreateSlider({
    Name = "Damage Multiplier",
    Range = {1, 100},
    Increment = 1,
    Suffix = "x",
    CurrentValue = 10,
    Flag = "MultiplierSlider",
    Callback = function(Value)
        MultiplierValue = Value
    end
})

-- Movement Section
MovementSection:CreateToggle({
    Name = "🚀 Speed Hack",
    CurrentValue = false,
    Flag = "SpeedToggle",
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
    Flag = "SpeedSlider",
    Callback = function(Value)
        WalkSpeed = Value
    end
})

MovementSection:CreateToggle({
    Name = "🦘 Super Jump",
    CurrentValue = false,
    Flag = "JumpToggle",
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
    Flag = "JumpSlider",
    Callback = function(Value)
        JumpPower = Value
    end
})

MovementSection:CreateToggle({
    Name = "🕊️ Fly Mode",
    CurrentValue = false,
    Flag = "FlyToggle",
    Callback = function(Value)
        FlyEnabled = Value
        if Value then
            ApplyFly()
        end
    end
})

MovementSection:CreateToggle({
    Name = "👻 NoClip",
    CurrentValue = false,
    Flag = "NoClipToggle",
    Callback = function(Value)
        NoClipEnabled = Value
        if Value then
            ApplyNoClip()
        end
    end
})

-- Visual Section
VisualSection:CreateToggle({
    Name = "🔍 X-Ray Vision",
    CurrentValue = false,
    Flag = "XRayToggle",
    Callback = function(Value)
        XRayEnabled = Value
        ApplyXRay()
    end
})

-- Teleport Section
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

LocationSection:CreateButton({
    Name = "👹 Teleport to Boss",
    Callback = function()
        TeleportToPosition("Boss")
        Rayfield:Notify({
            Title = "Teleported",
            Content = "Teleported to Boss",
            Duration = 2,
            Image = 4483362458,
        })
    end
})

-- Settings Section
ConfigSection:CreateToggle({
    Name = "🔄 Anti-AFK",
    CurrentValue = true,
    Flag = "AntiAFKToggle",
    Callback = function(Value)
        AntiAFK = Value
    end
})

ConfigSection:CreateDropdown({
    Name = "Farm Mode",
    Options = {"Normal", "Fast", "Ultra", "Safe"},
    CurrentOption = "Normal",
    Flag = "FarmModeDropdown",
    Callback = function(Value)
        AutoFarmMode = Value
    end
})

UISection:CreateKeybind({
    Name = "Toggle UI",
    CurrentKeybind = Enum.KeyCode.RightControl,
    HoldToInteract = false,
    Flag = "UIToggle",
    Callback = function(Keybind)
        Rayfield:Toggle()
    end
})

UISection:CreateButton({
    Name = "💾 Save Configuration",
    Callback = function()
        Rayfield:Notify({
            Title = "Configuration Saved",
            Content = "Your settings have been saved!",
            Duration = 3,
            Image = 4483362458,
        })
    end
})

UISection:CreateColorpicker({
    Name = "UI Color",
    Color = Color3.fromRGB(0, 255, 0),
    Flag = "UIColorPicker",
    Callback = function(Value)
        Window:ChangeColor(Value)
    end
})

-- Anti-AFK System
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

-- Initial Notification
Rayfield:Notify({
    Title = "🌿 Plants vs Brainrots Loaded!",
    Content = "Rayfield Ultimate Menu Activated!",
    Duration = 5,
    Image = 4483362458,
})

-- Load Configuration
Rayfield:LoadConfiguration()