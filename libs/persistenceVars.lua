local expect = require "cc.expect"

expect(1, arg[1], "string", "nil")

local filename = arg[1] or "vars.conf"

local function load()
    if fs.exists(filename) == false then
        return nil
    end
    local file = fs.open(filename, "r")

    local function loadTable(indent)
        expect(1, indent, "string", "nil")

        indent = indent or ""

        local table = {}
        local line = file.readLine()

        while line ~= nil do
            local key, value = line:match(indent .. "(.-) = (.+)")
            if key ~= nil then
                if value == "{" then
                    table[key] = loadTable(indent .. "    ")
                elseif value == "}" then
                    return table
                else
                    table[key] = value
                end
            end

            line = file.readLine()
        end

        return table
    end

    local table = loadTable()
    return table
end

local function save(_table)
    expect(1, _table, "table")
    local file = fs.open(filename, "w")

    if file then
        local function parseTable(_table, indent)
            indent = indent or ""

            for key, value in pairs(_table) do
                if type(value) == "table" then
                    file.write(indent .. key .. " = {" .. "\n")
                    parseTable(value, indent .. "    ")
                    file.write(indent .. "}" .. "\n")
                else
                    file.write(indent .. key .. " = " .. tostring(value) .. "\n")
                end
            end
        end

        parseTable(_table)
        file.close()
        return true
    else
        return false
    end
end


return {
    load = load,
    save = save
}
