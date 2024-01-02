localize = require("localize")

for i = 1, 8 do turtle.forward() end

local msg = arg

redstone.setAnalogOutput("back", 4)

shell.run("gps", "host", "x", "y", "z")
