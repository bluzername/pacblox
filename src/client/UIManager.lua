-- UIManager.lua
-- Manages all UI elements including score, game state displays, and HUD

local UIManager = {}
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

UIManager.screenGui = nil
UIManager.elements = {}

-- Initialize UI
function UIManager.init()
    -- Create main screen GUI
    UIManager.screenGui = Instance.new("ScreenGui")
    UIManager.screenGui.Name = "PacBloxUI"
    UIManager.screenGui.ResetOnSpawn = false
    UIManager.screenGui.Parent = playerGui
    
    -- Create UI elements
    UIManager.createScoreDisplay()
    UIManager.createGameStateDisplay()
    UIManager.createPelletCounter()
    UIManager.createLivesDisplay()
    UIManager.createPowerUpIndicator()
    
    -- Connect to server events
    local scoreUpdateEvent = ReplicatedStorage:WaitForChild("ScoreUpdate")
    scoreUpdateEvent.OnClientEvent:Connect(UIManager.updateScore)
    
    local gameStateEvent = ReplicatedStorage:WaitForChild("GameStateChanged")
    gameStateEvent.OnClientEvent:Connect(UIManager.updateGameState)
end

-- Create score display
function UIManager.createScoreDisplay()
    local scoreFrame = Instance.new("Frame")
    scoreFrame.Name = "ScoreFrame"
    scoreFrame.Size = UDim2.new(0, 200, 0, 50)
    scoreFrame.Position = UDim2.new(0, 10, 0, 10)
    scoreFrame.BackgroundColor3 = Color3.new(0, 0, 0)
    scoreFrame.BackgroundTransparency = 0.3
    scoreFrame.BorderSizePixel = 2
    scoreFrame.BorderColor3 = Color3.new(0, 0.5, 1)
    scoreFrame.Parent = UIManager.screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = scoreFrame
    
    local scoreLabel = Instance.new("TextLabel")
    scoreLabel.Name = "ScoreLabel"
    scoreLabel.Size = UDim2.new(1, 0, 0.4, 0)
    scoreLabel.Position = UDim2.new(0, 0, 0, 0)
    scoreLabel.BackgroundTransparency = 1
    scoreLabel.Text = "SCORE"
    scoreLabel.TextColor3 = Color3.new(1, 1, 1)
    scoreLabel.TextScaled = true
    scoreLabel.Font = Enum.Font.Arcade
    scoreLabel.Parent = scoreFrame
    
    local scoreValue = Instance.new("TextLabel")
    scoreValue.Name = "ScoreValue"
    scoreValue.Size = UDim2.new(1, 0, 0.6, 0)
    scoreValue.Position = UDim2.new(0, 0, 0.4, 0)
    scoreValue.BackgroundTransparency = 1
    scoreValue.Text = "0"
    scoreValue.TextColor3 = Color3.new(1, 1, 0)
    scoreValue.TextScaled = true
    scoreValue.Font = Enum.Font.Arcade
    scoreValue.Parent = scoreFrame
    
    UIManager.elements.scoreValue = scoreValue
end

-- Create pellet counter
function UIManager.createPelletCounter()
    local pelletFrame = Instance.new("Frame")
    pelletFrame.Name = "PelletFrame"
    pelletFrame.Size = UDim2.new(0, 200, 0, 40)
    pelletFrame.Position = UDim2.new(0, 10, 0, 70)
    pelletFrame.BackgroundColor3 = Color3.new(0, 0, 0)
    pelletFrame.BackgroundTransparency = 0.3
    pelletFrame.BorderSizePixel = 2
    pelletFrame.BorderColor3 = Color3.new(0, 0.5, 1)
    pelletFrame.Parent = UIManager.screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = pelletFrame
    
    local pelletLabel = Instance.new("TextLabel")
    pelletLabel.Name = "PelletLabel"
    pelletLabel.Size = UDim2.new(1, 0, 1, 0)
    pelletLabel.BackgroundTransparency = 1
    pelletLabel.Text = "PELLETS: 0/0"
    pelletLabel.TextColor3 = Color3.new(1, 1, 1)
    pelletLabel.TextScaled = true
    pelletLabel.Font = Enum.Font.Arcade
    pelletLabel.Parent = pelletFrame
    
    UIManager.elements.pelletLabel = pelletLabel
end

