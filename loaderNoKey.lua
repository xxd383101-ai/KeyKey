-- TurboModsHack Menu для 99 Nights
local TurboModsHack = {}

-- Сервисы
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Переменные
local flying = false
local flySpeed = 50
local noclip = false
local speedHack = 16
local killAura = false
local killAuraRadius = 20
local infiniteJump = false

-- Целевые NPC для Kill Aura
local killAuraTargets = {"Alien", "Alpha Wolf", "Wolf", "Crossbow Cultist", "Cultist", "Bear", "Polar Bear"}

-- Создание GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TurboModsHackMenu"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Кнопка открытия меню (изначально видима)
local openButton = Instance.new("TextButton")
openButton.Size = UDim2.new(0, 50, 0, 50)
openButton.Position = UDim2.new(0, 20, 0.5, -25)
openButton.BackgroundColor3 = Color3.fromRGB(0, 255, 127)
openButton.BorderSizePixel = 0
openButton.Text = "🎮"
openButton.TextColor3 = Color3.fromRGB(255, 255, 255)
openButton.TextSize = 20
openButton.ZIndex = 2
openButton.Parent = screenGui

-- Тень кнопки
local openButtonShadow = Instance.new("ImageLabel")
openButtonShadow.Size = UDim2.new(1, 10, 1, 10)
openButtonShadow.Position = UDim2.new(0, -5, 0, -5)
openButtonShadow.BackgroundTransparency = 1
openButtonShadow.Image = "rbxassetid://5554236805"
openButtonShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
openButtonShadow.ImageTransparency = 0.8
openButtonShadow.ScaleType = Enum.ScaleType.Slice
openButtonShadow.SliceCenter = Rect.new(10, 10, 118, 118)
openButtonShadow.ZIndex = 1
openButtonShadow.Parent = openButton

-- Главный фрейм (изначально скрыт)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 280, 0, 380)
mainFrame.Position = UDim2.new(0.02, 0, 0.1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.BackgroundTransparency = 0.1
mainFrame.Visible = false
mainFrame.Parent = screenGui

-- Тень меню
local shadow = Instance.new("ImageLabel")
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.Position = UDim2.new(0, -5, 0, -5)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://5554236805"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.8
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 118, 118)
shadow.Parent = mainFrame

-- Заголовок
local titleFrame = Instance.new("Frame")
titleFrame.Size = UDim2.new(1, 0, 0, 40)
titleFrame.Position = UDim2.new(0, 0, 0, 0)
titleFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
titleFrame.BorderSizePixel = 0
titleFrame.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "TURBOMODSHACK"
title.TextColor3 = Color3.fromRGB(0, 255, 127)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.Parent = titleFrame

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, 0, 0, 15)
subtitle.Position = UDim2.new(0, 0, 1, -15)
subtitle.BackgroundTransparency = 1
subtitle.Text = "99 NIGHTS • TG @TurboModsHack"
subtitle.TextColor3 = Color3.fromRGB(200, 200, 200)
subtitle.TextSize = 10
subtitle.Font = Enum.Font.Gotham
subtitle.Parent = titleFrame

-- Контейнер для кнопок
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -10, 1, -50)
scrollFrame.Position = UDim2.new(0, 5, 0, 45)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 3
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 127)
scrollFrame.Parent = mainFrame

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Padding = UDim.new(0, 5)
uiListLayout.Parent = scrollFrame

