local modem = peripheral.find("modem") or error("No modem attached", 0)
modem.open(99)

local event, side, channel, replyChannel, message, distance
repeat
    event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")

    print("Received a reply: " ..
        tostring(message) ..
        " on channel " ..
        tostring(channel) ..
        " from " .. tostring(replyChannel) .. " at distance " .. tostring(math.floor(distance * 100) / 100) .. " blocks")
until message == "stop"
print("Stop message received")
