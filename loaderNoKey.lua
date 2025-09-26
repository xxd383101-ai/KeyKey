-- By Modder t.me/TurboHackMods & TurboModder
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Переменные для функций
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")

-- Создание окна
local Window = Rayfield:CreateWindow({
   Name = "🔥 Turbo Script v2.0",
   LoadingTitle = "Turbo Script Loading...",
   LoadingSubtitle = "by TurboModder t.me/TurboHackMods",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "TurboScriptConfig",
      FileName = "Settings"
   },
   Discord = {
      Enabled = false,
      Invite = "invitelink",
      RememberJoins = true
   },
})

-- Вкладка Main
local MainTab = Window:CreateTab("Main", 4483362458)

-- Раздел Movement
-- НОВЫЙ ТИП ПОЛЕТА (BodyVelocity)
local newFlyEnabled = false
local newFlySpeed = 100
local newFlyBodyVel = nil
local newFlyConnection = nil

local NewFlyToggle = MainTab:CreateToggle({
    Name = "🛸 New Flight Mode",
    CurrentValue = false,
    Flag = "NewFly",
    Callback = function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion(Value)
        newFlyEnabled = Value
        local character = LocalPlayer.Character
        if not character then return end

        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if not rootPart then return end

        if Value then
            -- Создание BodyVelocity
            newFlyBodyVel = Instance.new("BodyVelocity")
            newFlyBodyVel.Velocity = Vector3.zero
            newFlyBodyVel.MaxForce = Vector3.new(1, 1, 1) * 1e6
            newFlyBodyVel.P = 1250
            newFlyBodyVel.Parent = rootPart

            -- Присвоение перемещения
            newFlyConnection = RunService.Heartbeat:Connect(function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion()
                if not newFlyEnabled or not rootPart then return end
                local moveDir = Vector3.zero
                local camCF = workspace.CurrentCamera.CFrame

                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    moveDir = moveDir + camCF.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    moveDir = moveDir - camCF.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    moveDir = moveDir + camCF.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    moveDir = moveDir - camCF.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    moveDir = moveDir + Vector3.new(0, 1, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                    moveDir = moveDir - Vector3.new(0, 1, 0)
                end

                if moveDir.Magnitude > 0 then
                    newFlyBodyVel.Velocity = moveDir.Unit * newFlySpeed
                else
                    newFlyBodyVel.Velocity = Vector3.zero
                end
            end)

            Rayfield:Notify({
                Title = "New Flight Activated 🛸",
                Content = "Use WASD + Space/Ctrl to move",
                Duration = 4,
            })
        else
            -- Отключение полета
            if newFlyBodyVel then
                newFlyBodyVel:Destroy()
                newFlyBodyVel = nil
            end
            if newFlyConnection then
                newFlyConnection:Disconnect()
                newFlyConnection = nil
            end
            Rayfield:Notify({
                Title = "New Flight Deactivated",
                Content = "Flight mode turned off",
                Duration = 3,
            })
        end
    end,
})

local NewFlySpeedSlider = MainTab:CreateSlider({
    Name = "⚙️ New Flight Speed",
    Range = {50, 500},
    Increment = 10,
    Suffix = "studs",
    CurrentValue = 100,
    Flag = "NewFlySpeed",
    Callback = function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion(Value)
        newFlySpeed = Value
    end,
})

-- 🏎️ Auto Spin (вращает персонажа на месте)
local SpinToggle = MainTab:CreateToggle({
    Name = "🏎️ Auto Spin",
    CurrentValue = false,
    Flag = "SpinToggle",
    Callback = function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion(Value)
        if Value then
            _G.Spin = true
            task.spawn(function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion()
                while _G.Spin do
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        LocalPlayer.Character.HumanoidRootPart.CFrame *= CFrame.Angles(0, math.rad(30), 0)
                    end
                    task.wait(0.05)
                end
            end)
        else
            _G.Spin = false
        end
    end,
})

-- 🎤 Annoying Jump Sound (каждый прыжок играет звук)
local JumpSoundToggle = MainTab:CreateToggle({
    Name = "🎤 Jump Sound",
    CurrentValue = false,
    Flag = "JumpSoundToggle",
    Callback = function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion(Value)
        if Value then
            _G.JumpSound = game:GetService("UserInputService").JumpRequest:Connect(function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion()
                local sound = Instance.new("Sound")
                sound.SoundId = "rbxassetid://12222142" -- смешной звук
                sound.Volume = 5
                sound.Parent = workspace
                sound:Play()
                game.Debris:AddItem(sound, 2)
            end)
        else
            if _G.JumpSound then _G.JumpSound:Disconnect() end
        end
    end,
})

-- 👻 Fake Lag (телепортация вперёд-назад, будто лагаешь)
local FakeLagToggle = MainTab:CreateToggle({
    Name = "👻 Fake Lag",
    CurrentValue = false,
    Flag = "FakeLagToggle",
    Callback = function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion(Value)
        if Value then
            _G.FakeLag = true
            task.spawn(function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion()
                while _G.FakeLag do
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local root = LocalPlayer.Character.HumanoidRootPart
                        root.CFrame = root.CFrame + Vector3.new(0,0,5)
                        task.wait(0.3)
                        root.CFrame = root.CFrame - Vector3.new(0,0,5)
                    end
                    task.wait(0.3)
                end
            end)
        else
            _G.FakeLag = false
        end
    end,
})


-- 🐰 BunnyHop
local BunnyHopToggle = MainTab:CreateToggle({
    Name = "🐰 BunnyHop",
    CurrentValue = false,
    Flag = "BunnyHopToggle",
    Callback = function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion(Value)
        if Value then
            _G.Bhop = true
            local uis = game:GetService("UserInputService")
            task.spawn(function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion()
                while _G.Bhop do
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                        if hum.FloorMaterial ~= Enum.Material.Air then
                            hum:ChangeState("Jumping")
                        end
                    end
                    task.wait(0.2)
                end
            end)
        else
            _G.Bhop = false
        end
    end,
})

-- 🐟 Flop Like Fish (персонаж падает и дрыгается)
local FishToggle = MainTab:CreateToggle({
    Name = "🐟 Flop Like Fish",
    CurrentValue = false,
    Flag = "FishToggle",
    Callback = function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion(Value)
        if Value then
            _G.Fish = true
            task.spawn(function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion()
                while _G.Fish do
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        LocalPlayer.Character.HumanoidRootPart.CFrame *= CFrame.Angles(math.rad(90),0,0)
                    end
                    task.wait(0.2)
                end
            end)
        else
            _G.Fish = false
        end
    end,
})

-- 🎈 Balloon Mode (персонаж подпрыгивает как шарик)
local BalloonToggle = MainTab:CreateToggle({
    Name = "🎈 Balloon Mode",
    CurrentValue = false,
    Flag = "BalloonToggle",
    Callback = function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion(Value)
        if Value then
            _G.Balloon = true
            task.spawn(function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion()
                while _G.Balloon do
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,50,0)
                    end
                    task.wait(1)
                end
            end)
        else
            _G.Balloon = false
        end
    end,
})

