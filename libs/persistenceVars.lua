local expect = require "cc.expect"

expect(1, arg[1], "string", "nil")

local filename = arg[1] or "vars.tmp"

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

local function save(table)
    expect(1, table, "table")
    local file = fs.open(filename, "w")

    local function saveTable(table, indent)
        expect(1, table, "table")
        expect(2, indent, "string", "nil")

        indent = indent or ""

        for k, v in pairs(table) do
            if type(v) == "table" then
                file.write(indent .. k .. " = {\n")
                saveTable(v, indent .. "    ")
                file.write(indent .. "}\n")
            else
                file.write(indent .. k .. " = " .. tostring(v) .. "\n")
            end
        end
    end

    saveTable(table)
end


return {
    load = load,
    save = save
}
