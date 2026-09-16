-- GhostAI.lua
-- AI controller for ghost enemies with different personalities

local GhostAI = {}
local RunService = game:GetService("RunService")
local PathfindingService = game:GetService("PathfindingService")

GhostAI.GHOST_SPEED = 14 -- Slightly slower than player
GhostAI.FRIGHTENED_SPEED = 8 -- Speed when player has power-up
GhostAI.SCATTER_DURATION = 7 -- Seconds in scatter mode
GhostAI.CHASE_DURATION = 20 -- Seconds in chase mode

-- Ghost states
local GhostState = {
    SCATTER = "Scatter", -- Move to corners
    CHASE = "Chase", -- Hunt the player
    FRIGHTENED = "Frightened", -- Run from player
    EATEN = "Eaten", -- Return to spawn
}

-- Ghost personalities
local GhostPersonality = {
    RED = "Blinky", -- Direct chaser
    PINK = "Pinky", -- Ambusher (targets ahead of player)
    BLUE = "Inky", -- Unpredictable
    ORANGE = "Clyde", -- Shy (runs when close)
}

GhostAI.ghosts = {}
GhostAI.globalState = GhostState.SCATTER
GhostAI.stateTimer = 0
GhostAI.powerMode = false
GhostAI.powerTimer = 0

-- Create a ghost character
function GhostAI.createGhost(name, color, personality)
    local ghost = Instance.new("Model")
    ghost.Name = name

    -- Ghost body
    local body = Instance.new("Part")
    body.Name = "Body"
    body.Shape = Enum.PartType.Ball
    body.Size = Vector3.new(3, 3, 3)
    body.Material = Enum.Material.Neon
    body.BrickColor = BrickColor.new(color)
    body.TopSurface = Enum.SurfaceType.Smooth
    body.BottomSurface = Enum.SurfaceType.Smooth
    body.CanCollide = false
    body.Parent = ghost

    -- Ghost eyes
    local leftEye = Instance.new("Part")
    leftEye.Name = "LeftEye"
    leftEye.Shape = Enum.PartType.Ball
    leftEye.Size = Vector3.new(0.5, 0.5, 0.5)
    leftEye.Material = Enum.Material.Neon
    leftEye.BrickColor = BrickColor.new("Institutional white")
    leftEye.CanCollide = false
    leftEye.Parent = ghost

    local rightEye = Instance.new("Part")
    rightEye.Name = "RightEye"
    rightEye.Shape = Enum.PartType.Ball
    rightEye.Size = Vector3.new(0.5, 0.5, 0.5)
    rightEye.Material = Enum.Material.Neon
    rightEye.BrickColor = BrickColor.new("Institutional white")
    rightEye.CanCollide = false
    rightEye.Parent = ghost

    -- Eye pupils
    local leftPupil = Instance.new("Part")
    leftPupil.Name = "LeftPupil"
    leftPupil.Shape = Enum.PartType.Ball
    leftPupil.Size = Vector3.new(0.25, 0.25, 0.25)
    leftPupil.Material = Enum.Material.Neon
    leftPupil.BrickColor = BrickColor.new("Really black")
    leftPupil.CanCollide = false
    leftPupil.Parent = ghost

    local rightPupil = Instance.new("Part")
    rightPupil.Name = "RightPupil"
    rightPupil.Shape = Enum.PartType.Ball
    rightPupil.Size = Vector3.new(0.25, 0.25, 0.25)
    rightPupil.Material = Enum.Material.Neon
    rightPupil.BrickColor = BrickColor.new("Really black")
    rightPupil.CanCollide = false
    rightPupil.Parent = ghost

    -- Weld eyes to body
    local weld1 = Instance.new("WeldConstraint")
    weld1.Part0 = body
    weld1.Part1 = leftEye
    weld1.Parent = body
    leftEye.CFrame = body.CFrame * CFrame.new(-0.5, 0.5, -1.2)

    local weld2 = Instance.new("WeldConstraint")
    weld2.Part0 = body
    weld2.Part1 = rightEye
    weld2.Parent = body
    rightEye.CFrame = body.CFrame * CFrame.new(0.5, 0.5, -1.2)

    local weld3 = Instance.new("WeldConstraint")
    weld3.Part0 = leftEye
    weld3.Part1 = leftPupil
    weld3.Parent = leftEye
    leftPupil.CFrame = leftEye.CFrame * CFrame.new(0, 0, -0.15)

    local weld4 = Instance.new("WeldConstraint")
    weld4.Part0 = rightEye
    weld4.Part1 = rightPupil
    weld4.Parent = rightEye
    rightPupil.CFrame = rightEye.CFrame * CFrame.new(0, 0, -0.15)

    -- Add Humanoid for pathfinding
    local humanoid = Instance.new("Humanoid")
    humanoid.MaxHealth = 100
    humanoid.Health = 100
    humanoid.WalkSpeed = GhostAI.GHOST_SPEED
    humanoid.JumpHeight = 0
    humanoid.Parent = ghost

    -- Set primary part
    ghost.PrimaryPart = body

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

    return ghost
