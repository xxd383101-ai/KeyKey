-- Plants vs Brainrots Premium Cheat Menu
-- Direct Telegram Bot Key System

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Конфигурация Telegram бота
local BotToken = "8251132761:AAG7_jY1henryq_rZCy9QiVdwM-v_wuK9ik"
local BotAPI = "https://api.telegram.org/bot" .. BotToken
local AdminID = 8144211675 -- Твой Telegram ID (замени на свой)

-- Глобальные переменные
local CurrentKey = nil
local KeyValidUntil = nil
local UserData = nil
local KeySystemEnabled = true

-- Функция для отправки запросов к Telegram API
local function TelegramRequest(method, data)
    local url = BotAPI .. "/" .. method
    
    local success, result = pcall(function()
        local httpService = game:GetService("HttpService")
        local jsonData = httpService:JSONEncode(data)
        
        return httpService:PostAsync(
            url,
            jsonData,
            Enum.HttpContentType.ApplicationJson
        )
    end)
    
    if success then
        return true, game:GetService("HttpService"):JSONDecode(result)
    else
        return false, "Request failed: " .. tostring(result)
    end
end

-- Функция проверки ключа через бота
local function ValidateKeyWithBot(key)
    -- Сначала проверяем локальную базу через бота
    local success, response = TelegramRequest("getChat", {
        chat_id = AdminID
    })
    
    if not success then
        return {success = false, error = "Ошибка связи с ботом"}
    end
    
    -- Эмуляция проверки ключа (в реальности бот должен иметь свою БД)
    local validKeys = {
        ["TESTKEY123456789"] = {hours = 2, premium = true},
        ["PREMIUMKEY123456"] = {hours = 0, premium = true},
        ["VIPACCESS789"] = {hours = 24, premium = true},
    }
    
    if validKeys[key] then
        local keyData = validKeys[key]
        local expiresAt = nil
        
        if keyData.hours > 0 then
            expiresAt = os.time() + (keyData.hours * 3600)
        end
        
        -- Отправляем уведомление админу о активации
        TelegramRequest("sendMessage", {
            chat_id = AdminID,
            text = "🔑 Активирован ключ: " .. key .. "\n" ..
                   "👤 Пользователь: " .. game.Players.LocalPlayer.Name .. "\n" ..
                   "🆔 UserID: " .. game.Players.LocalPlayer.UserId .. "\n" ..
                   "⏰ Время: " .. os.date("%Y-%m-%d %H:%M:%S")
        })
        
        return {
            success = true,
            data = {
                premium = keyData.premium,
                expires_at = expiresAt,
                duration_hours = keyData.hours,
                key_type = keyData.hours == 0 and "Бессрочный" or ("На " .. keyData.hours .. " часов")
            }
        }
    else
        return {success = false, error = "Неверный или неактивный ключ"}
    end
end

-- Функция запроса ключа через бота
local function RequestKeyFromBot(duration)
    local message = "🆕 Запрос ключа от пользователя:\n" ..
                   "👤 Имя: " .. game.Players.LocalPlayer.Name .. "\n" ..
                   "🆔 UserID: " .. game.Players.LocalPlayer.UserId .. "\n" ..
                   "⏰ Запрошено: " .. os.date("%Y-%m-%d %H:%M:%S") .. "\n" ..
                   "📅 Длительность: " .. (duration or "2 часа")
    
    local success, response = TelegramRequest("sendMessage", {
        chat_id = AdminID,
        text = message,
        reply_markup = {
            inline_keyboard = {
                {
                    {text = "✅ Сгенерировать ключ", callback_data = "generate_key_" .. game.Players.LocalPlayer.UserId}
                }
            }
        }
    })
    
    return success
end

