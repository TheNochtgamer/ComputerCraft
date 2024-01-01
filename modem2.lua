local split = require "splitFn"
local expect = require "cc.expect"
local expect, field = expect.expect, expect.field

local modem = peripheral.find("modem") or error("No modem attached", 0)
modem.open(99)

local function cmds(args)
    if args[1] == "redstone" then
        expect(1, args[2], "back", "front")
        expect(2, args[3], "string", nil)

        redstone.setAnalogOutput(args[2], tonumber(args[3] or 1))
    end
end

local event, side, channel, replyChannel, message, distance
repeat
    event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")

    print("Received a reply: '" ..
        tostring(message) ..
        "' on channel " ..
        tostring(channel) ..
        " from " .. tostring(replyChannel) .. " at distance " .. tostring(math.floor(distance * 100) / 100) .. " blocks")


    local args = split(message, " ")

    xpcall(cmds(args), function(err)
        print(err)
        -- Esto deberia responder el modem
    end)
until message == "stop"
print("Stop message received")
