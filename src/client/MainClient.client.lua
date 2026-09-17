-- MainClient.lua
-- Main client script that handles client-side initialization

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

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

-- Handle sound playback requests from server. The server only sends names of
-- sounds that have an asset id set in Constants.SOUND_IDS.
local soundEvent = ReplicatedStorage:WaitForChild("PlaySound", 5)
if soundEvent then
    soundEvent.OnClientEvent:Connect(function(soundName)
        local soundsFolder = SoundService:FindFirstChild("GameSounds")
        local sound = soundsFolder and soundsFolder:FindFirstChild(soundName)
        if sound and sound.SoundId ~= "" then
            sound:Play()
        end
    end)
end

print("PacBlox Client Ready!")
