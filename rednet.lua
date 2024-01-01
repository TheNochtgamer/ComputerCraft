peripheral.find("modem", rednet.open)

repeat
    local event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
    if channel == 43 then
        print("Received a reply: " .. tostring(message))
    end
until channel == 43
