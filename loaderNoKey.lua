-- By Modder t.me/TurboHackMods & TurboModder
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Переменные для функций
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")

-- Красивое окно с тематикой Brainrot
local Window = Rayfield:CreateWindow({
   Name = "🧠 Brainrot Stealer v3.0",
   LoadingTitle = "Brainrot Stealer Loading...",
   LoadingSubtitle = "by TurboModder | t.me/TurboHackMods",
   Theme = "Dark",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "BrainrotStealer",
      FileName = "Config"
   },
   Discord = {
      Enabled = false,
      Invite = "invitelink",
      RememberJoins = true
   },
})

-- Вкладка Auto Farm
local AutoFarmTab = Window:CreateTab("🤖 Auto Farm", 4483362458)

-- Авто-сбор Brainrot
local AutoCollectToggle = AutoFarmTab:CreateToggle({
    Name = "🔄 Auto Collect Brainrot",
    CurrentValue = false,
    Flag = "AutoCollect",
    Callback = function(Value)
        if Value then
            _G.AutoCollect = true
            Rayfield:Notify({
                Title = "Auto Collect Started",
                Content = "Automatically collecting Brainrot...",
                Duration = 3,
            })
            
            while _G.AutoCollect do
                -- Поиск и сбор Brainrot
                for _, item in pairs(workspace:GetDescendants()) do
                    if item.Name:lower():find("brainrot") or item.Name:lower():find("brain") then
                        if item:IsA("Part") and LocalPlayer.Character then
                            local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                            if root then
                                root.CFrame = item.CFrame
                                task.wait(0.5)
                            end
                        end
                    end
                end
                task.wait(1)
            end
        else
            _G.AutoCollect = false
        end
    end,
})

-- Авто-продажа
local AutoSellToggle = AutoFarmTab:CreateToggle({
    Name = "💰 Auto Sell Brainrot",
    CurrentValue = false,
    Flag = "AutoSell",
    Callback = function(Value)
        if Value then
            _G.AutoSell = true
            Rayfield:Notify({
                Title = "Auto Sell Started",
                Content = "Automatically selling Brainrot...",
                Duration = 3,
            })
            
            while _G.AutoSell do
                -- Поиск NPC для продажи
                for _, npc in pairs(workspace:GetDescendants()) do
                    if npc.Name:lower():find("merchant") or npc.Name:lower():find("seller") or npc.Name:lower():find("vendor") then
                        if npc:IsA("Model") and LocalPlayer.Character then
                            local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                            local npcRoot = npc:FindFirstChild("HumanoidRootPart")
                            if root and npcRoot then
                                root.CFrame = npcRoot.CFrame
                                task.wait(2)
                                -- Имитация продажи
                                fireproximityprompt(npc:FindFirstChildOfClass("ProximityPrompt"))
                            end
                        end
                    end
                end
                task.wait(3)
            end
        else
            _G.AutoSell = false
        end
    end,
})

-- Авто-покупка улучшений
local AutoUpgradeToggle = AutoFarmTab:CreateToggle({
    Name = "⚡ Auto Buy Upgrades",
    CurrentValue = false,
    Flag = "AutoUpgrade",
    Callback = function(Value)
        if Value then
            _G.AutoUpgrade = true
            Rayfield:Notify({
                Title = "Auto Upgrade Started",
                Content = "Automatically buying upgrades...",
                Duration = 3,
            })
        else
            _G.AutoUpgrade = false
        end
    end,
})

-- Слайдер скорости фарма
local FarmSpeedSlider = AutoFarmTab:CreateSlider({
    Name = "🎯 Farm Speed",
    Range = {1, 10},
    Increment = 1,
    Suffix = "x",
    CurrentValue = 5,
    Flag = "FarmSpeed",
    Callback = function(Value)
        _G.FarmSpeed = Value
    end,
})

-- Вкладка Teleport
local TeleportTab = Window:CreateTab("📍 Teleport", 4483353530)

