-- GameEvents.lua
-- RemoteEvents and RemoteFunctions for client-server communication

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GameEvents = {}

-- Create events folder in ReplicatedStorage
local function getOrCreateFolder(parent, name)
    local folder = parent:FindFirstChild(name)
    if not folder then
        folder = Instance.new("Folder")
        folder.Name = name
        folder.Parent = parent
    end
    return folder
end

local eventsFolder = getOrCreateFolder(ReplicatedStorage, "PacBloxEvents")

-- Create RemoteEvents
local function createRemoteEvent(name)
    local event = eventsFolder:FindFirstChild(name)
    if not event then
        event = Instance.new("RemoteEvent")
        event.Name = name
        event.Parent = eventsFolder
    end
    return event
end

local function createRemoteFunction(name)
    local func = eventsFolder:FindFirstChild(name)
    if not func then
        func = Instance.new("RemoteFunction")
        func.Name = name
        func.Parent = eventsFolder
    end
    return func
end

-- Game Events
GameEvents.PlayerMove = createRemoteEvent("PlayerMove")
GameEvents.PlayerJoined = createRemoteEvent("PlayerJoined")
GameEvents.PlayerLeft = createRemoteEvent("PlayerLeft")
GameEvents.GameStateChanged = createRemoteEvent("GameStateChanged")
GameEvents.ScoreUpdated = createRemoteEvent("ScoreUpdated")
GameEvents.PelletCollected = createRemoteEvent("PelletCollected")
GameEvents.PowerUpActivated = createRemoteEvent("PowerUpActivated")
GameEvents.GhostEaten = createRemoteEvent("GhostEaten")
GameEvents.PlayerDied = createRemoteEvent("PlayerDied")
GameEvents.GameWon = createRemoteEvent("GameWon")
GameEvents.MazeUpdated = createRemoteEvent("MazeUpdated")
GameEvents.GhostStateChanged = createRemoteEvent("GhostStateChanged")
GameEvents.SoundPlay = createRemoteEvent("SoundPlay")

-- Remote Functions
GameEvents.GetGameState = createRemoteFunction("GetGameState")
GameEvents.GetPlayerData = createRemoteFunction("GetPlayerData")
GameEvents.GetMazeData = createRemoteFunction("GetMazeData")

return GameEvents