-- Функция создания стильной кнопки
function CreateButton(text, isToggle)
    local buttonFrame = Instance.new("Frame")
    buttonFrame.Size = UDim2.new(1, 0, 0, 35)
    buttonFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    buttonFrame.BorderSizePixel = 0
    buttonFrame.Parent = scrollFrame

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundTransparency = 1
    button.Text = ""
    button.ZIndex = 2
    button.Parent = buttonFrame

    local buttonText = Instance.new("TextLabel")
    buttonText.Size = UDim2.new(0.8, 0, 1, 0)
    buttonText.Position = UDim2.new(0.1, 0, 0, 0)
    buttonText.BackgroundTransparency = 1
    buttonText.Text = text
    buttonText.TextColor3 = Color3.fromRGB(255, 255, 255)
    buttonText.TextSize = 12
    buttonText.TextXAlignment = Enum.TextXAlignment.Left
    buttonText.Font = Enum.Font.Gotham
    buttonText.Parent = buttonFrame

    local statusIndicator = Instance.new("Frame")
    statusIndicator.Size = UDim2.new(0, 8, 0, 8)
    statusIndicator.Position = UDim2.new(0.9, -10, 0.5, -4)
    statusIndicator.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    statusIndicator.BorderSizePixel = 0
    statusIndicator.Visible = isToggle
    statusIndicator.Parent = buttonFrame

    -- Анимация при наведении
    button.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(
            buttonFrame,
            TweenInfo.new(0.2),
            {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}
        ):Play()
    end)

    button.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(
            buttonFrame,
            TweenInfo.new(0.2),
            {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}
        ):Play()
    end)

    return button, statusIndicator, buttonText
end

