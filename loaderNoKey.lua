-- TurboModsHack Menu
local TurboModsHack = {}

-- GUI создание
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera
local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "TurboModsHackMenu"
gui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 350, 0, 500)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Text = "TurboModsHack - 99 Nights"
title.TextScaled = true
title.Parent = mainFrame

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, 0, 0, 20)
subtitle.Position = UDim2.new(0, 0, 0, 40)
subtitle.BackgroundTransparency = 1
subtitle.TextColor3 = Color3.fromRGB(200, 200, 200)
subtitle.Text = "TG @TurboModsHack"
subtitle.TextSize = 14
subtitle.Parent = mainFrame

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -10, 1, -70)
scrollFrame.Position = UDim2.new(0, 5, 0, 70)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 5
scrollFrame.Parent = mainFrame

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Parent = scrollFrame

-- Переменные из 99 Nights скрипта
local teleportTargets = {
    "Alien", "Alien Chest", "Alien Shelf", "Alpha Wolf", "Alpha Wolf Pelt", "Anvil Base", "Apple", "Bandage", "Bear", "Berry",
    "Bolt", "Broken Fan", "Broken Microwave", "Bunny", "Bunny Foot", "Cake", "Carrot", "Chair Set", "Chest", "Chilli",
    "Coal", "Coin Stack", "Crossbow Cultist", "Cultist", "Cultist Gem", "Deer", "Fuel Canister", "Giant Sack", "Good Axe", "Iron Body",
    "Item Chest", "Item Chest2", "Item Chest3", "Item Chest4", "Item Chest6", "Laser Fence Blueprint", "Laser Sword", "Leather Body", "Log", "Lost Child",
    "Lost Child2", "Lost Child3", "Lost Child4", "Medkit", "Meat? Sandwich", "Morsel", "Old Car Engine", "Old Flashlight", "Old Radio", "Oil Barrel",
    "Raygun", "Revolver", "Revolver Ammo", "Rifle", "Rifle Ammo", "Riot Shield", "Sapling", "Seed Box", "Sheet Metal", "Spear",
    "Steak", "Stronghold Diamond Chest", "Tyre", "UFO Component", "UFO Junk", "Washing Machine", "Wolf", "Wolf Corpse", "Wolf Pelt"
}

local AimbotTargets = {"Alien", "Alpha Wolf", "Wolf", "Crossbow Cultist", "Cultist", "Bunny", "Bear", "Polar Bear"}
local espEnabled = false
local npcESPEnabled = false
local ignoreDistanceFrom = Vector3.new(0, 0, 0)
local minDistance = 50
local AutoTreeFarmEnabled = false
local AimbotEnabled = false
local FOVRadius = 100
local flying = false
local flyConnection = nil
local flySpeed = 60
local currentSpeed = 16
local AntiDeathEnabled = false
local AntiDeathRadius = 50
local fogEnabled = false
local defaultFogStart = game.Lighting.FogStart
local defaultFogEnd = game.Lighting.FogEnd

-- Функция получения ника игрока
local function getPlayerName()
    return player.Name
end

-- Функции из 99 Nights скрипта
function mouse1click()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
end

-- Aimbot FOV Circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(128, 255, 0)
FOVCircle.Thickness = 1
FOVCircle.Radius = FOVRadius
FOVCircle.Transparency = 0.5
FOVCircle.Filled = false
FOVCircle.Visible = false

-- ESP Function
local function createESP(item)
    local adorneePart
    if item:IsA("Model") then
        if item:FindFirstChildWhichIsA("Humanoid") then return end
        adorneePart = item:FindFirstChildWhichIsA("BasePart")
    elseif item:IsA("BasePart") then
        adorneePart = item
    else
        return
    end

    if not adorneePart then return end

    local distance = (adorneePart.Position - ignoreDistanceFrom).Magnitude
    if distance < minDistance then return end

    if not item:FindFirstChild("ESP_Billboard") then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESP_Billboard"
        billboard.Adornee = adorneePart
        billboard.Size = UDim2.new(0, 50, 0, 20)
        billboard.AlwaysOnTop = true
        billboard.StudsOffset = Vector3.new(0, 2, 0)

        local label = Instance.new("TextLabel", billboard)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.Text = item.Name
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextStrokeTransparency = 0
        label.TextScaled = true
        billboard.Parent = item
    end

    if not item:FindFirstChild("ESP_Highlight") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESP_Highlight"
        highlight.FillColor = Color3.fromRGB(255, 85, 0)
        highlight.OutlineColor = Color3.fromRGB(0, 100, 0)
        highlight.FillTransparency = 0.25
        highlight.OutlineTransparency = 0
        highlight.Adornee = item:IsA("Model") and item or adorneePart
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = item
    end