-- Функция активации ключа
local function ActivateKey()
    Rayfield:Notify({
        Title = "🔐 Система ключей",
        Content = "Требуется активация для доступа к премиум функциям",
        Duration = 6,
        Image = "lock",
    })
    
    local keyInput = nil
    local activationSuccess = false
    
    -- Создание окна активации
    local ActivationWindow = Rayfield:CreateWindow({
        Name = "🌿 Plants vs Brainrots | Активация",
        LoadingTitle = "Подключение к Telegram боту...",
        LoadingSubtitle = "Проверка лицензии",
        ConfigurationSaving = {Enabled = false},
        KeySystem = false,
    })
    
    local ActivationTab = ActivationWindow:CreateTab("Активация", "rbxassetid://4483345998")
    
    -- Секция ввода ключа
    local MainSection = ActivationTab:CreateSection("🔐 Активация ключа")
    
    local KeyInputField = ActivationTab:CreateInput({
        Name = "Ключ активации",
        PlaceholderText = "Введите ключ полученный от бота...",
        RemoveTextAfterFocusLost = false,
        Callback = function(Text)
            keyInput = Text
        end,
    })
    
    local ActivateBtn = ActivationTab:CreateButton({
        Name = "✅ Активировать ключ",
        Callback = function()
            if keyInput and #keyInput >= 10 then
                Rayfield:Notify({
                    Title = "🔍 Проверка ключа...",
                    Content = "Подключение к Telegram боту",
                    Duration = 3,
                    Image = "loader",
                })
                
                local validationResult = ValidateKeyWithBot(keyInput)
                
                if validationResult.success then
                    CurrentKey = keyInput
                    KeyValidUntil = validationResult.data.expires_at
                    UserData = validationResult.data
                    
                    -- Сохраняем ключ
                    if writefile then
                        pcall(function()
                            writefile("brainrots_key.txt", keyInput)
                        end)
                    end
                    
                    Rayfield:Notify({
                        Title = "✅ Успешная активация!",
                        Content = "Премиум функции разблокированы!\nТип: " .. validationResult.data.key_type,
                        Duration = 6,
                        Image = "check-circle",
                    })
                    
                    wait(2)
                    ActivationWindow:Destroy()
                    activationSuccess = true
                else
                    Rayfield:Notify({
                        Title = "❌ Ошибка активации",
                        Content = validationResult.error or "Неверный ключ",
                        Duration = 5,
                        Image = "x-circle",
                    })
                end
            else
                Rayfield:Notify({
                    Title = "Ошибка",
                    Content = "Введите корректный ключ!",
                    Duration = 3,
                    Image = "alert-triangle",
                })
            end
        end,
    })
    
    -- Секция получения ключа
    local GetKeySection = ActivationTab:CreateSection("🔑 Получение ключа")
    
    ActivationTab:CreateButton({
        Name = "📱 Перейти в бота",
        Callback = function()
            setclipboard("https://t.me/your_bot_username")
            Rayfield:Notify({
                Title = "Ссылка скопирована",
                Content = "Перейдите в бота для получения ключа",
                Duration = 6,
                Image = "external-link",
            })
        end,
    })
    
    ActivationTab:CreateButton({
        Name = "🔄 Запросить ключ у администратора",
        Callback = function()
            local success = RequestKeyFromBot("2 часа")
            if success then
                Rayfield:Notify({
                    Title = "📨 Запрос отправлен",
                    Content = "Администратор уведомлен. Ожидайте ключ",
                    Duration = 6,
                    Image = "mail",
                })
            else
                Rayfield:Notify({
                    Title = "❌ Ошибка",
                    Content = "Не удалось отправить запрос",
                    Duration = 4,
                    Image = "x-circle",
                })
            end
        end,
    })
    
    -- Секция информации
    local InfoSection = ActivationTab:CreateSection("📋 Информация")
    
    ActivationTab:CreateLabel("• 🔑 Ключ выдается на 2 часа бесплатно")
    ActivationTab:CreateLabel("• 👑 Премиум ключи - через администратора")
    ActivationTab:CreateLabel("• 📱 Ключ получайте в нашем Telegram боте")
    ActivationTab:CreateLabel("• 🆘 Поддержка: @your_username")
    
    -- Проверка сохраненного ключа
    if readfile then
        pcall(function()
            local savedKey = readfile("brainrots_key.txt")
            if savedKey and #savedKey >= 10 then
                ActivationTab:CreateButton({
                    Name = "🔄 Проверить сохраненный ключ",
                    Callback = function()
                        keyInput = savedKey
                        ActivateBtn.Callback()
                    end,
                })
            end
        end)
    end
    
    -- Ждем активации
    repeat wait() until activationSuccess
    return true
end

-- Функция проверки срока действия ключа
local function CheckKeyExpiry()
    if not KeySystemEnabled or not KeyValidUntil then return true end
    
    if KeyValidUntil and os.time() > KeyValidUntil then
        Rayfield:Notify({
            Title = "⏰ Ключ истек",
            Content = "Срок действия вашего ключа истек",
            Duration = 6,
            Image = "clock",
        })
        
        -- Удаляем сохраненный ключ
        if writefile then
            pcall(function()
                delfile("brainrots_key.txt")
            end)
        end
        
        return false
    end
    
    return true
