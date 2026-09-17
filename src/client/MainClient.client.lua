-- MainClient.lua
-- Main client script that handles client-side initialization

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

-- Wait for character to load
repeat
    wait()
until player.Character

print("PacBlox Client Starting for " .. player.Name)

-- Load client modules
local InputHandler = require(script.Parent:WaitForChild("InputHandler"))
local UIManager = require(script.Parent:WaitForChild("UIManager"))

-- Initialize UI
UIManager.init()

-- Initialize input handling
InputHandler.start()

-- Handle sound playback requests from server
local soundEvent = ReplicatedStorage:WaitForChild("PlaySound", 5)
if soundEvent then
    soundEvent.OnClientEvent:Connect(function(soundName)
        -- Client-side sound playback would go here
        print("Playing sound: " .. soundName)
    end)
end

print("PacBlox Client Ready!")
