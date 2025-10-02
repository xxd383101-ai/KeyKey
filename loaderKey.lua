-- Plants vs Brainrots Cheat Menu
-- No Key System

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "🌿 Plants vs Brainrots 🧠 | FREE",
   LoadingTitle = "Loading Cheat Menu...",
   LoadingSubtitle = "by Sirius",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "BrainrotsFree",
      FileName = "Config"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },
   KeySystem = false,
})

-- Tabs
local MainTab = Window:CreateTab("Главная", "rbxassetid://4483345998")
local PlantsTab = Window:CreateTab("Растения", "rbxassetid://7733674079")
local PlayerTab = Window:CreateTab("Игрок", "rbxassetid://7733661389")
local TeleportTab = Window:CreateTab("Телепорты", "rbxassetid://7733682953")

-- Notify
Rayfield:Notify({
   Title = "Меню загружено!",
   Content = "Все функции разблокированы!",
   Duration = 6.5,
   Image = "check-circle",
})

-- Main Tab
local MainSection = MainTab:CreateSection("Основные функции")

local AutoFarm = MainTab:CreateToggle({
   Name = "💰 Авто-ферминг денег",
   CurrentValue = false,
   Flag = "AutoFarm",
   Callback = function(Value)
       getgenv().AutoFarm = Value
       if Value then
           Rayfield:Notify({
              Title = "Авто-ферминг",
              Content = "Включен авто-сбор денег!",
              Duration = 3,
              Image = "dollar-sign",
           })
           
           spawn(function()
               while getgenv().AutoFarm do
                   for _, obj in pairs(workspace:GetDescendants()) do
                       if obj.Name:lower():find("coin") or obj.Name:lower():find("money") or obj.Name:lower():find("cash") then
                           if obj:IsA("Part") then
                               firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, obj, 0)
                               firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, obj, 1)
                           end
                       end
                   end
                   wait(0.5)
               end
           end)
       end
   end,
})

local AutoWin = MainTab:CreateToggle({
   Name = "⚔️ Авто-убийство врагов",
   CurrentValue = false,
   Flag = "AutoWin",
   Callback = function(Value)
       getgenv().AutoWin = Value
       if Value then
           Rayfield:Notify({
              Title = "Авто-убийство",
              Content = "Включено авто-убийство врагов!",
              Duration = 3,
              Image = "sword",
           })
           
           spawn(function()
               while getgenv().AutoWin do
                   for _, enemy in pairs(workspace:GetChildren()) do
                       if enemy.Name:lower():find("brain") or enemy.Name:lower():find("zombie") or enemy.Name:lower():find("enemy") then
                           if enemy:FindFirstChild("Humanoid") then
                               enemy.Humanoid.Health = 0
                           end
                       end
                   end
                   wait(0.3)
               end
           end)
       end
   end,
})

local GodMode = MainTab:CreateToggle({
   Name = "🛡️ Бессмертие",
   CurrentValue = false,
   Flag = "GodMode",
   Callback = function(Value)
       getgenv().GodMode = Value
       if Value then
           local char = game.Players.LocalPlayer.Character
           if char then
               local hum = char:FindFirstChild("Humanoid")
               if hum then
                   hum.Name = "HumanoidGodMode"
               end
           end
           Rayfield:Notify({
              Title = "Бессмертие",
              Content = "Режим бессмертия включен!",
              Duration = 3,
              Image = "shield",
           })
       else
           local char = game.Players.LocalPlayer.Character
           if char then
               local hum = char:FindFirstChild("HumanoidGodMode")
               if hum then
                   hum.Name = "Humanoid"
               end
           end
       end
   end,
})

local Noclip = MainTab:CreateToggle({
   Name = "🚀 Ноклип",
   CurrentValue = false,
   Flag = "Noclip",
   Callback = function(Value)
       getgenv().Noclip = Value
       if Value then
           Rayfield:Notify({
              Title = "Ноклип",
              Content = "Режим ноклипа включен!",
              Duration = 3,
              Image = "zap",
           })
           
           spawn(function()
               while getgenv().Noclip do
                   if game.Players.LocalPlayer.Character then
                       for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                           if part:IsA("BasePart") then
                               part.CanCollide = false
                           end
                       end
                   end
                   wait(0.1)
               end
           end)
       end
   end,
})

