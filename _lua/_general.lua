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