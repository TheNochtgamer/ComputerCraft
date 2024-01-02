local dfpwm = require("cc.audio.dfpwm")
local modem =
    peripheral.find("modem") or
    error("No modem attached", 0)
local expect = require "cc.expect"
expect(1, arg[1], "string")

local filename = arg[1]
local channel = tonumber(arg[2] or 103)
local reciverChannel = tonumber(arg[3] or 104)

local decoder = dfpwm.make_decoder()

modem.open(reciverChannel)

local function main()
    for chunk in io.lines(filename, 16 * 1024) do
        local buffer = decoder(chunk)

        print("Sending " .. tostring(#buffer) .. " bytes")

        modem.transmit(channel, reciverChannel, buffer)
        -- while not  do
        --     os.pullEvent("modem_message")
        -- end
        os.pullEvent("modem_message")

        print("Received a reply")
    end
end
main()
