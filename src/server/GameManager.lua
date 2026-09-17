-- GameManager.lua
-- Main game state manager and coordinator

local GameManager = {}
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Game states
local GameState = {
    WAITING = "Waiting",
    PLAYING = "Playing",
    GAME_OVER = "GameOver",
    VICTORY = "Victory",
}

GameManager.currentState = GameState.WAITING
GameManager.gameLoop = nil
GameManager.modules = {}

-- Initialize game manager
function GameManager.init()
    -- Create RemoteEvents for client-server communication
    local remoteEvents = Instance.new("Folder")
    remoteEvents.Name = "RemoteEvents"
    remoteEvents.Parent = ReplicatedStorage

    local moveEvent = Instance.new("RemoteEvent")
    moveEvent.Name = "PlayerMove"
    moveEvent.Parent = ReplicatedStorage

    local gameStateEvent = Instance.new("RemoteEvent")
    gameStateEvent.Name = "GameStateChanged"
    gameStateEvent.Parent = ReplicatedStorage

    local scoreUpdateEvent = Instance.new("RemoteEvent")
    scoreUpdateEvent.Name = "ScoreUpdate"
    scoreUpdateEvent.Parent = ReplicatedStorage

    -- Load modules
    local ServerScriptService = game:GetService("ServerScriptService")
    GameManager.modules.MazeGenerator = require(ServerScriptService:WaitForChild("MazeGenerator"))
    GameManager.modules.PlayerController = require(ServerScriptService:WaitForChild("PlayerController"))
    GameManager.modules.GhostAI = require(ServerScriptService:WaitForChild("GhostAI"))
    GameManager.modules.PelletManager = require(ServerScriptService:WaitForChild("PelletManager"))

    -- Connect player events
    Players.PlayerAdded:Connect(GameManager.onPlayerJoined)
    Players.PlayerRemoving:Connect(GameManager.onPlayerLeft)

    -- Connect movement event
    moveEvent.OnServerEvent:Connect(GameManager.onPlayerMove)
end

-- Handle player joining
function GameManager.onPlayerJoined(player)
    print(player.Name .. " joined the game")

    -- Wait for character to load
    player.CharacterAdded:Connect(function()
        if GameManager.currentState == GameState.WAITING then
            GameManager.startGame()
        elseif GameManager.currentState == GameState.PLAYING then
            -- Add player to ongoing game
            local spawnPositions = GameManager.modules.MazeGenerator.getSpawnPositions()
            GameManager.modules.PlayerController.initializePlayer(player, spawnPositions.player)
        end
    end)
end

-- Handle player leaving
function GameManager.onPlayerLeft(player)
    print(player.Name .. " left the game")
    GameManager.modules.PlayerController.removePlayer(player)

    -- Check if any players remain
    if #Players:GetPlayers() == 0 then
        GameManager.endGame()
    end
end

-- Handle player movement input
function GameManager.onPlayerMove(player, direction)
    if GameManager.currentState ~= GameState.PLAYING then
        return
    end

    GameManager.modules.PlayerController.setPlayerDirection(player, direction)
end

-- Start the game
function GameManager.startGame()
    print("Starting PacBlox game...")

    GameManager.currentState = GameState.PLAYING

    -- Generate maze
    local maze, totalPellets = GameManager.modules.MazeGenerator.generateMaze(workspace)

    -- Get spawn positions
    local spawnPositions = GameManager.modules.MazeGenerator.getSpawnPositions()

    -- Initialize players
    for _, player in pairs(Players:GetPlayers()) do
        GameManager.modules.PlayerController.initializePlayer(player, spawnPositions.player)
    end

    -- Initialize ghosts
    GameManager.modules.GhostAI.init(spawnPositions)

    -- Initialize pellet manager
    GameManager.modules.PelletManager.init(maze, totalPellets)

    -- Setup pellet collection callback
    GameManager.modules.PelletManager.onPelletCollected(function(player, _points, totalScore, isPowerPellet)
        -- Update client UI
        local scoreUpdateEvent = ReplicatedStorage:FindFirstChild("ScoreUpdate")
        if scoreUpdateEvent then
            scoreUpdateEvent:FireClient(player, totalScore)
        end

        -- Handle power pellet
        if isPowerPellet then
            GameManager.activatePowerMode(10)
        end
    end)

    -- Notify clients game started
    local gameStateEvent = ReplicatedStorage:FindFirstChild("GameStateChanged")
    if gameStateEvent then
        gameStateEvent:FireAllClients(GameManager.currentState)
    end

    -- Start game loop
    GameManager.startGameLoop()
