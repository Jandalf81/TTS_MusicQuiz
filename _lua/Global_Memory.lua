function Memory_drawField(numX, numZ)
    -- set the upper left point where the tiles will be placed
    startPosX = 0
    startPosZ = 0

    -- set the offset between tiles
    offsetX = 3
    offsetZ = 3

    -- compute the coordinates of the 4 corners
    local fieldTopLeft = {x = (startPosX - (offsetX / 2)), y = 1, z = (startPosZ + (offsetZ / 2))}
    --local fieldTopRight = {x = (startPosX + (offsetX * (numX - 1)) + (offsetX / 2)), y = 1, z = (startPosZ + (offsetZ / 2))}
    --local fieldBottomLeft = {x = (startPosX - (offsetX / 2)), y = 1, z = (startPosZ - (offsetZ * (numZ - 1)) - (offsetZ / 2))}
    local fieldBottomRight = {x = (startPosX + (offsetX * (numX - 1)) + (offsetX / 2)), y = 1, z = (startPosZ - (offsetZ * (numZ - 1)) - (offsetZ / 2))}

    local color = {1, 1, 1}
    local thickness = 0.2
    local rotation = {0, 0, 0}

    -- draw a rectangle around the playing field
    drawRectangle(fieldTopLeft, fieldBottomRight, color, thickness, rotation)

    -- TODO: draw rectangles around the players' score zones
    drawRectangle({x = 4, y = 1, z = 4}, {x = 5, y = 1, z = 5}, {r= 1, g = 0, b= 0}, 0.2, {x = 0, y = 0, z = 0})
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

    -- compute needed pairs
    local pairsNeeded = 0

    if(isOdd(numX * numZ)) then
        pairsNeeded = ((numX * numZ) - 1) / 2
    else
        pairsNeeded = (numX * numZ) / 2
    end
    log('pairsNeeded: ' .. pairsNeeded)

    if (pairsNeeded > #songpack.memory.pool) then
        local LANG_MEMORY_POOLTOOSMALL_repl
        LANG_MEMORY_POOLTOOSMALL_repl = string.gsub(LANG_MEMORY_POOLTOOSMALL, '<poolentries>', #songpack.memory.pool)
        broadcastToAll(LANG_MEMORY_POOLTOOSMALL_repl)

        broadcastToAll()
        return
    end

    -- remove random songs from pool if pool exceeds needed pairs
    local poolIndexes = {}

    -- add all indexes of songpack.memory.pool into poolIndexes
    for i, _ in ipairs(songpack.memory.pool) do
        table.insert(poolIndexes, i)
    end

    -- remove random entries from poolIndexes until it has as many entries left as pairs are needed
    while (#poolIndexes > pairsNeeded) do
        table.remove(poolIndexes, math.random(1, #poolIndexes))
    end
    log(poolIndexes)

    -- fill a table with pairs of indexes of songpack.memory.pool
    local poolOfPairs = {}

    for _, v in ipairs(poolIndexes) do
        -- every index needs to be added twice, because... pairs
        table.insert(poolOfPairs, v)
        table.insert(poolOfPairs, v)
    end
    log(poolOfPairs)

    local skipTile = nil

    -- check if both sides are odd
    if (isOdd(numX) and isOdd(numZ)) then
        log('ODD')
        -- compute the tile to skip
        skipTile = {
            ["x"] = (numX - 1) / 2,
            ["z"] = (numZ - 1) / 2
        }
    end

    -- for each tile horizontally...
    for x = 0, numX - 1, 1 do
        -- for each tile vertically...
        for z = 0, numZ - 1, 1 do
            --skip the current tile if skipTile is set
            if (skipTile ~= nil) then
                if (skipTile.x == x and skipTile.z == z) then
                    goto continue
                end
            end

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
            randIndex = math.random(1, #poolOfPairs)

            -- log('Tile at coords ' .. x .. ' / ' .. z)
            -- log(poolOfPairs)
            -- log('#poolOfPairs: ' .. #poolOfPairs)
            -- log('RandIndex: ' .. randIndex)
            -- log('Setting index ' .. poolOfPairs[randIndex])

            newObj.setGMNotes(poolOfPairs[randIndex])
            newObj.editButton({index = 0, label = 'Play\n' .. poolOfPairs[randIndex]})

            table.remove(poolOfPairs, randIndex)

            table.insert(MemoryTiles, newObj)

            ::continue::
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
        broadcastToAll(LANG_MEMORY_HIT)

        Memory_firstGuess.editButton({index = 0, color = {r = 0, g = 1, b = 0}})
        Memory_secondGuess.editButton({index = 0, color = {r = 0, g = 1, b = 0}})

        Wait.time(Memory_playSong_guessCorrect, 1)
    else
        broadcastToAll(LANG_MEMORY_MISS)
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