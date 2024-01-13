local mons = { peripheral.find("monitor") }
local filename = "monsArray.cfg"

print(("Found %s monitors"):format(#mons))

settings.define("monitorsArray", {
    description = "The monitor array",
    type = "table",
    default = {}
})
settings.load(filename)

local function sortMons()
    local saved = settings.get("monitorsArray")

    if not saved[1] then
        local defaultMons = {}
        for i = 1, #mons, 1 do
            defaultMons[i] = mons[i]
        end
        settings.set("monitorsArray", defaultMons)

        settings.save(filename)
        return mons
    end

    return saved
end

local res = sortMons()
for i = 1, #res, 1 do
    res[i].setTextScale(5)
    res[i].clear()
    res[i].setCursorPos(1, 1)
    res[i].write(i)
end
