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

    log(poolIndex)

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

            -- insert a random number of 1 to (#songpack.memory.pool) here. Each number must be given exactly twice
            randIndex = math.random(1, #poolIndex)

            -- log('Tile at coords ' .. x .. ' / ' .. z)
            -- log(poolIndex)
            -- log('#poolIndex: ' .. #poolIndex)
            -- log('RandIndex: ' .. randIndex)
            -- log('Setting index ' .. poolIndex[randIndex])

            newObj.setGMNotes(poolIndex[randIndex])
            table.remove(poolIndex, randIndex)
        end
    end 
end

function Memory_playSong(obj)
    -- play the song with the objects associated number from songpack.memory.pool
    MusicPlayer_play(songpack.memory.pool[tonumber(obj.getGMNotes())])

    -- change the button to orange
    obj.editButton({index = 0, color = {1, 1, 0}})

    -- save the guesses
    if (Memory_firstGuess == nil) then
        -- first guess
        Memory_firstGuess = obj
    else
        -- second guess
        Memory_secondGuess = obj

        -- wait for the current song to start playing, then wait for the Music Player to stop playing
        Wait.condition(Memory_playSong_Started, MusicPlayer_isPlaying, 30, Memory_playSong_Timeout)
    end
end

function Memory_playSong_Started()
    -- wait for the Music Player to stop playing, then compare the guesses
    Wait.condition(Memory_playSong_showResult, MusicPlayer_isStopped, 30, Memory_playSong_Timeout)
end

function Memory_playSong_showResult()
     -- compare the guesses
     if (Memory_firstGuess.getGMNotes() == Memory_secondGuess.getGMNotes()) then
        -- TODO: give player a point
        broadcastToAll('Treffer') 
        -- Memory_firstGuess.editButton({index = 0, color = {0, 1, 0}})
        -- Memory_secondGuess.editButton({index = 0, color = {0, 1, 0}})
        destroyObject(Memory_firstGuess)
        destroyObject(Memory_secondGuess)
    else
        broadcastToAll('Daneben')
        Memory_firstGuess.editButton({index = 0, color = {1, 1, 1}})
        Memory_secondGuess.editButton({index = 0, color = {1, 1, 1}})
    end

    -- reset the guesses
    Memory_firstGuess = nil
    Memory_secondGuess = nil
end


function Memory_playSong_Timeout()
    log('Memory_playSong_Timeout')
end