end

-- Основное меню после активации
local function CreateMainMenu()
    local MainWindow = Rayfield:CreateWindow({
        Name = "🌿 Plants vs Brainrots 🧠 | Premium",
        LoadingTitle = "Загрузка премиум функций...",
        LoadingSubtitle = "Лицензия активна",
        ConfigurationSaving = {
            Enabled = true,
            FolderName = "BrainrotsPremium",
            FileName = "PremiumConfig"
        },
        Discord = {
            Enabled = false,
            Invite = "noinvitelink",
            RememberJoins = true
        },
        KeySystem = false,
    })
    
    -- Вкладка основной информации
    local HomeTab = MainWindow:CreateTab("Главная", "rbxassetid://4483345998")
    
    local WelcomeSection = HomeTab:CreateSection("👋 Добро пожаловать, " .. game.Players.LocalPlayer.Name)
    
    -- Информация о ключе
    local keyInfoText = "🔑 Ключ: " .. string.sub(CurrentKey, 1, 8) .. "..."
    if KeyValidUntil then
        local timeLeft = KeyValidUntil - os.time()
        local hoursLeft = math.floor(timeLeft / 3600)
        local minutesLeft = math.floor((timeLeft % 3600) / 60)
        keyInfoText = keyInfoText .. "\n⏰ Осталось: " .. hoursLeft .. "ч " .. minutesLeft .. "м"
    else
        keyInfoText = keyInfoText .. "\n⏰ Срок: ♾️ Бессрочно"
    end
    
    HomeTab:CreateLabel(keyInfoText)
    
    -- Кнопка проверки статуса
    HomeTab:CreateButton({
        Name = "🔄 Проверить статус ключа",
        Callback = function()
            if CheckKeyExpiry() then
                Rayfield:Notify({
                    Title = "✅ Ключ активен",
                    Content = keyInfoText,
                    Duration = 5,
                    Image = "check-circle",
                })
            end
        end,
    })
    
    -- Основные функции
    local MainSection = HomeTab:CreateSection("⚡ Премиум функции")
    
    local AutoFarmToggle = HomeTab:CreateToggle({
        Name = "💰 Авто-ферминг денег",
        CurrentValue = false,
        Flag = "AutoFarm",
        Callback = function(Value)
            if not CheckKeyExpiry() then
                _G.AutoFarm = false
                return
            end
            
            _G.AutoFarm = Value
            if Value then
                Rayfield:Notify({
                    Title = "Авто-ферминг",
                    Content = "Автоматический сбор денег активирован!",
                    Duration = 3,
                    Image = "dollar-sign",
                })
                
                spawn(function()
                    while _G.AutoFarm and CheckKeyExpiry() do
                        -- Авто-ферминг денег
                        local players = game:GetService("Players")
                        local player = players.LocalPlayer
                        
                        -- Поиск денег на карте
                        for _, obj in pairs(workspace:GetDescendants()) do
                            if obj.Name:lower():find("coin") or obj.Name:lower():find("money") or obj.Name:lower():find("cash") then
                                if obj:IsA("Part") then
                                    firetouchinterest(player.Character.HumanoidRootPart, obj, 0)
                                    firetouchinterest(player.Character.HumanoidRootPart, obj, 1)
                                end
                            end
                        end
                        
                        wait(0.5)
                    end
                end)
            end
        end,
    })
    
    local AutoWinToggle = HomeTab:CreateToggle({
        Name = "⚔️ Авто-победа над бреинротами",
        CurrentValue = false,
        Flag = "AutoWin",
        Callback = function(Value)
            if not CheckKeyExpiry() then
                _G.AutoWin = false
                return
            end
            
            _G.AutoWin = Value
            if Value then
                Rayfield:Notify({
                    Title = "Авто-победа",
                    Content = "Автоматическая победа над врагами активирована!",
                    Duration = 3,
                    Image = "sword",
                })
                
                spawn(function()
                    while _G.AutoWin and CheckKeyExpiry() do
                        -- Авто-атака врагов
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
    
    local GodModeToggle = HomeTab:CreateToggle({
        Name = "🛡️ Режим бессмертия",
        CurrentValue = false,
        Flag = "GodMode",
        Callback = function(Value)
            if not CheckKeyExpiry() then
                _G.GodMode = false
                return
            end
            
            _G.GodMode = Value
            if Value then
                local character = game.Players.LocalPlayer.Character
                if character then
                    local humanoid = character:FindFirstChild("Humanoid")
                    if humanoid then
                        humanoid.Name = "HumanoidGodMode"
                    end
                end
                Rayfield:Notify({
                    Title = "Бессмертие",
                    Content = "Режим бессмертия активирован!",
                    Duration = 3,
                    Image = "shield",
                })
            else
                local character = game.Players.LocalPlayer.Character
                if character then
                    local humanoid = character:FindFirstChild("HumanoidGodMode")
                    if humanoid then
                        humanoid.Name = "Humanoid"
                    end
                end
            end
        end,
    })
    
    -- Вкладка улучшений растений
    local PlantsTab = MainWindow:CreateTab("🌿 Растения", "rbxassetid://7733674079")
    
    local BoostSection = PlantsTab:CreateSection("Усиление растений")
    
    local DamageMultiplier = PlantsTab:CreateSlider({
        Name = "Множитель урона растений",
        Range = {1, 10},
        Increment = 0.5,
        Suffix = "x",
        CurrentValue = 1,
        Flag = "DamageMulti",
        Callback = function(Value)
            if CheckKeyExpiry() then
                _G.DamageMultiplier = Value
            end
        end,
    })
    
    local AttackSpeed = PlantsTab:CreateSlider({
        Name = "Скорость атаки растений",
        Range = {0.1, 3},
        Increment = 0.1,
        Suffix = "x",
        CurrentValue = 1,
        Flag = "AttackSpeed",
        Callback = function(Value)
            if CheckKeyExpiry() then
                _G.AttackSpeed = Value
            end
        end,
    })
    
    -- Вкладка телепортов
    local TeleportTab = MainWindow:CreateTab("📍 Телепорты", "rbxassetid://7733682953")
    
    local LocationsSection = TeleportTab:CreateSection("Быстрые телепорты")
    
    local Locations = {
        ["🏠 Стартовая зона"] = CFrame.new(0, 10, 0),
        ["🎯 Центр карты"] = CFrame.new(100, 20, 100),
        ["🌿 Ферма растений"] = CFrame.new(50, 15, -150),
        ["🧠 База бреинротов"] = CFrame.new(-100, 25, 200),
        ["💎 Секретная зона"] = CFrame.new(-200, 50, -200),
    }
    
    for name, position in pairs(Locations) do
        TeleportTab:CreateButton({
            Name = "Телепорт: " .. name,
            Callback = function()
                if CheckKeyExpiry() then
                    local char = game.Players.LocalPlayer.Character
                    if char then
                        local hrp = char:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            hrp.CFrame = position
                            Rayfield:Notify({
                                Title = "Телепортация",
                                Content = "Перемещен в " .. name,
                                Duration = 3,
                                Image = "map-pin",
                            })
                        end
                    end
                end
            end,
        })
    end
    
    -- Периодическая проверка ключа
    spawn(function()
        while true do
            wait(60) -- Проверка каждую минуту
            CheckKeyExpiry()
        end
    end)
    
    -- Уведомление о успешной загрузке
    Rayfield:Notify({
        Title = "🎉 Премиум доступ активирован!",
        Content = "Все функции разблокированы!\nБот подключен: @" .. BotToken:sub(1, 10) .. "...",
        Duration = 8,
        Image = "star",
    })
end

-- Основная функция инициализации
local function Initialize()
    -- Пытаемся загрузить сохраненный ключ
    if readfile and pcall(function()
        local savedKey = readfile("brainrots_key.txt")
        if savedKey then
            local validation = ValidateKeyWithBot(savedKey)
            if validation.success then
                CurrentKey = savedKey
                KeyValidUntil = validation.data.expires_at
                CreateMainMenu()
                return true
            end
        end
    end) then
        return
    end
    
    -- Если ключа нет или он невалидный, запускаем активацию
    if ActivateKey() then
        CreateMainMenu()
    else
        Rayfield:Notify({
            Title = "Ошибка",
            Content = "Не удалось активировать скрипт",
            Duration = 5,
            Image = "x-circle",
        })
    end
end

-- Запуск скрипта
Initialize()