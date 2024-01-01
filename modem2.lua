local splitFn = require "splitFn"
local expect = require "cc.expect"
local expect, field = expect.expect, expect.field

local modem = peripheral.find("modem") or error("No modem attached", 0)
modem.open(99)

local event, side, channel, replyChannel, message, distance
repeat
    event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")

    print("Received a reply: '" ..
        tostring(message) ..
        "' on channel " ..
        tostring(channel) ..
        " from " .. tostring(replyChannel) .. " at distance " .. tostring(math.floor(distance * 100) / 100) .. " blocks")

    local args = splitFn(message, " ")

    if args[0] == "redstone" then
        expect(1, args[1], "back", "front", nil)
        expect(2, args[2], "string", nil)

        redstone.setAnalogOutput(args[1] or "back", tonumber(args[2] or 1))
    end
until message == "stop"
print("Stop message received")
