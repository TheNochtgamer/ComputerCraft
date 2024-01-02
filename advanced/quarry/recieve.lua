-- Program to receive messages from computers/
-- turtles using flex.lua "send" function
-- <Flexico64@gmail.com>

--------------------------------------
-- |¯\|¯¯] /¯]|¯¯][¯¯]\\  //|¯¯]|¯\ --
-- | /| ] | [ | ]  ][  \\// | ] | / --
-- | \|__] \_]|__][__]  \/  |__]| \ --
--------------------------------------

local log_file = "log.txt"
local options_file = "flex_options.cfg"
os.loadAPI("flex.lua")
local modem_channel = 6464


if fs.exists(options_file) then
    local file = fs.open("flex_options.cfg", "r")
    local line = file.readLine()
    while line ~= nil do
        if string.find(line, "modem_channel=") == 1 then
            modem_channel = tonumber(string.sub(
                line, 15, string.len(line)))
            break
        end --if
        line = file.readLine()
    end --while
    file.close()
end   --if


local modem
local p = flex.getPeripheral("modem")
if #p > 0 then
    modem = peripheral.wrap(p[1])
    modem.open(modem_channel)
else
    flex.printColors("Please attach a wireless"
        .. " or ender modem\n", colors.red)
    sleep(2)
    return
end --if/else

local monitor
p = flex.getPeripheral("monitor")
if #p > 0 then
    monitor = peripheral.wrap(p[1])
    term.redirect(monitor)
    monitor.clear()
    monitor.setCursorPos(1, 1)
    monitor.setTextScale(0.5)
end --if
local lcd_x, lcd_y = monitor.getSize()


local file, line
local filelist = {}
if fs.exists(log_file) then
    file = fs.open(log_file, "r")
    line = file.readLine()

    while line ~= nil do
        if line ~= "" or (line == "" and
                filelist[#filelist] ~= "") then
            filelist[#filelist + 1] = line
        end --if

        line = file.readLine()
    end --while
    file.close()
    file = fs.open(log_file, "a")
else
    -- Log file does not exist: make one!
    file = fs.open(log_file, "w")
end --if/else


local x, y
y = math.max(1, #filelist - lcd_y)
for x = y, #filelist do
    flex.printColors(filelist[x])
end --for

if filelist[#filelist] ~= "" then
    file.writeLine("")
end --if
file.close()


term.setTextColor(colors.white)
print("Waiting for message on channel "
    .. tostring(modem_channel) .. "...")

while true do
    local event, modemSide, senderChannel,
    replyChannel, message, senderDistance =
        os.pullEvent("modem_message")

    file = fs.open(log_file, "a")
    file.writeLine(message)
    file.close()

    flex.printColors(message)

    sleep(0.01)
end --while
