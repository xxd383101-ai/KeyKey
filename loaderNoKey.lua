-- Rayfield Interface Suite
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Переменные для функций
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

-- Создание окна
local Window = Rayfield:CreateWindow({
   Name = "🔥 Ultimate Script Menu v2.0",
   LoadingTitle = "Ultimate Script Loading...",
   LoadingSubtitle = "by Developer",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "UltimateScriptConfig",
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
local bodyVelocity

local FlyToggle = MainTab:CreateToggle({
    Name = "🕊️ Fly",
    CurrentValue = false,
    Flag = "FlyToggle",
    Callback = function(Value)
        flying = Value
        if flying then
            local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                bodyVelocity.MaxForce = Vector3.new(0, 0, 0)
                bodyVelocity.Parent = root
                
                Rayfield:Notify({
                    Title = "Fly Activated",
                    Content = "Use W/A/S/D to fly. Space to go up, Ctrl to go down",
                    Duration = 3,
                })
            end
        else
            if bodyVelocity then
                bodyVelocity:Destroy()
                bodyVelocity = nil
            end
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
            if noclipConnection then
                noclipConnection:Disconnect()
            end
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
local speedHack = false
local originalWalkSpeed = 16

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
local originalJumpPower

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

-- Вкладка Visuals
local VisualsTab = Window:CreateTab("Visuals", 4483345990)

-- ESP Function
local espEnabled = false
local espObjects = {}

local ESPToggle = VisualsTab:CreateToggle({
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
                if obj then
                    obj:Remove()
                end
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

-- Fullbright
local FullbrightToggle = VisualsTab:CreateToggle({
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

-- X-Ray Vision
local XRayToggle = VisualsTab:CreateToggle({
    Name = "🔍 X-Ray Vision",
    CurrentValue = false,
    Flag = "XRay",
    Callback = function(Value)
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.CameraOffset = Value and Vector3.new(0, 0, -10) or Vector3.new(0, 0, 0)
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
            local targetPlayer = Players[Option]
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character:MoveTo(targetPlayer.Character.HumanoidRootPart.Position)
            end
        end
    end,
})

-- Update player list
local function updatePlayerList()
    local playerNames = {"Select Player"}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(playerNames, player.Name)
        end
    end
    playerDropdown:Refresh(playerNames, true)
end

updatePlayerList()
Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)

-- Teleport to Locations
local TeleportSection = TeleportTab:CreateSection("Location Teleport")

local locations = {
    {"Spawn Point", Vector3.new(0, 10, 0)},
    {"High Point", Vector3.new(0, 100, 0)},
    {"Far Point", Vector3.new(100, 10, 100)}
}

for i, location in ipairs(locations) do
    TeleportTab:CreateButton({
        Name = "📍 Teleport to " .. location[1],
        Callback = function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(location[2])
            end
        end,
    })
end

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
        
        -- Simple server hop implementation
        local servers = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100"))
        for _, server in pairs(servers.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, server.id)
                break
            end
        end
    end,
})

-- FPS Boost
local FPSBoostButton = MiscTab:CreateButton({
    Name = "⚡ FPS Boost",
    Callback = function()
        -- Graphics optimization
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

-- Fly Controls
local flyConnection
flyConnection = RunService.Heartbeat:Connect(function()
    if flying and bodyVelocity and LocalPlayer.Character then
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
            bodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
        end
    end
end)

-- Уведомление о загрузке
Rayfield:Notify({
    Title = "Ultimate Script Loaded!",
    Content = "All features are now available. Use with caution!",
    Duration = 6,
    Image = 4483362458,
})

-- Очистка при отключении
game:GetService("UserInputService").WindowFocused:Connect(function()
    if not flying and bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    if noclipConnection then
        noclipConnection:Disconnect()
    end
    if flyConnection then
        flyConnection:Disconnect()
    end
end)