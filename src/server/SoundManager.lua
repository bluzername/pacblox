-- SoundManager.lua
-- Manages sound effects and music for PacBlox game

local SoundManager = {}
local SoundService = game:GetService("SoundService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

SoundManager.sounds = {}

-- Initialize sound manager
function SoundManager.init()
    -- Create sounds folder
    local soundsFolder = Instance.new("Folder")
    soundsFolder.Name = "GameSounds"
    soundsFolder.Parent = SoundService
    
    -- Create sound objects (placeholders - actual sound IDs would be needed)
    SoundManager.createSounds(soundsFolder)
    
    -- Create RemoteEvent for client sound playback
    local soundEvent = Instance.new("RemoteEvent")
    soundEvent.Name = "PlaySound"
    soundEvent.Parent = ReplicatedStorage
end

-- Create all game sounds
function SoundManager.createSounds(parent)
    -- Pellet collection sound
    local pelletSound = Instance.new("Sound")
    pelletSound.Name = "PelletCollect"
    pelletSound.Volume = 0.3
    pelletSound.Pitch = 1.2
    -- pelletSound.SoundId = "rbxassetid://XXXXXXXXX" -- Replace with actual sound ID
    pelletSound.Parent = parent
    SoundManager.sounds.pelletCollect = pelletSound
    
    -- Power pellet collection sound
    local powerPelletSound = Instance.new("Sound")
    powerPelletSound.Name = "PowerPelletCollect"
    powerPelletSound.Volume = 0.5
    powerPelletSound.Pitch = 1.0
    -- powerPelletSound.SoundId = "rbxassetid://XXXXXXXXX" -- Replace with actual sound ID
    powerPelletSound.Parent = parent
    SoundManager.sounds.powerPelletCollect = powerPelletSound
    
    -- Ghost eaten sound
    local ghostEatenSound = Instance.new("Sound")
    ghostEatenSound.Name = "GhostEaten"
    ghostEatenSound.Volume = 0.4
    ghostEatenSound.Pitch = 1.5
    -- ghostEatenSound.SoundId = "rbxassetid://XXXXXXXXX" -- Replace with actual sound ID
    ghostEatenSound.Parent = parent
    SoundManager.sounds.ghostEaten = ghostEatenSound
    
    -- Player death sound
    local deathSound = Instance.new("Sound")
    deathSound.Name = "PlayerDeath"
    deathSound.Volume = 0.6
    deathSound.Pitch = 0.8
    -- deathSound.SoundId = "rbxassetid://XXXXXXXXX" -- Replace with actual sound ID
    deathSound.Parent = parent
    SoundManager.sounds.playerDeath = deathSound
    
    -- Game start sound
    local startSound = Instance.new("Sound")
    startSound.Name = "GameStart"
    startSound.Volume = 0.5
    startSound.Pitch = 1.0
    -- startSound.SoundId = "rbxassetid://XXXXXXXXX" -- Replace with actual sound ID
    startSound.Parent = parent
    SoundManager.sounds.gameStart = startSound
    
    -- Victory sound
    local victorySound = Instance.new("Sound")
    victorySound.Name = "Victory"
    victorySound.Volume = 0.7
    victorySound.Pitch = 1.0
    -- victorySound.SoundId = "rbxassetid://XXXXXXXXX" -- Replace with actual sound ID
    victorySound.Parent = parent
    SoundManager.sounds.victory = victorySound
    
    -- Game over sound
    local gameOverSound = Instance.new("Sound")
    gameOverSound.Name = "GameOver"
    gameOverSound.Volume = 0.6
    gameOverSound.Pitch = 0.9
    -- gameOverSound.SoundId = "rbxassetid://XXXXXXXXX" -- Replace with actual sound ID
    gameOverSound.Parent = parent
    SoundManager.sounds.gameOver = gameOverSound
    
    -- Background music
    local bgMusic = Instance.new("Sound")
    bgMusic.Name = "BackgroundMusic"
    bgMusic.Volume = 0.2
    bgMusic.Looped = true
    bgMusic.Pitch = 1.0
    -- bgMusic.SoundId = "rbxassetid://XXXXXXXXX" -- Replace with actual sound ID
    bgMusic.Parent = parent
    SoundManager.sounds.backgroundMusic = bgMusic
    
    -- Power-up music
    local powerMusic = Instance.new("Sound")
    powerMusic.Name = "PowerUpMusic"
    powerMusic.Volume = 0.3
    powerMusic.Looped = true
    powerMusic.Pitch = 1.1
    -- powerMusic.SoundId = "rbxassetid://XXXXXXXXX" -- Replace with actual sound ID
    powerMusic.Parent = parent
    SoundManager.sounds.powerUpMusic = powerMusic
    
    -- Movement sound (continuous)
    local moveSound = Instance.new("Sound")
    moveSound.Name = "Movement"
    moveSound.Volume = 0.1
    moveSound.Looped = true
    moveSound.Pitch = 1.3
    -- moveSound.SoundId = "rbxassetid://XXXXXXXXX" -- Replace with actual sound ID
    moveSound.Parent = parent
    SoundManager.sounds.movement = moveSound
end

-- Play a sound effect
function SoundManager.playSound(soundName, playOnClient)
    local sound = SoundManager.sounds[soundName]
    if not sound then
        warn("Sound not found: " .. soundName)
        return
    end
    
    if playOnClient then
        -- Send to all clients to play locally
        local soundEvent = ReplicatedStorage:FindFirstChild("PlaySound")
        if soundEvent then
            soundEvent:FireAllClients(soundName)
        end
    else
        -- Play on server
        sound:Play()
    end
end

-- Play sound for specific player
function SoundManager.playSoundForPlayer(player, soundName)
    local soundEvent = ReplicatedStorage:FindFirstChild("PlaySound")
    if soundEvent then
        soundEvent:FireClient(player, soundName)
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