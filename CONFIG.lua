-- Configuration Guide for Kick A Lucky Block Script
-- Modify these values to customize behavior

return {
    -- Auto Train Configuration
    AutoTrainConfig = {
        Enabled = false,
        Speed = 0.1, -- Lower = faster (0.05-1)
        DumbbellNames = {"Dumbell", "Barbell", "Dumbbell", "Weight"}, -- Alternative object names
        ButtonText = "×2", -- Purple button indicator
        ButtonColor = Color3.fromRGB(128, 0, 128) -- Purple color
    },

    -- God Mode Configuration  
    GodModeConfig = {
        Enabled = false,
        InfiniteHealth = true,
        InfiniteHealthValue = math.huge,
        BlockWaveDamage = true,
        BlockFallDamage = true
    },

    -- Auto Collect Configuration
    AutoCollectConfig = {
        Enabled = false,
        CollectionRange = 50, -- studs
        Delay = 0.5, -- seconds between collections
        MoneyObjectNames = {"Money", "Cash", "Coin", "Gem", "Currency"},
        TeleportToItems = true,
        MoveSpeed = 1 -- speed multiplier
    },

    -- Auto Upgrade Configuration
    AutoUpgradeConfig = {
        Enabled = false,
        UpgradeDelay = 0.5, -- seconds between upgrades
        UpgradeButtonNames = {"Upgrade", "Upgrade Brainrot", "Enhance", "Level Up"},
        AutoClickVisibleOnly = true,
        CheckForEnoughMoney = false -- Set to true to check balance before upgrading
    },

    -- General Settings
    GeneralSettings = {
        ConfigSavingEnabled = true,
        ConfigFolderName = "KickALuckyBlockHub",
        NotificationsEnabled = true,
        AutoRejoinOnKick = false,
        RejoinDelay = 5 -- seconds
    }
}

--[[
    HOW TO USE THIS CONFIG:
    
    1. If you want to add/modify object detection:
       - Add object names to the respective "Names" table
       - The script uses string matching with :lower():find()
       
    2. If buttons don't get clicked:
       - Check the button names in your game
       - Add them to the Names table
       - Check the button colors (for ×2 button)
       
    3. If features run too slow/fast:
       - Adjust the Delay or Speed values
       - Lower values = faster execution
       
    4. Troubleshooting colors:
       - Get button color: print(button.BackgroundColor3)
       - Compare with Color3.fromRGB(R, G, B)
--]]
