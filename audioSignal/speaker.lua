local speaker = peripheral.find("speaker")
local modem = peripheral.find("modem") or error("No modem attached", 0)

modem.open(103)

local function main()
    while true do
        local event, side, channel, replyChannel, buffer, distance = os.pullEvent("modem_message")

        print("Received " .. tostring(#buffer) .. " bytes")

        speaker.playAudio(buffer)
        os.pullEvent("speaker_audio_empty")

        modem.transmit(replyChannel, 0, "done")
    end
end
main()
