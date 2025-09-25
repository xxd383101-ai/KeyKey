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

-- Создание окна
local Window = Rayfield:CreateWindow({
   Name = "🔥 Universal Script Menu",
   LoadingTitle = "Universal Script Loading...",
   LoadingSubtitle = "by TurboModder t.me/TurboHackMods",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "UniversalScriptConfig",
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

-- Fly Function
local flying = false
local flySpeed = 50
local flyConnection
local bodyGyro, bodyVelocity

local FlyToggle = MainTab:CreateToggle({
    Name = "🕊️ Fly",
    CurrentValue = false,
    Flag = "FlyToggle",
    Callback = function(Value)
        flying = Value
        local character = LocalPlayer.Character
        local humanoid = character and character:FindFirstChild("Humanoid")
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        
        if flying then
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
            
            bodyGyro = Instance.new("BodyGyro")
            bodyVelocity = Instance.new("BodyVelocity")
            
            bodyGyro.P = 10000
            bodyGyro.MaxTorque = Vector3.new(100000, 100000, 100000)
            bodyGyro.CFrame = rootPart.CFrame
            bodyGyro.Parent = rootPart
            
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            bodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
            bodyVelocity.Parent = rootPart
            
            flyConnection = RunService.Heartbeat:Connect(function()
                if not flying or not bodyGyro or not bodyVelocity then return end
                
                local camera = workspace.CurrentCamera
                local direction = Vector3.new()
                
                bodyGyro.CFrame = camera.CFrame
                
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
                    bodyVelocity.Velocity = direction.Unit * flySpeed
                else
                    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                end
            end)
            
            Rayfield:Notify({
                Title = "Fly Activated ✅",
                Content = "WASD: Move | Space: Up | Ctrl: Down",
                Duration = 4,
            })
            
        else
            if bodyGyro then bodyGyro:Destroy() end
            if bodyVelocity then bodyVelocity:Destroy() end
            if flyConnection then flyConnection:Disconnect() end
            if humanoid then humanoid.PlatformStand = false end
        end
    end,
})

local FlySpeedSlider = MainTab:CreateSlider({
    Name = "🚀 Fly Speed",
    Range = {1, 200},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = 50,
    Flag = "FlySpeed",
    Callback = function(Value)
        flySpeed = Value
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
    Name = "💨 Speed Hack",
    Range = {1, 100},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = 16,
    Flag = "SpeedHack",
    Callback = function(Value)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = Value
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
        if infiniteJump then
            UserInputService.JumpRequest:Connect(function()
                if infiniteJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        end
    end,
})

-- Раздел Combat
local CombatSection = MainTab:CreateSection("Combat Features")

-- God Mode
local GodModeToggle = MainTab:CreateToggle({
    Name = "🛡️ God Mode",
    CurrentValue = false,
    Flag = "GodMode",
    Callback = function(Value)
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.MaxHealth = Value and math.huge or 100
                if Value then
                    humanoid.Health = math.huge
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
                local humanoid = player.Character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.Health = 0
                end
            end
        end
    end,
})

-- Вкладка Teleport
local TeleportTab = Window:CreateTab("Teleport", 4483353530)

-- Teleport to Player
local playerDropdown = TeleportTab:CreateDropdown({
    Name = "👤 Teleport to Player",
    Options = {"Select Player"},
    CurrentOption = "Select Player",
    Flag = "PlayerDropdown",
    Callback = function(Option)
        if Option ~= "Select Player" then
            local targetPlayer = Players:FindFirstChild(Option)
            if targetPlayer and targetPlayer.Character then
                local rootPart = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                local localRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                
                if rootPart and localRoot then
                    localRoot.CFrame = rootPart.CFrame
                    Rayfield:Notify({
                        Title = "Teleported!",
                        Content = "Teleported to " .. Option,
                        Duration = 3,
                    })
                end
            end
        end
    end,
})

-- Update player list function
local function updatePlayerList()
    local playerNames = {"Select Player"}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(playerNames, player.Name)
        end
    end
    playerDropdown:Refresh(playerNames, true)
end

-- Initial update and connections
updatePlayerList()
Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)

-- Bring Player to You
local BringButton = TeleportTab:CreateButton({
    Name = "📥 Bring Player to You",
    Callback = function()
        local selectedPlayer = playerDropdown.CurrentOption
        if selectedPlayer ~= "Select Player" then
            local targetPlayer = Players:FindFirstChild(selectedPlayer)
            local localRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            
            if targetPlayer and targetPlayer.Character and localRoot then
                local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                if targetRoot then
                    targetRoot.CFrame = localRoot.CFrame
                    Rayfield:Notify({
                        Title = "Player Brought!",
                        Content = "Brought " .. selectedPlayer .. " to you",
                        Duration = 3,
                    })
                end
            end
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "Select a player first!",
                Duration = 3,
            })
        end
    end,
})

-- Teleport to Coordinate
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

-- Вкладка Player
local PlayerTab = Window:CreateTab("Player", 4483345990)

-- ESP Function
local espEnabled = false
local espObjects = {}

