-- PelletManager.lua
-- Manages pellet collection and scoring system

local PelletManager = {}
local RunService = game:GetService("RunService")

PelletManager.PELLET_SCORE = 10
PelletManager.POWER_PELLET_SCORE = 50
PelletManager.POWER_UP_DURATION = 10  -- seconds

local totalPellets = 0
local collectedPellets = 0
local pelletCollectionCallbacks = {}

-- Initialize pellet manager with maze pellets
function PelletManager.init(mazeFolder, pelletCount)
    totalPellets = pelletCount
    collectedPellets = 0
    
    -- Setup collision detection for all pellets
    local pellets = mazeFolder:FindFirstChild("Pellets")
    local powerPellets = mazeFolder:FindFirstChild("PowerPellets")
    
    if pellets then
        for _, pellet in pairs(pellets:GetChildren()) do
            PelletManager.setupPelletCollision(pellet, false)
        end
    end
    
    if powerPellets then
        for _, powerPellet in pairs(powerPellets:GetChildren()) do
            PelletManager.setupPelletCollision(powerPellet, true)
        end
    end
end

-- Setup collision detection for a pellet
function PelletManager.setupPelletCollision(pellet, isPowerPellet)
    -- Add a slightly larger invisible collision part
    local collisionPart = Instance.new("Part")
    collisionPart.Name = "CollisionPart"
    collisionPart.Size = isPowerPellet and Vector3.new(2, 2, 2) or Vector3.new(1.5, 1.5, 1.5)
    collisionPart.Position = pellet.Position
    collisionPart.Anchored = true
    collisionPart.CanCollide = false
    collisionPart.Transparency = 1
    collisionPart.Parent = pellet
    
    -- Store reference to actual pellet
    collisionPart:SetAttribute("IsPowerPellet", isPowerPellet)
    collisionPart:SetAttribute("PelletPart", pellet)
end

-- Check for pellet collection
function PelletManager.checkCollections(playerController, gameManager)
    for player, playerData in pairs(playerController.players) do
        if not playerData.isAlive then continue end
        
        local character = playerData.character
        if not character then continue end
        
        local body = character:FindFirstChild("Body")
        if not body then continue end
        
        -- Check regular pellets
        local pellets = workspace:FindFirstChild("Maze"):FindFirstChild("Pellets")
        if pellets then
            for _, pellet in pairs(pellets:GetChildren()) do
                if pellet and pellet.Parent and pellet:FindFirstChild("CollisionPart") then
                    local distance = (pellet.Position - body.Position).Magnitude
                    if distance < 2 then
                        PelletManager.collectPellet(player, pellet, false, playerController, gameManager)
                    end
                end
            end
        end
        
        -- Check power pellets
        local powerPellets = workspace:FindFirstChild("Maze"):FindFirstChild("PowerPellets")
        if powerPellets then
            for _, powerPellet in pairs(powerPellets:GetChildren()) do
                if powerPellet and powerPellet.Parent and powerPellet:FindFirstChild("CollisionPart") then
                    local distance = (powerPellet.Position - body.Position).Magnitude
                    if distance < 2.5 then
                        PelletManager.collectPellet(player, powerPellet, true, playerController, gameManager)
                    end
                end
            end
        end
    end
end

-- Handle pellet collection
function PelletManager.collectPellet(player, pellet, isPowerPellet, playerController, gameManager)
    -- Prevent double collection
    if pellet:GetAttribute("Collected") then return end
    pellet:SetAttribute("Collected", true)
    
    -- Add score
    local score = isPowerPellet and PelletManager.POWER_PELLET_SCORE or PelletManager.PELLET_SCORE
    local newScore = playerController.addScore(player, score)
    
    -- Update pellet count
    collectedPellets = collectedPellets + 1
    
    -- Animate pellet disappearance
    spawn(function()
        for i = 1, 10 do
            pellet.Transparency = i / 10
            pellet.Size = pellet.Size * 0.9
            wait(0.02)
        end
        pellet:Destroy()
    end)
    
    -- Handle power pellet effect
    if isPowerPellet then
        playerController.activatePowerUp(player, PelletManager.POWER_UP_DURATION)
        -- Notify ghost AI to enter frightened mode
        if gameManager then
            gameManager.activatePowerMode(PelletManager.POWER_UP_DURATION)
        end
    end
    
    -- Fire callbacks
    for _, callback in pairs(pelletCollectionCallbacks) do
        callback(player, score, newScore, isPowerPellet)
    end
    
    -- Check win condition
    if collectedPellets >= totalPellets then
        if gameManager then
            gameManager.playerWins(player)
        end
    end
end

-- Add callback for pellet collection events
function PelletManager.onPelletCollected(callback)
    table.insert(pelletCollectionCallbacks, callback)
end

-- Get pellet collection progress
function PelletManager.getProgress()
    return collectedPellets, totalPellets
end

-- Reset pellet manager
function PelletManager.reset()
    collectedPellets = 0
    pelletCollectionCallbacks = {}
end

return PelletManager