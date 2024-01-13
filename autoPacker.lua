-- Config

local outputItem = ""

-- Functions

function Main()
    while true do
        for i = 1, 9, 1 do
            if turtle.getItemCount(i) > 0 then
                goto continue
            end

            if not turtle.suck() then
                sleep(20)
            end
            ::continue::
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

        local function dropExtra()
            if turtle.getItemCount(4) > 0 then
                turtle.select(4)
                turtle.drop()
                turtle.select(1)
            end

            if turtle.getItemCount(8) > 0 then
                turtle.select(8)
                turtle.drop()
                turtle.select(1)
            end

            for i = 12, 16, 1 do
                if turtle.getItemCount(i) > 0 then
                    turtle.select(i)
                    turtle.drop()
                    turtle.select(1)
                end
            end
        end


        if not turtle.craft() then
            dropExtra()
            turtle.craft()
        end

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

Main()
