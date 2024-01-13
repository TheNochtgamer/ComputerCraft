while true do
    sleep(0.1)
    for i = 1, 9 do
        turtle.suck()
    end

    turtle.select(4)
    turtle.transferTo(11)
    turtle.select(8)
    turtle.transferTo(12)

    turtle.craft()

    turtle.select(1)
    turtle.dropDown()
end
