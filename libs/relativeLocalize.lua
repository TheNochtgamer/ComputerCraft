--
-- RelativeLocalize script
-- By TheNochtgamer
--

local config = {
    _debug = false,
    _persistentFile = "localize.cfg",
}

local relativeDisplacement = {
    -- distances from start point
    dx = 0,
    dy = 0,
    dz = 0,

    -- +1 = right, -1 = left (0 .. 3)
    rotation = 0,
}

settings.define("dx.displacement", {
    description = "The displacement of the turtle relative to the starting position",
    type = "number",
    default = 0,
})

settings.define("dy.displacement", {
    description = "The displacement of the turtle relative to the starting position",
    type = "number",
    default = 0,
})

settings.define("dz.displacement", {
    description = "The displacement of the turtle relative to the starting position",
    type = "number",
    default = 0,
})

settings.define("rotation.displacement", {
    description = "The displacement of the turtle relative to the starting position",
    type = "number",
    default = 0,
})

local _load = function()
    if config._debug then print("[F]_load") end
    settings.load(config._persistentFile)
    relativeDisplacement.dx = settings.get("dx.displacement")
    relativeDisplacement.dy = settings.get("dy.displacement")
    relativeDisplacement.dz = settings.get("dz.displacement")
    relativeDisplacement.rotation = settings.get("rotation.displacement")
end

local _save = function()
    if config._debug then print("[F]_save") end
    settings.set("dx.displacement", relativeDisplacement.dx)
    settings.set("dy.displacement", relativeDisplacement.dy)
    settings.set("dz.displacement", relativeDisplacement.dz)
    settings.set("rotation.displacement", relativeDisplacement.rotation)
    settings.save(config._persistentFile)
end

local _setRotation = function(rotation)
    if rotation < 0 then
        rotation = 3
    elseif rotation > 3 then
        rotation = 0
    end

    if config._debug then print("[F]_setRotation " .. tostring(rotation)) end
    relativeDisplacement.rotation = rotation
    _save()
end

local reset = function()
    if config._debug then print("[F]reset") end
    relativeDisplacement.dx = 0
    relativeDisplacement.dy = 0
    relativeDisplacement.dz = 0
    relativeDisplacement.rotation = 0

    pcall(fs.delete, config._persistentFile)
end

local function isBackHome()
    if
        relativeDisplacement.dx == 0 and
        relativeDisplacement.dy == 0 and
        relativeDisplacement.dz == 0 and
        relativeDisplacement.rotation == 0
    then
        return true
    end
    return false
end

local simpleGoBackHome = function()
    if config._debug then print("[F]goBackHome") end
    if isBackHome() then return true end

    while relativeDisplacement.dy ~= 0 do
        if relativeDisplacement.dy > 0 then
            down()
        else
            up()
        end
    end

    while relativeDisplacement.dz ~= 0 do
        if relativeDisplacement.dz < 0 then
            if relativeDisplacement.rotation == 3 then
                turnRight()
            elseif relativeDisplacement.rotation == 1 then
                turnLeft()
            elseif relativeDisplacement.rotation == 2 then
                turnLeft()
                turnLeft()
            end
        else
            if relativeDisplacement.rotation == 1 then
                turnLeft()
            elseif relativeDisplacement.rotation == 3 then
                turnRight()
            elseif relativeDisplacement.rotation == 0 then
                turnLeft()
                turnLeft()
            end
        end

        forward()
    end

    while relativeDisplacement.dx ~= 0 do
        if relativeDisplacement.dx < 0 then
            if relativeDisplacement.rotation == 0 then
                turnRight()
            elseif relativeDisplacement.rotation == 2 then
                turnLeft()
            elseif relativeDisplacement.rotation == 3 then
                turnLeft()
                turnLeft()
            end
        else
            if relativeDisplacement.rotation == 0 then
                turnLeft()
            elseif relativeDisplacement.rotation == 2 then
                turnRight()
            elseif relativeDisplacement.rotation == 1 then
                turnLeft()
                turnLeft()
            end
        end

        forward()
    end

    while relativeDisplacement.rotation ~= 0 do
        turnRight()
    end

    return true
end

function forward()
    local res, reason = turtle.forward()
    if not res then return res, reason end

    if relativeDisplacement.rotation == 0 then
        relativeDisplacement.dz = relativeDisplacement.dz + 1
        if config._debug then print("[F]forward dz +1") end
    elseif relativeDisplacement.rotation == 1 then
        relativeDisplacement.dx = relativeDisplacement.dx + 1
        if config._debug then print("[F]forward dx +1") end
    elseif relativeDisplacement.rotation == 2 then
        relativeDisplacement.dz = relativeDisplacement.dz - 1
        if config._debug then print("[F]forward dz -1") end
    elseif relativeDisplacement.rotation == 3 then
        relativeDisplacement.dx = relativeDisplacement.dx - 1
        if config._debug then print("[F]forward dx -1") end
    end
    if config._debug then sleep(0.5) end

    _save()

    return true
end

function back()
    local res, reason = turtle.back()
    if not res then return res, reason end

    if relativeDisplacement.rotation == 0 then
        relativeDisplacement.dz = relativeDisplacement.dz - 1
        if config._debug then print("[F]back dz -1") end
    elseif relativeDisplacement.rotation == 1 then
        relativeDisplacement.dx = relativeDisplacement.dx - 1
        if config._debug then print("[F]back dx -1") end
    elseif relativeDisplacement.rotation == 2 then
        relativeDisplacement.dz = relativeDisplacement.dz + 1
        if config._debug then print("[F]back dz +1") end
    elseif relativeDisplacement.rotation == 3 then
        relativeDisplacement.dx = relativeDisplacement.dx + 1
        if config._debug then print("[F]back dx +1") end
    end

    return true
end

function up()
    local res, reason = turtle.up()
    if not res then return res, reason end
    if config._debug then
        print("[F]up")
        sleep(0.5)
    end

    relativeDisplacement.elevation = relativeDisplacement.elevation + 1

    _save()

    return true
end

function down()
    local res, reason = turtle.down()
    if not res then return res, reason end
    if config._debug then
        print("[F]down")
        sleep(0.5)
    end

    relativeDisplacement.elevation = relativeDisplacement.elevation - 1

    _save()

    return true
end

function turnLeft()
    local res, reason = turtle.turnLeft()
    if not res then return res, reason end
    if config._debug then
        print("[F]turnLeft")
        sleep(0.5)
    end


    _setRotation(relativeDisplacement.rotation - 1)

    _save()

    return true
end

function turnRight()
    local res, reason = turtle.turnRight()
    if not res then return res, reason end
    if config._debug then
        print("[F]turnRight")
        sleep(0.5)
    end

    _setRotation(relativeDisplacement.rotation + 1)

    _save()

    return true
end

_load()
return {
    reset = reset,
    isBackHome = isBackHome,
    relativeDisplacement = relativeDisplacement,
    simpleGoBackHome = simpleGoBackHome,

    forward = forward,
    back = back,
    up = up,
    down = down,
    turnLeft = turnLeft,
    turnRight = turnRight,
}
