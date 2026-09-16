-- Constants.lua
-- Shared game constants and configuration values

local Constants = {}

-- Game Settings
Constants.GRID_SIZE = 4
Constants.MAZE_WIDTH = 19
Constants.MAZE_HEIGHT = 21

-- Player Settings
Constants.PLAYER_SPEED = 16
Constants.PLAYER_TURN_SPEED = 0.1

-- Ghost Settings
Constants.GHOST_SPEED = 14
Constants.GHOST_FRIGHTENED_SPEED = 8
Constants.GHOST_EATEN_SPEED = 32

-- Timing
Constants.POWER_UP_DURATION = 10
Constants.SCATTER_DURATION = 7
Constants.CHASE_DURATION = 20
Constants.FRIGHTENED_FLASH_TIME = 2

-- Scoring
Constants.PELLET_SCORE = 10
Constants.POWER_PELLET_SCORE = 50
Constants.GHOST_SCORE = 200
Constants.LEVEL_COMPLETE_BONUS = 1000

-- Cell Types
Constants.CellType = {
    WALL = 1,
    PELLET = 2,
    POWER_PELLET = 3,
    EMPTY = 0,
    GHOST_HOUSE = 4,
}

-- Game States
Constants.GameState = {
    WAITING = "Waiting",
    PLAYING = "Playing",
    POWER_UP = "PowerUp",
    VICTORY = "Victory",
    GAME_OVER = "GameOver",
}

-- Ghost States
Constants.GhostState = {
    SCATTER = "Scatter",
    CHASE = "Chase",
    FRIGHTENED = "Frightened",
    EATEN = "Eaten",
}

-- Ghost Personalities
Constants.GhostPersonality = {
    BLINKY = "Blinky", -- Red - Direct pursuit
    PINKY = "Pinky", -- Pink - Ambush ahead
    INKY = "Inky", -- Cyan - Unpredictable
    CLYDE = "Clyde", -- Orange - Shy
}

-- Directions
Constants.Direction = {
    UP = Vector3.new(0, 0, 1),
    DOWN = Vector3.new(0, 0, -1),
    LEFT = Vector3.new(-1, 0, 0),
    RIGHT = Vector3.new(1, 0, 0),
    NONE = Vector3.new(0, 0, 0),
}

-- Colors
Constants.Colors = {
    WALL = Color3.fromRGB(0, 0, 255),
    PELLET = Color3.fromRGB(255, 255, 0),
    POWER_PELLET = Color3.fromRGB(255, 255, 255),
    PLAYER = Color3.fromRGB(255, 255, 0),
    GHOST_BLINKY = Color3.fromRGB(255, 0, 0),
    GHOST_PINKY = Color3.fromRGB(255, 184, 255),
    GHOST_INKY = Color3.fromRGB(0, 255, 255),
    GHOST_CLYDE = Color3.fromRGB(255, 184, 82),
    GHOST_FRIGHTENED = Color3.fromRGB(0, 0, 255),
    BACKGROUND = Color3.fromRGB(0, 0, 0),
}

-- Sound IDs (placeholders - replace with actual Roblox sound IDs)
Constants.SoundIds = {
    PELLET_COLLECT = "rbxassetid://131961136",
    POWER_UP = "rbxassetid://131961136",
    GHOST_EATEN = "rbxassetid://131961136",
    DEATH = "rbxassetid://131961136",
    VICTORY = "rbxassetid://131961136",
    GAME_START = "rbxassetid://131961136",
    GHOST_SIREN = "rbxassetid://131961136",
}

return Constants