end

local function toggleESP(state)
    espEnabled = state
    for _, item in pairs(workspace:GetDescendants()) do
        if table.find(teleportTargets, item.Name) then
            if espEnabled then
                createESP(item)
            else
                if item:FindFirstChild("ESP_Billboard") then item.ESP_Billboard:Destroy() end
                if item:FindFirstChild("ESP_Highlight") then item.ESP_Highlight:Destroy() end
            end
        end
    end
end

-- NPC ESP
local npcBoxes = {}

local function createNPCESP(npc)
    if not npc:IsA("Model") or npc:FindFirstChild("HumanoidRootPart") == nil then return end

    local root = npc:FindFirstChild("HumanoidRootPart")
    if npcBoxes[npc] then return end

    local box = Drawing.new("Square")
    box.Thickness = 2
    box.Transparency = 1
    box.Color = Color3.fromRGB(255, 85, 0)
    box.Filled = false
    box.Visible = true

    local nameText = Drawing.new("Text")
    nameText.Text = npc.Name
    nameText.Color = Color3.fromRGB(255, 255, 255)
    nameText.Size = 16
    nameText.Center = true
    nameText.Outline = true
    nameText.Visible = true

    npcBoxes[npc] = {box = box, name = nameText}

    npc.AncestryChanged:Connect(function(_, parent)
        if not parent and npcBoxes[npc] then
            npcBoxes[npc].box:Remove()
            npcBoxes[npc].name:Remove()
            npcBoxes[npc] = nil
        end
    end)
end

local function toggleNPCESP(state)
    npcESPEnabled = state
    if not state then
        for npc, visuals in pairs(npcBoxes) do
            if visuals.box then visuals.box:Remove() end
            if visuals.name then visuals.name:Remove() end
        end
        npcBoxes = {}
    else
        for _, obj in ipairs(workspace:GetDescendants()) do
            if table.find(AimbotTargets, obj.Name) and obj:IsA("Model") then
                createNPCESP(obj)
            end
        end
    end
end

-- Auto Tree Farm
local badTrees = {}

