-- we are using computer craft to farm in minecraft

local farmBlocksFront = 8
local farmBlocksRight = 9

local function checkAndFarm()
    local success, data = turtle.inspectDown()
    if success then
        if (data.state.age == 7) then
            -- turtle.digDown()
            turtle.placeDown() -- in my case, i have a mod that autofarms with second click
            turtle.suckDown()
        end
    end
end

local function dropAll()
    for i = 2, 16 do
        turtle.select(i)
        turtle.drop()
    end
    turtle.select(1)
end

local function main()
    local direction = 1

    turtle.select(1)
    while true do
        for i = 1, farmBlocksRight do
            for i = 1, farmBlocksFront do
                turtle.refuel()

                checkAndFarm()
                sleep(1)
                turtle.forward()
            end
            print("Ended row" .. i)
            checkAndFarm()

            if i ~= farmBlocksRight then
                if direction == 1 then
                    turtle.turnRight()
                    turtle.forward()
                    turtle.turnRight()
                    direction = 0
                else
                    turtle.turnLeft()
                    turtle.forward()
                    turtle.turnLeft()
                    direction = 1
                end
            end
        end
        print("Ended farming")
        print("Going back to start")

        turtle.turnLeft()
        for i = 1, farmBlocksFront do
            turtle.forward()
        end
        turtle.turnLeft()
        for i = 1, farmBlocksFront do
            turtle.forward()
        end
        dropAll()

        turtle.turnRight()
        turtle.turnRight()

        sleep(7)
    end
end
main()
