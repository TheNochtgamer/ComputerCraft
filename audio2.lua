local dfpwm = require("cc.audio.dfpwm")
local speaker = peripheral.find("speaker")

local decoder = dfpwm.make_decoder()

local args = { ... }

function PlayLoop(filename)
    while true do
        for chunk in io.lines(filename, 16 * 1024) do
            local buffer = decoder(chunk)

            while not speaker.playAudio(buffer) do
                os.pullEvent("speaker_audio_empty")
            end
        end
        sleep(3)
    end
end

local function build()
    return
end

parallel.waitForAny(
    build()
)
