-- MainServer.lua
-- Main server script that initializes and runs the PacBlox game

local ServerScriptService = game:GetService("ServerScriptService")

-- Wait for all modules to load
print("PacBlox Server Starting...")

-- Create module instances folder
local modulesFolder = Instance.new("Folder")
modulesFolder.Name = "PacBloxModules"
modulesFolder.Parent = ServerScriptService

-- Load game modules
local GameManager = require(script.Parent:WaitForChild("GameManager"))
local SoundManager = require(script.Parent:WaitForChild("SoundManager"))

-- Initialize systems
print("Initializing game systems...")

-- Initialize sound manager first
SoundManager.init()

-- Initialize game manager (this handles everything else)
GameManager.init()

print("PacBlox Server Ready!")
print("================================")
print("PacBlox - Classic Arcade Action")
print("================================")
print("Controls:")
print("- WASD or Arrow Keys to move")
print("- Collect all pellets to win")
print("- Avoid ghosts (unless powered up!)")
print("- Power pellets let you eat ghosts")
print("================================")
print("Waiting for players to join...")