end

-- Main game loop
function GameManager.startGameLoop()
    local lastUpdate = tick()

    GameManager.gameLoop = RunService.Heartbeat:Connect(function()
        if GameManager.currentState ~= GameState.PLAYING then
            return
        end

        local now = tick()
        local deltaTime = now - lastUpdate
        lastUpdate = now

        -- Update player movement
        for player, _ in pairs(GameManager.modules.PlayerController.players) do
            GameManager.modules.PlayerController.updateMovement(player)
            GameManager.modules.PlayerController.updatePowerUp(player, deltaTime)
        end

        -- Update ghost AI
        GameManager.modules.GhostAI.updateStates(deltaTime)

        for _, ghostData in pairs(GameManager.modules.GhostAI.ghosts) do
            local caughtPlayer =
                GameManager.modules.GhostAI.updateGhost(ghostData, GameManager.modules.PlayerController)

            if caughtPlayer then
                -- Player was caught by ghost
                GameManager.playerCaught(caughtPlayer)
            end
        end

        -- Check pellet collections
        GameManager.modules.PelletManager.checkCollections(GameManager.modules.PlayerController, GameManager)
    end)
end

-- Handle player being caught
function GameManager.playerCaught(player)
    print(player.Name .. " was caught!")

    GameManager.modules.PlayerController.killPlayer(player)

    -- Check if all players are dead
    local anyAlive = false
    for _, playerData in pairs(GameManager.modules.PlayerController.players) do
        if playerData.isAlive then
            anyAlive = true
            break
        end
    end

    if not anyAlive then
        GameManager.gameOver()
    end
end

-- Handle player winning
function GameManager.playerWins(player)
    print(player.Name .. " collected all pellets!")

    GameManager.currentState = GameState.VICTORY

    -- Stop game loop
    if GameManager.gameLoop then
        GameManager.gameLoop:Disconnect()
        GameManager.gameLoop = nil
    end

    -- Notify clients
    local gameStateEvent = ReplicatedStorage:FindFirstChild("GameStateChanged")
    if gameStateEvent then
        gameStateEvent:FireAllClients(GameState.VICTORY, player.Name)
    end

    -- Restart after delay
    wait(5)
    GameManager.resetGame()
end

-- Handle game over
function GameManager.gameOver()
    print("Game Over!")

    GameManager.currentState = GameState.GAME_OVER

    -- Stop game loop
    if GameManager.gameLoop then
        GameManager.gameLoop:Disconnect()
        GameManager.gameLoop = nil
    end

    -- Notify clients
    local gameStateEvent = ReplicatedStorage:FindFirstChild("GameStateChanged")
    if gameStateEvent then
        gameStateEvent:FireAllClients(GameState.GAME_OVER)
    end

    -- Restart after delay
    wait(5)
    GameManager.resetGame()
end

-- Activate power mode
function GameManager.activatePowerMode(duration)
    GameManager.modules.GhostAI.activatePowerMode(duration)
end

-- Reset the game
function GameManager.resetGame()
    print("Resetting game...")

    -- Clean up existing game objects
    if workspace:FindFirstChild("Maze") then
        workspace.Maze:Destroy()
    end

    -- Clean up ghosts
    GameManager.modules.GhostAI.cleanup()

    -- Reset pellet manager
    GameManager.modules.PelletManager.reset()

    -- Reset player scores
    for player, _ in pairs(GameManager.modules.PlayerController.players) do
        GameManager.modules.PlayerController.removePlayer(player)
    end

    -- Start new game if players are present
    if #Players:GetPlayers() > 0 then
        wait(2)
        GameManager.startGame()
    else
        GameManager.currentState = GameState.WAITING
    end
end

-- End the game
function GameManager.endGame()
    if GameManager.gameLoop then
        GameManager.gameLoop:Disconnect()
        GameManager.gameLoop = nil
    end

    GameManager.currentState = GameState.WAITING
end

return GameManager
