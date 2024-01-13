-- Config

local outputItem = ""

-- Functions

function Main()
    while true do
        for i = 1, 9, 1 do
            if not turtle.suck() then
                sleep(20)
            end
        end

        if turtle.getItemDetail(4) then
            turtle.select(4)
            turtle.transferTo(10)
            turtle.select(1)
        end

        if turtle.getItemDetail(8) then
            turtle.select(8)
            turtle.transferTo(11)
            turtle.select(1)
        end

        for i = 12, 16, 1 do
            if turtle.getItemCount(i) > 0 then
                turtle.select(i)
                turtle.drop()
                turtle.select(1)
            end
        end

        turtle.craft()

        for i = 1, 16, 1 do
            turtle.select(i)
            if turtle.getItemDetail(i) then
                if turtle.getItemDetail(i).name == outputItem then
                    turtle.dropDown()
                    break
                end
            end
        end
    end
end