task.spawn(function()
    while true do
        if AutoTreeFarmEnabled then
            local trees = {}
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj.Name == "Trunk" and obj.Parent and obj.Parent.Name == "Small Tree" then
                    local distance = (obj.Position - ignoreDistanceFrom).Magnitude
                    if distance > minDistance and not badTrees[obj:GetFullName()] then
                        table.insert(trees, obj)
                    end
                end
            end

            table.sort(trees, function(a, b)
                return (a.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <
                       (b.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            end)

            for _, trunk in ipairs(trees) do
                if not AutoTreeFarmEnabled then break end
                LocalPlayer.Character:PivotTo(trunk.CFrame + Vector3.new(0, 3, 0))
                task.wait(0.2)
                local startTime = tick()
                while AutoTreeFarmEnabled and trunk and trunk.Parent and trunk.Parent.Name == "Small Tree" do
                    mouse1click()
                    task.wait(0.2)
                    if tick() - startTime > 12 then
                        badTrees[trunk:GetFullName()] = true
                        break
                    end
                end
                task.wait(0.3)
            end
        end
        task.wait(1.5)
    end
end)

-- Aimbot
local lastAimbotCheck = 0
local aimbotCheckInterval = 0.02

RunService.RenderStepped:Connect(function()
    if AimbotEnabled then
        local mousePos = UserInputService:GetMouseLocation()
        FOVCircle.Position = Vector2.new(mousePos.X, mousePos.Y)
        FOVCircle.Visible = true
    else
        FOVCircle.Visible = false
    end

    if not AimbotEnabled or not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        return
    end

    local currentTime = tick()
    if currentTime - lastAimbotCheck < aimbotCheckInterval then return end
    lastAimbotCheck = currentTime

    local mousePos = UserInputService:GetMouseLocation()
    local closestTarget, shortestDistance = nil, math.huge

    for _, obj in ipairs(workspace:GetDescendants()) do
        if table.find(AimbotTargets, obj.Name) and obj:IsA("Model") then
            local head = obj:FindFirstChild("Head")
            if head then
                local screenPos, onScreen = camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if dist < shortestDistance and dist <= FOVRadius then
                        shortestDistance = dist
                        closestTarget = head
                    end
                end
            end
        end
    end

    if closestTarget then
        local currentCF = camera.CFrame
        local targetCF = CFrame.new(camera.CFrame.Position, closestTarget.Position)
        camera.CFrame = currentCF:Lerp(targetCF, 0.2)
    end
end)

-- Fly System
local function startFlying()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local bodyGyro = Instance.new("BodyGyro", hrp)
    local bodyVelocity = Instance.new("BodyVelocity", hrp)
    bodyGyro.P = 9e4
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.CFrame = hrp.CFrame
    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)

    flyConnection = RunService.RenderStepped:Connect(function()
        local moveVec = Vector3.zero
        local camCF = camera.CFrame
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVec += camCF.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVec -= camCF.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVec -= camCF.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVec += camCF.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveVec += camCF.UpVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveVec -= camCF.UpVector end
        bodyVelocity.Velocity = moveVec.Magnitude > 0 and moveVec.Unit * flySpeed or Vector3.zero
        bodyGyro.CFrame = camCF
    end)
end

local function stopFlying()
    if flyConnection then flyConnection:Disconnect() end
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        for _, v in pairs(hrp:GetChildren()) do
            if v:IsA("BodyGyro") or v:IsA("BodyVelocity") then v:Destroy() end
        end
    end
end

local function toggleFly(state)
    flying = state
    if flying then startFlying() else stopFlying() end
end

-- Speed System
local function setWalkSpeed(speed)
    currentSpeed = speed
    local character = LocalPlayer.Character
    if character and character:FindFirstChildOfClass("Humanoid") then
        character:FindFirstChildOfClass("Humanoid").WalkSpeed = speed
    end
end

LocalPlayer.CharacterAdded:Connect(function(char)
    task.spawn(function()
        local humanoid = char:WaitForChild("Humanoid", 5)
        if humanoid then
            humanoid.WalkSpeed = currentSpeed
        end
    end)
end)

-- Anti Death System
local AntiDeathTargets = {
    Alien = true,
    ["Alpha Wolf"] = true,
    Wolf = true,
    ["Crossbow Cultist"] = true,
    Cultist = true,
    Bear = true,
}

task.spawn(function()
    while true do
        if AntiDeathEnabled then
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local pos = hrp.Position
                for _, npc in ipairs(workspace:GetDescendants()) do
                    if npc:IsA("Model") and npc:FindFirstChild("HumanoidRootPart") and AntiDeathTargets[npc.Name] then
                        local npcPos = npc.HumanoidRootPart.Position
                        if (npcPos - pos).Magnitude <= AntiDeathRadius then
                            LocalPlayer.Character:PivotTo(CFrame.new(0, 10, 0))
                            break
                        end
                    end
                end
            end
        end
        task.wait(0.2)
    end
end)

-- No Fog System
local function toggleFog(state)
    fogEnabled = state
    if fogEnabled then
        game.Lighting.FogStart = 999999
        game.Lighting.FogEnd = 1000000
    else
        game.Lighting.FogStart = defaultFogStart
        game.Lighting.FogEnd = defaultFogEnd
    end
end

-- Teleport Functions
local function teleportToCampfire()
    LocalPlayer.Character:PivotTo(CFrame.new(0, 10, 0))
end

local function teleportToGrinder()
    LocalPlayer.Character:PivotTo(CFrame.new(16.1,4,-4.6))
end

local function teleportToItem(itemName)
    local closest, shortest = nil, math.huge
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name == itemName and obj:IsA("Model") then
            local cf = nil
            if pcall(function() cf = obj:GetPivot() end) then
            else
                local part = obj:FindFirstChildWhichIsA("BasePart")
                if part then cf = part.CFrame end
            end
            if cf then
                local dist = (cf.Position - ignoreDistanceFrom).Magnitude
                if dist >= minDistance and dist < shortest then
                    closest = obj
                    shortest = dist
                end
            end
        end
    end
    if closest then
        local cf = nil
        if pcall(function() cf = closest:GetPivot() end) then
        else
            local part = closest:FindFirstChildWhichIsA("BasePart")
            if part then cf = part.CFrame end
        end
        if cf then
            LocalPlayer.Character:PivotTo(cf + Vector3.new(0, 5, 0))
        end
    end
end

-- Данные меню
TurboModsHack.menus = {
    main = {
        {name = "🏠 Главное меню", type = "submenu", target = "home"},
        {name = "🧲 Телепорты", type = "submenu", target = "teleport"},
        {name = "🎯 Функции", type = "submenu", target = "functions"},
        {name = "🛡️ Защита", type = "submenu", target = "protection"},
        {name = "⚙️ Настройки", type = "submenu", target = "settings"}
    },
    
    home = {
        {name = "📊 Информация", type = "submenu", target = "info"},
        {name = "🔙 Назад", type = "back"}
    },
    
    info = {
        {name = "👤 " .. getPlayerName(), type = "function", action = function() 
            print("Игрок: " .. player.Name)
        end},
        {name = "💻 TG @TurboModsHack", type = "function", action = function() 
            print("Создатель: TG @TurboModsHack")
        end},
        {name = "🔙 Назад", type = "back"}
    },
    
    teleport = {
        {name = "🔥 К костру", type = "function", action = teleportToCampfire},
        {name = "⚙️ К дробилке", type = "function", action = teleportToGrinder},
        {name = "📦 Телепорты к предметам", type = "submenu", target = "items_teleport"},
        {name = "🔙 Назад", type = "back"}
    },
    
    items_teleport = {},
    
    functions = {
        {name = "🎯 Aimbot (ПКМ)", type = "toggle", value = AimbotEnabled, action = function(val) AimbotEnabled = val end},
        {name = "🛸 Полёт (WASD+Space+Shift)", type = "toggle", value = flying, action = toggleFly},
        {name = "🏃 Скорость", type = "submenu", target = "speed_settings"},
        {name = "🌳 Авто-ферма деревьев", type = "toggle", value = AutoTreeFarmEnabled, action = function(val) AutoTreeFarmEnabled = val end},
        {name = "👁️ ESP предметов", type = "toggle", value = espEnabled, action = toggleESP},
        {name = "👥 ESP NPC", type = "toggle", value = npcESPEnabled, action = toggleNPCESP},
        {name = "🌫️ Убрать туман", type = "toggle", value = fogEnabled, action = toggleFog},
        {name = "🔙 Назад", type = "back"}
    },
    
    speed_settings = {
        {name = "🚶 Нормальная (16)", type = "function", action = function() setWalkSpeed(16) end},
        {name = "🏃 Быстрая (50)", type = "function", action = function() setWalkSpeed(50) end},
        {name = "⚡ Супер (100)", type = "function", action = function() setWalkSpeed(100) end},
        {name = "🔙 Назад", type = "back"}
    },
    
    protection = {
        {name = "🛡️ Анти-смерть", type = "toggle", value = AntiDeathEnabled, action = function(val) AntiDeathEnabled = val end},
        {name = "📏 Радиус защиты", type = "submenu", target = "protection_radius"},
        {name = "🔙 Назад", type = "back"}
    },
    
    protection_radius = {
        {name = "🔴 Маленький (25)", type = "function", action = function() AntiDeathRadius = 25 end},
        {name = "🟡 Средний (50)", type = "function", action = function() AntiDeathRadius = 50 end},
        {name = "🟢 Большой (100)", type = "function", action = function() AntiDeathRadius = 100 end},
        {name = "🔙 Назад", type = "back"}
    },
    
    settings = {
        {name = "⚡ Скорость полёта", type = "submenu", target = "fly_speed"},
        {name = "🎯 Радиус аимбота", type = "submenu", target = "aimbot_fov"},
        {name = "🔙 Назад", type = "back"}
    },
    
    fly_speed = {
        {name = "🐢 Медленная (30)", type = "function", action = function() flySpeed = 30 end},
        {name = "🚶 Обычная (60)", type = "function", action = function() flySpeed = 60 end},
        {name = "🏃 Быстрая (100)", type = "function", action = function() flySpeed = 100 end},
        {name = "🔙 Назад", type = "back"}
    },
    
    aimbot_fov = {
        {name = "🎯 Маленький (50)", type = "function", action = function() FOVRadius = 50 end},
        {name = "🎯 Средний (100)", type = "function", action = function() FOVRadius = 100 end},
        {name = "🎯 Большой (200)", type = "function", action = function() FOVRadius = 200 end},
        {name = "🔙 Назад", type = "back"}
    }
}

-- Заполняем телепорты к предметам
for _, itemName in ipairs(teleportTargets) do
    table.insert(TurboModsHack.menus.items_teleport, {
        name = "📦 " .. itemName,
        type = "function", 
        action = function() teleportToItem(itemName) end
    })
end
table.insert(TurboModsHack.menus.items_teleport, {name = "🔙 Назад", type = "back"})

TurboModsHack.currentMenu = "main"
TurboModsHack.menuStack = {}

-- Создание кнопки
function TurboModsHack.createButton(text, index)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 35)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Text = text
    button.TextSize = 14
    button.TextWrapped = true
    button.BorderSizePixel = 0
    
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    end)
    
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end)
    
    return button
