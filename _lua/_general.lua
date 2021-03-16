function removeAllVectorLines()
    log(Global.getVectorLines())
    Global.setVectorLines(nil)
end

function drawRectangle(topLeft, bottomRight, color, thickness, rotation)
    vectorLines = Global.getVectorLines()

    if (vectorLines == nil) then
        vectorLines = {}
    end

    table.insert(vectorLines, {
        points = {topLeft, {x = bottomRight.x, y = topLeft.y, z = topLeft.z}},
        color = color,
        thickness = thickness,
        rotation = rotation
    })

    table.insert(vectorLines, {
        points = {{x = bottomRight.x, y = topLeft.y, z = topLeft.z}, bottomRight},
        color = color,
        thickness = thickness,
        rotation = rotation
    })

    table.insert(vectorLines, {
        points = {bottomRight, {x = topLeft.x, y = topLeft.y, z= bottomRight.z}},
        color = color,
        thickness = thickness,
        rotation = rotation
    })

    table.insert(vectorLines, {
        points = {{x = topLeft.x, y = topLeft.y, z = bottomRight.z}, topLeft},
        color = color,
        thickness = thickness,
        rotation = rotation
    })

    Global.setVectorLines(vectorLines)
end

function isOdd(num)
    if (num % 2 == 1) then
        return true
    end
        
    return false
end

function getObjectsFromPosition()
    local position = {x = 0, y = 2, z = 0}
    local range = 3
    local type = 'Tile'

    local params = {
        type = 3,
        origin = position,
        direction = {0, -1, 0},
        size = {x = range, y = range, z = range},
        max_distance = 0,
        debug = true
    }

    local hitlist = Physics.cast(params)

    log('Hitlist')
    log(hitlist)

    local retList = {}
    for _, result in ipairs(hitlist) do
        log(result.hit_object.type)
        if (result.hit_object.type == type) then
            table.insert(retList, result.hit_object)
        end
    end

    log(retList)
end