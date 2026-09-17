-- Utils.lua
-- Shared utility functions for common operations

local Constants = require(script.Parent.Constants)

local Utils = {}

-- Math utilities
function Utils.clamp(value, min, max)
    return math.max(min, math.min(max, value))
end

function Utils.lerp(a, b, t)
    return a + (b - a) * t
end

function Utils.round(x)
    return math.floor(x + 0.5)
end

function Utils.distance(pos1, pos2)
    return (pos1 - pos2).Magnitude
end

function Utils.manhattanDistance(pos1, pos2)
    local diff = pos1 - pos2
    return math.abs(diff.X) + math.abs(diff.Z)
end

-- Grid utilities
function Utils.worldToGrid(worldPos)
    return Vector3.new(Utils.round(worldPos.X / Constants.GRID_SIZE), 0, Utils.round(worldPos.Z / Constants.GRID_SIZE))
end

function Utils.gridToWorld(gridPos)
    return Vector3.new(gridPos.X * Constants.GRID_SIZE, gridPos.Y, gridPos.Z * Constants.GRID_SIZE)
end

function Utils.isValidGridPosition(x, z, mazeData)
    return x >= 1
        and x <= Constants.MAZE_WIDTH
        and z >= 1
        and z <= Constants.MAZE_HEIGHT
        and mazeData
        and mazeData[z]
        and mazeData[z][x] ~= Constants.CellType.WALL
end

-- Direction utilities
function Utils.getOppositeDirection(direction)
    return -direction
end

function Utils.isOppositeDirection(dir1, dir2)
    return Utils.getOppositeDirection(dir1) == dir2
end

function Utils.getRandomDirection()
    local directions = {
        Constants.Direction.UP,
        Constants.Direction.DOWN,
        Constants.Direction.LEFT,
        Constants.Direction.RIGHT,
    }
    return directions[math.random(1, #directions)]
end

function Utils.getDirectionFromVector(vector)
    if vector.X > 0 then
        return Constants.Direction.RIGHT
    elseif vector.X < 0 then
        return Constants.Direction.LEFT
    elseif vector.Z > 0 then
        return Constants.Direction.UP
    elseif vector.Z < 0 then
        return Constants.Direction.DOWN
    else
        return Constants.Direction.NONE
    end
end

-- Array utilities
function Utils.contains(array, value)
    for i = 1, #array do
        if array[i] == value then
            return true
        end
    end
    return false
end

function Utils.removeValue(array, value)
    for i = #array, 1, -1 do
        if array[i] == value then
            table.remove(array, i)
        end
    end
end

function Utils.shuffle(array)
    for i = #array, 2, -1 do
        local j = math.random(i)
        array[i], array[j] = array[j], array[i]
    end
    return array
end

-- Color utilities
function Utils.lerpColor(color1, color2, t)
    return Color3.new(
        Utils.lerp(color1.R, color2.R, t),
        Utils.lerp(color1.G, color2.G, t),
        Utils.lerp(color1.B, color2.B, t)
    )
end

-- Time utilities
function Utils.formatTime(seconds)
    local mins = math.floor(seconds / 60)
    local secs = math.floor(seconds % 60)
    return string.format("%02d:%02d", mins, secs)
end

-- Debug utilities
function Utils.debugPrint(...)
    if game:GetService("RunService"):IsStudio() then
        print("[PacBlox Debug]", ...)
    end
end

function Utils.printStackTrace()
    print(debug.traceback())
end

-- Table utilities
function Utils.deepCopy(original)
    local originalType = type(original)
    local copy
    if originalType == "table" then
        copy = {}
        for originalKey, originalValue in next, original, nil do
            copy[Utils.deepCopy(originalKey)] = Utils.deepCopy(originalValue)
        end
        setmetatable(copy, Utils.deepCopy(getmetatable(original)))
    else
        copy = original
    end
    return copy
end

function Utils.tableSize(t)
    local count = 0
    for _ in pairs(t) do
        count = count + 1
    end
    return count
end

-- String utilities
function Utils.startsWith(str, prefix)
    return string.sub(str, 1, string.len(prefix)) == prefix
end

function Utils.endsWith(str, suffix)
    return string.sub(str, -string.len(suffix)) == suffix
end

return Utils
