-- SoundManager.lua
-- Manages sound effects and music for PacBlox game.
-- Sound asset ids live in Constants.SOUND_IDS. Any sound whose id is empty is
-- created but never played, so the game runs silently until ids are filled in.

local SoundManager = {}
local SoundService = game:GetService("SoundService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Constants = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Constants"))

SoundManager.sounds = {}

-- One entry per sound. `key` is the name used in code and in Constants.SOUND_IDS,
-- `name` is the Sound instance name under SoundService.GameSounds.
local SOUND_SPECS = {
    { key = "pelletCollect", name = "PelletCollect", volume = 0.3, pitch = 1.2 },
    { key = "powerPelletCollect", name = "PowerPelletCollect", volume = 0.5, pitch = 1.0 },
    { key = "ghostEaten", name = "GhostEaten", volume = 0.4, pitch = 1.5 },
    { key = "playerDeath", name = "PlayerDeath", volume = 0.6, pitch = 0.8 },
    { key = "gameStart", name = "GameStart", volume = 0.5, pitch = 1.0 },
    { key = "victory", name = "Victory", volume = 0.7, pitch = 1.0 },
    { key = "gameOver", name = "GameOver", volume = 0.6, pitch = 0.9 },
    { key = "backgroundMusic", name = "BackgroundMusic", volume = 0.2, pitch = 1.0, looped = true },
    { key = "powerUpMusic", name = "PowerUpMusic", volume = 0.3, pitch = 1.1, looped = true },
    { key = "movement", name = "Movement", volume = 0.1, pitch = 1.3, looped = true },
}

local function hasSoundId(sound)
    return sound.SoundId ~= nil and sound.SoundId ~= ""
end

-- Initialize sound manager
function SoundManager.init()
    local soundsFolder = Instance.new("Folder")
    soundsFolder.Name = "GameSounds"
    soundsFolder.Parent = SoundService

    SoundManager.createSounds(soundsFolder)

    -- RemoteEvent for client sound playback
    local soundEvent = Instance.new("RemoteEvent")
    soundEvent.Name = "PlaySound"
    soundEvent.Parent = ReplicatedStorage
end

-- Create all game sounds from SOUND_SPECS and Constants.SOUND_IDS
function SoundManager.createSounds(parent)
    local configured = 0
    for _, spec in ipairs(SOUND_SPECS) do
        local sound = Instance.new("Sound")
        sound.Name = spec.name
        sound.Volume = spec.volume
        sound.Pitch = spec.pitch
        sound.Looped = spec.looped == true

        local soundId = Constants.SOUND_IDS[spec.key]
        if soundId ~= nil and soundId ~= "" then
            sound.SoundId = soundId
            configured += 1
        end

        sound.Parent = parent
        SoundManager.sounds[spec.key] = sound
    end

    if configured < #SOUND_SPECS then
        print(
            string.format(
                "SoundManager: %d of %d sound ids set in Constants.SOUND_IDS; unset sounds are skipped",
                configured,
                #SOUND_SPECS
            )
        )
    end
end

-- Play a sound effect. Sounds without an asset id are skipped silently.
function SoundManager.playSound(soundName, playOnClient)
    local sound = SoundManager.sounds[soundName]
    if not sound then
        warn("Sound not found: " .. tostring(soundName))
        return
    end

    if not hasSoundId(sound) then
        return
    end

    if playOnClient then
        local soundEvent = ReplicatedStorage:FindFirstChild("PlaySound")
        if soundEvent then
            soundEvent:FireAllClients(sound.Name)
        end
    else
        sound:Play()
    end
end

-- Play sound for specific player
function SoundManager.playSoundForPlayer(player, soundName)
    local sound = SoundManager.sounds[soundName]
    if not sound or not hasSoundId(sound) then
        return
    end

    local soundEvent = ReplicatedStorage:FindFirstChild("PlaySound")
    if soundEvent then
        soundEvent:FireClient(player, sound.Name)
    end
end

-- Stop a sound
function SoundManager.stopSound(soundName)
    local sound = SoundManager.sounds[soundName]
    if sound then
        sound:Stop()
    end
end

-- Start background music
function SoundManager.startBackgroundMusic()
    SoundManager.stopSound("powerUpMusic")
    SoundManager.playSound("backgroundMusic", false)
end

-- Start power-up music
function SoundManager.startPowerUpMusic()
    SoundManager.stopSound("backgroundMusic")
    SoundManager.playSound("powerUpMusic", false)
end

-- Stop all music
function SoundManager.stopAllMusic()
    SoundManager.stopSound("backgroundMusic")
    SoundManager.stopSound("powerUpMusic")
end

-- Sound effect triggers for game events
function SoundManager.onPelletCollected(isPowerPellet)
    if isPowerPellet then
        SoundManager.playSound("powerPelletCollect", true)
        SoundManager.startPowerUpMusic()
    else
        SoundManager.playSound("pelletCollect", true)
    end
end

function SoundManager.onGhostEaten()
    SoundManager.playSound("ghostEaten", true)
end

function SoundManager.onPlayerDeath()
    SoundManager.stopAllMusic()
    SoundManager.playSound("playerDeath", true)
end

function SoundManager.onGameStart()
    SoundManager.playSound("gameStart", true)
    wait(2)
    SoundManager.startBackgroundMusic()
end

function SoundManager.onGameOver()
    SoundManager.stopAllMusic()
    SoundManager.playSound("gameOver", true)
end

function SoundManager.onVictory()
    SoundManager.stopAllMusic()
    SoundManager.playSound("victory", true)
end

function SoundManager.onPowerUpEnd()
    SoundManager.startBackgroundMusic()
end

return SoundManager