-- 🦀 Crab Walk (ходит боком как краб)
local CrabWalkToggle = MainTab:CreateToggle({
    Name = "🦀 Crab Walk",
    CurrentValue = false,
    Flag = "CrabWalkToggle",
    Callback = function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion(Value)
        if Value then
            _G.CrabWalk = true
            task.spawn(function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion()
                while _G.CrabWalk do
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        LocalPlayer.Character.HumanoidRootPart.CFrame *= CFrame.Angles(0, math.rad(90), 0)
                    end
                    task.wait(0.5)
                end
            end)
        else
            _G.CrabWalk = false
        end
    end,
})

-- 📢 OOF Spam (каждый шаг играет "Roblox OOF")
local OOFSpamToggle = MainTab:CreateToggle({
    Name = "📢 OOF Spam",
    CurrentValue = false,
    Flag = "OOFSpamToggle",
    Callback = function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion(Value)
        if Value then
            _G.OOF = true
            task.spawn(function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion()
                while _G.OOF do
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local sound = Instance.new("Sound")
                        sound.SoundId = "rbxassetid://138083993" -- OOF звук
                        sound.Volume = 5
                        sound.Parent = workspace
                        sound:Play()
                        game.Debris:AddItem(sound, 1)
                    end
                    task.wait(0.5)
                end
            end)
        else
            _G.OOF = false
        end
    end,
})

