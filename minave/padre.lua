local modem = peripheral.find("modem") or error("No modem attached", 0)
local expect = require "cc.expect"

expect(1, arg[1], "string", "number")

local function refuel()
    for i = 1, 16, 1 do
        turtle.select(i)
        turtle.refuel()
    end
    turtle.select(1)
end

local function main()
    modem.transmit(109, 99, "refuel")

    sleep(3)

    for i = 1, tonumber(arg[1]), 1 do
        sleep(0.3)
        modem.transmit(109, 99, "move")
        turtle.forward()
    end
end
main()
