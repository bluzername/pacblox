# PacBlox Setup Instructions for Roblox Studio

## Quick Setup Guide

### Step 1: Prepare Roblox Studio
1. Open Roblox Studio
2. Create a new Baseplate game (File → New → Baseplate)
3. Delete the default SpawnLocation (not needed for our game)

### Step 2: Create Server Scripts
1. In the Explorer window, find **ServerScriptService**
2. Right-click on ServerScriptService → Insert Object → Script
3. Name this script "MainServer"
4. Delete the default code and paste the contents of `src/server/MainServer.lua`

5. Create additional Module Scripts in ServerScriptService:
   - Right-click ServerScriptService → Insert Object → ModuleScript
   - Create these modules and paste the corresponding code:
     - `GameManager` ← src/server/GameManager.lua
     - `MazeGenerator` ← src/server/MazeGenerator.lua
     - `PlayerController` ← src/server/PlayerController.lua
     - `GhostAI` ← src/server/GhostAI.lua
     - `PelletManager` ← src/server/PelletManager.lua
     - `SoundManager` ← src/server/SoundManager.lua

### Step 3: Create Client Scripts
1. In Explorer, navigate to **StarterPlayer → StarterPlayerScripts**
2. Right-click on StarterPlayerScripts → Insert Object → LocalScript
3. Name this script "MainClient"
4. Delete default code and paste contents of `src/client/MainClient.lua`

5. Create client Module Scripts in StarterPlayerScripts:
   - Right-click StarterPlayerScripts → Insert Object → ModuleScript
   - Create these modules:
     - `InputHandler` ← src/client/InputHandler.lua
     - `UIManager` ← src/client/UIManager.lua

### Step 4: Configure Workspace
1. In Workspace properties:
   - Set Gravity to 196.2 (default)
   - Ensure Streaming is disabled for consistent gameplay

### Step 5: Test the Game
1. Click the "Play" button in Roblox Studio
2. Use WASD or Arrow keys to move
3. The game should automatically start when you spawn

## Troubleshooting

### Common Issues and Solutions

**Issue: Scripts not running**
- Solution: Make sure MainServer is a Script (not LocalScript or ModuleScript)
- Make sure MainClient is a LocalScript (not Script or ModuleScript)

**Issue: Character not spawning**
- Solution: The game creates its own character. Make sure you deleted the default SpawnLocation

**Issue: Modules not found**
- Solution: Ensure all ModuleScripts are named exactly as specified (case-sensitive)

**Issue: Maze not appearing**
- Solution: Check that MazeGenerator module is in ServerScriptService

**Issue: Controls not working**
- Solution: Ensure InputHandler is in StarterPlayerScripts as a ModuleScript

## Advanced Configuration

### Changing Game Settings
Edit these values in the respective files:

**MazeGenerator.lua:**
```lua
CELL_SIZE = 4        -- Size of each maze cell
WALL_HEIGHT = 8      -- Height of maze walls
```

**PlayerController.lua:**
```lua
MOVE_SPEED = 16      -- Player movement speed
```

**GhostAI.lua:**
```lua
GHOST_SPEED = 14             -- Normal ghost speed
FRIGHTENED_SPEED = 8         -- Ghost speed when fleeing
SCATTER_DURATION = 7         -- Seconds in scatter mode
CHASE_DURATION = 20          -- Seconds in chase mode
```

### Custom Maze Layouts
To create your own maze, edit the MAZE_LAYOUT array in MazeGenerator.lua.
Use this legend:
- 0 = Empty space (no pellet)
- 1 = Wall
- 2 = Regular pellet
- 3 = Power pellet

Example small maze:
```lua
MAZE_LAYOUT = {
    {1,1,1,1,1,1,1},
    {1,3,2,2,2,3,1},
    {1,2,1,1,1,2,1},
    {1,2,2,2,2,2,1},
    {1,1,1,1,1,1,1}
}
```

## Publishing Your Game

### Pre-publish Checklist
- [ ] Test in Studio with multiple players (Test → Start Server)
- [ ] Verify all controls work properly
- [ ] Check that scoring system functions correctly
- [ ] Ensure ghosts behave as expected
- [ ] Test win and lose conditions

### Publishing Steps
1. File → Publish to Roblox
2. Give your game a name and description
3. Select appropriate genre (Action/Arcade)
4. Upload a thumbnail (optional but recommended)
5. Set game to Public when ready

### Recommended Game Settings
- Max Players: 1-4 (game is designed for single player but can support multiple)
- Genre: Action or Classic
- Devices: Computer, Phone, Tablet (all supported)

## Adding Polish

### Sound Effects
To add actual sound effects:
1. Find sound assets on Roblox Library or upload your own
2. Copy the asset IDs (format: rbxassetid://XXXXXXXXX)
3. Edit SoundManager.lua and replace the placeholder comments with actual IDs

### Visual Effects
Consider adding:
- Particle effects for pellet collection
- Ghost eye animations
- Player mouth animation
- Maze wall glow effects

## Support
If you encounter issues:
1. Check the Output window in Roblox Studio for error messages
2. Verify all scripts are in the correct locations
3. Ensure script names match exactly (case-sensitive)
4. Try testing with a fresh Baseplate template

## Next Steps
Once the basic game is working:
- Add more maze layouts
- Implement level progression
- Create a high score system
- Add multiplayer competitive modes
- Customize visual themes

Good luck with your PacBlox game!