local detector = peripheral.find("playerDetector") or error("No player detector attached", 0)
local modem = peripheral.find("modem") or error("No modem attached", 0)

local transmitChannel = 107
local targetName = "TheNocht"

while true do
    local coords = detector.getPlayerPos(targetName)

    modem.transmit(
        transmitChannel,
        0,
        coords
    )

    sleep(2)
end
