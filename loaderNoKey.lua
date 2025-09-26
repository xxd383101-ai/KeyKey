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
local MovementSection = MainTab:CreateSection("Movement Features")

-- НОВЫЙ РАБОЧИЙ FLY
local flying = false
local flySpeed = 100
local flyConnection

local FlyToggle = MainTab:CreateToggle({
    Name = "🕊️ Fly (FIXED)",
    CurrentValue = false,
    Flag = "FlyToggle",
    Callback = function(Value)
        flying = Value
        if flying then
            local character = LocalPlayer.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            local rootPart = character and character:FindFirstChild("HumanoidRootPart")
            
            if not rootPart or not humanoid then
                Rayfield:Notify({
                    Title = "Fly Error",
                    Content = "Character not found!",
                    Duration = 3,
                })
                flying = false
                return
            end
            
            humanoid.PlatformStand = true
            
            flyConnection = RunService.Heartbeat:Connect(function()
                if not flying or not character or not rootPart then return end
                
                local camera = workspace.CurrentCamera
                local velocity = Vector3.new(0, 0, 0)
                
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    velocity = velocity + camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    velocity = velocity - camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    velocity = velocity + camera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    velocity = velocity - camera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    velocity = velocity + Vector3.new(0, 1, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                    velocity = velocity - Vector3.new(0, 1, 0)
                end
                
                if velocity.Magnitude > 0 then
                    rootPart.Velocity = velocity.Unit * flySpeed
                else
                    rootPart.Velocity = Vector3.new(0, rootPart.Velocity.Y, 0)
                end
            end)
            
            Rayfield:Notify({
                Title = "Fly Activated ✅",
                Content = "WASD + Space/Ctrl - Movement",
                Duration = 4,
            })
            
        else
            if flyConnection then
                flyConnection:Disconnect()
                flyConnection = nil
            end
            if LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.PlatformStand = false
                end
            end
        end
    end,
})

local FlySpeedSlider = MainTab:CreateSlider({
    Name = "🚀 Fly Speed",
    Range = {50, 500},
    Increment = 10,
    Suffix = "studs",
    CurrentValue = 100,
    Flag = "FlySpeed",
    Callback = function(Value)
        flySpeed = Value
    end,
})

-- WALLHOP SYSTEM
local wallhopEnabled = false
local wallhopConnection

local WallhopToggle = MainTab:CreateToggle({
    Name = "🧱 WallHop",
    CurrentValue = false,
    Flag = "WallhopToggle",
    Callback = function(Value)
        wallhopEnabled = Value
        if wallhopEnabled then
            wallhopConnection = UserInputService.JumpRequest:Connect(function()
                if not wallhopEnabled then return end
                
                local character = LocalPlayer.Character
                if not character then return end
                
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                
                if not humanoid or not rootPart then return end
                if humanoid:GetState() == Enum.HumanoidStateType.Dead then return end
                
                -- Wall detection
                local raycastParams = RaycastParams.new()
                raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                raycastParams.FilterDescendantsInstances = {character}
                
                local detectionDistance = 5
                local rayOrigin = rootPart.Position
                local rayDirection = rootPart.CFrame.LookVector * detectionDistance
                
                local rayResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
                
                if rayResult then
                    local wallNormal = rayResult.Normal
                    local jumpDirection = (rootPart.CFrame.LookVector - 2 * wallNormal * wallNormal:Dot(rootPart.CFrame.LookVector)).Unit
                    
                    rootPart.Velocity = jumpDirection * 100 + Vector3.new(0, 100, 0)
                    
                    Rayfield:Notify({
                        Title = "WallHop!",
                        Content = "Wall jump performed",
                        Duration = 1,
                    })
                end
            end)
            
            Rayfield:Notify({
                Title = "WallHop Activated",
                Content = "Jump near walls to wall jump",
                Duration = 3,
            })
        else
            if wallhopConnection then
                wallhopConnection:Disconnect()
                wallhopConnection = nil
            end
        end
    end,
})

-- Noclip Function
local noclip = false
local noclipConnection

local NoclipToggle = MainTab:CreateToggle({
    Name = "👻 Noclip",
    CurrentValue = false,
    Flag = "NoclipToggle",
    Callback = function(Value)
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
    Callback = function(Value)
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
    Callback = function(Value)
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
    Callback = function(Value)
        infiniteJump = Value
    end,
})

UserInputService.JumpRequest:Connect(function()
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
    Callback = function(Value)
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
    Callback = function(Value)
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
local function updatePlayerList()
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
    Callback = function(Option)
        -- Just store selection
    end,
})

local TeleportButton = TeleportTab:CreateButton({
    Name = "📡 Teleport to Player",
    Callback = function()
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
    Callback = function(Text) end,
})

local YInput = TeleportTab:CreateInput({
    Name = "Y Coordinate",
    PlaceholderText = "0",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text) end,
})

local ZInput = TeleportTab:CreateInput({
    Name = "Z Coordinate",
    PlaceholderText = "0",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text) end,
})

local TeleportCoordButton = TeleportTab:CreateButton({
    Name = "📍 Teleport to Coordinates",
    Callback = function()
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
    Callback = function(Value)
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

function espCreate(player)
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

-- X-Ray
local XRayToggle = VisualsTab:CreateToggle({
    Name = "🔍 X-Ray Vision",
    CurrentValue = false,
    Flag = "XRay",
    Callback = function(Value)
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
    Callback = function(Value)
        if Value then
            LocalPlayer.Idled:Connect(function()
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
        if LocalPlayer.Character then
            LocalPlayer.Character:BreakJoints()
        end
    end,
})

-- Aimbot loop
RunService.Heartbeat:Connect(function()
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
    if flying then
        flying = false
        if flyConnection then flyConnection:Disconnect() end
    end
end)