end

-- Обновление меню
function TurboModsHack.updateMenu()
    for i, child in ipairs(scrollFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    local menuItems = TurboModsHack.menus[TurboModsHack.currentMenu]
    
    for i, item in ipairs(menuItems) do
        local button = TurboModsHack.createButton(item.name, i)
        button.Parent = scrollFrame
        
        button.MouseButton1Click:Connect(function()
            if item.type == "submenu" then
                table.insert(TurboModsHack.menuStack, {
                    menu = TurboModsHack.currentMenu,
                    index = i
                })
                TurboModsHack.currentMenu = item.target
                TurboModsHack.updateMenu()
            elseif item.type == "function" then
                if item.action then item.action() end
            elseif item.type == "toggle" then
                local newValue = not item.value
                if item.action then item.action(newValue) end
                -- Обновляем значение в меню
                for menuName, menuData in pairs(TurboModsHack.menus) do
                    for j, menuItem in ipairs(menuData) do
                        if menuItem.name == item.name then
                            menuItem.value = newValue
                            -- Обновляем текст кнопки
                            if newValue then
                                button.Text = item.name .. " ✅"
                            else
                                button.Text = item.name .. " ❌"
                            end
                        end
                    end
                end
            elseif item.type == "back" then
                if #TurboModsHack.menuStack > 0 then
                    local previous = table.remove(TurboModsHack.menuStack)
                    TurboModsHack.currentMenu = previous.menu
                    TurboModsHack.updateMenu()
                end
            end
        end)
    end
    
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y)
end