-- Plants Tab
local PlantsSection = PlantsTab:CreateSection("Улучшения растений")

local DamageMulti = PlantsTab:CreateSlider({
   Name = "Множитель урона",
   Range = {1, 10},
   Increment = 0.5,
   Suffix = "x",
   CurrentValue = 1,
   Flag = "DamageMulti",
   Callback = function(Value)
       getgenv().DamageMultiplier = Value
   end,
})

local AttackSpeed = PlantsTab:CreateSlider({
   Name = "Скорость атаки",
   Range = {0.1, 5},
   Increment = 0.1,
   Suffix = "x",
   CurrentValue = 1,
   Flag = "AttackSpeed",
   Callback = function(Value)
       getgenv().AttackSpeed = Value
   end,
})

local InstantPlant = PlantsTab:CreateToggle({
   Name = "⚡ Мгновенная посадка",
   CurrentValue = false,
   Flag = "InstantPlant",
   Callback = function(Value)
       getgenv().InstantPlant = Value
   end,
})

-- Player Tab
local PlayerSection = PlayerTab:CreateSection("Настройки игрока")

local WalkSpeed = PlayerTab:CreateSlider({
   Name = "Скорость ходьбы",
   Range = {16, 200},
   Increment = 5,
   Suffix = "studs",
   CurrentValue = 16,
   Flag = "WalkSpeed",
   Callback = function(Value)
       game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
   end,
})

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

local InfJump = PlayerTab:CreateToggle({
   Name = "🦘 Бесконечный прыжок",
   CurrentValue = false,
   Flag = "InfJump",
   Callback = function(Value)
       getgenv().InfiniteJump = Value
       if Value then
           game:GetService("UserInputService").JumpRequest:connect(function()
               if getgenv().InfiniteJump then
                   game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
               end
           end)
       end
   end,
})

-- Teleport Tab
local TeleportSection = TeleportTab:CreateSection("Телепорты")

local Locations = {
   ["🏠 Старт"] = CFrame.new(0, 10, 0),
   ["🎯 Центр"] = CFrame.new(100, 20, 100),
   ["🌿 Ферма"] = CFrame.new(50, 15, -150),
   ["🧠 Враги"] = CFrame.new(-100, 25, 200),
   ["💎 Секрет"] = CFrame.new(-200, 50, -200),
}

for name, pos in pairs(Locations) do
   TeleportTab:CreateButton({
      Name = "ТП: " .. name,
      Callback = function()
          local char = game.Players.LocalPlayer.Character
          if char then
              local hrp = char:FindFirstChild("HumanoidRootPart")
              if hrp then
                  hrp.CFrame = pos
                  Rayfield:Notify({
                     Title = "Телепорт",
                     Content = "Телепортирован в " .. name,
                     Duration = 3,
                     Image = "map-pin",
                  })
              end
          end
      end,
   })
end

-- Buttons Section
local ButtonsSection = MainTab:CreateSection("Быстрые действия")

MainTab:CreateButton({
   Name = "💸 Собрать все деньги",
   Callback = function()
       Rayfield:Notify({
          Title = "Сбор денег",
          Content = "Собираю все деньги...",
          Duration = 3,
          Image = "dollar-sign",
       })
       
       for _, obj in pairs(workspace:GetDescendants()) do
           if obj.Name:lower():find("coin") or obj.Name:lower():find("money") then
               if obj:IsA("Part") then
                   firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, obj, 0)
                   firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, obj, 1)
               end
           end
       end
   end,
})

MainTab:CreateButton({
   Name = "💀 Убить всех врагов",
   Callback = function()
       Rayfield:Notify({
          Title = "Убийство",
          Content = "Убиваю всех врагов...",
          Duration = 3,
          Image = "skull",
       })
       
       for _, enemy in pairs(workspace:GetChildren()) do
           if enemy.Name:lower():find("brain") or enemy.Name:lower():find("enemy") then
               if enemy:FindFirstChild("Humanoid") then
                   enemy.Humanoid.Health = 0
               end
           end
       end
   end,
})

-- Final notify
Rayfield:Notify({
   Title = "Готово!",
   Content = "Меню полностью загружено!\nНаслаждайся читами!",
   Duration = 8,
   Image = "zap",
})

print("Plants vs Brainrots FREE Cheat loaded!")