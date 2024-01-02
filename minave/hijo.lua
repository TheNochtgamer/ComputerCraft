local split = require "splitFn"
local modem = peripheral.find("modem") or error("No modem attached", 0)
modem.open(109)

local function cmds(args)
    if args[1] == "refuel" then
        for i = 1, 16, 1 do
            turtle.select(i)
            turtle.refuel()
        end
        turtle.select(1)
    end

    if args[1] == "move" then
        turtle.forward()
    end
end

local event, side, channel, replyChannel, message, distance
repeat
    event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")

    print("Received a command: '" ..
        tostring(message))

    local args = split(message, " ")

    local success, result = pcall(cmds, args)
    if not success then
        print("Error: " .. tostring(result))
    end
until message == "stop"
print("Stop message received")
