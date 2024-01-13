-- Config

-- local outputItem = ""

-- Functions

function Main()
    while true do
        local offset = 0

        for i = 1, 9, 1 do
            if i == 4 then offset = 1 end
            if i == 7 then offset = 2 end
            local pos = i + offset

            if turtle.getItemCount(pos) == 0 then
                turtle.select(pos)
                if not turtle.suck() then
                    sleep(20)
                end
            end
        end

        turtle.select(16)
        if not turtle.craft() then
            for i = 1, 16, 1 do
                turtle.select(i)
                turtle.drop()
            end
            break
        end

        turtle.dropDown()
    end
end

Main()
