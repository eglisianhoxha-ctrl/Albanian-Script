# Kick A Lucky Block - Rayfield UI Script

A comprehensive Roblox script for the game "Kick A Lucky Block" with multiple automation features.

## Features

### 🏋️ Auto Train
- **Hold Dumbell**: Automatically equips and holds the dumbell from your inventory
- **Click ×2 Button**: Automatically clicks the purple ×2 button to train
- **Adjustable Speed**: Control how fast the training automation runs (0.05x - 1x)

### ❤️ God Mode
- **Infinite Health**: Sets your health to infinite (math.huge)
- **Wave Protection**: Can't die from waves or other damage
- **Health Regeneration**: Automatically restores health if any damage occurs

### 💰 Auto Collect
- **Auto Collection**: Automatically collects money/currency from brainrots in your base
- **Range Control**: Adjust collection range from 10-100 studs
- **Smart Pathing**: Moves to collect items automatically

### ⬆️ Auto Upgrade
- **Automatic Upgrades**: Continuously clicks upgrade buttons for your brainrots
- **Adjustable Delay**: Control upgrade speed (0.1s - 2s)
- **Manual Upgrade**: One-click button to upgrade all brainrots at once

## How to Use

1. **Copy the script**: Copy the content of `KickALuckyBlock.lua`
2. **Open Executor**: Use any Roblox script executor (Synapse X, Krnl, etc.)
3. **Paste & Execute**: Paste the script into the executor and run it
4. **Rayfield UI Loads**: The Rayfield UI will appear on your screen

## Features Usage

### Auto Train Tab
- Toggle "Enable Auto Train" to start automatic training
- Use the speed slider to adjust how fast it trains
- The script will hold the dumbell and click the ×2 button repeatedly

### God Mode Tab
- Toggle "Enable God Mode (Inf Health)" for infinite health
- You won't take damage from waves or other sources
- Toggle off to go back to normal

### Auto Collect Tab
- Toggle "Enable Auto Collect" to automatically collect money
- Adjust the collection range as needed
- The script teleports to money objects and collects them

### Auto Upgrade Tab
- Toggle "Enable Auto Upgrade Loop" for automatic upgrades
- Adjust upgrade delay to control speed
- Use "Upgrade All Brainrots" button for manual one-time upgrade

### Miscellaneous Tab
- **Stop All Scripts**: Immediately stops all running automations
- **Rejoin Game**: Teleports you back to the game
- Displays script version info

## Settings Saved

The script auto-saves your configuration in VS Code folder: `KickALuckyBlockHub`

## Requirements

- Roblox script executor capable of running Lua
- Rayfield UI library (loaded automatically from CDN)
- Access to execute scripts in Roblox

## Important Notes

⚠️ **Use Responsibly**
- This script is for educational purposes
- Use with caution - game developers may detect automation
- Ban risk varies by game rules
- Disable before joining multiplayer zones if cautious

✅ **Features Work Best When**
- You have a dumbell in your inventory (for Auto Train)
- You have brainrots in your base (for Auto Collect/Upgrade)
- You're in your base/safe zone (for God Mode)

## Troubleshooting

**"Script not working?"**
- Make sure your executor supports Rayfield
- Check if the game interface matches the script (button names, etc.)
- Try clicking "Stop All Scripts" and re-enabling features

**"God Mode not protecting?"**
- Make sure God Mode is toggled ON
- You may need to toggle it after respawning

**"Auto features not clicking?"**
- The script uses UI button detection
- If button names changed in-game, script may need updates

## Script Updates

For updates or improvements, modify the object detection in each loop section:
- Auto Train: Looks for "dumb" or "barbell" in dumbell name
- Auto Collect: Looks for "money", "cash", or "coin" names
- Auto Upgrade: Looks for "upgrade" in button names

Adjust these if the game uses different naming conventions.

---

**Enjoy automating Kick A Lucky Block!** ✓
