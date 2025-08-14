-- MazeGenerator.lua
-- Generates the maze geometry for PacBlox game

local MazeGenerator = {}

-- Maze layout definition (1 = wall, 0 = path, 2 = pellet, 3 = power pellet)
MazeGenerator.MAZE_LAYOUT = {
    {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
    {1,2,2,2,2,2,2,2,2,2,2,2,2,1,1,2,2,2,2,2,2,2,2,2,2,2,2,1},
    {1,3,1,1,1,1,2,1,1,1,1,1,2,1,1,2,1,1,1,1,1,2,1,1,1,1,3,1},
    {1,2,1,1,1,1,2,1,1,1,1,1,2,1,1,2,1,1,1,1,1,2,1,1,1,1,2,1},
    {1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1},
    {1,2,1,1,1,1,2,1,1,2,1,1,1,1,1,1,1,1,2,1,1,2,1,1,1,1,2,1},
    {1,2,2,2,2,2,2,1,1,2,2,2,2,1,1,2,2,2,2,1,1,2,2,2,2,2,2,1},
    {1,1,1,1,1,1,2,1,1,1,1,1,0,1,1,0,1,1,1,1,1,2,1,1,1,1,1,1},
    {0,0,0,0,0,1,2,1,1,0,0,0,0,0,0,0,0,0,0,1,1,2,1,0,0,0,0,0},
    {1,1,1,1,1,1,2,1,1,0,1,1,1,0,0,1,1,1,0,1,1,2,1,1,1,1,1,1},
    {0,0,0,0,0,0,2,0,0,0,1,0,0,0,0,0,0,1,0,0,0,2,0,0,0,0,0,0},
    {1,1,1,1,1,1,2,1,1,0,1,0,0,0,0,0,0,1,0,1,1,2,1,1,1,1,1,1},
    {0,0,0,0,0,1,2,1,1,0,1,1,1,1,1,1,1,1,0,1,1,2,1,0,0,0,0,0},
    {1,1,1,1,1,1,2,1,1,0,0,0,0,0,0,0,0,0,0,1,1,2,1,1,1,1,1,1},
    {1,2,2,2,2,2,2,2,2,2,2,2,2,1,1,2,2,2,2,2,2,2,2,2,2,2,2,1},
    {1,2,1,1,1,1,2,1,1,1,1,1,2,1,1,2,1,1,1,1,1,2,1,1,1,1,2,1},
    {1,3,2,2,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,2,2,3,1},
    {1,1,1,2,1,1,2,1,1,2,1,1,1,1,1,1,1,1,2,1,1,2,1,1,2,1,1,1},
    {1,2,2,2,2,2,2,1,1,2,2,2,2,1,1,2,2,2,2,1,1,2,2,2,2,2,2,1},
    {1,2,1,1,1,1,1,1,1,1,1,1,2,1,1,2,1,1,1,1,1,1,1,1,1,1,2,1},
    {1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1},
    {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}
}

MazeGenerator.CELL_SIZE = 4  -- Size of each cell in studs
MazeGenerator.WALL_HEIGHT = 8  -- Height of walls in studs

function MazeGenerator.generateMaze(parent)
    local maze = Instance.new("Folder")
    maze.Name = "Maze"
    maze.Parent = parent
    
    local walls = Instance.new("Folder")
    walls.Name = "Walls"
    walls.Parent = maze
    
    local pellets = Instance.new("Folder")
    pellets.Name = "Pellets"
    pellets.Parent = maze
    
    local powerPellets = Instance.new("Folder")
    powerPellets.Name = "PowerPellets"
    powerPellets.Parent = maze
    
    local totalPellets = 0
    
    -- Generate maze based on layout
    for row = 1, #MazeGenerator.MAZE_LAYOUT do
        for col = 1, #MazeGenerator.MAZE_LAYOUT[row] do
            local cellType = MazeGenerator.MAZE_LAYOUT[row][col]
            local x = (col - 1) * MazeGenerator.CELL_SIZE - (#MazeGenerator.MAZE_LAYOUT[1] * MazeGenerator.CELL_SIZE / 2)
            local z = (row - 1) * MazeGenerator.CELL_SIZE - (#MazeGenerator.MAZE_LAYOUT * MazeGenerator.CELL_SIZE / 2)
            
            if cellType == 1 then
                -- Create wall
                local wall = Instance.new("Part")
                wall.Name = "Wall_" .. row .. "_" .. col
                wall.Size = Vector3.new(MazeGenerator.CELL_SIZE, MazeGenerator.WALL_HEIGHT, MazeGenerator.CELL_SIZE)
                wall.Position = Vector3.new(x, MazeGenerator.WALL_HEIGHT / 2, z)
                wall.Anchored = true
                wall.Material = Enum.Material.Neon
                wall.BrickColor = BrickColor.new("Electric blue")
                wall.TopSurface = Enum.SurfaceType.Smooth
                wall.BottomSurface = Enum.SurfaceType.Smooth
                wall.Parent = walls
                
            elseif cellType == 2 then
                -- Create pellet
                local pellet = Instance.new("Part")
                pellet.Name = "Pellet_" .. row .. "_" .. col
                pellet.Shape = Enum.PartType.Ball
                pellet.Size = Vector3.new(0.5, 0.5, 0.5)
                pellet.Position = Vector3.new(x, 1, z)
                pellet.Anchored = true
                pellet.CanCollide = false
                pellet.Material = Enum.Material.Neon
                pellet.BrickColor = BrickColor.new("Institutional white")
                pellet.Parent = pellets
                
                -- Add IntValue to track pellet
                local pelletValue = Instance.new("IntValue")
                pelletValue.Name = "PelletValue"
                pelletValue.Value = 10
                pelletValue.Parent = pellet
                
                totalPellets = totalPellets + 1
                
            elseif cellType == 3 then
                -- Create power pellet
                local powerPellet = Instance.new("Part")
                powerPellet.Name = "PowerPellet_" .. row .. "_" .. col
                powerPellet.Shape = Enum.PartType.Ball
                powerPellet.Size = Vector3.new(1, 1, 1)
                powerPellet.Position = Vector3.new(x, 1, z)
                powerPellet.Anchored = true
                powerPellet.CanCollide = false
                powerPellet.Material = Enum.Material.Neon
                powerPellet.BrickColor = BrickColor.new("Institutional white")
                powerPellet.Parent = powerPellets
                
                -- Add IntValue to track power pellet
                local pelletValue = Instance.new("IntValue")
                pelletValue.Name = "PowerPelletValue"
                pelletValue.Value = 50
                pelletValue.Parent = powerPellet
                
                totalPellets = totalPellets + 1
            end
        end
    end
    
    -- Create floor
    local floor = Instance.new("Part")
    floor.Name = "Floor"
    floor.Size = Vector3.new(
        #MazeGenerator.MAZE_LAYOUT[1] * MazeGenerator.CELL_SIZE,
        1,
        #MazeGenerator.MAZE_LAYOUT * MazeGenerator.CELL_SIZE
    )
    floor.Position = Vector3.new(0, -0.5, 0)
    floor.Anchored = true
    floor.Material = Enum.Material.Granite
    floor.BrickColor = BrickColor.new("Black")
    floor.TopSurface = Enum.SurfaceType.Smooth
    floor.BottomSurface = Enum.SurfaceType.Smooth
    floor.Parent = maze
    
    return maze, totalPellets
end

-- Get spawn positions for player and ghosts
function MazeGenerator.getSpawnPositions()
    local positions = {}
    
    -- Player spawn (center bottom area)
    positions.player = Vector3.new(0, 2, 32)
    
    -- Ghost spawns (center ghost house)
    positions.ghosts = {
        Vector3.new(-6, 2, 0),   -- Red ghost
        Vector3.new(-2, 2, 0),   -- Pink ghost
        Vector3.new(2, 2, 0),    -- Blue ghost
        Vector3.new(6, 2, 0)     -- Orange ghost
    }
    
    return positions
end

return MazeGenerator