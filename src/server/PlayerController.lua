-- PlayerController.lua
-- Handles player character creation and server-side movement validation

local PlayerController = {}

PlayerController.MOVE_SPEED = 16 -- Studs per second
PlayerController.players = {} -- Track active players

-- Create the PacBlox character model
function PlayerController.createCharacter(player)
    local character = Instance.new("Model")
    character.Name = player.Name .. "_PacBlox"

    -- Create main body (sphere)
    local body = Instance.new("Part")
    body.Name = "Body"
    body.Shape = Enum.PartType.Ball
    body.Size = Vector3.new(3, 3, 3)
    body.Material = Enum.Material.Neon
    body.BrickColor = BrickColor.new("New Yeller")
    body.TopSurface = Enum.SurfaceType.Smooth
    body.BottomSurface = Enum.SurfaceType.Smooth
    body.CanCollide = false
    body.Parent = character

    -- Create mouth (wedge for Pac-Man look)
    local mouth = Instance.new("WedgePart")
    mouth.Name = "Mouth"
    mouth.Size = Vector3.new(1.5, 3, 3)
    mouth.Material = Enum.Material.Neon
    mouth.BrickColor = BrickColor.new("Black")
    mouth.CanCollide = false
    mouth.Anchored = false
    mouth.Parent = character

    -- Weld mouth to body
    local weld = Instance.new("WeldConstraint")
    weld.Part0 = body
    weld.Part1 = mouth
    weld.Parent = body
    mouth.CFrame = body.CFrame * CFrame.new(0.75, 0, 0) * CFrame.Angles(0, math.rad(90), 0)

    -- Add Humanoid for movement
    local humanoid = Instance.new("Humanoid")
    humanoid.MaxHealth = 100
    humanoid.Health = 100
    humanoid.WalkSpeed = PlayerController.MOVE_SPEED
    humanoid.JumpHeight = 0 -- Disable jumping
    humanoid.Parent = character

    -- Set primary part
    character.PrimaryPart = body

    -- Add BodyVelocity for smooth movement
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(4000, 0, 4000)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = body

    -- Add BodyPosition to maintain Y position
    local bodyPosition = Instance.new("BodyPosition")
    bodyPosition.MaxForce = Vector3.new(0, 4000, 0)
    bodyPosition.Position = Vector3.new(0, 2, 0)
    bodyPosition.Parent = body

    return character
end

-- Initialize player when they join
function PlayerController.initializePlayer(player, spawnPosition)
    local character = PlayerController.createCharacter(player)
    character:SetPrimaryPartCFrame(CFrame.new(spawnPosition))
    character.Parent = workspace

    -- Store player data
    PlayerController.players[player] = {
        character = character,
        direction = Vector3.new(0, 0, 0),
        nextDirection = Vector3.new(0, 0, 0),
        score = 0,
        powerUpTime = 0,
        isAlive = true,
    }

    -- Set character for player
    player.Character = character

    return character
end

-- Update player movement direction
function PlayerController.setPlayerDirection(player, direction)
    if PlayerController.players[player] then
        PlayerController.players[player].nextDirection = direction
    end
end

-- Check if movement in direction is valid (no wall collision)
function PlayerController.canMove(position, direction)
    local ray = workspace:Raycast(position, direction * 2, RaycastParams.new())

    if ray and ray.Instance and ray.Instance.Name:find("Wall") then
        return false
    end

    return true
end

-- Update player movement
function PlayerController.updateMovement(player)
    local playerData = PlayerController.players[player]
    if not playerData or not playerData.isAlive then
        return
    end

    local character = playerData.character
    local body = character:FindFirstChild("Body")
    local bodyVelocity = body and body:FindFirstChild("BodyVelocity")

    if not bodyVelocity then
        return
    end

    -- Check if we can change to the next direction
    if playerData.nextDirection.Magnitude > 0 then
        if PlayerController.canMove(body.Position, playerData.nextDirection) then
            playerData.direction = playerData.nextDirection
            playerData.nextDirection = Vector3.new(0, 0, 0)
        end
    end

    -- Check if current direction is still valid
    if playerData.direction.Magnitude > 0 then
        if not PlayerController.canMove(body.Position, playerData.direction) then
            playerData.direction = Vector3.new(0, 0, 0)
        end
    end

    -- Apply movement
    bodyVelocity.Velocity = playerData.direction * PlayerController.MOVE_SPEED

    -- Rotate character to face movement direction
    if playerData.direction.Magnitude > 0 then
        local lookDirection = body.Position + playerData.direction
        body.CFrame = CFrame.lookAt(body.Position, lookDirection)
    end
end

-- Handle player death
function PlayerController.killPlayer(player)
    local playerData = PlayerController.players[player]
    if playerData then
        playerData.isAlive = false
        if playerData.character then
            -- Play death animation (make character disappear)
            local body = playerData.character:FindFirstChild("Body")
            if body then
                for i = 1, 10 do
                    body.Transparency = i / 10
                    wait(0.05)
                end
            end
        end
    end
end

-- Clean up when player leaves
function PlayerController.removePlayer(player)
    local playerData = PlayerController.players[player]
    if playerData and playerData.character then
        playerData.character:Destroy()
    end
    PlayerController.players[player] = nil
end

-- Get player score
function PlayerController.getScore(player)
    local playerData = PlayerController.players[player]
    return playerData and playerData.score or 0
end

-- Add to player score
function PlayerController.addScore(player, points)
    local playerData = PlayerController.players[player]
    if playerData then
        playerData.score = playerData.score + points
        return playerData.score
    end
    return 0
end

-- Activate power-up for player
function PlayerController.activatePowerUp(player, duration)
    local playerData = PlayerController.players[player]
    if playerData then
        playerData.powerUpTime = duration
        -- Make player glow to indicate power-up
        local body = playerData.character:FindFirstChild("Body")
        if body then
            body.BrickColor = BrickColor.new("Cyan")
        end
    end
end

-- Update power-up timer
function PlayerController.updatePowerUp(player, deltaTime)
    local playerData = PlayerController.players[player]
    if playerData and playerData.powerUpTime > 0 then
        playerData.powerUpTime = playerData.powerUpTime - deltaTime

        if playerData.powerUpTime <= 0 then
            -- Power-up expired, return to normal
            local body = playerData.character:FindFirstChild("Body")
            if body then
                body.BrickColor = BrickColor.new("New Yeller")
            end
        end
    end
end

-- Check if player has active power-up
function PlayerController.hasPowerUp(player)
    local playerData = PlayerController.players[player]
    return playerData and playerData.powerUpTime > 0
end

return PlayerController
