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
local MarketplaceService = game:GetService("MarketplaceService")

-- Красивое окно
local Window = Rayfield:CreateWindow({
   Name = "🧠 ULTIMATE BRAINROT STEALER",
   LoadingTitle = "Loading Ultimate Brainrot Stealer...",
   LoadingSubtitle = "by TurboModder | t.me/TurboHackMods",
   Theme = "Dark",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "BrainrotStealer",
      FileName = "Config"
   },
})

-- Вкладка Auto Farm
local AutoFarmTab = Window:CreateTab("🤖 Auto Farm", 4483362458)

-- Авто-сбор Brainrot (ИСПРАВЛЕННЫЙ)
local AutoCollectToggle = AutoFarmTab:CreateToggle({
    Name = "🔄 Auto Collect Brainrot",
    CurrentValue = false,
    Flag = "AutoCollect",
    Callback = function(Value)
        _G.AutoCollect = Value
        if Value then
            Rayfield:Notify({
                Title = "Auto Collect Started",
                Content = "Automatically collecting Brainrot...",
                Duration = 3,
            })
            
            coroutine.wrap(function()
                while _G.AutoCollect and LocalPlayer.Character do
                    local character = LocalPlayer.Character
                    local root = character:FindFirstChild("HumanoidRootPart")
                    if not root then break end
                    
                    -- Поиск Brainrot
                    local brainrots = {}
                    for _, item in pairs(workspace:GetDescendants()) do
                        if item:IsA("Part") and (item.Name:lower():find("brainrot") or item.Name:lower():find("brain") or item.Name:lower():find("coin") or item.Name:lower():find("money")) then
                            table.insert(brainrots, item)
                        end
                    end
                    
                    if #brainrots > 0 then
                        -- Сортировка по расстоянию
                        table.sort(brainrots, function(a, b)
                            return (a.Position - root.Position).Magnitude < (b.Position - root.Position).Magnitude
                        end)
                        
                        -- Телепорт к ближайшему
                        local target = brainrots[1]
                        root.CFrame = CFrame.new(target.Position + Vector3.new(0, 3, 0))
                        
                        -- Попытка собрать
                        firetouchinterest(root, target, 0)
                        task.wait(0.1)
                        firetouchinterest(root, target, 1)
                        
                    else
                        Rayfield:Notify({
                            Title = "No Brainrot Found",
                            Content = "Searching for more Brainrot...",
                            Duration = 2,
                        })
                    end
                    
                    task.wait(0.5)
                end
            end)()
        else
            Rayfield:Notify({
                Title = "Auto Collect Stopped",
                Content = "Stopped collecting Brainrot",
                Duration = 2,
            })
        end
    end,
})

-- Авто-покупка Brainrot (КАК В ИГРЕ)
local AutoBuyToggle = AutoFarmTab:CreateToggle({
    Name = "🛒 Auto Buy Brainrot",
    CurrentValue = false,
    Flag = "AutoBuy",
    Callback = function(Value)
        _G.AutoBuy = Value
        if Value then
            Rayfield:Notify({
                Title = "Auto Buy Started",
                Content = "Automatically buying Brainrot...",
                Duration = 3,
            })
            
            coroutine.wrap(function()
                while _G.AutoBuy do
                    -- Поиск магазина или NPC для покупки
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if obj.Name:lower():find("shop") or obj.Name:lower():find("store") or obj.Name:lower():find("merchant") or obj.Name:lower():find("vendor") then
                            if LocalPlayer.Character then
                                local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                                local objRoot = obj:FindFirstChild("HumanoidRootPart") or obj
                                
                                if root and objRoot then
                                    -- Телепорт к магазину
                                    root.CFrame = objRoot.CFrame + Vector3.new(0, 0, 3)
                                    
                                    -- Попытка купить
                                    local prompt = obj:FindFirstChildOfClass("ProximityPrompt")
                                    if prompt then
                                        fireproximityprompt(prompt)
                                    end
                                    
                                    task.wait(1)
                                end
                            end
                        end
                    end
                    task.wait(5)
                end
            end)()
        end
    end,
})

-- Авто-продажа (ИСПРАВЛЕННАЯ)
local AutoSellToggle = AutoFarmTab:CreateToggle({
    Name = "💰 Auto Sell Items",
    CurrentValue = false,
    Flag = "AutoSell",
    Callback = function(Value)
        _G.AutoSell = Value
        if Value then
            Rayfield:Notify({
                Title = "Auto Sell Started",
                Content = "Automatically selling items...",
                Duration = 3,
            })
            
            coroutine.wrap(function()
                while _G.AutoSell do
                    -- Поиск продавца
                    local seller = nil
                    for _, npc in pairs(workspace:GetDescendants()) do
                        if npc.Name:lower():find("sell") or npc.Name:lower():find("merchant") or npc.Name:lower():find("vendor") then
                            seller = npc
                            break
                        end
                    end
                    
                    if seller and LocalPlayer.Character then
                        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        local sellerRoot = seller:FindFirstChild("HumanoidRootPart") or seller
                        
                        if root then
                            -- Телепорт к продавцу
                            root.CFrame = sellerRoot.CFrame + Vector3.new(0, 0, 3)
                            
                            -- Продажа
                            local prompt = seller:FindFirstChildOfClass("ProximityPrompt")
                            if prompt then
                                for i = 1, 3 do
                                    fireproximityprompt(prompt)
                                    task.wait(0.5)
                                end
                            end
                        end
                    end
                    task.wait(10)
                end
            end)()
        end
    end,
})

