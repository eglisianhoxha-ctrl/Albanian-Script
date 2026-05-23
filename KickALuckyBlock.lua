
-- Kick A Lucky Block - WindUI Script
-- Features: Auto Train, God Mode, Auto Collect, Auto Upgrade

-- Attempt to load Rayfield first (compat), then WindUI, else continue with whatever loaded UI.
local Rayfield
do
    local ok, lib = pcall(function()
        return loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
    end)
    if ok and lib then
        Rayfield = lib
    else
        local ok2, wind = pcall(function()
            -- Replace the URL below with a valid WindUI CDN/raw URL if you have one.
            return loadstring(game:HttpGet('https://example.com/windui'))()
        end)
        if ok2 and wind then
            Rayfield = wind
        else
            -- If neither UI loaded, create a minimal shim so script won't error on calls.
            Rayfield = {}
            function Rayfield:CreateWindow() return { CreateTab = function() return { CreateSection = function() end, CreateToggle = function() end, CreateSlider = function() end, CreateButton = function() end, CreateLabel = function() end } end end
            function Rayfield:Notify(params) end
        end
    end
end

local Window = Rayfield:CreateWindow({
    Name = "Kick A Lucky Block Hub",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "by Copilot",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "KickALuckyBlockHub",
        FileName = "Config"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink"
    },
    KeySystem = false
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Script Settings
local Settings = {
    AutoTrain = false,
    AutoTrainSpeed = 0.1,
    GodMode = false,
    AutoCollect = false,
    AutoUpgrade = false,
    AutoUpgradeDelay = 0.5,
    CollectionRange = 50
}

-- Utility: attempt multiple ways to activate a GUI button/tool
local function safeActivate(target)
    if not target then return end
    pcall(function()
        if type(target.Activate) == "function" then
            target:Activate()
            return
        end
    end)
    pcall(function()
        if target.MouseButton1Click and type(target.MouseButton1Click.Fire) == "function" then
            target.MouseButton1Click:Fire()
            return
        end
    end)
    pcall(function()
        if target.Fire and type(target.Fire) == "function" then
            target:Fire()
            return
        end
    end)
end

local function safeEquip(tool)
    if not tool then return end
    pcall(function()
        if tool:IsA and tool:IsA("Tool") then
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.EquipTool then
                humanoid:EquipTool(tool)
                return
            end
            if type(tool.Activate) == "function" then
                tool:Activate()
                return
            end
        end
    end)
end

-- Tabs
local TrainTab = Window:CreateTab("🏋️ Auto Train", 4483362458)
local GodModeTab = Window:CreateTab("❤️ God Mode", 4483362458)
local CollectTab = Window:CreateTab("💰 Auto Collect", 4483362458)
local UpgradeTab = Window:CreateTab("⬆️ Auto Upgrade", 4483362458)

-- ==================== AUTO TRAIN TAB ====================
local TrainSection = TrainTab:CreateSection("Auto Train Settings")

TrainTab:CreateToggle({
    Name = "Enable Auto Train",
    Callback = function(Value)
        Settings.AutoTrain = Value
        Rayfield:Notify({
            Title = "Auto Train",
            Content = Value and "Auto Train Enabled ✓" or "Auto Train Disabled ✗",
            Duration = 2,
            Image = 4483362458
        })
        if Value and (trainCoroutine == nil or coroutine.status(trainCoroutine) == "dead") then
            trainCoroutine = coroutine.create(autoTrain)
            coroutine.resume(trainCoroutine)
        end
    end
})

TrainTab:CreateSlider({
    Name = "Train Speed",
    Range = {0.05, 1},
    Increment = 0.05,
    Suffix = "x",
    CurrentValue = 0.1,
    Callback = function(Value)
        Settings.AutoTrainSpeed = Value
    end
})

TrainTab:CreateButton({
    Name = "Hold Dumbell",
    Callback = function()
        local function findDumbell()
            local backpack = player:FindFirstChild("Backpack")
            if backpack then
                for _, item in pairs(backpack:GetChildren()) do
                        if item:IsA("Tool") and (item.Name:lower():find("dumb") or item.Name:lower():find("barbell")) then
                        safeEquip(item)
                        return true
                    end
                end
            end
            return false
        end
        if findDumbell() then
            Rayfield:Notify({
                Title = "Dumbell",
                Content = "Dumbell equipped ✓",
                Duration = 2
            })
        end
    end
})

-- Auto Train Loop
local autoTrainConnection
local function autoTrain()
    while Settings.AutoTrain do
        pcall(function()
            local backpack = player:FindFirstChild("Backpack")
            if backpack then
                for _, item in pairs(backpack:GetChildren()) do
                        if item:IsA("Tool") and (item.Name:lower():find("dumb") or item.Name:lower():find("barbell")) then
                        if character:FindFirstChildOfClass("Tool") == nil then
                            safeEquip(item)
                        end
                    end
                end
            end
            
            -- Look for purple ×2 button
            local gui = player:FindFirstChild("PlayerGui")
            if gui then
                for _, descendant in pairs(gui:GetDescendants()) do
                    if descendant:IsA("TextButton") and (descendant.Text:find("×2") or descendant.Text:find("x2")) and descendant.BackgroundColor3 == Color3.fromRGB(128, 0, 128) then
                        pcall(function()
                            safeActivate(descendant)
                        end)
                    end
                end
            end
        end)
        wait(Settings.AutoTrainSpeed)
    end
end

local trainCoroutine = nil
TrainTab:CreateToggle({
    Name = "Start Auto Train Loop",
    Callback = function(Value)
        if Value then
            Settings.AutoTrain = Value
            trainCoroutine = coroutine.create(autoTrain)
            coroutine.resume(trainCoroutine)
        else
            Settings.AutoTrain = false
        end
    end
})

-- ==================== GOD MODE TAB ====================
local GodModeSection = GodModeTab:CreateSection("God Mode Settings")

GodModeTab:CreateToggle({
    Name = "Enable God Mode (Inf Health)",
    Callback = function(Value)
        Settings.GodMode = Value
        
        if Value then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.MaxHealth = math.huge
                humanoid.Health = math.huge
                
                -- Prevent damage
                local connection
                connection = humanoid.HealthChanged:Connect(function()
                    if Settings.GodMode then
                        humanoid.Health = math.huge
                    else
                        connection:Disconnect()
                    end
                end)
                
                -- Block damage from waves
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    local touchConnection
                    touchConnection = rootPart.Touched:Connect(function(hit)
                        if Settings.GodMode and hit.Parent:FindFirstChild("Humanoid") == nil then
                            humanoid.Health = math.huge
                        end
                    end)
                end
            end
            
            Rayfield:Notify({
                Title = "God Mode",
                Content = "God Mode Activated ✓ (Infinite Health)",
                Duration = 2,
                Image = 4483362458
            })
        else
            Rayfield:Notify({
                Title = "God Mode",
                Content = "God Mode Deactivated ✗",
                Duration = 2,
                Image = 4483362458
            })
        end
    end
})

GodModeTab:CreateLabel("God Mode prevents all damage and sets health to infinite.")
GodModeTab:CreateLabel("Only works while enabled - toggle off to take damage again.")

-- ==================== AUTO COLLECT TAB ====================
local CollectSection = CollectTab:CreateSection("Auto Collect Settings")

CollectTab:CreateToggle({
    Name = "Enable Auto Collect",
    Callback = function(Value)
        Settings.AutoCollect = Value
        Rayfield:Notify({
            Title = "Auto Collect",
            Content = Value and "Auto Collect Enabled ✓" or "Auto Collect Disabled ✗",
            Duration = 2,
            Image = 4483362458
        })
        if Value and (collectCoroutine == nil or coroutine.status(collectCoroutine) == "dead") then
            collectCoroutine = coroutine.create(autoCollect)
            coroutine.resume(collectCoroutine)
        end
    end
})

-- Auto Collect Loop
local collectCoroutine = nil
local function autoCollect()
    while Settings.AutoCollect do
        pcall(function()
            local workspace = game:GetService("Workspace")
            local range = Settings.CollectionRange or 50
            
            for _, part in pairs(workspace:GetDescendants()) do
                if Settings.AutoCollect then
                    local isMoney = part.Name:lower():find("money") or part.Name:lower():find("cash") or part.Name:lower():find("coin") or part.Name:lower():find("gem")
                    if isMoney then
                        local targetPos
                        if part:IsA("Model") then
                            targetPos = part.PrimaryPart and part.PrimaryPart.Position
                        elseif part:IsA("BasePart") then
                            targetPos = part.Position
                        end
                        if targetPos and character:FindFirstChild("HumanoidRootPart") then
                            if (targetPos - character.HumanoidRootPart.Position).Magnitude <= range then
                                character.HumanoidRootPart.CFrame = CFrame.new(targetPos)
                                wait(0.1)
                            end
                        end
                    end
                end
            end
        end)
        wait(0.5)
    end
end

CollectTab:CreateToggle({
    Name = "Start Auto Collect Loop",
    Callback = function(Value)
        if Value then
            Settings.AutoCollect = Value
            collectCoroutine = coroutine.create(autoCollect)
            coroutine.resume(collectCoroutine)
        else
            Settings.AutoCollect = false
        end
    end
})

CollectTab:CreateLabel("Automatically collects money from your base brainrots.")
CollectTab:CreateSlider({
    Name = "Collection Range",
    Range = {10, 100},
    Increment = 5,
    Suffix = " studs",
    CurrentValue = 50,
    Callback = function(Value)
        Settings.CollectionRange = Value
    end
})

-- ==================== AUTO UPGRADE TAB ====================
local UpgradeSection = UpgradeTab:CreateSection("Auto Upgrade Settings")

UpgradeTab:CreateToggle({
    Name = "Enable Auto Upgrade",
    Callback = function(Value)
        Settings.AutoUpgrade = Value
        Rayfield:Notify({
            Title = "Auto Upgrade",
            Content = Value and "Auto Upgrade Enabled ✓" or "Auto Upgrade Disabled ✗",
            Duration = 2,
            Image = 4483362458
        })
        if Value and (upgradeCoroutine == nil or coroutine.status(upgradeCoroutine) == "dead") then
            upgradeCoroutine = coroutine.create(autoUpgrade)
            coroutine.resume(upgradeCoroutine)
        end
    end
})

UpgradeTab:CreateSlider({
    Name = "Upgrade Delay",
    Range = {0.1, 2},
    Increment = 0.1,
    Suffix = "s",
    CurrentValue = 0.5,
    Callback = function(Value)
        Settings.AutoUpgradeDelay = Value
    end
})

-- Auto Upgrade Loop
local upgradeCoroutine = nil
local function autoUpgrade()
    while Settings.AutoUpgrade do
        pcall(function()
            local gui = player:FindFirstChild("PlayerGui")
            if gui then
                for _, descendant in pairs(gui:GetDescendants()) do
                    if Settings.AutoUpgrade then
                        -- Look for upgrade buttons
                            if descendant:IsA("TextButton") then
                            if descendant.Name:lower():find("upgrade") or descendant.Text:lower():find("upgrade") then
                                if descendant.Visible and (descendant.Parent and descendant.Parent.Visible) then
                                pcall(function()
                                    safeActivate(descendant)
                                end)
                                wait(0.05)
                            end
                            end
                        end
                    end
                end
            end
        end)
        wait(Settings.AutoUpgradeDelay)
    end
end

UpgradeTab:CreateToggle({
    Name = "Start Auto Upgrade Loop",
    Callback = function(Value)
        if Value then
            Settings.AutoUpgrade = Value
            upgradeCoroutine = coroutine.create(autoUpgrade)
            coroutine.resume(upgradeCoroutine)
        else
            Settings.AutoUpgrade = false
        end
    end
})

UpgradeTab:CreateLabel("Automatically clicks upgrade buttons for your brainrots.")
UpgradeTab:CreateButton({
    Name = "Upgrade All Brainrots",
    Callback = function()
        local gui = player:FindFirstChild("PlayerGui")
        if gui then
            for _, descendant in pairs(gui:GetDescendants()) do
                if descendant:IsA("TextButton") and (descendant.Name:lower():find("upgrade") or descendant.Text:lower():find("upgrade")) then
                    if descendant.Visible then
                        pcall(function()
                            safeActivate(descendant)
                        end)
                    end
                end
            end
        end
        Rayfield:Notify({
            Title = "Upgrade",
            Content = "Upgrade attempt completed ✓",
            Duration = 2
        })
    end
})

-- ==================== MISCELLANEOUS TAB ====================
local MiscTab = Window:CreateTab("⚙️ Miscellaneous", 4483362458)

MiscTab:CreateButton({
    Name = "Stop All Scripts",
    Callback = function()
        Settings.AutoTrain = false
        Settings.AutoCollect = false
        Settings.AutoUpgrade = false
        Settings.GodMode = false
        
        Rayfield:Notify({
            Title = "Scripts Stopped",
            Content = "All scripts have been stopped ✓",
            Duration = 2
        })
    end
})

MiscTab:CreateButton({
    Name = "Rejoin Game",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId)
    end
})

MiscTab:CreateLabel("Script Version: 1.0")
MiscTab:CreateLabel("Game: Kick A Lucky Block")

-- Handle character respawn
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    if Settings.GodMode then
        local humanoid = character:WaitForChild("Humanoid")
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
    end
end)

-- Cleanup on script stop
game:GetService("RunService").Heartbeat:Connect(function()
    if not game.Parent then
        Settings.AutoTrain = false
        Settings.AutoCollect = false
        Settings.AutoUpgrade = false
        Settings.GodMode = false
    end
end)

Rayfield:Notify({
    Title = "Script Loaded",
    Content = "Kick A Lucky Block Hub is ready! ✓",
    Duration = 3,
    Image = 4483362458
})

return {
    Settings = Settings,
    Window = Window
}
