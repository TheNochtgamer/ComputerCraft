-- Objetivo: un script que maneje una turtle y sirva como quarry
-- Tengo en cuenta que:
-- 1 - El dispositivo (bloque) objetivo es un turtle
-- 2 - Existe un gps activo en el mundo
-- 3 - Tiene un punto de partida y un permitro que MINAR
-- 4 - Al dejar de cargar los chunks y volverlos a cargar el script debe volver a iniciar en el punto que se quedo
local split = require "splitFn"
local vars = require("persistenceVars")
local modem = peripheral.find("modem") or error("No modem attached", 0)

local config = {
    start = { x = 0, y = 0, z = 0 },
    perimeterCorner0 = { x = 0, y = 0, z = 0 },
    perimeterCorner1 = { x = 0, y = 0, z = 0 },
}

local function loadConfig()
    local _table = vars.load()
    if _table == nil then
        return
    end
    config = _table
end
loadConfig()

vars.save(config)

if gps.locate() == nil then
    error("No gps signal", 0)
end

if config.start.x == 0 or config.start.y == 0 or config.start.z == 0 then
    error("No start point defined", 0)
end

-- procedures

-- 0 = north | 1 = east | 2 = south | 3 = west
local function checkDirection()
    local x, _, z = gps.locate()
    local isBackMove = false

    if turtle.forward() == false then
        isBackMove = turtle.back()
    end

    local x2, _, z2 = gps.locate()

    if not isBackMove then
        turtle.back()
        if x2 > x then
            return 1
        elseif x2 < x then
            return 3
        elseif z2 > z then
            return 0
        elseif z2 < z then
            return 2
        end
    else
        turtle.forward()
        if x2 > x then
            return 3
        elseif x2 < x then
            return 1
        elseif z2 > z then
            return 2
        elseif z2 < z then
            return 0
        end
    end
    return 0
end

local function goToStart()
    local x, y, z = gps.locate()
    local dx, dy, dz = config.start.x - x, config.start.y - y, config.start.z - z

    for i = 1, dy, 1 do
        turtle.up()
    end
    -- FIXME ARREGLAR
    for i = 1, dx, 1 do
        turtle.forward()
    end

    turtle.turnLeft()
    for i = 1, dz, 1 do
        turtle.forward()
    end
end

local function checkAndRefuel()
    local fuelLevel = turtle.getFuelLevel()
    if fuelLevel < 100 then
        local slot = 1
        while turtle.getItemCount(slot) == 0 and not slot == 17 do
            slot = slot + 1
        end
        turtle.select(slot)
        turtle.refuel(1)
    end
end

-- main
local function Main()
    checkAndRefuel()
    print(checkDirection())
end
Main()
