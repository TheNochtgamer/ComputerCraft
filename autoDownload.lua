local expect = require "cc.expect"

expect(1, arg[1], "string")
expect(2, arg[2], "string", "nil")

local scriptName = "auto-" .. (arg[2] or "script.lua")

fs.open(scriptName, "w")
    .write("fs.delete(\"" .. scriptName .. "\")")
    .write("shell.run(\"wget\"" ..
        arg[1] .. "\", \"" .. scriptName .. "\")")
    .write("shell.run(\"" .. scriptName .. "\")")
    .close()
