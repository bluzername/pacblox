-- InputHandler.lua
-- Handles player input and sends movement commands to server

local InputHandler = {}
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local moveEvent -- Will be set when RemoteEvent is created

-- Movement directions mapped to keys
local keyDirections = {
    [Enum.KeyCode.W] = Vector3.new(0, 0, -1), -- Up
    [Enum.KeyCode.S] = Vector3.new(0, 0, 1), -- Down
    [Enum.KeyCode.A] = Vector3.new(-1, 0, 0), -- Left
    [Enum.KeyCode.D] = Vector3.new(1, 0, 0), -- Right
    [Enum.KeyCode.Up] = Vector3.new(0, 0, -1), -- Arrow Up
    [Enum.KeyCode.Down] = Vector3.new(0, 0, 1), -- Arrow Down
    [Enum.KeyCode.Left] = Vector3.new(-1, 0, 0), -- Arrow Left
    [Enum.KeyCode.Right] = Vector3.new(1, 0, 0), -- Arrow Right
}

-- Initialize input handler
function InputHandler.init()
    -- Wait for RemoteEvent to be created
    moveEvent = ReplicatedStorage:WaitForChild("PlayerMove")

    -- Connect input handlers
    UserInputService.InputBegan:Connect(InputHandler.onInputBegan)
end

-- Handle key press
function InputHandler.onInputBegan(input, gameProcessed)
    if gameProcessed then
        return
    end

    local direction = keyDirections[input.KeyCode]
    if direction and moveEvent then
        -- Send movement direction to server
        moveEvent:FireServer(direction)
    end
end

-- Mobile touch controls support
function InputHandler.setupMobileControls()
    -- Create GUI for mobile controls
    local playerGui = player:WaitForChild("PlayerGui")
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MobileControls"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui

    -- Create directional buttons
    local buttonSize = UDim2.new(0, 60, 0, 60)
    local centerX = 0.15
    local centerY = 0.7

    -- Up button
    local upButton = InputHandler.createControlButton("Up", UDim2.new(centerX, 0, centerY - 0.1, 0), buttonSize, "↑")
    upButton.Parent = screenGui
    upButton.MouseButton1Click:Connect(function()
        if moveEvent then
            moveEvent:FireServer(Vector3.new(0, 0, -1))
        end
    end)

    -- Down button
    local downButton =
        InputHandler.createControlButton("Down", UDim2.new(centerX, 0, centerY + 0.1, 0), buttonSize, "↓")
    downButton.Parent = screenGui
    downButton.MouseButton1Click:Connect(function()
        if moveEvent then
            moveEvent:FireServer(Vector3.new(0, 0, 1))
        end
    end)

    -- Left button
    local leftButton =
        InputHandler.createControlButton("Left", UDim2.new(centerX - 0.08, 0, centerY, 0), buttonSize, "←")
    leftButton.Parent = screenGui
    leftButton.MouseButton1Click:Connect(function()
        if moveEvent then
            moveEvent:FireServer(Vector3.new(-1, 0, 0))
        end
    end)

    -- Right button
    local rightButton =
        InputHandler.createControlButton("Right", UDim2.new(centerX + 0.08, 0, centerY, 0), buttonSize, "→")
    rightButton.Parent = screenGui
    rightButton.MouseButton1Click:Connect(function()
        if moveEvent then
            moveEvent:FireServer(Vector3.new(1, 0, 0))
        end
    end)
end

-- Helper function to create control buttons
function InputHandler.createControlButton(name, position, size, text)
    local button = Instance.new("TextButton")
    button.Name = name .. "Button"
    button.Position = position
    button.Size = size
    button.BackgroundColor3 = Color3.new(0.2, 0.2, 0.8)
    button.BackgroundTransparency = 0.3
    button.BorderSizePixel = 2
    button.BorderColor3 = Color3.new(1, 1, 1)
    button.Text = text
    button.TextColor3 = Color3.new(1, 1, 1)
    button.TextScaled = true
    button.Font = Enum.Font.SourceSansBold

    -- Add rounded corners
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button

    return button
end

-- Check if on mobile device
function InputHandler.isMobile()
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

-- Start input handling
function InputHandler.start()
    InputHandler.init()

    -- Setup mobile controls if on mobile device
    if InputHandler.isMobile() then
        InputHandler.setupMobileControls()
    end
end

return InputHandler
