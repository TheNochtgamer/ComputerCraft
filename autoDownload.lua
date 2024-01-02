local expect = require "cc.expect"

expect(1, arg[1], "string")
expect(2, arg[2], "string", "nil")

local scriptName = "auto-" .. (arg[2] or "script.lua")

if fs.exists(scriptName) then
    fs.delete(scriptName)
end

local file = fs.open(scriptName, "w");
file.write("fs.delete(\"" .. scriptName .. "\")\n")
file.write("shell.run(\"wget\", \"" ..
    arg[1] .. "\", \"" .. scriptName .. "\")\n")
file.write("print(\"running\", \"" .. scriptName .. "\")")
file.write("shell.run(\"" .. scriptName .. "\")\n")
file.close()



print("Auto script created: " .. scriptName)