-- 🐸 Shrink & Grow (рандомно меняет размер тела)
local MemeSizeToggle = MainTab:CreateToggle({
    Name = "🐸 Shrink & Grow",
    CurrentValue = false,
    Flag = "MemeSizeToggle",
    Callback = function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion(Value)
        if Value then
            _G.SizeMeme = true
            task.spawn(function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion()
                while _G.SizeMeme do
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                        local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
                        hum.BodyHeightScale.Value = math.random(5,15)/10
                        hum.BodyWidthScale.Value = math.random(5,15)/10
                        hum.BodyDepthScale.Value = math.random(5,15)/10
                    end
                    task.wait(1)
                end
            end)
        else
            _G.SizeMeme = false
        end
    end,
})

-- 🚀 YEET Jump (смешной гиперпрыжок с криком)
local YeetToggle = MainTab:CreateToggle({
    Name = "🚀 YEET Jump",
    CurrentValue = false,
    Flag = "YeetToggle",
    Callback = function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion(Value)
        if Value then
            _G.Yeet = game:GetService("UserInputService").JumpRequest:Connect(function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local root = LocalPlayer.Character.HumanoidRootPart
                    root.Velocity = Vector3.new(0,200,0)
                    local sound = Instance.new("Sound")
                    sound.SoundId = "rbxassetid://1847853096" -- YEET
                    sound.Volume = 10
                    sound.Parent = workspace
                    sound:Play()
                    game.Debris:AddItem(sound, 2)
                end
            end)
        else
            if _G.Yeet then _G.Yeet:Disconnect() end
        end
    end,
})

-- 🌀 Head Spin (вращение головы)
local HeadSpinToggle = MainTab:CreateToggle({
    Name = "🌀 Head Spin",
    CurrentValue = false,
    Flag = "HeadSpinToggle",
    Callback = function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion(Value)
        if Value then
            _G.HeadSpin = true
            task.spawn(function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion()
                while _G.HeadSpin do
                    local char = LocalPlayer.Character
                    if char and char:FindFirstChild("Head") then
                        char.Head.CFrame *= CFrame.Angles(0, math.rad(45), 0)
                    end
                    task.wait(0.1)
                end
            end)
        else
            _G.HeadSpin = false
        end
    end,
})

-- 🎲 Random Teleport
local RandomTPToggle = MainTab:CreateToggle({
    Name = "🎲 Random Teleport",
    CurrentValue = false,
    Flag = "RandomTPToggle",
    Callback = function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion(Value)
        if Value then
            _G.RandomTP = true
            task.spawn(function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion()
                while _G.RandomTP do
                    local char = LocalPlayer.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    if root then
                        root.CFrame = CFrame.new(math.random(-100,100), math.random(5,50), math.random(-100,100))
                    end
                    task.wait(3)
                end
            end)
        else
            _G.RandomTP = false
        end
    end,
})

-- 🔄 Fake Gravity Flip
local GravityFlipToggle = MainTab:CreateToggle({
    Name = "🔄 Gravity Flip",
    CurrentValue = false,
    Flag = "GravityFlipToggle",
    Callback = function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion(Value)
        if Value then
            _G.GravityFlip = true
            task.spawn(function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion()
                while _G.GravityFlip do
                    local char = LocalPlayer.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        local root = char.HumanoidRootPart
                        root.CFrame = root.CFrame * CFrame.Angles(math.rad(180),0,0)
                    end
                    task.wait(2)
                end
            end)
        else
            _G.GravityFlip = false
        end
    end,
})

