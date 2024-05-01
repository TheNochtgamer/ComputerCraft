local function checkAndRefuel()
  local slot = turtle.getSelectedSlot()

  if turtle.getFuelLevel() < 100 then
    turtle.select(16)
    turtle.refuel()
  end

  turtle.select(slot)

end

local function tryBuild()
  local success = nil

  if turtle.getItemCount(turtle.getSelectedSlot()) == 0 then
    for i = 1, 16, 1 do
      turtle.select(i)
      if turtle.getItemCount(i) > 0 then
        success = turtle.placeDown()
        if success then
          break
        end
      end
    end
  else
    success = turtle.placeDown()
  end

  return success
end

function Main()
  while true do
    if not tryBuild() then
      error("No more blocks to build")
    end
    checkAndRefuel()
    turtle.forward()
  end

end
Main()