-- Вкладка Teleport
local TeleportTab = Window:CreateTab("📍 Teleport", 4483353530)

-- Телепорт к базе (КАК В ИГРЕ)
local BaseTPButton = TeleportTab:CreateButton({
    Name = "🏠 TP to Your Base",
    Callback = function()
        if not LocalPlayer.Character then return end
        
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        -- Поиск базы игрока
        local baseFound = false
        
        -- Поиск по названиям связанным с базой
        local baseKeywords = {"base", "spawn", "house", "home", "plot", "island", "area"}
        
        for _, keyword in pairs(baseKeywords) do
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj.Name:lower():find(keyword) then
                    if obj:IsA("Part") or obj:IsA("Model") then
                        local targetPos = obj:IsA("Part") and obj.Position or (obj:FindFirstChild("HumanoidRootPart") and obj.HumanoidRootPart.Position)
                        if targetPos then
                            root.CFrame = CFrame.new(targetPos + Vector3.new(0, 5, 0))
                            baseFound = true
                            Rayfield:Notify({
                                Title = "Teleported to Base",
                                Content = "Successfully teleported to your base!",
                                Duration = 3,
                            })
                            return
                        end
                    end
                end
            end
        end
        
        -- Если база не найдена, телепорт в безопасное место
        if not baseFound then
            root.CFrame = CFrame.new(0, 100, 0)
            Rayfield:Notify({
                Title = "Teleported to Safe Zone",
                Content = "Base not found, teleported to safe location",
                Duration = 3,
            })
        end
    end,
})

-- Телепорт к лучшему месту фарма
local BestFarmButton = TeleportTab:CreateButton({
    Name = "💎 TP to Best Farm Spot",
    Callback = function()
        if not LocalPlayer.Character then return end
        
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        -- Поиск области с наибольшим количеством Brainrot
        local bestArea = nil
        local maxDensity = 0
        
        for _, item in pairs(workspace:GetDescendants()) do
            if item:IsA("Part") and (item.Name:lower():find("brainrot") or item.Name:lower():find("brain") or item.Name:lower():find("coin")) then
                local nearbyCount = 0
                for _, nearby in pairs(workspace:GetDescendants()) do
                    if nearby:IsA("Part") and (nearby.Name:lower():find("brainrot") or nearby.Name:lower():find("brain") or nearby.Name:lower():find("coin")) then
                        if (item.Position - nearby.Position).Magnitude < 20 then
                            nearbyCount = nearbyCount + 1
                        end
                    end
                end
                
                if nearbyCount > maxDensity then
                    maxDensity = nearbyCount
                    bestArea = item
                end
            end
        end
        
        if bestArea then
            root.CFrame = CFrame.new(bestArea.Position + Vector3.new(0, 5, 0))
            Rayfield:Notify({
                Title = "Teleported to Best Spot",
                Content = string.format("Area with %d Brainrot nearby!", maxDensity),
                Duration = 3,
            })
        else
            Rayfield:Notify({
                Title = "No Good Spots Found",
                Content = "Could not find good farming areas",
                Duration = 3,
            })
        end
    end,
})

-- Массовый сбор в радиусе
local MassCollectButton = TeleportTab:CreateButton({
    Name = "🌀 Mass Collect in Area",
    Callback = function()
        if not LocalPlayer.Character then return end
        
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        local collected = 0
        local radius = 50
        
        Rayfield:Notify({
            Title = "Mass Collection Started",
            Content = "Collecting all Brainrot in area...",
            Duration = 2,
        })
        
        for _, item in pairs(workspace:GetDescendants()) do
            if item:IsA("Part") and (item.Name:lower():find("brainrot") or item.Name:lower():find("brain") or item.Name:lower():find("coin")) then
                local distance = (root.Position - item.Position).Magnitude
                if distance <= radius then
                    root.CFrame = CFrame.new(item.Position + Vector3.new(0, 3, 0))
                    collected = collected + 1
                    task.wait(0.1)
                end
            end
        end
        
        Rayfield:Notify({
            Title = "Mass Collection Complete",
            Content = string.format("Collected %d items!", collected),
            Duration = 3,
        })
    end,
})

-- Вкладка Player
local PlayerTab = Window:CreateTab("🎮 Player", 4483344167)