local ESPToggle = PlayerTab:CreateToggle({
    Name = "👁️ Player ESP",
    CurrentValue = false,
    Flag = "ESP",
    Callback = function(Value)
        espEnabled = Value
        if espEnabled then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    createESP(player.Character, player.Name)
                end
            end
            
            Players.PlayerAdded:Connect(function(player)
                player.CharacterAdded:Connect(function(character)
                    if espEnabled then
                        createESP(character, player.Name)
                    end
                end)
            end)
        else
            for _, obj in pairs(espObjects) do
                if obj then obj:Remove() end
            end
            espObjects = {}
        end
    end,
})

function createESP(character, name)
    local highlight = Instance.new("Highlight")
    highlight.Parent = character
    highlight.Name = "ESP_" .. name
    highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.FillTransparency = 0.8
    table.insert(espObjects, highlight)
end

-- View Player
local ViewButton = PlayerTab:CreateButton({
    Name = "👀 View Player",
    Callback = function()
        local selectedPlayer = playerDropdown.CurrentOption
        if selectedPlayer ~= "Select Player" then
            local targetPlayer = Players:FindFirstChild(selectedPlayer)
            if targetPlayer then
                workspace.CurrentCamera.CameraSubject = targetPlayer.Character and targetPlayer.Character:FindFirstChild("Humanoid")
                Rayfield:Notify({
                    Title = "Viewing Player",
                    Content = "Now viewing " .. selectedPlayer,
                    Duration = 3,
                })
            end
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "Select a player first!",
                Duration = 3,
            })
        end
    end,
})

-- Reset View
local ResetViewButton = PlayerTab:CreateButton({
    Name = "🔁 Reset View",
    Callback = function()
        workspace.CurrentCamera.CameraSubject = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        Rayfield:Notify({
            Title = "View Reset",
            Content = "Camera view reset to yourself",
            Duration = 3,
        })
    end,
})

-- Freeze Player
local FreezeButton = PlayerTab:CreateButton({
    Name = "❄️ Freeze Player",
    Callback = function()
        local selectedPlayer = playerDropdown.CurrentOption
        if selectedPlayer ~= "Select Player" then
            local targetPlayer = Players:FindFirstChild(selectedPlayer)
            if targetPlayer and targetPlayer.Character then
                local humanoid = targetPlayer.Character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.PlatformStand = true
                    Rayfield:Notify({
                        Title = "Player Frozen",
                        Content = "Frozen " .. selectedPlayer,
                        Duration = 3,
                    })
                end
            end
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "Select a player first!",
                Duration = 3,
            })
        end
    end,
})

-- Unfreeze All Players
local UnfreezeButton = PlayerTab:CreateButton({
    Name = "🔥 Unfreeze All Players",
    Callback = function()
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character then
                local humanoid = player.Character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.PlatformStand = false
                end
            end
        end
        Rayfield:Notify({
            Title = "Players Unfrozen",
            Content = "All players unfrozen",
            Duration = 3,
        })
    end,
})

-- Вкладка World
local WorldTab = Window:CreateTab("World", 4483344167)

-- Fullbright
local FullbrightToggle = WorldTab:CreateToggle({
    Name = "💡 Fullbright",
    CurrentValue = false,
    Flag = "Fullbright",
    Callback = function(Value)
        if Value then
            Lighting.Ambient = Color3.new(1, 1, 1)
            Lighting.Brightness = 1
            Lighting.GlobalShadows = false
        else
            Lighting.Ambient = Color3.new(0, 0, 0)
            Lighting.Brightness = 0.8
            Lighting.GlobalShadows = true
        end
    end,
})

-- Time of Day
local TimeSlider = WorldTab:CreateSlider({
    Name = "⏰ Time of Day",
    Range = {0, 24},
    Increment = 0.5,
    Suffix = " hours",
    CurrentValue = 12,
    Flag = "TimeOfDay",
    Callback = function(Value)
        Lighting.ClockTime = Value
    end,
})

-- FPS Boost
local FPSBoostButton = WorldTab:CreateButton({
    Name = "⚡ FPS Boost",
    Callback = function()
        settings().Rendering.QualityLevel = 1
        for _, desc in pairs(workspace:GetDescendants()) do
            if desc:IsA("Part") then
                desc.Material = Enum.Material.Plastic
            end
        end
        
        Rayfield:Notify({
            Title = "FPS Boost Applied",
            Content = "Graphics optimized for better performance",
            Duration = 3,
        })
    end,
})

-- Вкладка Misc
local MiscTab = Window:CreateTab("Miscellaneous", 4483350926)

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

-- Rejoin Server
local RejoinButton = MiscTab:CreateButton({
    Name = "🔃 Rejoin Server",
    Callback = function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId)
    end,
})

-- Fly Controls
local flyConnection
flyConnection = RunService.Heartbeat:Connect(function()
    if flying and bodyGyro and bodyVelocity and LocalPlayer.Character then
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
            
            bodyVelocity.Velocity = direction.Unit * flySpeed
        end
    end
end)

-- Уведомление о загрузке
Rayfield:Notify({
    Title = "Universal Script Loaded! 🚀",
    Content = "All features are now available!",
    Duration = 6,
    Image = 4483362458,
})

-- Очистка при отключении
game:GetService("UserInputService").WindowFocusReleased:Connect(function()
    if flying then
        flying = false
        if bodyGyro then bodyGyro:Destroy() end
        if bodyVelocity then bodyVelocity:Destroy() end
        if flyConnection then flyConnection:Disconnect() end
    end
end)