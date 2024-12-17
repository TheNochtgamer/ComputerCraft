local mon = peripheral.find("monitor") or error("No monitor attached")

local config = {
    -- The text to display
    text = "DvD"

    ,
    -- The time between each frame
    time = 0.4

    ,
    -- Send redstone output to the back when the text hit a perfect corner
    cornerRedstone = true

    ,
    -- The scale of the text
    textScale = 1.6
}

local w, h = mon.getSize()
local dx, dy = 1, 1

local function randomColor()
    local avaliable = {
        colors.white,
        colors.orange,
        colors.magenta,
        colors.lightBlue,
        colors.yellow,
        colors.lime,
        colors.pink,
        colors.gray,
        colors.lightGray,
        colors.cyan,
        colors.purple,
        colors.blue,
        colors.brown,
        colors.green,
        colors.red,
        colors.black
    }
    local rand = math.floor(math.random(1, #avaliable))

    while avaliable[rand] == mon.getTextColor() or avaliable[rand] == mon.getBackgroundColor() do
        rand = math.floor(math.random(1, #avaliable))
    end

    return avaliable[rand]
end

function MonResize()
    while true do
        os.pullEvent("monitor_resize")

        w, h = mon.getSize()
    end
end

function MonTouch()
    while true do
        os.pullEvent("monitor_touch")
        dx = -dx
        dy = -dy
    end
end

function Main()
    local x, y = 1, 1

    mon.clear()
    mon.setTextScale(config.textScale)

    while true do
        local isCorner = 0
        mon.setCursorPos(x, y)
        mon.write(config.text)

        sleep(config.time)

        mon.setCursorPos(x, y)
        for i = 1, #config.text, 1 do
            mon.write(" ")
        end

        x = x + dx
        y = y + dy

        if x <= 1 or x >= w - #config.text + 1 then
            if x <= 1 then
                dx = 1
            else
                dx = -1
            end

            isCorner = 1
            if mon.isColor() then
                mon.setTextColor(randomColor())
            end
        end
        if y <= 1 or y >= h then
            if y <= 1 then
                dy = 1
            else
                dy = -1
            end

            isCorner = isCorner + 1
            if mon.isColor() then
                mon.setTextColor(randomColor())
            end
        end
        if isCorner == 2 and config.cornerRedstone then
            redstone.setOutput("back", true)
            sleep(0.5)
            redstone.setOutput("back", false)
        end
    end
end

parallel.waitForAny(Main, MonTouch, MonResize)