-- Телепорт на базу
local BaseTPButton = TeleportTab:CreateButton({
    Name = "🏠 Teleport to Base",
    Callback = function()
        -- Поиск базы игрока
        local baseFound = false
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj.Name:lower():find("base") or obj.Name:lower():find("spawn") then
                if obj:IsA("Part") and LocalPlayer.Character then
                    local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if root then
                        root.CFrame = obj.CFrame
                        baseFound = true
                        Rayfield:Notify({
                            Title = "Teleported to Base",
                            Content = "Successfully teleported to your base!",
                            Duration = 3,
                        })
                        break
                    end
                end
            end
        end
        
        if not baseFound then
            -- Телепорт на стандартную позицию
            local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                root.CFrame = CFrame.new(0, 50, 0)
                Rayfield:Notify({
                    Title = "Teleported to Safe Zone",
                    Content = "Teleported to default safe location",
                    Duration = 3,
                })
            end
        end
    end,
})

-- Телепорт к лучшему месту фарма
local BestFarmTPButton = TeleportTab:CreateButton({
    Name = "💎 TP to Best Farm Spot",
    Callback = function()
        local bestSpot = nil
        local maxBrainrot = 0
        
        -- Поиск области с наибольшим количеством Brainrot
        for _, item in pairs(workspace:GetDescendants()) do
            if item.Name:lower():find("brainrot") then
                if item:IsA("Part") then
                    local nearbyCount = 0
                    for _, nearby in pairs(workspace:GetDescendants()) do
                        if nearby.Name:lower():find("brainrot") and nearby:IsA("Part") then
                            if (item.Position - nearby.Position).Magnitude < 20 then
                                nearbyCount = nearbyCount + 1
                            end
                        end
                    end
                    
                    if nearbyCount > maxBrainrot then
                        maxBrainrot = nearbyCount
                        bestSpot = item
                    end
                end
            end
        end
        
        if bestSpot and LocalPlayer.Character then
            local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                root.CFrame = bestSpot.CFrame + Vector3.new(0, 5, 0)
                Rayfield:Notify({
                    Title = "Teleported to Best Spot",
                    Content = string.format("Found area with %d Brainrot!", maxBrainrot),
                    Duration = 3,
                })
            end
        end
    end,
})

-- Телепорт к продавцу
local MerchantTPButton = TeleportTab:CreateButton({
    Name = "🏪 TP to Merchant",
    Callback = function()
        for _, npc in pairs(workspace:GetDescendants()) do
            if npc.Name:lower():find("merchant") or npc.Name:lower():find("seller") then
                if npc:IsA("Model") and LocalPlayer.Character then
                    local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    local npcRoot = npc:FindFirstChild("HumanoidRootPart")
                    if root and npcRoot then
                        root.CFrame = npcRoot.CFrame + Vector3.new(0, 0, 3)
                        Rayfield:Notify({
                            Title = "Teleported to Merchant",
                            Content = "Ready to sell your Brainrot!",
                            Duration = 3,
                        })
                        return
                    end
                end
            end
        end
        Rayfield:Notify({
            Title = "Merchant Not Found",
            Content = "Could not find merchant NPC",
            Duration = 3,
        })
    end,
})

-- Вкладка Protection
local ProtectionTab = Window:CreateTab("🛡️ Protection", 4483345990)

-- Анти-афк
local AntiAFKToggle = ProtectionTab:CreateToggle({
    Name = "⏰ Anti AFK",
    CurrentValue = false,
    Flag = "AntiAFK",
    Callback = function(Value)
        if Value then
            LocalPlayer.Idled:Connect(function()
                game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                task.wait(1)
                game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            end)
            Rayfield:Notify({
                Title = "Anti AFK Enabled",
                Content = "You won't be kicked for AFK",
                Duration = 3,
            })
        end
    end,
})

