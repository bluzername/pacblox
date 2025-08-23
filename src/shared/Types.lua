-- Types.lua
-- Type definitions and data structures for the game

local Constants = require(script.Parent.Constants)

local Types = {}

-- Player data structure
Types.PlayerData = {
    userId = 0,
    displayName = "",
    character = nil,
    position = Vector3.new(0, 0, 0),
    gridPosition = Vector3.new(0, 0, 0),
    direction = Constants.Direction.NONE,
    nextDirection = Constants.Direction.NONE,
    speed = Constants.PLAYER_SPEED,
    score = 0,
    lives = 3,
    isAlive = true,
    isPoweredUp = false,
    powerUpTimeLeft = 0
}

-- Ghost data structure
Types.GhostData = {
    id = "",
    personality = Constants.GhostPersonality.BLINKY,
    position = Vector3.new(0, 0, 0),
    gridPosition = Vector3.new(0, 0, 0),
    homePosition = Vector3.new(0, 0, 0),
    direction = Constants.Direction.NONE,
    state = Constants.GhostState.SCATTER,
    speed = Constants.GHOST_SPEED,
    target = Vector3.new(0, 0, 0),
    stateTimer = 0,
    model = nil,
    color = Constants.Colors.GHOST_BLINKY,
    scatterTarget = Vector3.new(0, 0, 0),
    isInHouse = false,
    exitTimer = 0
}

-- Maze cell data structure  
Types.MazeCell = {
    type = Constants.CellType.EMPTY,
    position = Vector3.new(0, 0, 0),
    hasItem = false,
    itemType = nil,
    part = nil
}

-- Game state data structure
Types.GameState = {
    state = Constants.GameState.WAITING,
    players = {},
    ghosts = {},
    maze = {},
    totalPellets = 0,
    pelletsRemaining = 0,
    gameTimer = 0,
    isPowerUpActive = false,
    powerUpTimeLeft = 0,
    level = 1,
    globalScore = 0
}

-- Pathfinding node
Types.PathNode = {
    position = Vector3.new(0, 0, 0),
    gCost = 0,
    hCost = 0,
    fCost = 0,
    parent = nil,
    walkable = true
}

-- Sound data structure
Types.SoundData = {
    id = "",
    soundId = "",
    volume = 0.5,
    pitch = 1.0,
    looped = false,
    sound = nil,
    isPlaying = false
}

-- UI elements data
Types.UIElementData = {
    name = "",
    type = "Frame",
    parent = nil,
    properties = {},
    children = {},
    element = nil
}

-- Input data structure
Types.InputData = {
    direction = Constants.Direction.NONE,
    timestamp = 0,
    processed = false
}

-- Animation data
Types.AnimationData = {
    target = nil,
    startValue = nil,
    endValue = nil,
    duration = 0,
    elapsed = 0,
    easingFunction = nil,
    onComplete = nil,
    isPlaying = false
}

-- Pellet data structure
Types.PelletData = {
    position = Vector3.new(0, 0, 0),
    gridPosition = Vector3.new(0, 0, 0),
    type = Constants.CellType.PELLET,
    score = Constants.PELLET_SCORE,
    part = nil,
    collected = false
}

-- Constructor functions for creating new instances
function Types.newPlayerData(player)
    local data = {}
    for k, v in pairs(Types.PlayerData) do
        data[k] = v
    end
    if player then
        data.userId = player.UserId
        data.displayName = player.DisplayName
        data.character = player.Character
    end
    return data
end

function Types.newGhostData(id, personality)
    local data = {}
    for k, v in pairs(Types.GhostData) do
        data[k] = v
    end
    data.id = id or ""
    data.personality = personality or Constants.GhostPersonality.BLINKY
    
    -- Set color based on personality
    if personality == Constants.GhostPersonality.BLINKY then
        data.color = Constants.Colors.GHOST_BLINKY
    elseif personality == Constants.GhostPersonality.PINKY then
        data.color = Constants.Colors.GHOST_PINKY
    elseif personality == Constants.GhostPersonality.INKY then
        data.color = Constants.Colors.GHOST_INKY
    elseif personality == Constants.GhostPersonality.CLYDE then
        data.color = Constants.Colors.GHOST_CLYDE
    end
    
    return data
end

function Types.newMazeCell(cellType, position)
    local data = {}
    for k, v in pairs(Types.MazeCell) do
        data[k] = v
    end
    data.type = cellType or Constants.CellType.EMPTY
    data.position = position or Vector3.new(0, 0, 0)
    
    if cellType == Constants.CellType.PELLET or cellType == Constants.CellType.POWER_PELLET then
        data.hasItem = true
        data.itemType = cellType
    end
    
    return data
end

function Types.newGameState()
    local data = {}
    for k, v in pairs(Types.GameState) do
        if type(v) == "table" then
            data[k] = {}
        else
            data[k] = v
        end
    end
    return data
end

function Types.newPelletData(position, gridPosition, pelletType)
    local data = {}
    for k, v in pairs(Types.PelletData) do
        data[k] = v
    end
    data.position = position or Vector3.new(0, 0, 0)
    data.gridPosition = gridPosition or Vector3.new(0, 0, 0)
    data.type = pelletType or Constants.CellType.PELLET
    
    if pelletType == Constants.CellType.POWER_PELLET then
        data.score = Constants.POWER_PELLET_SCORE
    end
    
    return data
end

return Types