-- Функция создания слайдера
function CreateSlider(text, min, max, current, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, 0, 0, 50)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    sliderFrame.BorderSizePixel = 0
    sliderFrame.Parent = scrollFrame

    local sliderText = Instance.new("TextLabel")
    sliderText.Size = UDim2.new(1, 0, 0, 20)
    sliderText.BackgroundTransparency = 1
    sliderText.Text = text
    sliderText.TextColor3 = Color3.fromRGB(255, 255, 255)
    sliderText.TextSize = 12
    sliderText.TextXAlignment = Enum.TextXAlignment.Left
    sliderText.Font = Enum.Font.Gotham
    sliderText.Parent = sliderFrame

    local sliderBackground = Instance.new("Frame")
    sliderBackground.Size = UDim2.new(0.9, 0, 0, 6)
    sliderBackground.Position = UDim2.new(0.05, 0, 0.7, 0)
    sliderBackground.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    sliderBackground.BorderSizePixel = 0
    sliderBackground.Parent = sliderFrame

    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((current - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 255, 127)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBackground

    local sliderButton = Instance.new("TextButton")
    sliderButton.Size = UDim2.new(0, 16, 0, 16)
    sliderButton.Position = UDim2.new((current - min) / (max - min), -8, 0.5, -8)
    sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderButton.BorderSizePixel = 0
    sliderButton.Text = ""
    sliderButton.ZIndex = 2
    sliderButton.Parent = sliderBackground

    local valueText = Instance.new("TextLabel")
    valueText.Size = UDim2.new(0.2, 0, 0, 20)
    valueText.Position = UDim2.new(0.75, 0, 0, 0)
    valueText.BackgroundTransparency = 1
    valueText.Text = tostring(current)
    valueText.TextColor3 = Color3.fromRGB(0, 255, 127)
    valueText.TextSize = 12
    valueText.Font = Enum.Font.GothamBold
    valueText.Parent = sliderFrame

    local function updateValue(value)
        local newValue = math.clamp(value, min, max)
        sliderFill.Size = UDim2.new((newValue - min) / (max - min), 0, 1, 0)
        sliderButton.Position = UDim2.new((newValue - min) / (max - min), -8, 0.5, -8)
        valueText.Text = tostring(newValue)
        callback(newValue)
    end

    sliderButton.MouseButton1Down:Connect(function()
        local connection
        connection = RunService.RenderStepped:Connect(function()
            local mousePos = UserInputService:GetMouseLocation()
            local relativeX = (mousePos.X - sliderBackground.AbsolutePosition.X) / sliderBackground.AbsoluteSize.X
            local value = min + (max - min) * math.clamp(relativeX, 0, 1)
            updateValue(math.floor(value))
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                connection:Disconnect()
            end
        end)
    end)

    return {Update = updateValue}
end

-- Кнопка закрытия меню
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -30, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeButton.BorderSizePixel = 0
closeButton.Text = "×"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 16
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = mainFrame

-- Функции открытия/закрытия меню
local function openMenu()
    mainFrame.Visible = true
    openButton.Visible = false
end

local function closeMenu()
    mainFrame.Visible = false
    openButton.Visible = true
end

closeButton.MouseButton1Click:Connect(closeMenu)
openButton.MouseButton1Click:Connect(openMenu)

-- Функции модов
-- Speed Hack
local function setSpeed(value)
    speedHack = value
    local character = LocalPlayer.Character
    if character and character:FindFirstChildOfClass("Humanoid") then
        character:FindFirstChildOfClass("Humanoid").WalkSpeed = value
    end
end

-- Fly System (как в админ команде)
local function toggleFly(state)
    flying = state
    local character = LocalPlayer.Character
    if not character then return end
    
    if flying then
        -- Включаем полёт
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.PlatformStand = true
        end
        
        -- Создаем BodyVelocity для управления полётом
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
        bodyVelocity.Parent = character:FindFirstChild("HumanoidRootPart")
        
        -- Управление полётом
        local flyConnection
        flyConnection = RunService.Heartbeat:Connect(function()
            if not flying or not character then
                if flyConnection then flyConnection:Disconnect() end
                return
            end
            
            local root = character:FindFirstChild("HumanoidRootPart")
            if not root then return end
            
            local camera = workspace.CurrentCamera
            local direction = Vector3.new()
            
            -- Управление WASD
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                direction = direction + camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                direction = direction - camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                direction = direction - camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                direction = direction + camera.CFrame.RightVector
            end
            
            -- Управление высотой
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                direction = direction + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                direction = direction - Vector3.new(0, 1, 0)
            end
            
            -- Применяем скорость
            if direction.Magnitude > 0 then
                direction = direction.Unit * flySpeed
            end
            
            local bodyVelocity = root:FindFirstChildOfClass("BodyVelocity")
            if bodyVelocity then
                bodyVelocity.Velocity = direction
            end
        end)
    else
        -- Выключаем полёт
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.PlatformStand = false
        end
        
        local root = character:FindFirstChild("HumanoidRootPart")
        if root then
            for _, v in pairs(root:GetChildren()) do
                if v:IsA("BodyVelocity") then
                    v:Destroy()
                end
            end
        end
    end
end

-- Noclip
local noclipConnection
local function toggleNoclip(state)
    noclip = state
    local character = LocalPlayer.Character
    if not character then return end
    
    if noclip then
        noclipConnection = RunService.Stepped:Connect(function()
            if not noclip or not character then
                if noclipConnection then noclipConnection:Disconnect() end
                return
            end
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    else
        if noclipConnection then
            noclipConnection:Disconnect()
        end
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

-- Infinite Jump
local infiniteJumpConnection
local function toggleInfiniteJump(state)
    infiniteJump = state
    
    if infiniteJump then
        infiniteJumpConnection = UserInputService.JumpRequest:Connect(function()
            if infiniteJump and LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end)
    else
        if infiniteJumpConnection then
            infiniteJumpConnection:Disconnect()
        end
    end
end

-- Kill Aura
local killAuraConnection
local function toggleKillAura(state)
    killAura = state
    
    if killAura then
        killAuraConnection = RunService.Heartbeat:Connect(function()
            if not killAura then
                if killAuraConnection then killAuraConnection:Disconnect() end
                return
            end
            
            local character = LocalPlayer.Character
            if not character then return end
            
            local hrp = character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            
            for _, npc in pairs(workspace:GetDescendants()) do
                if npc:IsA("Model") and table.find(killAuraTargets, npc.Name) then
                    local npcHrp = npc:FindFirstChild("HumanoidRootPart")
                    local humanoid = npc:FindFirstChildOfClass("Humanoid")
                    
                    if npcHrp and humanoid and humanoid.Health > 0 then
                        local distance = (hrp.Position - npcHrp.Position).Magnitude
                        
                        if distance <= killAuraRadius then
                            -- Телепортируемся к NPC и атакуем
                            character:PivotTo(npcHrp.CFrame * CFrame.new(0, 0, -3))
                            wait(0.1)
                            mouse1click()
                        end
                    end
                end
            end
        end)
    else
        if killAuraConnection then
            killAuraConnection:Disconnect()
        end
    end
end

-- Функция для клика
function mouse1click()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
end

-- Создание элементов меню
local speedButton, speedIndicator, speedText = CreateButton("Speed Hack", true)
local flyButton, flyIndicator, flyText = CreateButton("Fly", true)
local noclipButton, noclipIndicator, noclipText = CreateButton("Noclip", true)
local infiniteJumpButton, infiniteJumpIndicator, infiniteJumpText = CreateButton("Infinite Jump", true)
local killAuraButton, killAuraIndicator, killAuraText = CreateButton("Kill Aura", true)

local flySpeedSlider = CreateSlider("Fly Speed", 10, 200, flySpeed, function(value)
    flySpeed = value
    if flying then
        toggleFly(false)
        wait(0.1)
        toggleFly(true)
    end
end)

local killAuraRadiusSlider = CreateSlider("Kill Aura Radius", 10, 50, killAuraRadius, function(value)
    killAuraRadius = value
end)

local speedSlider = CreateSlider("Walk Speed", 16, 100, speedHack, function(value)
    setSpeed(value)
end)

-- Обработчики кнопок
speedButton.MouseButton1Click:Connect(function()
    if speedHack == 16 then
        setSpeed(50)
        speedIndicator.BackgroundColor3 = Color3.fromRGB(0, 255, 127)
        speedText.Text = "Speed Hack ✅"
    else
        setSpeed(16)
        speedIndicator.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        speedText.Text = "Speed Hack ❌"
    end
end)

flyButton.MouseButton1Click:Connect(function()
    toggleFly(not flying)
    if flying then
        flyIndicator.BackgroundColor3 = Color3.fromRGB(0, 255, 127)
        flyText.Text = "Fly ✅"
    else
        flyIndicator.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        flyText.Text = "Fly ❌"
    end
end)

noclipButton.MouseButton1Click:Connect(function()
    toggleNoclip(not noclip)
    if noclip then
        noclipIndicator.BackgroundColor3 = Color3.fromRGB(0, 255, 127)
        noclipText.Text = "Noclip ✅"
    else
        noclipIndicator.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        noclipText.Text = "Noclip ❌"
    end
end)

infiniteJumpButton.MouseButton1Click:Connect(function()
    toggleInfiniteJump(not infiniteJump)
    if infiniteJump then
        infiniteJumpIndicator.BackgroundColor3 = Color3.fromRGB(0, 255, 127)
        infiniteJumpText.Text = "Infinite Jump ✅"
    else
        infiniteJumpIndicator.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        infiniteJumpText.Text = "Infinite Jump ❌"
    end
end)

killAuraButton.MouseButton1Click:Connect(function()
    toggleKillAura(not killAura)
    if killAura then
        killAuraIndicator.BackgroundColor3 = Color3.fromRGB(0, 255, 127)
        killAuraText.Text = "Kill Aura ✅"
    else
        killAuraIndicator.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        killAuraText.Text = "Kill Aura ❌"
    end
end)

-- Перетаскивание кнопки открытия
local openButtonDragging = false
local openButtonDragStart, openButtonStartPos

openButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        openButtonDragging = true
        openButtonDragStart = input.Position
        openButtonStartPos = openButton.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                openButtonDragging = false
            end
        end)
    end
end)

openButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        openButtonDragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if openButtonDragging and input == openButtonDragInput then
        local delta = input.Position - openButtonDragStart
        openButton.Position = openButtonStartPos + UDim2.new(0, delta.X, 0, delta.Y)
    end
end)

-- Перетаскивание меню
local menuDragging = false
local menuDragStart, menuStartPos

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        menuDragging = true
        menuDragStart = input.Position
        menuStartPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                menuDragging = false
            end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        menuDragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if menuDragging and input == menuDragInput then
        local delta = input.Position - menuDragStart
        mainFrame.Position = menuStartPos + UDim2.new(0, delta.X, 0, delta.Y)
    end
end)

-- Авто-обновление размера скролла
uiListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y)
end)

-- Горячая клавиша для скрытия/показа (F5)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F5 then
        if mainFrame.Visible then
            closeMenu()
        else
            openMenu()
        end
    end
end)

print("🎮 TurboModsHack Menu загружен!")
print("👤 Player: " .. LocalPlayer.Name)
print("💻 Creator: TG @TurboModsHack")
print("🎯 Hotkey: F5 - toggle menu")
print("🚀 Features: Speed, Fly, Noclip, Infinite Jump, Kill Aura")