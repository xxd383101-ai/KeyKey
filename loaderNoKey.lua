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

-- Красивое окно
local Window = Rayfield:CreateWindow({
   Name = "🧠 Ultimate Brainrot Stealer",
   LoadingTitle = "Brainrot Stealer Loading...",
   LoadingSubtitle = "by TurboModder | t.me/TurboHackMods",
   Theme = "Dark",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "BrainrotStealer",
      FileName = "Config"
   },
})

-- Вкладка Teleport
local TeleportTab = Window:CreateTab("📍 Teleport", 4483353530)

-- Плавный полет к базе с выбором скорости
local FlyToBaseSection = TeleportTab:CreateSection("Fly To Base")

local FlySpeedSlider = TeleportTab:CreateSlider({
    Name = "🚀 Fly Speed",
    Range = {10, 200},
    Increment = 5,
    Suffix = "studs/sec",
    CurrentValue = 50,
    Flag = "FlySpeed",
    Callback = function(Value)
        _G.FlySpeed = Value
    end,
})

local FlyToBaseButton = TeleportTab:CreateButton({
    Name = "🏠 Fly to Base",
    Callback = function()
        if not LocalPlayer.Character then return end
        
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        -- Поиск базы
        local baseParts = {}
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj.Name:lower():find("base") or obj.Name:lower():find("spawn") or obj.Name:lower():find("house") then
                if obj:IsA("Part") or obj:IsA("MeshPart") then
                    table.insert(baseParts, obj)
                end
            end
        end
        
        if #baseParts == 0 then
            Rayfield:Notify({
                Title = "Base Not Found",
                Content = "Could not find base, teleporting to safe zone",
                Duration = 3,
            })
            root.CFrame = CFrame.new(0, 100, 0)
            return
        end
        
        -- Выбор ближайшей базы
        local closestBase = nil
        local closestDistance = math.huge
        
        for _, basePart in pairs(baseParts) do
            local distance = (root.Position - basePart.Position).Magnitude
            if distance < closestDistance then
                closestDistance = distance
                closestBase = basePart
            end
        end
        
        if closestBase then
            Rayfield:Notify({
                Title = "Flying to Base",
                Content = string.format("Flying at %d studs/sec", _G.FlySpeed or 50),
                Duration = 3,
            })
            
            -- Плавный полет
            local startPos = root.Position
            local endPos = closestBase.Position + Vector3.new(0, 5, 0)
            local direction = (endPos - startPos).Unit
            local distance = (endPos - startPos).Magnitude
            local travelTime = distance / (_G.FlySpeed or 50)
            
            local startTime = tick()
            local flyConnection
            
            flyConnection = RunService.Heartbeat:Connect(function()
                local elapsed = tick() - startTime
                local progress = math.min(elapsed / travelTime, 1)
                
                if progress >= 1 then
                    root.CFrame = CFrame.new(endPos)
                    flyConnection:Disconnect()
                    Rayfield:Notify({
                        Title = "Arrived at Base",
                        Content = "Successfully reached base!",
                        Duration = 3,
                    })
                    return
                end
                
                local currentPos = startPos + (endPos - startPos) * progress
                root.CFrame = CFrame.new(currentPos)
            end)
        end
    end,
})

-- Телепорт к Brainrot
local StealSection = TeleportTab:CreateSection("Steal Functions")

local TeleportToBrainrotButton = TeleportTab:CreateButton({
    Name = "🧠 TP to Nearest Brainrot",
    Callback = function()
        if not LocalPlayer.Character then return end
        
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        local closestBrainrot = nil
        local closestDistance = math.huge
        
        for _, item in pairs(workspace:GetDescendants()) do
            if item.Name:lower():find("brainrot") or item.Name:lower():find("brain") or item.Name:lower():find("coin") then
                if item:IsA("Part") or item:IsA("MeshPart") then
                    local distance = (root.Position - item.Position).Magnitude
                    if distance < closestDistance then
                        closestDistance = distance
                        closestBrainrot = item
                    end
                end
            end
        end
        
        if closestBrainrot then
            root.CFrame = closestBrainrot.CFrame
            Rayfield:Notify({
                Title = "Teleported to Brainrot",
                Content = "Ready to collect!",
                Duration = 2,
            })
        else
            Rayfield:Notify({
                Title = "No Brainrot Found",
                Content = "Could not find any Brainrot nearby",
                Duration = 3,
            })
        end
    end,
})

-- Авто-сбор всех Brainrot в радиусе
local CollectRadiusSlider = TeleportTab:CreateSlider({
    Name = "🎯 Collection Radius",
    Range = {10, 100},
    Increment = 5,
    Suffix = "studs",
    CurrentValue = 30,
    Flag = "CollectRadius",
    Callback = function(Value)
        _G.CollectRadius = Value
    end,
})

local CollectAllInRadiusButton = TeleportTab:CreateButton({
    Name = "🌀 Collect All in Radius",
    Callback = function()
        if not LocalPlayer.Character then return end
        
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        local collected = 0
        local radius = _G.CollectRadius or 30
        
        for _, item in pairs(workspace:GetDescendants()) do
            if (item.Name:lower():find("brainrot") or item.Name:lower():find("brain") or item.Name:lower():find("coin")) then
                if item:IsA("Part") or item:IsA("MeshPart") then
                    local distance = (root.Position - item.Position).Magnitude
                    if distance <= radius then
                        root.CFrame = item.CFrame
                        collected = collected + 1
                        task.wait(0.1)
                    end
                end
            end
        end
        
        Rayfield:Notify({
            Title = "Collection Complete",
            Content = string.format("Collected %d items in %d stud radius", collected, radius),
            Duration = 3,
        })
    end,
})