-- Create lives display
function UIManager.createLivesDisplay()
    local livesFrame = Instance.new("Frame")
    livesFrame.Name = "LivesFrame"
    livesFrame.Size = UDim2.new(0, 200, 0, 40)
    livesFrame.Position = UDim2.new(0, 10, 0, 120)
    livesFrame.BackgroundColor3 = Color3.new(0, 0, 0)
    livesFrame.BackgroundTransparency = 0.3
    livesFrame.BorderSizePixel = 2
    livesFrame.BorderColor3 = Color3.new(0, 0.5, 1)
    livesFrame.Parent = UIManager.screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = livesFrame
    
    local livesLabel = Instance.new("TextLabel")
    livesLabel.Name = "LivesLabel"
    livesLabel.Size = UDim2.new(0.4, 0, 1, 0)
    livesLabel.BackgroundTransparency = 1
    livesLabel.Text = "LIVES:"
    livesLabel.TextColor3 = Color3.new(1, 1, 1)
    livesLabel.TextScaled = true
    livesLabel.Font = Enum.Font.Arcade
    livesLabel.Parent = livesFrame
    
    -- Create life icons
    for i = 1, 3 do
        local lifeIcon = Instance.new("Frame")
        lifeIcon.Name = "Life" .. i
        lifeIcon.Size = UDim2.new(0, 25, 0, 25)
        lifeIcon.Position = UDim2.new(0.4 + (i - 1) * 0.15, 0, 0.5, -12)
        lifeIcon.BackgroundColor3 = Color3.new(1, 1, 0)
        lifeIcon.BorderSizePixel = 0
        lifeIcon.Parent = livesFrame
        
        local lifeCorner = Instance.new("UICorner")
        lifeCorner.CornerRadius = UDim.new(1, 0)
        lifeCorner.Parent = lifeIcon
    end
    
    UIManager.elements.livesFrame = livesFrame
end

-- Create power-up indicator
function UIManager.createPowerUpIndicator()
    local powerFrame = Instance.new("Frame")
    powerFrame.Name = "PowerUpFrame"
    powerFrame.Size = UDim2.new(0, 300, 0, 30)
    powerFrame.Position = UDim2.new(0.5, -150, 0, 50)
    powerFrame.BackgroundColor3 = Color3.new(0, 0, 0)
    powerFrame.BackgroundTransparency = 0.5
    powerFrame.BorderSizePixel = 2
    powerFrame.BorderColor3 = Color3.new(0, 1, 1)
    powerFrame.Visible = false
    powerFrame.Parent = UIManager.screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = powerFrame
    
    local powerBar = Instance.new("Frame")
    powerBar.Name = "PowerBar"
    powerBar.Size = UDim2.new(1, -4, 1, -4)
    powerBar.Position = UDim2.new(0, 2, 0, 2)
    powerBar.BackgroundColor3 = Color3.new(0, 1, 1)
    powerBar.BorderSizePixel = 0
    powerBar.Parent = powerFrame
    
    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(0, 6)
    barCorner.Parent = powerBar
    
    UIManager.elements.powerFrame = powerFrame
    UIManager.elements.powerBar = powerBar
end

-- Create game state display (Game Over, Victory, etc.)
function UIManager.createGameStateDisplay()
    local stateFrame = Instance.new("Frame")
    stateFrame.Name = "GameStateFrame"
    stateFrame.Size = UDim2.new(0.6, 0, 0.3, 0)
    stateFrame.Position = UDim2.new(0.2, 0, 0.35, 0)
    stateFrame.BackgroundColor3 = Color3.new(0, 0, 0)
    stateFrame.BackgroundTransparency = 0.2
    stateFrame.BorderSizePixel = 3
    stateFrame.BorderColor3 = Color3.new(1, 1, 0)
    stateFrame.Visible = false
    stateFrame.Parent = UIManager.screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = stateFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Size = UDim2.new(1, 0, 0.5, 0)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "GAME OVER"
    titleLabel.TextColor3 = Color3.new(1, 0, 0)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.Arcade
    titleLabel.Parent = stateFrame
    
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Name = "MessageLabel"
    messageLabel.Size = UDim2.new(1, 0, 0.3, 0)
    messageLabel.Position = UDim2.new(0, 0, 0.5, 0)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Text = "Restarting..."
    messageLabel.TextColor3 = Color3.new(1, 1, 1)
    messageLabel.TextScaled = true
    messageLabel.Font = Enum.Font.SourceSans
    messageLabel.Parent = stateFrame
    
    UIManager.elements.stateFrame = stateFrame
    UIManager.elements.titleLabel = titleLabel
    UIManager.elements.messageLabel = messageLabel
end