-- 😂 Laugh Spam
local LaughSpamToggle = MainTab:CreateToggle({
    Name = "😂 Laugh Spam",
    CurrentValue = false,
    Flag = "LaughSpamToggle",
    Callback = function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion(Value)
        if Value then
            _G.LaughSpam = true
            task.spawn(function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion()
                while _G.LaughSpam do
                    game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer("HAHAHA", "All")
                    task.wait(1)
                end
            end)
        else
            _G.LaughSpam = false
        end
    end,
})

-- 🌙 Moon Gravity
local MoonGravityToggle = MainTab:CreateToggle({
    Name = "🌙 Moon Gravity",
    CurrentValue = false,
    Flag = "MoonGravityToggle",
    Callback = function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion(Value)
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.UseJumpPower = true
            hum.JumpPower = Value and 150 or 50
            hum.GravityScale = Value and 0.3 or 1 -- низкая гравитация
        end
    end,
})

-- 🧠 Big Head Mode
local BigHeadToggle = MainTab:CreateToggle({
    Name = "🧠 Big Head Mode",
    CurrentValue = false,
    Flag = "BigHeadToggle",
    Callback = function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion(Value)
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Head") then
            char.Head.Size = Value and Vector3.new(6,6,6) or Vector3.new(2,2,2)
        end
    end,
})

-- 🦵 Tiny Legs Mode
local TinyLegsToggle = MainTab:CreateToggle({
    Name = "🦵 Tiny Legs Mode",
    CurrentValue = false,
    Flag = "TinyLegsToggle",
    Callback = function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion(Value)
        local char = LocalPlayer.Character
        if char then
            for _, limb in pairs({"LeftLeg","RightLeg"}) do
                local part = char:FindFirstChild(limb)
                if part then
                    part.Size = Value and Vector3.new(0.5,0.5,0.5) or Vector3.new(1,2,1)
                end
            end
        end
    end,
})

-- 🌀 Spinning Arms
local SpinArmsToggle = MainTab:CreateToggle({
    Name = "🌀 Spinning Arms",
    CurrentValue = false,
    Flag = "SpinArmsToggle",
    Callback = function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion(Value)
        _G.SpinArms = Value
        task.spawn(function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion()
            while _G.SpinArms do
                local char = LocalPlayer.Character
                for _, limb in pairs({"LeftUpperArm","RightUpperArm","LeftLowerArm","RightLowerArm"}) do
                    local part = char and char:FindFirstChild(limb)
                    if part then
                        part.CFrame *= CFrame.Angles(0, math.rad(30), 0)
                    end
                end
                task.wait(0.05)
            end
        end)
    end,
})

-- 🔄 Invert Controls
local InvertControlsToggle = MainTab:CreateToggle({
    Name = "🔄 Invert Controls",
    CurrentValue = false,
    Flag = "InvertControlsToggle",
    Callback = function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion(Value)
        _G.InvertControls = Value
        local uis = game:GetService("UserInputService")
        if Value then
            uis.InputBegan:Connect(function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion(input)
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    -- блокируем стандартное управление и делаем обратное
                    -- здесь можно вставить твою логику для инвертирования
                end
            end)
        end
    end,
})

-- 🎲 Random Size Change
local RandomSizeToggle = MainTab:CreateToggle({
    Name = "🎲 Random Size Change",
    CurrentValue = false,
    Flag = "RandomSizeToggle",
    Callback = function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion(Value)
        _G.RandomSize = Value
        task.spawn(function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion()
            while _G.RandomSize do
                local char = LocalPlayer.Character
                if char and char:FindFirstChildOfClass("Humanoid") then
                    local scale = math.random(5,20)/10
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    hum.BodyHeightScale.Value = scale
                    hum.BodyWidthScale.Value = scale
                    hum.BodyDepthScale.Value = scale
                end
                task.wait(2)
            end
        end)
    end,
})