-- Полёт (ИСПРАВЛЕННЫЙ)
local FlyToggle = PlayerTab:CreateToggle({
    Name = "🕊️ Fly Mode",
    CurrentValue = false,
    Flag = "FlyMode",
    Callback = function(Value)
        _G.Flying = Value
        if Value then
            Rayfield:Notify({
                Title = "Fly Mode Enabled",
                Content = "Use WASD + Space/Ctrl to fly",
                Duration = 3,
            })
            
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            bodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
            
            if LocalPlayer.Character then
                local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    bodyVelocity.Parent = root
                end
            end
            
            _G.FlyConnection = RunService.Heartbeat:Connect(function()
                if _G.Flying and LocalPlayer.Character then
                    local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if root and bodyVelocity then
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
                        
                        if direction.Magnitude > 0 then
                            bodyVelocity.Velocity = direction.Unit * 100
                        else
                            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                        end
                    end
                else
                    if _G.FlyConnection then
                        _G.FlyConnection:Disconnect()
                    end
                    if bodyVelocity then
                        bodyVelocity:Destroy()
                    end
                end
            end)
        else
            if _G.FlyConnection then
                _G.FlyConnection:Disconnect()
            end
        end
    end,
})

-- NoClip (ИСПРАВЛЕННЫЙ)
local NoclipToggle = PlayerTab:CreateToggle({
    Name = "👻 NoClip",
    CurrentValue = false,
    Flag = "NoClip",
    Callback = function(Value)
        _G.NoClip = Value
        if Value then
            _G.NoclipConnection = RunService.Stepped:Connect(function()
                if _G.NoClip and LocalPlayer.Character then
                    for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                else
                    if _G.NoclipConnection then
                        _G.NoclipConnection:Disconnect()
                    end
                end
            end)
        else
            if _G.NoclipConnection then
                _G.NoclipConnection:Disconnect()
            end
        end
    end,
})

-- Speed
local SpeedSlider = PlayerTab:CreateSlider({
    Name = "💨 Walk Speed",
    Range = {16, 200},
    Increment = 5,
    Suffix = "studs",
    CurrentValue = 16,
    Flag = "WalkSpeed",
    Callback = function(Value)
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = Value
            end
        end
    end,
})

-- Вкладка Visuals
local VisualsTab = Window:CreateTab("👁️ Visuals", 4483345990)

-- ESP для Brainrot (ИСПРАВЛЕННЫЙ)
local ESPToggle = VisualsTab:CreateToggle({
    Name = "🧠 Brainrot ESP",
    CurrentValue = false,
    Flag = "BrainrotESP",
    Callback = function(Value)
        _G.BrainrotESP = Value
        if Value then
            Rayfield:Notify({
                Title = "Brainrot ESP Enabled",
                Content = "Highlighting all Brainrot items",
                Duration = 3,
            })
            
            coroutine.wrap(function()
                while _G.BrainrotESP do
                    for _, item in pairs(workspace:GetDescendants()) do
                        if item:IsA("Part") and (item.Name:lower():find("brainrot") or item.Name:lower():find("brain") or item.Name:lower():find("coin")) then
                            if not item:FindFirstChild("BrainrotESP") then
                                local highlight = Instance.new("Highlight")
                                highlight.Name = "BrainrotESP"
                                highlight.Parent = item
                                highlight.FillColor = Color3.fromRGB(0, 255, 0)
                                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                                highlight.FillTransparency = 0.3
                            end
                        end
                    end
                    task.wait(2)
                end
                
                -- Очистка при выключении
                for _, item in pairs(workspace:GetDescendants()) do
                    local highlight = item:FindFirstChild("BrainrotESP")
                    if highlight then
                        highlight:Destroy()
                    end
                end
            end)()
        else
            Rayfield:Notify({
                Title = "Brainrot ESP Disabled",
                Content = "ESP turned off",
                Duration = 2,
            })
        end
    end,
})

-- Fullbright
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
local MiscTab = Window:CreateTab("⚙️ Misc", 4483344167)

-- Anti AFK
local AntiAFKToggle = MiscTab:CreateToggle({
    Name = "⏰ Anti AFK",
    CurrentValue = false,
    Flag = "AntiAFK",
    Callback = function(Value)
        if Value then
            LocalPlayer.Idled:Connect(function()
                game:GetService("VirtualUser"):Button2Down(Vector3.new(0,0,0))
                wait(1)
                game:GetService("VirtualUser"):Button2Up(Vector3.new(0,0,0))
            end)
            Rayfield:Notify({
                Title = "Anti AFK Enabled",
                Content = "You won't be kicked for AFK",
                Duration = 3,
            })
        end
    end,
})

-- Server Hop
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
    Title = "🧠 ULTIMATE BRAINROT STEALER LOADED!",
    Content = "All features are ready! Use wisely!",
    Duration = 6,
})

print("Ultimate Brainrot Stealer successfully loaded!")