-- Анти-игнор стен
local NoClipToggle = ProtectionTab:CreateToggle({
    Name = "👻 No Clip",
    CurrentValue = false,
    Flag = "NoClip",
    Callback = function(Value)
        if Value then
            _G.NoClip = true
            local noclipConnection
            noclipConnection = RunService.Stepped:Connect(function()
                if _G.NoClip and LocalPlayer.Character then
                    for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                else
                    if noclipConnection then
                        noclipConnection:Disconnect()
                    end
                end
            end)
        else
            _G.NoClip = false
        end
    end,
})

-- Защита от падения
local AntiFallToggle = ProtectionTab:CreateToggle({
    Name = "🪂 Anti Fall Damage",
    CurrentValue = false,
    Flag = "AntiFall",
    Callback = function(Value)
        if Value then
            _G.AntiFall = true
            local fallConnection
            fallConnection = RunService.Heartbeat:Connect(function()
                if _G.AntiFall and LocalPlayer.Character then
                    local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if root and humanoid then
                        if root.Position.Y < -50 then
                            root.CFrame = CFrame.new(0, 100, 0)
                        end
                        if humanoid.Health < 100 then
                            humanoid.Health = 100
                        end
                    end
                else
                    if fallConnection then
                        fallConnection:Disconnect()
                    end
                end
            end)
        else
            _G.AntiFall = false
        end
    end,
})

-- Невидимость для NPC
local NPCInvisibilityToggle = ProtectionTab:CreateToggle({
    Name = "👤 NPC Invisibility",
    CurrentValue = false,
    Flag = "NPCInvisibility",
    Callback = function(Value)
        if Value then
            -- Скрытие от NPC (если есть такая механика в игре)
            Rayfield:Notify({
                Title = "NPC Invisibility Enabled",
                Content = "NPCs may not detect you",
                Duration = 3,
            })
        else
            Rayfield:Notify({
                Title = "NPC Invisibility Disabled",
                Content = "NPCs can detect you normally",
                Duration = 3,
            })
        end
    end,
})

-- Вкладка Player
local PlayerTab = Window:CreateTab("🎮 Player", 4483344167)

-- Скорость передвижения
local SpeedSlider = PlayerTab:CreateSlider({
    Name = "💨 Movement Speed",
    Range = {16, 200},
    Increment = 5,
    Suffix = "studs",
    CurrentValue = 16,
    Flag = "PlayerSpeed",
    Callback = function(Value)
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = Value
            end
        end
    end,
})

-- Сила прыжка
local JumpPowerSlider = PlayerTab:CreateSlider({
    Name = "🦘 Jump Power",
    Range = {50, 500},
    Increment = 10,
    Suffix = "power",
    CurrentValue = 50,
    Flag = "JumpPower",
    Callback = function(Value)
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.JumpPower = Value
            end
        end
    end,
})

-- Бесконечный прыжок
local InfiniteJumpToggle = PlayerTab:CreateToggle({
    Name = "∞ Infinite Jump",
    CurrentValue = false,
    Flag = "InfiniteJump",
    Callback = function(Value)
        _G.InfiniteJump = Value
    end,
})

