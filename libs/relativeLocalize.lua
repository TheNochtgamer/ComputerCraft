local config = {
    _debug = false,
    _persistenceFile = "localize.cfg",
}

local relativeDisplacement = {
    -- +1 = forward, -1 = back
    movement = 0,
    -- +1 = up, -1 = down
    elevation = 0,
    -- +1 = right, -1 = left
    rotation = 0,
}

settings.define("movement.displacement", {
    description = "The displacement of the turtle relative to the starting position",
    type = "number",
    default = 0,
})

settings.define("elevation.displacement", {
    description = "The displacement of the turtle relative to the starting position",
    type = "number",
    default = 0,
})

settings.define("rotation.displacement", {
    description = "The displacement of the turtle relative to the starting position",
    type = "number",
    default = 0,
})

local _save       = function()
    if config._debug then print("[F]_save") end
    settings.set("movement.displacement", relativeDisplacement.movement)
    settings.set("elevation.displacement", relativeDisplacement.elevation)
    settings.set("rotation.displacement", relativeDisplacement.rotation)
    settings.save(config._persistenceFile)
end

local ogFunctions = {
    _forward   = turtle.forward,
    _back      = turtle.back,
    _up        = turtle.up,
    _down      = turtle.down,
    _turnLeft  = turtle.turnLeft,
    _turnRight = turtle.turnRight
}

local reset       = function()
    if config._debug then print("[F]reset") end
    relativeDisplacement.movement = 0
    relativeDisplacement.elevation = 0
    relativeDisplacement.rotation = 0
end

local function isBackHome()
    if config._debug then print("[F]isBackHome") end
    if relativeDisplacement.movement == 0 and relativeDisplacement.elevation == 0 and relativeDisplacement.rotation == 0 then
        return true
    end
    return false
end

local simpleGoBackHome = function()
    if config._debug then print("[F]goBackHome") end
    if isBackHome() then return true end

    local movement = relativeDisplacement.movement
    local elevation = relativeDisplacement.elevation
    local rotation = relativeDisplacement.rotation

    if movement > 0 then
        for i = 1, movement, 1 do
            turtle.back()
        end
    elseif movement < 0 then
        for i = 1, math.abs(movement), 1 do
            turtle.forward()
        end
    end

    if elevation > 0 then
        for i = 1, elevation, 1 do
            turtle.down()
        end
    elseif elevation < 0 then
        for i = 1, math.abs(elevation), 1 do
            turtle.up()
        end
    end

    if rotation > 0 then
        for i = 1, rotation, 1 do
            turtle.turnLeft()
        end
    elseif rotation < 0 then
        for i = 1, math.abs(rotation), 1 do
            turtle.turnRight()
        end
    end

    return true
end

turtle.forward = function()
    if config._debug then print("[F]forward") end
    local res, reason = ogFunctions._forward()
    if not res then return res, reason end

    relativeDisplacement.movement = relativeDisplacement.movement + 1
    _save()

    return true
end

turtle.back = function()
    if config._debug then print("[F]back") end
    local res, reason = ogFunctions._back()
    if not res then return res, reason end

    relativeDisplacement.movement = relativeDisplacement.movement - 1
    _save()

    return true
end

turtle.up = function()
    if config._debug then print("[F]up") end
    local res, reason = ogFunctions._up()
    if not res then return res, reason end

    relativeDisplacement.elevation = relativeDisplacement.elevation + 1
    _save()

    return true
end

turtle.down = function()
    if config._debug then print("[F]down") end
    local res, reason = ogFunctions._down()
    if not res then return res, reason end

    relativeDisplacement.elevation = relativeDisplacement.elevation - 1
    _save()

    return true
end

turtle.turnLeft = function()
    if config._debug then print("[F]turnLeft") end
    local res, reason = ogFunctions._turnLeft()
    if not res then return res, reason end

    relativeDisplacement.rotation = relativeDisplacement.rotation - 1
    _save()

    return true
end

turtle.turnRight = function()
    if config._debug then print("[F]turnRight") end
    local res, reason = ogFunctions._turnRight()
    if not res then return res, reason end

    relativeDisplacement.rotation = relativeDisplacement.rotation + 1
    _save()

    return true
end
settings.load(config._persistenceFile)

return {
    reset = reset,
    isBackHome = isBackHome,
    relativeDisplacement = relativeDisplacement,
    simpleGoBackHome = simpleGoBackHome,
    _ogFunctions = ogFunctions,
}
