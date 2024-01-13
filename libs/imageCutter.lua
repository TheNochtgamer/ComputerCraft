--
-- Image Cutter lib
-- By TheNochtgamer
--

local expect = require "cc.expect"
local expect = expect.expect

local function Cut(image, maxX, maxY, x, y)
    expect(1, image, "table")
    expect(2, maxX, "number")
    expect(3, maxY, "number")
    expect(4, x, "number", "nil")
    expect(5, y, "number", "nil")

    local cutted = {}
    x = x or 1
    y = y or 1

    for sy = y, maxY + y - 1, 1 do
        if not image[sy] then
            break
        end

        cutted[sy - y + 1] = {}

        for sx = x, maxX + x - 1, 1 do
            if not image[sy][sx] then
                break
            end
            cutted[sy - y + 1][sx - x + 1] = image[sy][sx]
        end
    end

    return cutted
end

-- Corta la imagen completa y la retorna en partes iguales de un array dentro de un array
local function CutsByEqualParts(image, partsX, partsY)
    expect(1, image, "table")
    expect(2, partsX, "number")
    expect(3, partsY, "number")

    local parts = {}
    local totalParts = partsX * partsY
    local maxX = #image[1]
    local maxY = #image

    local widthPerPart = math.floor(maxX / partsX)
    local heightPerPart = math.floor(maxY / partsY)

    for t = 1, totalParts, 1 do
        -- parts[t] = Cut(image, widthPerPart, heightPerPart, widthPerPart * (t - 1), heightPerPart * (t - 1))

        local part = {}
        local partY = math.floor((t - 1) / partsX)
        local partX = (t - 1) - (partY * partsX)

        for y = 1, heightPerPart, 1 do
            part[y] = {}

            for x = 1, widthPerPart, 1 do
                part[y][x] = image[partY * heightPerPart + y][partX * widthPerPart + x]
            end
        end

        parts[t] = part
    end

    return parts
end

return {
    Cut = Cut,
    CutsByEqualParts = CutsByEqualParts
}
