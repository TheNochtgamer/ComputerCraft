--
-- Monitors driver lib
-- by TheNochtgamer
--


local imageCutter = require("imageCutter")
local expect = require("cc.expect").expect
local monitors = { peripheral.find("monitor") }

local filename = "monitorsArray.cfg"
local sortedMonitors = {}

if not monitors[1] then
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

if #savedMonitors ~= #monitors then
    settings.save(filename)

    for i = 1, #monitors, 1 do
        local myId = (peripheral.getName(monitors[i])):match("%d+")
        monitors[i].setTextScale(5)
        monitors[i].clear()
        monitors[i].setCursorPos(1, 1)
        monitors[i].write(myId)
    end

    print(("%s == %s | false"):format(#savedMonitors, #monitors))
    error("La configuracion del array no concuerda, porfavor edita el archivo monitorsArray.cfg con el orden de iz->de.",
        0)
end

if settings.get("monitorsArrayWidth") * settings.get("monitorsArrayHeight") ~= #monitors then
    print(("%s * %s == %s | false"):format(settings.get("monitorsArrayWidth"), settings.get("monitorsArrayHeight"),
        #monitors))
    error(
        "La configuracion de la posicion de monitores no concuerda, porfavor edita el archivo monitorsArray.cfg.",
        0)
end

for i = 1, #savedMonitors, 1 do
    local myName  = ("monitor_%s"):format(savedMonitors[i])
    local monitor = peripheral.wrap(myName)

    if not monitor then
        error(("Monitor en la linea %s '%s' no existe"):format(i, myName), 0)
    end

    table.insert(sortedMonitors, monitor)
end

local function check()
    for i = 1, #sortedMonitors, 1 do
        sortedMonitors[i].clear()
        sortedMonitors[i].setTextScale(5)
        sortedMonitors[i].setCursorPos(1, 1)

        sortedMonitors[i].setTextColor(colors.white)
        sortedMonitors[i].setBackgroundColor(colors.black)

        sortedMonitors[i].write(i)
        sortedMonitors[i].setCursorPos(1, 1)
    end
end

local function draw(image)
    expect(1, image, "table")
    local myTerm = term.current()

    local parts = imageCutter.CutsByEqualParts(image, settings.get("monitorsArrayWidth"),
        settings.get("monitorsArrayHeight"))

    for i = 1, #sortedMonitors, 1 do
        sortedMonitors[i].clear()
        sortedMonitors[i].setTextScale(0.5)
        sortedMonitors[i].setCursorPos(1, 1)

        term.redirect(sortedMonitors[i])
        paintutils.drawImage(parts[i], 1, 1)
        term.redirect(myTerm)
    end
end

return {
    check = check,
    draw = draw
}
