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