-- 🎥 Shake Camera
local ShakeCameraToggle = MainTab:CreateToggle({
    Name = "🎥 Shake Camera",
    CurrentValue = false,
    Flag = "ShakeCameraToggle",
    Callback = function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion(Value)
        _G.ShakeCamera = Value
        task.spawn(function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion()
            local cam = workspace.CurrentCamera
            while _G.ShakeCamera do
                cam.CFrame = cam.CFrame * CFrame.new(math.random(-1,1)/5, math.random(-1,1)/5, 0)
                task.wait(0.05)
            end
        end)
    end,
})

-- 🌀 Spinning Body
local SpinBodyToggle = MainTab:CreateToggle({
    Name = "🌀 Spinning Body",
    CurrentValue = false,
    Flag = "SpinBodyToggle",
    Callback = function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion(Value)
        _G.SpinBody = Value
        task.spawn(function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion()
            while _G.SpinBody do
                local char = LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if root then
                    root.CFrame *= CFrame.Angles(0, math.rad(45), 0)
                end
                task.wait(0.05)
            end
        end)
    end,
})

-- 🔥 Insta Kill / One Hit
local InstaKillToggle = MainTab:CreateToggle({
    Name = "🔥 Insta Kill",
    CurrentValue = false,
    Flag = "InstaKillToggle",
    Callback = function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion(Value)
        _G.InstaKill = Value
        task.spawn(function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion()
            while _G.InstaKill do
                for _, player in pairs(game.Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
                        player.Character.Humanoid.Health = 0
                    end
                end
                task.wait(0.1)
            end
        end)
    end,
})

-- 🚀 Teleport Dash (мгновенный рывок вперёд)
local TeleportDashToggle = MainTab:CreateToggle({
    Name = "🚀 Teleport Dash",
    CurrentValue = false,
    Flag = "TeleportDashToggle",
    Callback = function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion(Value)
        _G.TeleportDash = Value
        local uis = game:GetService("UserInputService")
        uis.InputBegan:Connect(function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion(input)
            if _G.TeleportDash and input.KeyCode == Enum.KeyCode.LeftShift then
                local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    root.CFrame = root.CFrame + root.CFrame.LookVector * 50
                end
            end
        end)
    end,
})

-- 💨 Speed Burst
local SpeedBurstToggle = MainTab:CreateToggle({
    Name = "💨 Speed Burst",
    CurrentValue = false,
    Flag = "SpeedBurstToggle",
    Callback = function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion(Value)
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = Value and 100 or 16
        end
    end,
})

-- 🛡️ God Mode (неуязвимость)
local GodModeToggle = MainTab:CreateToggle({
    Name = "🛡️ God Mode",
    CurrentValue = false,
    Flag = "GodModeToggle",
    Callback = function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion(Value)
        _G.GodMode = Value
        local char = LocalPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            local hum = char:FindFirstChildOfClass("Humanoid")
            hum.MaxHealth = Value and math.huge or 100
            hum.Health = hum.MaxHealth
        end
    end,
})

-- 🧲 Magnet Loot (подтаскивает предметы к тебе)
local MagnetLootToggle = MainTab:CreateToggle({
    Name = "🧲 Magnet Loot",
    CurrentValue = false,
    Flag = "MagnetLootToggle",
    Callback = function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion(Value)
        _G.MagnetLoot = Value
        task.spawn(function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion()
            while _G.MagnetLoot do
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and obj.Name:match("Loot") then
                        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if root then
                            obj.Position = root.Position + Vector3.new(0,2,0)
                        end
                    end
                end
                task.wait(0.1)
            end
        end)
    end,
})

-- Функция WallHop
function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion WallhopToggle()
    Name = "🧱 WallHop",
    CurrentValue = false,
    Flag = "WallhopToggle",
    Callback = function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion(Value)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    -- Имитация прыжка вверх и вперёд (отталкивание от стены)
    humanoidRootPart.Velocity = Vector3.new(0, 50, 0) + humanoidRootPart.CFrame.LookVector * 30
end


local MovementSection = MainTab:CreateSection("Movement Features")



-- Noclip Function
local noclip = false
local noclipConnection

local NoclipToggle = MainTab:CreateToggle({
    Name = "👻 Noclip",
    CurrentValue = false,
    Flag = "NoclipToggle",
    Callback = function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion(Value)
        noclip = Value
        if noclip then
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
            
            noclipConnection = RunService.Stepped:Connect(function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion()
                if noclip and LocalPlayer.Character then
                    for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            if noclipConnection then noclipConnection:Disconnect() end
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end,
})

-- Speed Hack
local SpeedHackSlider = MainTab:CreateSlider({
    Name = "💨 WalkSpeed",
    Range = {16, 200},
    Increment = 5,
    Suffix = "studs",
    CurrentValue = 16,
    Flag = "SpeedHack",
    Callback = function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion(Value)
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = Value
            end
        end
    end,
})

-- JumpPower
local JumpPowerSlider = MainTab:CreateSlider({
    Name = "🦘 JumpPower",
    Range = {50, 500},
    Increment = 10,
    Suffix = "power",
    CurrentValue = 50,
    Flag = "JumpPower",
    Callback = function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion(Value)
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.JumpPower = Value
            end
        end
    end,
})

-- Infinite Jump
local infiniteJump = false

local InfiniteJumpToggle = MainTab:CreateToggle({
    Name = "∞ Infinite Jump",
    CurrentValue = false,
    Flag = "InfiniteJump",
    Callback = function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion(Value)
        infiniteJump = Value
    end,
})

UserInputService.JumpRequest:Connect(function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion()
    if infiniteJump and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid:GetState() ~= Enum.HumanoidStateType.Dead then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Раздел Combat
local CombatSection = MainTab:CreateSection("Combat Features")

-- God Mode
local GodModeToggle = MainTab:CreateToggle({
    Name = "🛡️ God Mode",
    CurrentValue = false,
    Flag = "GodMode",
    Callback = function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion(Value)
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                if Value then
                    humanoid.MaxHealth = math.huge
                    humanoid.Health = math.huge
                else
                    humanoid.MaxHealth = 100
                    humanoid.Health = 100
                end
            end
        end
    end,
})

-- Kill All Players
local KillAllButton = MainTab:CreateButton({
    Name = "💀 Kill All Players",
    Callback = function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion()
        Rayfield:Notify({
            Title = "Kill All",
            Content = "Attempting to kill all players...",
            Duration = 3,
        })
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.Health = 0
                end
            end
        end
    end,
})

-- Aimbot
local aimbotEnabled = false
local aimbotTarget = nil

local AimbotToggle = MainTab:CreateToggle({
    Name = "🎯 Aimbot",
    CurrentValue = false,
    Flag = "Aimbot",
    Callback = function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion(Value)
        aimbotEnabled = Value
        if aimbotEnabled then
            Rayfield:Notify({
                Title = "Aimbot Activated",
                Content = "Looking for closest player...",
                Duration = 3,
            })
        end
    end,
})

-- Вкладка Teleport (ИСПРАВЛЕННАЯ)
local TeleportTab = Window:CreateTab("Teleport", 4483353530)

-- Player list for teleport
local playerList = {}
local function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion updatePlayerList()
    playerList = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(playerList, player.Name)
        end
    end
end

updatePlayerList()
Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)

-- Teleport to Player (FIXED)
local playerDropdown = TeleportTab:CreateDropdown({
    Name = "👤 Select Player",
    Options = playerList,
    CurrentOption = playerList[1] or "No players",
    Flag = "PlayerDropdown",
    Callback = function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion(Option)
        -- Just store selection
    end,
})

local TeleportButton = TeleportTab:CreateButton({
    Name = "📡 Teleport to Player",
    Callback = function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion()
        local targetName = playerDropdown.CurrentOption
        if targetName and targetName ~= "No players" then
            local targetPlayer = Players:FindFirstChild(targetName)
            if targetPlayer and targetPlayer.Character then
                local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                local localRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                
                if targetRoot and localRoot then
                    localRoot.CFrame = targetRoot.CFrame
                    Rayfield:Notify({
                        Title = "Teleported!",
                        Content = "Teleported to " .. targetName,
                        Duration = 3,
                    })
                end
            end
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "No player selected or no players online",
                Duration = 3,
            })
        end
    end,
})