-- Update score display
function UIManager.updateScore(score)
    if UIManager.elements.scoreValue then
        UIManager.elements.scoreValue.Text = tostring(score)
        
        -- Animate score change
        local tween = TweenService:Create(
            UIManager.elements.scoreValue,
            TweenInfo.new(0.2, Enum.EasingStyle.Bounce),
            {TextColor3 = Color3.new(1, 0, 0)}
        )
        tween:Play()
        
        wait(0.2)
        
        local tween2 = TweenService:Create(
            UIManager.elements.scoreValue,
            TweenInfo.new(0.2),
            {TextColor3 = Color3.new(1, 1, 0)}
        )
        tween2:Play()
    end
end

-- Update pellet counter
function UIManager.updatePelletCount(collected, total)
    if UIManager.elements.pelletLabel then
        UIManager.elements.pelletLabel.Text = "PELLETS: " .. collected .. "/" .. total
    end
end

-- Update game state display
function UIManager.updateGameState(state, extraInfo)
    local stateFrame = UIManager.elements.stateFrame
    local titleLabel = UIManager.elements.titleLabel
    local messageLabel = UIManager.elements.messageLabel
    
    if not stateFrame then return end
    
    if state == "GameOver" then
        titleLabel.Text = "GAME OVER"
        titleLabel.TextColor3 = Color3.new(1, 0, 0)
        messageLabel.Text = "The ghosts got you! Restarting..."
        stateFrame.Visible = true
        
        -- Hide after delay
        wait(4)
        stateFrame.Visible = false
        
    elseif state == "Victory" then
        titleLabel.Text = "VICTORY!"
        titleLabel.TextColor3 = Color3.new(0, 1, 0)
        messageLabel.Text = (extraInfo or "You") .. " collected all pellets!"
        stateFrame.Visible = true
        
        -- Hide after delay
        wait(4)
        stateFrame.Visible = false
        
    elseif state == "Playing" then
        stateFrame.Visible = false
        
    elseif state == "Waiting" then
        titleLabel.Text = "PACBLOX"
        titleLabel.TextColor3 = Color3.new(1, 1, 0)
        messageLabel.Text = "Game starting soon..."
        stateFrame.Visible = true
        
        wait(2)
        stateFrame.Visible = false
    end
end

-- Show power-up indicator
function UIManager.showPowerUp(duration)
    local powerFrame = UIManager.elements.powerFrame
    local powerBar = UIManager.elements.powerBar
    
    if not powerFrame then return end
    
    powerFrame.Visible = true
    powerBar.Size = UDim2.new(1, -4, 1, -4)
    
    -- Animate power bar depletion
    local tween = TweenService:Create(
        powerBar,
        TweenInfo.new(duration, Enum.EasingStyle.Linear),
        {Size = UDim2.new(0, 0, 1, -4)}
    )
    tween:Play()
    
    wait(duration)
    powerFrame.Visible = false
end

-- Update lives display
function UIManager.updateLives(lives)
    local livesFrame = UIManager.elements.livesFrame
    if not livesFrame then return end
    
    for i = 1, 3 do
        local lifeIcon = livesFrame:FindFirstChild("Life" .. i)
        if lifeIcon then
            lifeIcon.Visible = i <= lives
        end
    end
end

-- Show notification
function UIManager.showNotification(text, color, duration)
    local notification = Instance.new("TextLabel")
    notification.Size = UDim2.new(0, 400, 0, 60)
    notification.Position = UDim2.new(0.5, -200, 0.8, 0)
    notification.BackgroundColor3 = Color3.new(0, 0, 0)
    notification.BackgroundTransparency = 0.3
    notification.BorderSizePixel = 2
    notification.BorderColor3 = color or Color3.new(1, 1, 1)
    notification.Text = text
    notification.TextColor3 = color or Color3.new(1, 1, 1)
    notification.TextScaled = true
    notification.Font = Enum.Font.Arcade
    notification.Parent = UIManager.screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = notification
    
    -- Animate in
    notification.Position = UDim2.new(0.5, -200, 1, 0)
    local tweenIn = TweenService:Create(
        notification,
        TweenInfo.new(0.5, Enum.EasingStyle.Back),
        {Position = UDim2.new(0.5, -200, 0.8, 0)}
    )
    tweenIn:Play()
    
    wait(duration or 2)
    
    -- Animate out
    local tweenOut = TweenService:Create(
        notification,
        TweenInfo.new(0.5, Enum.EasingStyle.Back),
        {Position = UDim2.new(0.5, -200, 1, 0)}
    )
    tweenOut:Play()
    
    wait(0.5)
    notification:Destroy()
end

return UIManager