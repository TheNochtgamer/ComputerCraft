local expect = require "cc.expect"

expect(1, arg[1], "string")
expect(2, arg[2], "string", "nil")

local targetScript = arg[1]:match("([^/]+)$")
local scriptName = arg[2] or ("auto-script.lua")

if fs.exists(scriptName) then
    fs.delete(scriptName)
end

local file = fs.open(scriptName, "w");
file.write("fs.delete(\"" .. targetScript .. "\")\n")
file.write("shell.run(\"wget\", \"" ..
    arg[1] .. "\", \"" .. targetScript .. "\")\n")
file.write("print(\"running\", \"" .. targetScript .. "\")")
file.write("shell.run(\"" .. targetScript .. "\")\n")
file.close()



print("Auto script created: " .. scriptName)
