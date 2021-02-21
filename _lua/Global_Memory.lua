function Memory_spawnTiles(numX, numZ)
    -- set the upper left point where the tiles will be placed
    startPosX = 0
    startPosZ = 0

    -- set the offset between tiles
    offsetX = 3
    offsetZ = 3

    math.randomseed(os.time())

    -- for each tile horizontally...
    for x = 0, numX - 1, 1 do
        -- for each tile vertically...
        for z = 0, numZ - 1, 1 do
            -- compute the new Position by startPos +- (index * offset)
            newPos = {x = startPosX + (x * offsetX), y = 1, z = startPosZ - (z * offsetZ)}

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

            -- attach a button to each tile
            btn_Play = {
                index = 0,
                click_function = 'Memory_playSong',
                function_owner = Global,
                label = 'Play',
                position = {0, 0.11, 0},
                rotation = {0, 0, 0},
                width = 400,
                height = 400,
                font_size = 150
            }
            newObj.createButton(btn_Play)

            -- TODO: Insert a random number of 1 to (#songpack.memory.pool) here. Each number must be given exactly twice
            newObj.setGMNotes(math.random(1, 3))
        end
    end 
end

function Memory_playSong(obj)
    -- play the song with the objects associated number from songpack.memory.pool
    playSong(songpack.memory.pool[tonumber(obj.getGMNotes())])

    -- change the button to orange
    obj.editButton({index = 0, color = {1, 1, 0}})

    -- save the guesses
    if (Memory_firstGuess == nil) then
        -- first guess
        Memory_firstGuess = obj
    else
        -- second guess
        Memory_secondGuess = obj

        -- compare the guesses
        if (Memory_firstGuess.getGMNotes() == Memory_secondGuess.getGMNotes()) then
           log('Treffer') 
           Memory_firstGuess.editButton({index = 0, color = {0, 1, 0}})
           Memory_secondGuess.editButton({index = 0, color = {0, 1, 0}})
        else
            log('Daneben')
            Memory_firstGuess.editButton({index = 0, color = {1, 1, 1}})
            Memory_secondGuess.editButton({index = 0, color = {1, 1, 1}})
        end

        -- reset the guesses
        Memory_firstGuess = nil
        Memory_secondGuess = nil
    end
end