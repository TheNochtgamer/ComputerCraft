--
-- Monitors driver lib
-- by TheNochtgamer
--

-- Imports

local imageCutter = require("imageCutter")
local expect = require("cc.expect").expect
local loadedMonitors = { peripheral.find("monitor") }

local sortedMonitors = {}
local sizeParts = {}
local currentPos = {}

-- Settings

local filename = "monitorsArray.cfg"

if not loadedMonitors[1] then
    error("No monitor attached", 0)
end

settings.define("monitorsArrayWidth", {
    description = "The total monitor width",
    type = "number",
    default = 1
})

settings.define("monitorsArrayHeight", {
    description = "The total monitor height",
    type = "number",
    default = 1
})

settings.define("monitorsArray", {
    description = "The monitor array",
    type = "table",
    default = {}
})

settings.load(filename)
local savedMonitors = settings.get("monitorsArray")

settings.set("monitorsArrayWidth", settings.get("monitorsArrayWidth"))
settings.set("monitorsArrayHeight", settings.get("monitorsArrayHeight"))
settings.set("monitorsArray", savedMonitors)

-- Utils

local function _runOnEveryMonitor(func)
    expect(1, func, "function")

    local res = {}

    if #sortedMonitors == 0 then
        for i = 1, #loadedMonitors, 1 do
            table.insert(res, func(loadedMonitors[i], i))
        end
    else
        for i = 1, #sortedMonitors, 1 do
            table.insert(res, func(sortedMonitors[i], i))
        end
    end
    return unpack(res)
end

local function _findMonitor(id)
    expect(1, id, "number")
    local monitor = {}

    if #sortedMonitors == 0 then
        monitor = loadedMonitors[id]
    else
        monitor = sortedMonitors[id]
    end

    if not monitor then
        return nil, "Monitor not found"
    end

    return monitor
end

local function showMonsNames()
    return _runOnEveryMonitor(function(monitor)
        local myId = (peripheral.getName(monitor)):match("%d+")
        monitor.setTextScale(5)
        monitor.clear()
        monitor.setCursorPos(1, 1)
        monitor.write(myId)
    end)
end


local function checkMonsQuantity()
    if #savedMonitors ~= #loadedMonitors then
        settings.save(filename)

        return 0
    end
    return 1
end

local function checkMonsTotal()
    if settings.get("monitorsArrayWidth") * settings.get("monitorsArrayHeight") ~= #loadedMonitors then
        return 0
    end
    return 1
end

-- Fallbacks

if arg[1] == "show" or arg[1] == "test" then
    showMonsNames()
    print("Mostrando los numeros de cada monitor.")
    return
end
if arg[1] == "help" then
    print(
        "Debes editar el archivo monitorsArray.cfg con el orden de los monitores de 'izq' a 'der' y de 'arriba' a 'abajo'.")
    return
end
if arg[1] == "clear" then
    _runOnEveryMonitor(function(monitor)
        monitor.clear()
    end)
    print("Limpiando todos los monitores.")
    return
end

if checkMonsQuantity() == 0 then
    print(("%s == %s | false"):format(#savedMonitors, #loadedMonitors))
    error(
        "La configuracion del array no concuerda, porfavor edita el archivo monitorsArray.cfg con el orden de iz->de.",
        0)
end
if checkMonsTotal() == 0 then
    print(("%s * %s == %s | false"):format(settings.get("monitorsArrayWidth"), settings.get("monitorsArrayHeight"),
        #loadedMonitors))
    error(
        "La configuracion de la posicion de monitores no concuerda, porfavor edita el archivo monitorsArray.cfg.",
        0)
end

-- Sorting Monitors

for i = 1, #savedMonitors, 1 do
    local myName  = ("monitor_%s"):format(savedMonitors[i])
    local monitor = peripheral.wrap(myName)

    if not monitor then
        error(("Monitor en la linea %s '%s' no existe"):format(i, myName), 0)
        return
    end

    table.insert(sortedMonitors, monitor)
end

local function calculateSizeParts()
    local totalWeight = 0
    local totalHeight = 0

    for i = 1, #sortedMonitors, 1 do
        local monitor = sortedMonitors[i]
        local mon_width, mon_height = monitor.getSize()

        local sizeObj = {
            monitor = monitor,
            width = mon_width,
            height = mon_height,
            posX = totalWeight,
            posY = totalHeight,
            maxPosX = totalWeight + mon_width - 1,
            maxPosY = totalHeight + mon_height - 1
        }

        totalWeight = totalWeight + mon_width
        totalHeight = totalHeight + mon_height

        table.insert(sizeParts, sizeObj)
    end
end
calculateSizeParts()

-- Endline Methods

local function test()
    _runOnEveryMonitor(function(monitor, i)
        monitor.clear()
        monitor.setTextScale(5)
        monitor.setCursorPos(1, 1)

        monitor.setTextColor(colors.white)
        monitor.setBackgroundColor(colors.black)

        monitor.write(i)
        monitor.setCursorPos(1, 1)
    end)
end

local function draw(image)
    expect(1, image, "table")
    local myTerm = term.current()

    local parts = imageCutter.CutsByEqualParts(image, settings.get("monitorsArrayWidth"),
        settings.get("monitorsArrayHeight"))

    _runOnEveryMonitor(function(monitor, i)
        monitor.clear()
        monitor.setTextScale(0.5)
        monitor.setCursorPos(1, 1)

        term.redirect(monitor)
        paintutils.drawImage(parts[i], 1, 1)
        term.redirect(myTerm)
    end)
end

local function clear()
    _runOnEveryMonitor(function(monitor)
        monitor.clear()
    end)
end

local function clearOne(id)
    expect(1, id, "number")

    local monitor, reason = _findMonitor(id)
    if (not monitor) then
        return reason
    end

    monitor.clear()
    return 1
end

local function getSize()
    local totalWidth = 0
    local totalHeight = 0

    _runOnEveryMonitor(function(monitor)
        local width, height = monitor.getSize()

        totalWidth = totalWidth + width
        totalHeight = totalHeight + height
    end)

    return totalWidth, totalHeight
end

local function getCursorPos()
    return currentPos.x, currentPos.y
end

local function setCursorPos(x, y)
    expect(1, x, "number")
    expect(2, y, "number")

    currentPos.x = x
    currentPos.y = y

    return 1
end

local function writeOne(id, text)
    expect(1, id, "number")
    expect(2, text, "string")

    local monitor, reason = _findMonitor(id)
    if (not monitor) then
        return reason
    end

    monitor.write(text)
end

-- TODO terminar de implementar el metodo write

local function write(text)
    local posX, posY = getCursorPos()

    for i = 1, #sortedMonitors, 1 do
        break
    end
end

-- API Return

return {
    monitors = sortedMonitors,
    test = test,
    draw = draw,
    clear = clear,
    getSize = getSize,
    clearOne = clearOne,
    getCursorPos = getCursorPos,
    setCursorPos = setCursorPos,
    writeOne = writeOne
}
