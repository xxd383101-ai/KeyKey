-- Plants vs Brainrots Cheat Menu
-- Rayfield Interface Script

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
   Name = "🌿 Plants vs Brainrots 🧠 | Cheat Menu",
   LoadingTitle = "Plants vs Brainrots Cheat",
   LoadingSubtitle = "by TurboModder && t.me/TurboHackMods",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "BrainrotsCheat",
      FileName = "Config"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },
   KeySystem = false,
})

-- Основная вкладка
local MainTab = Window:CreateTab("Основные функции", "rbxassetid://4483345998")
local FarmTab = Window:CreateTab("Авто-ферма", "rbxassetid://4483345998")
local PlayerTab = Window:CreateTab("Игрок", "rbxassetid://4483345998")
local TeleportTab = Window:CreateTab("Телепорты", "rbxassetid://4483345998")

-- Уведомление при запуске
Rayfield:Notify({
   Title = "Cheat Menu Activated",
   Content = "Plants vs Brainrots cheat loaded successfully!",
   Duration = 6.5,
   Image = "check-circle",
})

-- Основные функции
local MainSection = MainTab:CreateSection("Основные функции")

-- Авто-ферминг
local AutoFarmToggle = MainTab:CreateToggle({
   Name = "Авто-ферминг денег",
   CurrentValue = false,
   Flag = "AutoFarm",
   Callback = function(Value)
       _G.AutoFarm = Value
       if Value then
           Rayfield:Notify({
              Title = "Авто-ферминг",
              Content = "Автоматический сбор денег активирован!",
              Duration = 3,
              Image = "dollar-sign",
           })
       end
       
       while _G.AutoFarm do
           task.wait(1)
           -- Твой код авто-ферминга здесь
       end
   end,
})

-- Авто-победа над врагами
local AutoWinToggle = MainTab:CreateToggle({
   Name = "Авто-победа над бреинротами",
   CurrentValue = false,
   Flag = "AutoWin",
   Callback = function(Value)
       _G.AutoWin = Value
       if Value then
           Rayfield:Notify({
              Title = "Авто-победа",
              Content = "Автоматическая победа над врагами активирована!",
              Duration = 3,
              Image = "sword",
           })
       end
   end,
})

-- Бессмертие
local GodModeToggle = MainTab:CreateToggle({
   Name = "Бессмертие",
   CurrentValue = false,
   Flag = "GodMode",
   Callback = function(Value)
       _G.GodMode = Value
       if Value then
           -- Код бессмертия
       end
   end,
})

-- Раздел улучшений растений
local PlantSection = MainTab:CreateSection("Улучшения растений")

-- Множитель урона растений
local DamageMultiplier = MainTab:CreateSlider({
   Name = "Множитель урона растений",
   Range = {1, 10},
   Increment = 0.5,
   Suffix = "x",
   CurrentValue = 1,
   Flag = "DamageMulti",
   Callback = function(Value)
       _G.DamageMultiplier = Value
   end,
})

-- Скорость атаки растений
local AttackSpeed = MainTab:CreateSlider({
   Name = "Скорость атаки растений",
   Range = {0.1, 5},
   Increment = 0.1,
   Suffix = "x",
   CurrentValue = 1,
   Flag = "AttackSpeed",
   Callback = function(Value)
       _G.AttackSpeed = Value
   end,
})

-- Вкладка авто-фермы
local FarmSection = FarmTab:CreateSection("Настройки фермы")

-- Авто-посадка растений
local AutoPlantToggle = FarmTab:CreateToggle({
   Name = "Авто-посадка растений",
   CurrentValue = false,
   Flag = "AutoPlant",
   Callback = function(Value)
       _G.AutoPlant = Value
   end,
})

-- Авто-сбор ресурсов
local AutoCollectToggle = FarmTab:CreateToggle({
   Name = "Авто-сбор ресурсов",
   CurrentValue = false,
   Flag = "AutoCollect",
   Callback = function(Value)
       _G.AutoCollect = Value
   end,
})