-- Кнопка закрытия
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -30, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Text = "X"
closeButton.TextSize = 16
closeButton.Parent = mainFrame

closeButton.MouseButton1Click:Connect(function()
    gui:Destroy()
    -- Очищаем ESP при закрытии
    toggleESP(false)
    toggleNPCESP(false)
    toggleFly(false)
    if FOVCircle then FOVCircle:Remove() end
end)

-- Перетаскивание
local dragging = false
local dragInput, dragStart, startPos

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        local delta = input.Position - dragStart
        mainFrame.Position = startPos + UDim2.new(0, delta.X, 0, delta.Y)
    end
end)

-- Инициализация ESP при добавлении объектов
workspace.DescendantAdded:Connect(function(desc)
    if espEnabled and table.find(teleportTargets, desc.Name) then
        task.wait(0.1)
        createESP(desc)
    end
    if table.find(AimbotTargets, desc.Name) and desc:IsA("Model") then
        task.wait(0.1)
        if npcESPEnabled then
            createNPCESP(desc)
        end
    end
end)

-- Инициализация
TurboModsHack.updateMenu()

print("🚀 TurboModsHack Menu loaded for 99 Nights!")
print("👤 Player: " .. getPlayerName())
print("💻 Creator: TG @TurboModsHack")

-- Hotkey для открытия/закрытия меню
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        mainFrame.Visible = not mainFrame.Visible
    end
end)