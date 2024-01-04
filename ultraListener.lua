local modem = peripheral.find("modem") or error("No modem attached", 0)
local monitor = peripheral.find("monitor")

local msgsCount = 0

if monitor ~= nil then
    monitor.clear()
end

for i = 0, 127, 1 do
    modem.open(i)
end

function Main()
    while true do
        local event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
        msgsCount = msgsCount + 1

        print("[" .. tostring(msgsCount) .. "]Msg: '" ..
            tostring(message) ..
            "' | channel: " ..
            tostring(channel) ..
            " | reply: " ..
            tostring(replyChannel) .. " | distance: " .. tostring(math.floor(distance * 100) / 100) .. " meters")

        if monitor ~= nil then
            local width, height = monitor.getSize()
            monitor.scroll(1)
            monitor.setCursorPos(1, height)
            monitor.write("[" .. tostring(msgsCount) .. "] Msg: '" ..
                tostring(message) ..
                "' | " ..
                tostring(channel) ..
                " | " ..
                tostring(replyChannel) .. " | " .. tostring(math.floor(distance * 100) / 100) .. " meters")
        end
        -- modem.transmit(replyChannel, channel, "Recieved")
    end
end

parallel.waitForAll(Main)
