function Memory_drawField(numX, numZ)
    -- set the upper left point where the tiles will be placed
    startPosX = 0
    startPosZ = 0

    -- set the offset between tiles
    offsetX = 3
    offsetZ = 3

    -- compute the coordinates of the 4 corners
    local fieldTopLeft = {x = (startPosX - (offsetX / 2)), y = 1, z = (startPosZ + (offsetZ / 2))}
    local fieldTopRight = {x = (startPosX + (offsetX * (numX - 1)) + (offsetX / 2)), y = 1, z = (startPosZ + (offsetZ / 2))}
    local fieldBottomLeft = {x = (startPosX - (offsetX / 2)), y = 1, z = (startPosZ - (offsetZ * (numZ - 1)) - (offsetZ / 2))}
    local fieldBottomRight = {x = (startPosX + (offsetX * (numX - 1)) + (offsetX / 2)), y = 1, z = (startPosZ - (offsetZ * (numZ - 1)) - (offsetZ / 2))}

    local color = {1, 1, 1}
    local thickness = 0.2
    local rotation = {0, 0, 0}

    -- TODO: move the code to draw lines and rectangles to functions

    -- draw the lines
    Global.setVectorLines({
        {
            points = {fieldTopLeft, fieldTopRight},
            color = color,
            thickness = thickness,
            rotation = rotation
        },
        {
            points = {fieldTopLeft, fieldBottomLeft},
            color = color,
            thickness = thickness,
            rotation = rotation
        },
        {
            points = {fieldBottomLeft, fieldBottomRight},
            color = color,
            thickness = thickness,
            rotation = rotation
        },
        {
            points = {fieldBottomRight, fieldTopRight},
            color = color,
            thickness = thickness,
            rotation = rotation
        }
    })
end


