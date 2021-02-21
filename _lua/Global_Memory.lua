function Memory_spawnTiles(numX, numY)
    log('spawn begin')
    startPosX = 0
    startPosY = 0

    spawnParams = {
        type = 'Custom_Tile',
        position = {x = 0, y = 0, z = 0},
        rotation = {x = 0, y = 0, z = 0},
        scale = {x = 1, y = 1, z = 1},
        sound = false,
        snap_to_grid = true
    }
    newObj = spawnObject(spawnParams)

    customParams = {
        image = songpack.settings.icon,
        type = 3,
        thickness = 0.1,
        stackable = false
    }
    newObj.setCustomObject(customParams)
end