-- Вкладка Auto Steal
local AutoStealTab = Window:CreateTab("🤖 Auto Steal", 4483362458)

-- Авто-сбор Brainrot
local AutoStealToggle = AutoStealTab:CreateToggle({
    Name = "🔄 Auto Steal Brainrot",
    CurrentValue = false,
    Flag = "AutoSteal",
    Callback = function(Value)
        if Value then
            _G.AutoSteal = true
            Rayfield:Notify({
                Title = "Auto Steal Started",
                Content = "Automatically stealing all Brainrot...",
                Duration = 3,
            })
            
            coroutine.wrap(function()
                while _G.AutoSteal and LocalPlayer.Character do
                    local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if not root then break end
                    
                    local closestBrainrot = nil
                    local closestDistance = math.huge
                    
                    -- Поиск ближайшего Brainrot
                    for _, item in pairs(workspace:GetDescendants()) do
                        if (item.Name:lower():find("brainrot") or item.Name:lower():find("brain") or item.Name:lower():find("coin")) then
                            if item:IsA("Part") or item:IsA("MeshPart") then
                                local distance = (root.Position - item.Position).Magnitude
                                if distance < closestDistance then
                                    closestDistance = distance
                                    closestBrainrot = item
                                end
                            end
                        end
                    end
                    
                    if closestBrainrot then
                        -- Плавный полет к Brainrot
                        local startPos = root.Position
                        local endPos = closestBrainrot.Position
                        local direction = (endPos - startPos).Unit
                        local distance = (endPos - startPos).Magnitude
                        local travelTime = distance / 50
                        
                        local startTime = tick()
                        
                        while tick() - startTime < travelTime and _G.AutoSteal do
                            if not LocalPlayer.Character then break end
                            local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                            if not root then break end
                            
                            local elapsed = tick() - startTime
                            local progress = math.min(elapsed / travelTime, 1)
                            local currentPos = startPos + (endPos - startPos) * progress
                            root.CFrame = CFrame.new(currentPos)
                            RunService.Heartbeat:Wait()
                        end
                        
                        if _G.AutoSteal and LocalPlayer.Character then
                            root.CFrame = CFrame.new(endPos)
                            task.wait(0.5)
                        end
                    else
                        task.wait(1)
                    end
                end
            end)()
        else
            _G.AutoSteal = false
        end
    end,
})

-- Авто-продажа
local AutoSellToggle = AutoStealTab:CreateToggle({
    Name = "💰 Auto Sell Items",
    CurrentValue = false,
    Flag = "AutoSell",
    Callback = function(Value)
        if Value then
            _G.AutoSell = true
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
                        if npc.Name:lower():find("merchant") or npc.Name:lower():find("seller") or npc.Name:lower():find("vendor") then
                            if npc:IsA("Model") then
                                seller = npc
                                break
                            end
                        end
                    end
                    
                    if seller and LocalPlayer.Character then
                        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        local sellerRoot = seller:FindFirstChild("HumanoidRootPart")
                        
                        if root and sellerRoot then
                            -- Полет к продавцу
                            local startPos = root.Position
                            local endPos = sellerRoot.Position + Vector3.new(0, 0, 3)
                            local direction = (endPos - startPos).Unit
                            local distance = (endPos - startPos).Magnitude
                            local travelTime = distance / 50
                            
                            local startTime = tick()
                            
                            while tick() - startTime < travelTime and _G.AutoSell do
                                if not LocalPlayer.Character then break end
                                local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                                if not root then break end
                                
                                local elapsed = tick() - startTime
                                local progress = math.min(elapsed / travelTime, 1)
                                local currentPos = startPos + (endPos - startPos) * progress
                                root.CFrame = CFrame.new(currentPos)
                                RunService.Heartbeat:Wait()
                            end
                            
                            if _G.AutoSell and LocalPlayer.Character then
                                root.CFrame = CFrame.new(endPos)
                                
                                -- Продажа
                                local prompt = seller:FindFirstChildOfClass("ProximityPrompt")
                                if prompt then
                                    fireproximityprompt(prompt)
                                end
                                
                                task.wait(2)
                            end
                        end
                    end
                    task.wait(5)
                end
            end)()
        else
            _G.AutoSell = false
        end
    end,
})

-- Вкладка Player
local PlayerTab = Window:CreateTab("🎮 Player", 4483344167)

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

-- Noclip
local NoclipToggle = PlayerTab:CreateToggle({
    Name = "👻 NoClip",
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

-- Вкладка Visuals
local VisualsTab = Window:CreateTab("👁️ Visuals", 4483345990)

-- ESP для Brainrot
local BrainrotESPToggle = VisualsTab:CreateToggle({
    Name = "🧠 Brainrot ESP",
    CurrentValue = false,
    Flag = "BrainrotESP",
    Callback = function(Value)
        if Value then
            _G.BrainrotESP = true
            coroutine.wrap(function()
                while _G.BrainrotESP do
                    for _, item in pairs(workspace:GetDescendants()) do
                        if (item.Name:lower():find("brainrot") or item.Name:lower():find("brain") or item.Name:lower():find("coin")) then
                            if item:IsA("Part") and not item:FindFirstChild("BrainrotHighlight") then
                                local highlight = Instance.new("Highlight")
                                highlight.Name = "BrainrotHighlight"
                                highlight.Parent = item
                                highlight.FillColor = Color3.fromRGB(0, 255, 0)
                                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                                highlight.FillTransparency = 0.3
                            end
                        end
                    end
                    task.wait(2)
                end
            end)()
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

-- Уведомление о загрузке
Rayfield:Notify({
    Title = "🧠 Ultimate Brainrot Stealer Loaded!",
    Content = "Ready to dominate the game!",
    Duration = 6,
})

print("Brainrot Stealer successfully loaded!")