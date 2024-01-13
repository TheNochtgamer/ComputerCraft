local mon = peripheral.find("monitor") or error("No monitor attached")

if not arg[1] then
    print("Usage: image <image.nfp>")
    return
end

print("Drawing...")
local old_term = term.current()
mon.setTextScale(0.5)
term.redirect(mon)
term.clear()
--draw image through paintutils
local image = paintutils.loadImage(arg[1])
paintutils.drawImage(image, 0, 0)

term.redirect(old_term)
print("Done")