-- Bring Player
local BringButton = TeleportTab:CreateButton({
    Name = "📥 Bring Player to You",
    Callback = function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion()
        local targetName = playerDropdown.CurrentOption
        if targetName and targetName ~= "No players" then
            local targetPlayer = Players:FindFirstChild(targetName)
            local localRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            
            if targetPlayer and targetPlayer.Character and localRoot then
                local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                if targetRoot then
                    targetRoot.CFrame = localRoot.CFrame
                    Rayfield:Notify({
                        Title = "Player Brought!",
                        Content = "Brought " .. targetName .. " to you",
                        Duration = 3,
                    })
                end
            end
        end
    end,
})

-- Teleport to Coordinates
local XInput = TeleportTab:CreateInput({
    Name = "X Coordinate",
    PlaceholderText = "0",
    RemoveTextAfterFocusLost = false,
    Callback = function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion(Text) end,
})

local YInput = TeleportTab:CreateInput({
    Name = "Y Coordinate",
    PlaceholderText = "0",
    RemoveTextAfterFocusLost = false,
    Callback = function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion(Text) end,
})

local ZInput = TeleportTab:CreateInput({
    Name = "Z Coordinate",
    PlaceholderText = "0",
    RemoveTextAfterFocusLost = false,
    Callback = function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion(Text) end,
})