-- Интервал сбора
local CollectInterval = FarmTab:CreateSlider({
   Name = "Интервал сбора (сек)",
   Range = {1, 60},
   Increment = 1,
   Suffix = "сек",
   CurrentValue = 5,
   Flag = "CollectInterval",
   Callback = function(Value)
       _G.CollectInterval = Value
   end,
})

-- Вкладка игрока
local PlayerSection = PlayerTab:CreateSection("Настройки игрока")

-- Скорость игрока
local WalkSpeed = PlayerTab:CreateSlider({
   Name = "Скорость передвижения",
   Range = {16, 200},
   Increment = 5,
   Suffix = "studs",
   CurrentValue = 16,
   Flag = "WalkSpeed",
   Callback = function(Value)
       game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
   end,
})

-- Сила прыжка
local JumpPower = PlayerTab:CreateSlider({
   Name = "Сила прыжка",
   Range = {50, 200},
   Increment = 5,
   Suffix = "power",
   CurrentValue = 50,
   Flag = "JumpPower",
   Callback = function(Value)
       game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
   end,
})

-- Ночное зрение
local NightVision = PlayerTab:CreateToggle({
   Name = "Ночное зрение",
   CurrentValue = false,
   Flag = "NightVision",
   Callback = function(Value)
       _G.NightVision = Value
   end,
})

-- Раздел телепортов
local TeleportSection = TeleportTab:CreateSection("Локации телепортации")

-- Быстрые телепорты
local Locations = {
   ["Стартовая зона"] = CFrame.new(0, 10, 0),
   ["Центр карты"] = CFrame.new(100, 20, 100),
   ["Секретная зона"] = CFrame.new(-200, 50, -200),
}

for name, position in pairs(Locations) do
   local TeleportButton = TeleportTab:CreateButton({
      Name = "Телепорт: " .. name,
      Callback = function()
          game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = position
          Rayfield:Notify({
             Title = "Телепортация",
             Content = "Телепортирован в " .. name,
             Duration = 3,
             Image = "map-pin",
          })
      end,
   })
end

-- Раздел промокодов [citation:2]
local CodesSection = MainTab:CreateSection("Промокоды")

-- Авто-ввод промокодов
local AutoRedeemToggle = MainTab:CreateToggle({
   Name = "Авто-ввод промокодов",
   CurrentValue = false,
   Flag = "AutoRedeem",
   Callback = function(Value)
       _G.AutoRedeem = Value
       if Value then
           RedeemAllCodes()
       end
   end,
})

-- Кнопка ввода всех кодов
local RedeemButton = MainTab:CreateButton({
   Name = "Ввести все промокоды",
   Callback = function()
       RedeemAllCodes()
   end,
})

-- Функция для ввода промокодов [citation:2]
function RedeemAllCodes()
   local Codes = {"BASED", "FROZEN", "STACKS"}
   
   Rayfield:Notify({
      Title = "Промокоды",
      Content = "Начинаю ввод промокодов...",
      Duration = 3,
      Image = "gift",
   })
   
   for _, code in pairs(Codes) do
       -- Твой код для ввода промокодов здесь
       task.wait(1)
   end
end

-- Раздел визуальных настроек
local VisualSection = MainTab:CreateSection("Визуальные настройки")

-- Цвет интерфейса
local InterfaceColor = MainTab:CreateColorPicker({
   Name = "Цвет интерфейса",
   Color = Color3.fromRGB(0, 255, 0),
   Flag = "InterfaceColor",
   Callback = function(Value)
       Window:ChangeColor(Value)
   end
})

-- Хоткеи
local KeybindsSection = MainTab:CreateSection("Горячие клавиши")

-- Быстрое меню
local QuickMenuToggle = MainTab:CreateToggle({
   Name = "Быстрое меню (F9)",
   CurrentValue = false,
   Flag = "QuickMenu",
   Callback = function(Value)
       _G.QuickMenu = Value
   end,
})

-- Информация о скрипте
Rayfield:Notify({
   Title = "Успешная загрузка",
   Content = "Plants vs Brainrots Cheat Menu активирован!\nИспользуй меню для активации функций.",
   Duration = 8,
   Image = "zap",
})

print("Plants vs Brainrots Cheat Menu loaded successfully!")