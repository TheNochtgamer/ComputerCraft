local url = arg[1]
local filename = url:match("^.+/(.+)$")

if not filename and arg[2] then
    filename = arg[2]
end
if not filename and not arg[2] then
    print("Invalid URL")
    return
end

if not url:find("^http://") and not url:find("^https://") then
    url = "http://" .. url
end

if fs.exists(filename) then
    fs.delete(filename)
end

if arg[2] then
    shell.run("wget", url, filename)
else
    shell.run("wget", url)
end