local TeleportCoordButton = TeleportTab:CreateButton({
    Name = "📍 Teleport to Coordinates",
    Callback = function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion()
        local x = tonumber(XInput.Value) or 0
        local y = tonumber(YInput.Value) or 0
        local z = tonumber(ZInput.Value) or 0
        
        local localRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if localRoot then
            localRoot.CFrame = CFrame.new(x, y, z)
            Rayfield:Notify({
                Title = "Teleported!",
                Content = string.format("Teleported to (%d, %d, %d)", x, y, z),
                Duration = 3,
            })
        end
    end,
})

-- Teleport to Spawn
local SpawnButton = TeleportTab:CreateButton({
    Name = "🏠 Teleport to Spawn",
    Callback = function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion()
        local localRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if localRoot then
            localRoot.CFrame = CFrame.new(0, 100, 0)
            Rayfield:Notify({
                Title = "Teleported to Spawn",
                Content = "Teleported to default spawn location",
                Duration = 3,
            })
        end
    end,
})

-- Вкладка Visuals
local VisualsTab = Window:CreateTab("Visuals", 4483345990)

-- ESP
local espEnabled = false
local espHighlights = {}

local ESPToggle = VisualsTab:CreateToggle({
    Name = "👁️ Player ESP",
    CurrentValue = false,
    Flag = "ESP",
    Callback = function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion(Value)
        espEnabled = Value
        if espEnabled then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    espCreate(player)
                end
            end
        else
            for _, highlight in pairs(espHighlights) do
                highlight:Destroy()
            end
            espHighlights = {}
        end
    end,
})

function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion espCreate(player)
    local character = player.Character or player.CharacterAdded:Wait()
    local highlight = Instance.new("Highlight")
    highlight.Parent = character
    highlight.Adornee = character
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.5
    table.insert(espHighlights, highlight)
end