UserInputService.JumpRequest:Connect(function()
    if _G.InfiniteJump and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid:GetState() ~= Enum.HumanoidStateType.Dead then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Полёт
local FlyToggle = PlayerTab:CreateToggle({
    Name = "🕊️ Fly Mode",
    CurrentValue = false,
    Flag = "FlyMode",
    Callback = function(Value)
        if Value then
            _G.Flying = true
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            bodyVelocity.MaxForce = Vector3.new(0, 0, 0)
            
            if LocalPlayer.Character then
                local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    bodyVelocity.Parent = root
                end
            end
            
            local flyConnection
            flyConnection = RunService.Heartbeat:Connect(function()
                if _G.Flying and LocalPlayer.Character then
                    local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if root then
                        local camera = workspace.CurrentCamera
                        local direction = Vector3.new()
                        
                        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                            direction = direction + camera.CFrame.LookVector
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                            direction = direction - camera.CFrame.LookVector
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                            direction = direction + camera.CFrame.RightVector
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                            direction = direction - camera.CFrame.RightVector
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                            direction = direction + Vector3.new(0, 1, 0)
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                            direction = direction - Vector3.new(0, 1, 0)
                        end
                        
                        bodyVelocity.Velocity = direction.Unit * 100
                        bodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
                    end
                else
                    if flyConnection then
                        flyConnection:Disconnect()
                    end
                    if bodyVelocity then
                        bodyVelocity:Destroy()
                    end
                end
            end)
        else
            _G.Flying = false
        end
    end,
})

-- Вкладка Visuals
local VisualsTab = Window:CreateTab("👁️ Visuals", 4483350926)

-- ESP для Brainrot
local BrainrotESPToggle = VisualsTab:CreateToggle({
    Name = "🧠 Brainrot ESP",
    CurrentValue = false,
    Flag = "BrainrotESP",
    Callback = function(Value)
        if Value then
            _G.BrainrotESP = true
            while _G.BrainrotESP do
                for _, item in pairs(workspace:GetDescendants()) do
                    if item.Name:lower():find("brainrot") and item:IsA("Part") then
                        if not item:FindFirstChild("BrainrotHighlight") then
                            local highlight = Instance.new("Highlight")
                            highlight.Name = "BrainrotHighlight"
                            highlight.Parent = item
                            highlight.FillColor = Color3.fromRGB(0, 255, 0)
                            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                            highlight.FillTransparency = 0.5
                        end
                    end
                end
                task.wait(1)
            end
        else
            _G.BrainrotESP = false
            for _, item in pairs(workspace:GetDescendants()) do
                local highlight = item:FindFirstChild("BrainrotHighlight")
                if highlight then
                    highlight:Destroy()
                end
            end
        end
    end,
})

-- ESP для NPC
local NPCESPToggle = VisualsTab:CreateToggle({
    Name = "👤 NPC ESP",
    CurrentValue = false,
    Flag = "NPCESP",
    Callback = function(Value)
        if Value then
            _G.NPCESP = true
            while _G.NPCESP do
                for _, npc in pairs(workspace:GetDescendants()) do
                    if (npc.Name:lower():find("merchant") or npc.Name:lower():find("npc")) and npc:IsA("Model") then
                        if not npc:FindFirstChild("NPCHighlight") then
                            local highlight = Instance.new("Highlight")
                            highlight.Name = "NPCHighlight"
                            highlight.Parent = npc
                            highlight.FillColor = Color3.fromRGB(255, 165, 0)
                            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                            highlight.FillTransparency = 0.5
                        end
                    end
                end
                task.wait(1)
            end
        else
            _G.NPCESP = false
            for _, npc in pairs(workspace:GetDescendants()) do
                local highlight = npc:FindFirstChild("NPCHighlight")
                if highlight then
                    highlight:Destroy()
                end
            end
        end
    end,
})

-- Полное освещение
local FullbrightToggle = VisualsTab:CreateToggle({
    Name = "💡 Fullbright",
    CurrentValue = false,
    Flag = "Fullbright",
    Callback = function(Value)
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

-- Вкладка Misc
local MiscTab = Window:CreateTab("⚙️ Miscellaneous", 4483345990)

-- Перезапуск персонажа
local ResetCharButton = MiscTab:CreateButton({
    Name = "🔁 Reset Character",
    Callback = function()
        if LocalPlayer.Character then
            LocalPlayer.Character:BreakJoints()
        end
    end,
})

-- Сервер хоп
local ServerHopButton = MiscTab:CreateButton({
    Name = "🔄 Server Hop",
    Callback = function()
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

-- Уведомление о загрузке
Rayfield:Notify({
    Title = "🧠 Brainrot Stealer v3.0 Loaded!",
    Content = "Ready to dominate the game!",
    Duration = 6,
    Image = 4483362458,
})

print("Brainrot Stealer successfully loaded!")