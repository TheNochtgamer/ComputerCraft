local function checkAndRefuel()
  local slot = turtle.getSelectedSlot()

  if turtle.getFuelLevel() < 100 then
    turtle.select(16)
    turtle.refuel()
  end

  if turtle.getFuelLevel() < 1 then
    error("Not enough fuel")
  end

  turtle.select(slot)

end

local function tryBuild()
  local success = nil

  if turtle.detectDown() then
    return 2
  end

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

  if not success then
    return 0
  end
  return 1
end

function Main()
  while true do
    if tryBuild() == 0 then
      error("No more blocks to build")
    end
    checkAndRefuel()
    turtle.forward()
  end

end
Main()