-- Fullbright
local FullbrightToggle = VisualsTab:CreateToggle({
    Name = "💡 Fullbright",
    CurrentValue = false,
    Flag = "Fullbright",
    Callback = function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion(Value)
        if Value then
            Lighting.Ambient = Color3.new(1, 1, 1)
            Lighting.Brightness = 2
            Lighting.GlobalShadows = false
        else
            Lighting.Ambient = Color3.new(0, 0, 0)
            Lighting.Brightness = 1
            Lighting.GlobalShadows = true
        end
    end,
})

-- X-Ray
local XRayToggle = VisualsTab:CreateToggle({
    Name = "🔍 X-Ray Vision",
    CurrentValue = false,
    Flag = "XRay",
    Callback = function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion(Value)
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.CameraOffset = Value and Vector3.new(0, 0, -10) or Vector3.new(0, 0, 0)
            end
        end
    end,
})

-- Вкладка Misc
local MiscTab = Window:CreateTab("Miscellaneous", 4483344167)

-- Anti AFK
local AntiAfkToggle = MiscTab:CreateToggle({
    Name = "⏰ Anti AFK",
    CurrentValue = false,
    Flag = "AntiAFK",
    Callback = function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion(Value)
        if Value then
            LocalPlayer.Idled:Connect(function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion()
                game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
                wait(1)
                game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
            end)
        end
    end,
})

-- Server Hop
local ServerHopButton = MiscTab:CreateButton({
    Name = "🔄 Server Hop",
    Callback = function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion()
        Rayfield:Notify({
            Title = "Server Hop",
            Content = "Searching for new server...",
            Duration = 3,
        })
        
        local servers = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100"))
        for _, server in pairs(servers.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id)
                break
            end
        end
    end,
})

-- FPS Boost
local FPSBoostButton = MiscTab:CreateButton({
    Name = "⚡ FPS Boost",
    Callback = function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion()
        settings().Rendering.QualityLevel = 1
        for _, light in pairs(workspace:GetDescendants()) do
            if light:IsA("PointLight") or light:IsA("SpotLight") then
                light.Enabled = false
            end
        end
        
        Rayfield:Notify({
            Title = "FPS Boost Applied",
            Content = "Graphics optimized for maximum FPS",
            Duration = 3,
        })
    end,
})

-- Reset Character
local ResetButton = MiscTab:CreateButton({
    Name = "🔁 Reset Character",
    Callback = function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion()
        if LocalPlayer.Character then
            LocalPlayer.Character:BreakJoints()
        end
    end,
})

-- Aimbot loop
RunService.Heartbeat:Connect(function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion()
    if aimbotEnabled then
        local closestPlayer = nil
        local closestDistance = math.huge
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
                local localRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                
                if rootPart and localRoot then
                    local distance = (rootPart.Position - localRoot.Position).Magnitude
                    if distance < closestDistance then
                        closestDistance = distance
                        closestPlayer = player
                    end
                end
            end
        end
        
        if closestPlayer then
            local targetRoot = closestPlayer.Character:FindFirstChild("HumanoidRootPart")
            local localRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            
            if targetRoot and localRoot then
                workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, targetRoot.Position)
            end
        end
    end
end)

-- Уведомление о загрузке
Rayfield:Notify({
    Title = "Turbo Script v2.0 Loaded! 🚀",
    Content = "Fixed Fly + WallHop + New Features!",
    Duration = 6,
    Image = 4483362458,
})

-- Автоматическая очистка
game:GetService("UserInputService").WindowFocusReleased:Connect(function()
                if newFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection += rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection -= rootPart.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection -= rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection += rootPart.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection -= Vector3.new(0, 1, 0)
                    end

                    if moveDirection.Magnitude > 0 then
                        newFlyBodyVel.Velocity = moveDirection.Unit * newFlySpeed
                    else
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                else
                    if newFlyBodyVel then
                        newFlyBodyVel.Velocity = Vector3.zero
                    end
                end
            endion()
    if flying then
        flying = false
        if flyConnection then flyConnection:Disconnect() end
    end
end)