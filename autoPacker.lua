-- Config

local totalDrawers = 5
local direction = "right"

-- Functions

local function checkFuelAndWait()
    if turtle.getFuelLevel() <= 0 then
        print("No tengo fuel, porfavor pon fuel en el slot 16 para continuar...")
        repeat
            sleep(6)
            if turtle.getItemCount(16) > 0 then
                turtle.select(16)
                turtle.refuel()
            end
        until turtle.getFuelLevel() > 0
        print("Fuel cargado, continuando en 4s")
        sleep(4)
    end
end

local function next()
    if direction == "right" then
        turtle.turnRight()
        local status, err = turtle.forward()
        if not status then
            turtle.turnLeft()
            return err
        end
        turtle.turnLeft()
    else
        turtle.turnLeft()
        local status, err = turtle.forward()
        if not status then
            turtle.turnRight()
            return err
        end
        turtle.turnRight()
    end
end

function Packer()
    while true do
        local offset = 0

        for i = 1, 9, 1 do
            if i == 4 then offset = 1 end
            if i == 7 then offset = 2 end
            local pos = i + offset

            if turtle.getItemCount(pos) == 0 then
                turtle.select(pos)
                if not turtle.suck() then
                    break
                end
            end
        end

        turtle.select(16)
        if not turtle.craft() then
            for i = 1, 16, 1 do
                turtle.select(i)
                turtle.drop()
            end
        end

        turtle.dropDown()
    end
end

function Main()
    while true do
        for i = 1, totalDrawers, 1 do
            checkFuelAndWait()

            if i > 1 then next() end

            Packer()
        end

        if direction == "right" then
            turtle.turnLeft()
        else
            turtle.turnRight()
        end

        for i = 1, totalDrawers, 1 do
            checkFuelAndWait()
            turtle.forward()
        end

        if direction == "right" then
            turtle.turnRight()
        else
            turtle.turnLeft()
        end
    end
end

Main()
