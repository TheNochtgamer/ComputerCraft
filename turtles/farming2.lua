--
-- Farm turtle script
-- By TheNochtgamer
--
-- Please place the turtle on the corner of the farm
-- and place a chest in front of it
--
local localize = require "relativeLocalize"

local args = {
  ...
}
if not type(args[1]) == "string" or not type(args[2]) == "string" or not (args[3] == "right" or args[3] == "left") then
  print("farming2.lua <rows> <columns> <'right', 'left'> [sleep]")
  return
end

-- Variables

local rows = tonumber(args[1])
local columns = tonumber(args[2])
local farmDirection = args[3] or "right"
local status = 'nothing'
local sleepTime = tonumber(args[4]) or 15

-- Utilities

local function addMc(itemName)
  if itemName:find(":") then
    return itemName
  end
  return "minecraft:" .. itemName
end

local function isFuel(slot)
  local fuelTypes = {
    "coal",
    "coal_block",
    "lava_bucket"
  }

  local item = turtle.getItemDetail(slot)
  return item ~= nil and fuelTypes[addMc(item.name)] ~= nil
end

-- Functions

local function fastSelect(slot)
  local current = turtle.getSelectedSlot()
  turtle.select(slot or 1)
  return function()
    turtle.select(current)
  end
end

local function detectChest()
  local success, frontBlock = turtle.inspect()

  if success == nil then
    return false
  end
  if frontBlock.name ~= "minecraft:chest" then
    return false
  end

  return peripheral.wrap("front")
end

local function manageInv()

  -- Revisa que el slot 1 sea combustible, sino mueve el item
  if isFuel(1) then
    local slot = fastSelect(1)
    for i = 2, 16, 1 do
      if turtle.transferTo(i) then
        break
      end
    end
    slot()
  end

  -- En el caso de volver a la base, vacía el inventario
  if status == "returning" and detectChest() then
    local total = 0

    for i = 2, 16, 1 do
      turtle.select(i)
      total = total + turtle.getItemCount()
      turtle.drop()
    end
    turtle.select(1)

    print("Total: " .. tostring(total) .. " items harvested")
    return
  end
end

local function checkAndFarm()
  local status, block = turtle.inspectDown()
  local function place()
    manageInv()
    local success, reason = turtle.placeDown()

    if not success and not reason == "Cannot place block here" then
      for i = 2, 16, 1 do
        turtle.select(i)
        success = turtle.placeDown()
        if success then
          break
        end
      end
    elseif not success and turtle.getItemCount(turtle.getSelectedSlot()) == 0 then
      local success2 = false
      for i = 2, 16, 1 do
        if turtle.getItemCount(i) > 0 then
          turtle.select(i)
          success2 = turtle.placeDown()
          if success2 then
            break
          end
        end
      end
    end
  end

  if not status then
    turtle.digDown()
    place()
  elseif block.tags["minecraft:replaceable_plants"] then
    down()
    up()
    place()
  elseif not block.tags["minecraft:crops"] then
    return
  elseif block.state.age == 7 then
    turtle.digDown()
    turtle.suckDown()
    place()
  end
end

local function refuel()
  if (turtle.getFuelLevel() > 100) then
    return
  end

  local slot = fastSelect(1)
  turtle.refuel(2)
  slot()
end

local function nextTile(column, row)
  local fuelLevel = turtle.getFuelLevel()
  local turn = {
    right = function()
      turnRight()
      forward()
      turnRight()
    end,
    left = function()
      turnLeft()
      forward()
      turnLeft()
    end
  }

  if fuelLevel == 0 then
    print("Out of fuel")
    repeat
      refuel()
      sleep(3)
    until turtle.getFuelLevel() > 0
    print("Refueled")
  end

  if row == rows then
    if column % 2 == 1 then
      turn[farmDirection]()
    else
      if farmDirection == "right" then
        turn.left()
      else
        turn.right()
      end
    end
  else
    forward()
  end
end

-- Main()

function Main()
  if not localize.isBackHome() then
    print("Returning home to start again")
    refuel()
  end
  localize.simpleGoBackHome()

  if not detectChest() then
    print("No chest detected")

    repeat
      sleep(3)
    until detectChest()
    print("Chest detected")
  end

  while true do
    turtle.select(2)
    turnLeft()
    turnLeft()

    status = 'farming'
    print("Going to farm")
    manageInv()
    refuel()
    for i = 1, columns, 1 do
      for j = 1, rows, 1 do
        checkAndFarm()
        nextTile(i, j)
      end
      refuel()
    end

    status = "returning"
    print("Returning to home")
    localize.simpleGoBackHome()

    if not detectChest() then
      print("No chest detected")

      repeat
        sleep(3)
      until detectChest()
      print("Chest detected")
    end
    manageInv()

    sleep(sleepTime)
  end
end
Main()