end

-- Initialize ghost AI
function GhostAI.init(spawnPositions)
    local ghostData = {
        { name = "Blinky", color = "Really red", personality = GhostPersonality.RED },
        { name = "Pinky", color = "Pink", personality = GhostPersonality.PINK },
        { name = "Inky", color = "Cyan", personality = GhostPersonality.BLUE },
        { name = "Clyde", color = "Deep orange", personality = GhostPersonality.ORANGE },
    }

    for i, data in ipairs(ghostData) do
        local ghost = GhostAI.createGhost(data.name, data.color, data.personality)
        ghost:SetPrimaryPartCFrame(CFrame.new(spawnPositions.ghosts[i]))
        ghost.Parent = workspace

        GhostAI.ghosts[ghost] = {
            model = ghost,
            personality = data.personality,
            state = GhostState.SCATTER,
            originalColor = data.color,
            spawnPosition = spawnPositions.ghosts[i],
            targetPosition = nil,
            path = nil,
            currentWaypoint = 1,
            direction = Vector3.new(0, 0, 0),
            isAlive = true,
        }
    end
end

-- Get scatter target based on personality
function GhostAI.getScatterTarget(ghostData)
    local corners = {
        Vector3.new(-50, 2, -50), -- Top-left
        Vector3.new(50, 2, -50), -- Top-right
        Vector3.new(-50, 2, 50), -- Bottom-left
        Vector3.new(50, 2, 50), -- Bottom-right
    }

    if ghostData.personality == GhostPersonality.RED then
        return corners[2] -- Top-right
    elseif ghostData.personality == GhostPersonality.PINK then
        return corners[1] -- Top-left
    elseif ghostData.personality == GhostPersonality.BLUE then
        return corners[4] -- Bottom-right
    else
        return corners[3] -- Bottom-left
    end
end

-- Get chase target based on personality
function GhostAI.getChaseTarget(ghostData, playerPosition, playerDirection)
    if not playerPosition then
        return ghostData.model.PrimaryPart.Position
    end

    if ghostData.personality == GhostPersonality.RED then
        -- Direct chase
        return playerPosition
    elseif ghostData.personality == GhostPersonality.PINK then
        -- Target 4 tiles ahead of player
        return playerPosition + (playerDirection * 16)
    elseif ghostData.personality == GhostPersonality.BLUE then
        -- Complex targeting (simplified for now)
        local offset = playerPosition + (playerDirection * 8)
        local ghostPos = ghostData.model.PrimaryPart.Position
        return offset + (offset - ghostPos)
    else -- ORANGE (Clyde)
        -- Shy behavior - chase if far, scatter if close
        local distance = (playerPosition - ghostData.model.PrimaryPart.Position).Magnitude
        if distance > 32 then
            return playerPosition
        else
            return GhostAI.getScatterTarget(ghostData)
        end
    end
end

-- Update ghost movement
function GhostAI.updateGhost(ghostData, playerController)
    if not ghostData.isAlive then
        return
    end

    local ghost = ghostData.model
    local body = ghost:FindFirstChild("Body")
    local bodyVelocity = body and body:FindFirstChild("BodyVelocity")

    if not bodyVelocity then
        return
    end

    -- Get player position for targeting
    local playerPosition = nil
    local playerDirection = Vector3.new(0, 0, 0)

    for player, pData in pairs(playerController.players) do
        if pData.isAlive and pData.character then
            playerPosition = pData.character.PrimaryPart.Position
            playerDirection = pData.direction
            break
        end
    end

    -- Determine target based on state
    local targetPosition

    if ghostData.state == GhostState.FRIGHTENED then
        -- Run away from player
        if playerPosition then
            local awayDirection = (body.Position - playerPosition).Unit
            targetPosition = body.Position + (awayDirection * 20)
        else
            targetPosition = GhostAI.getScatterTarget(ghostData)
        end
    elseif ghostData.state == GhostState.EATEN then
        -- Return to spawn
        targetPosition = ghostData.spawnPosition
    elseif ghostData.state == GhostState.SCATTER then
        targetPosition = GhostAI.getScatterTarget(ghostData)
    else -- CHASE
        targetPosition = GhostAI.getChaseTarget(ghostData, playerPosition, playerDirection)
    end

    -- Simple movement towards target (simplified pathfinding)
    if targetPosition then
        local direction = (targetPosition - body.Position).Unit
        direction = Vector3.new(direction.X, 0, direction.Z) -- Keep Y at 0

        -- Check for walls
        local ray = workspace:Raycast(body.Position, direction * 3, RaycastParams.new())

        if ray and ray.Instance and ray.Instance.Name:find("Wall") then
            -- Try alternate directions
            local alternates = {
                Vector3.new(direction.Z, 0, -direction.X), -- Turn right
                Vector3.new(-direction.Z, 0, direction.X), -- Turn left
                Vector3.new(-direction.X, 0, -direction.Z), -- Turn around
            }

            for _, altDir in ipairs(alternates) do
                local altRay = workspace:Raycast(body.Position, altDir * 3, RaycastParams.new())

                if not (altRay and altRay.Instance and altRay.Instance.Name:find("Wall")) then
                    direction = altDir
                    break
                end
            end
        end

        ghostData.direction = direction

        -- Apply movement
        local speed = ghostData.state == GhostState.FRIGHTENED and GhostAI.FRIGHTENED_SPEED or GhostAI.GHOST_SPEED
        bodyVelocity.Velocity = direction * speed

        -- Rotate to face direction
        if direction.Magnitude > 0 then
            body.CFrame = CFrame.lookAt(body.Position, body.Position + direction)
        end
    end

    -- Check for collision with player
    if playerPosition and ghostData.state ~= GhostState.EATEN then
        local distance = (playerPosition - body.Position).Magnitude

        if distance < 3 then
            if ghostData.state == GhostState.FRIGHTENED then
                -- Ghost gets eaten
                GhostAI.eatGhost(ghostData, playerController)
            else
                -- Player gets caught
                for player, pData in pairs(playerController.players) do
                    if pData.isAlive and pData.character then
                        return player -- Return caught player
                    end
                end
            end
        end
    end

    -- Check if eaten ghost reached spawn
    if ghostData.state == GhostState.EATEN then
        local distance = (ghostData.spawnPosition - body.Position).Magnitude
        if distance < 5 then
            ghostData.state = GhostAI.globalState
            body.BrickColor = BrickColor.new(ghostData.originalColor)
        end
    end

    return nil
