local _debug           = false

local _forward         = turtle.forward
local _back            = turtle.back
local _up              = turtle.up
local _down            = turtle.down

local _turnLeft        = turtle.turnLeft
local _turnRight       = turtle.turnRight

local _configured      = false
local errorMessage     = "Turtle not configured, please run localize.setDirection(0|3)"

local axisDisplacement = {
    x = 0,
    y = 0,
    z = 0,
    -- 0 = North, 1 = East, 2 = South, 3 = West
    direction = 0
}

local _say             = function(message)
    print("<localize> " .. message)
end

local reset            = function()
    if _debug then print("[F]reset") end
    axisDisplacement.x = 0
    axisDisplacement.y = 0
    axisDisplacement.z = 0
    axisDisplacement.direction = 0
    _configured = false
end

local setDirection     = function(direction)
    if _debug then
        print("[F]setDirection")
        print("direction: " .. direction)
    end
    if type(direction) ~= "number" then
        if direction == "north" then
            direction = 0
        elseif direction == "east" then
            direction = 1
        elseif direction == "south" then
            direction = 2
        elseif direction == "west" then
            direction = 3
        else
            return false, "Invalid direction"
        end
    end

    if direction > 3 then
        direction = 0
    end
    if direction < 0 then
        direction = 3
    end

    axisDisplacement.direction = direction
    _configured = true

    return true
end

local isBackHome       = function()
    if _debug then print("[F]isBackHome") end
    if axisDisplacement.x == 0 and axisDisplacement.y == 0 and axisDisplacement.z == 0 then
        return true
    end
    return false
end

local _sayBackHome     = function()
    if _debug then print("[F]_sayBackHome") end
    if isBackHome() then
        _say("Welcome back home")
    end
end

turtle.forward         = function()
    if _debug then print("[F]forward") end
    if not _configured then return false, errorMessage end

    local res, reason = _forward()
    if not res then return false, reason end

    if axisDisplacement.direction == 0 then
        axisDisplacement.z = axisDisplacement.z + 1
    elseif axisDisplacement.direction == 1 then
        axisDisplacement.x = axisDisplacement.x + 1
    elseif axisDisplacement.direction == 2 then
        axisDisplacement.z = axisDisplacement.z - 1
    elseif axisDisplacement.direction == 3 then
        axisDisplacement.x = axisDisplacement.x - 1
    end

    _sayBackHome()
    return true
end

turtle.back            = function()
    if _debug then print("[F]back") end
    if not _configured then return false, errorMessage end

    local res, reason = _back()
    if not res then return false, reason end

    if axisDisplacement.direction == 0 then
        axisDisplacement.z = axisDisplacement.z - 1
    elseif axisDisplacement.direction == 1 then
        axisDisplacement.x = axisDisplacement.x - 1
    elseif axisDisplacement.direction == 2 then
        axisDisplacement.z = axisDisplacement.z + 1
    elseif axisDisplacement.direction == 3 then
        axisDisplacement.x = axisDisplacement.x + 1
    end

    _sayBackHome()
    return true
end

turtle.up              = function()
    if _debug then print("[F]up") end
    local res, reason = _up()
    if not res then return false, reason end

    axisDisplacement.y = axisDisplacement.y + 1

    _sayBackHome()
    return true
end

turtle.down            = function()
    if _debug then print("[F]down") end
    local res, reason = _down()
    if not res then return false, reason end

    axisDisplacement.y = axisDisplacement.y - 1

    _sayBackHome()
    return true
end

turtle.turnLeft        = function()
    if _debug then print("[F]turnLeft") end
    if not _configured then return false, errorMessage end

    local res, reason = _turnLeft()
    if not res then return false, reason end

    setDirection(axisDisplacement.direction - 1)

    return true
end

turtle.turnRight       = function()
    if _debug then print("[F]turnRight") end
    if not _configured then return false, errorMessage end

    local res, reason = _turnRight()
    if not res then return false, reason end

    setDirection(axisDisplacement.direction + 1)

    return true
end

return {
    reset = reset,
    setDirection = setDirection,
    axisDisplacement = axisDisplacement,
    isBackHome = isBackHome,
}
