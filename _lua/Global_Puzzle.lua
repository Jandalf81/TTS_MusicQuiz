function Memory_preparePlayingField()
    -- table to save the last row of each player's field (players will move their guesses here)
    Memory_PlayerFields = {}

    Memory_drawField(0, 0, 5, 'White', 'Jandalf')
    Memory_addSnapPoints()
end

function Memory_drawField(originX, originZ, parts, color, name)
    local topLeft
    local bottomRight

    local thickness = 0.2
    local rotation = {0, 0, 0}

    Memory_PlayerFields[color] = {}

    -- for each part...
    for column = 0, parts - 1, 1 do
        -- draw a column with 3 rows for each part
        for row = 0, 2, 1 do
            -- compute the current position 
            currPos = {x = (originX + (offsetX * column)), y = 1, z = (originZ - (offsetZ * row))}

            -- save the positions of each column of the last row
            if (row == 2) then
                Memory_PlayerFields[color][column] = {position = currPos}
            end

            -- draw a rectangle around each position effectively creating a grid
            drawRectangle(Vector(currPos) - Vector((offsetX / 2), 0, (offsetZ / 2)), Vector(currPos) + Vector((offsetX / 2), 0, (offsetZ / 2)), color, thickness, rotation)
        end
    end
end

function Memory_addSnapPoints()
    local snapPoints = {}

    -- prepare a table of snap points
    for _, color in pairs(Memory_PlayerFields) do
        for _, pos in pairs(color) do
            table.insert(snapPoints, {position = {pos.position.x, pos.position.y, pos.position.z}, rotation = {0, 0, 0}, rotation_snap = false})
        end
    end

    -- use the table to create snapPoints
    Global.setSnapPoints(snapPoints)
end

function Puzzle_spawnTiles(parts)
    for x = 1, parts, 1 do
        -- compute the new Position by startPos +- (index * offset)
        newPos = {x = startPosX + (x * offsetX), y = 1, z = 1}

        -- set the spawn parameters and spawn the tile
        spawnParams = {
            type = 'Custom_Tile',
            position = newPos,
            rotation = {x = 0, y = 180, z = 0},
            scale = {x = 1, y = 1, z = 1},
            sound = false,
            snap_to_grid = true
        }
        newObj = spawnObject(spawnParams)
    
        -- set the custom parameters needed for a tile
        customParams = {
            image = songpack.settings.icon,
            type = 3,
            thickness = 0.1,
            stackable = false
        }
        newObj.setCustomObject(customParams)

        newObj.setGMNotes('1|' .. x)
    end
end