end

-- Handle ghost being eaten
function GhostAI.eatGhost(ghostData, playerController)
    ghostData.state = GhostState.EATEN

    -- Make ghost transparent (eyes only)
    local body = ghostData.model:FindFirstChild("Body")
    if body then
        body.Transparency = 0.8
    end

    -- Award points to player
    for player, pData in pairs(playerController.players) do
        if pData.isAlive then
            playerController.addScore(player, 200)
            break
        end
    end
end

-- Activate power mode (all ghosts become frightened)
function GhostAI.activatePowerMode(duration)
    GhostAI.powerMode = true
    GhostAI.powerTimer = duration

    for ghost, ghostData in pairs(GhostAI.ghosts) do
        if ghostData.state ~= GhostState.EATEN then
            ghostData.state = GhostState.FRIGHTENED

            -- Change color to blue
            local body = ghostData.model:FindFirstChild("Body")
            if body then
                body.BrickColor = BrickColor.new("Navy blue")
            end
        end
    end
end

-- Update ghost states
function GhostAI.updateStates(deltaTime)
    -- Update power mode timer
    if GhostAI.powerMode then
        GhostAI.powerTimer = GhostAI.powerTimer - deltaTime

        if GhostAI.powerTimer <= 0 then
            GhostAI.powerMode = false

            -- Return ghosts to normal state
            for ghost, ghostData in pairs(GhostAI.ghosts) do
                if ghostData.state == GhostState.FRIGHTENED then
                    ghostData.state = GhostAI.globalState

                    local body = ghostData.model:FindFirstChild("Body")
                    if body then
                        body.BrickColor = BrickColor.new(ghostData.originalColor)
                    end
                end
            end
        end
    end

    -- Update global state timer (scatter/chase cycle)
    if not GhostAI.powerMode then
        GhostAI.stateTimer = GhostAI.stateTimer + deltaTime

        if GhostAI.globalState == GhostState.SCATTER then
            if GhostAI.stateTimer >= GhostAI.SCATTER_DURATION then
                GhostAI.globalState = GhostState.CHASE
                GhostAI.stateTimer = 0

                -- Update all non-frightened/eaten ghosts
                for ghost, ghostData in pairs(GhostAI.ghosts) do
                    if ghostData.state == GhostState.SCATTER then
                        ghostData.state = GhostState.CHASE
                    end
                end
            end
        else
            if GhostAI.stateTimer >= GhostAI.CHASE_DURATION then
                GhostAI.globalState = GhostState.SCATTER
                GhostAI.stateTimer = 0

                -- Update all non-frightened/eaten ghosts
                for ghost, ghostData in pairs(GhostAI.ghosts) do
                    if ghostData.state == GhostState.CHASE then
                        ghostData.state = GhostState.SCATTER
                    end
                end
            end
        end
    end
end

-- Clean up ghosts
function GhostAI.cleanup()
    for ghost, ghostData in pairs(GhostAI.ghosts) do
        if ghostData.model then
            ghostData.model:Destroy()
        end
    end
    GhostAI.ghosts = {}
end

return GhostAI