function Memory_spawnTiles(numX, numZ)
    -- set the upper left point where the tiles will be placed
    startPosX = 0
    startPosZ = 0

    -- set the offset between tiles
    offsetX = 3
    offsetZ = 3

    -- create table for all tiles
    MemoryTiles = {}

    -- initiate math.random
    math.randomseed(os.time())
    for i = 1, 20, 1 do
        math.random(1, 10)
    end

    -- fill a table with indexes of songpack.memory.pool
    local poolIndex = {}

    for i = 1, #songpack.memory.pool, 1 do
        -- every index needs to be added twice, because... pairs
        table.insert(poolIndex, i)
        table.insert(poolIndex, i)
    end

    -- log(poolIndex)

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
                position = {x = 0, y = 0.11, z = 0},
                rotation = {x = 0, y = 0, z = 0},
                width = 400,
                height = 400,
                font_size = 150
            }
            newObj.createButton(btn_Play)

            -- insert a random number of 1 to (#songpack.memory.pool) here. Each number must be given exactly twice
            randIndex = math.random(1, #poolIndex)

            -- log('Tile at coords ' .. x .. ' / ' .. z)
            -- log(poolIndex)
            -- log('#poolIndex: ' .. #poolIndex)
            -- log('RandIndex: ' .. randIndex)
            -- log('Setting index ' .. poolIndex[randIndex])

            newObj.setGMNotes(poolIndex[randIndex])
            newObj.editButton({index = 0, label = 'Play\n' .. poolIndex[randIndex]})

            table.remove(poolIndex, randIndex)

            table.insert(MemoryTiles, newObj)
        end
    end 
    log(MemoryTiles)
end

function Memory_playSong(obj)
    -- play the song with the objects associated number from songpack.memory.pool
    MusicPlayer_play(songpack.memory.pool[tonumber(obj.getGMNotes())])

    -- change the button to orange
    obj.editButton({index = 0, color = {r = 1, g = 1, b = 0}, click_function = 'none'})

    -- save the guesses
    if (Memory_firstGuess == nil) then
        -- first guess
        Memory_firstGuess = obj

        -- temporarily de-activate all other buttons
        for _, tile in pairs(MemoryTiles) do
            if (tile.getGUID() ~= Memory_firstGuess.getGUID()) then
                tile.editButton({index = 0, color = {r = 0.6, g = 0.6, b = 0.6}, click_function = 'none'})
            end
        end

        Wait.condition(Memory_playSong_Started_First, MusicPlayer_isPlaying, 30, Memory_playSong_Timeout)
    else
        -- second guess
        Memory_secondGuess = obj

        -- temporarily de-activate all other buttons
        for _, tile in pairs(MemoryTiles) do
            if (tile.getGUID() ~= Memory_firstGuess.getGUID() and tile.getGUID() ~= Memory_secondGuess.getGUID()) then
                tile.editButton({index = 0, color = {r = 0.6, g = 0.6, b = 0.6}, click_function = 'none'})
            end
        end

        -- wait for the current song to start playing, then wait for the Music Player to stop playing
        Wait.condition(Memory_playSong_Started_Second, MusicPlayer_isPlaying, 30, Memory_playSong_Timeout)
    end
end

function Memory_playSong_Started_First()
    -- wait for the Music Player to stop playing, then re-activate all other buttons
    Wait.condition(Memory_playSong_resetOtherButtons, MusicPlayer_isStopped, 30, Memory_playSong_Timeout)
end

function Memory_playSong_resetOtherButtons()
    -- re-activate all other buttons
    for _, tile in pairs(MemoryTiles) do
        if (tile.getGUID() ~= Memory_firstGuess.getGUID()) then
            tile.editButton({index = 0, color =  {r = 1, g = 1, b = 1}, click_function = 'Memory_playSong'})
        end
    end
end

function Memory_playSong_Started_Second()
    -- wait for the Music Player to stop playing, then compare the guesses
    Wait.condition(Memory_playSong_showResult, MusicPlayer_isStopped, 30, Memory_playSong_Timeout)
end

function Memory_playSong_showResult()
     -- compare the guesses
     if (Memory_firstGuess.getGMNotes() == Memory_secondGuess.getGMNotes()) then
        -- TODO: give player a point
        -- TODO: play success sound
        broadcastToAll(LANG_HIT)

        Memory_firstGuess.editButton({index = 0, color = {r = 0, g = 1, b = 0}})
        Memory_secondGuess.editButton({index = 0, color = {r = 0, g = 1, b = 0}})

        Wait.time(Memory_playSong_guessCorrect, 1)
    else
        broadcastToAll(LANG_MISS)
        -- TODO: play error sound
        Memory_firstGuess.editButton({index = 0, color = {r = 1, g = 0, b = 0}})
        Memory_secondGuess.editButton({index = 0, color = {r = 1, g = 0, b = 0}})

        Wait.time(Memory_playSong_resetAllButtons, 1)
    end
end

function Memory_playSong_guessCorrect()
    -- remove tiles from table
    for i, tile in ipairs(MemoryTiles) do
        if (tile.getGUID() == Memory_firstGuess.getGUID()) then
            table.remove(MemoryTiles, i)
            break
        end
    end

    for i, tile in ipairs(MemoryTiles) do
        if (tile.getGUID() == Memory_secondGuess.getGUID()) then
            table.remove(MemoryTiles, i)
            break
        end
    end

    -- TODO: move to player's score zone
    destroyObject(Memory_firstGuess)
    destroyObject(Memory_secondGuess)

    Memory_playSong_resetAllButtons()
end

function Memory_playSong_resetAllButtons()
    -- re-activate the buttons
    for _, tile in pairs(MemoryTiles) do
        tile.editButton({index = 0, color =  {r = 1, g = 1, b = 1}, click_function = 'Memory_playSong'})
    end

    -- reset the guesses
    Memory_firstGuess = nil
    Memory_secondGuess = nil
end

function Memory_playSong_Timeout()
    log('Memory_playSong_Timeout')
end