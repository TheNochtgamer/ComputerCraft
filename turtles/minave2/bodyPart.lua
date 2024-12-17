local modem = peripheral.find("modem") or error("No modem attached", 0)

-- Configs

local commandsChannel = 4;
local shipSyncChannel = 109;

-- Vars

local ship = {
  status = 0
}

-- Functions

local function split(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t = {}
  for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
    table.insert(t, str)
  end
  return t
end

local function checkFuelAndNotify(replyChannel)
  if turtle.getFuelLevel() <= 1 then
    modem.transmit(replyChannel, shipSyncChannel, 0)
    return
  end
  if turtle.getFuelLevel() < 100 then
    modem.transmit(replyChannel, shipSyncChannel, 1)
  end
end

-- Main

local syncCalls = {
  forward = function()
    checkFuelAndNotify(args._event.replyChannel)
    turtle.forward()
  end,
  back = function()
    checkFuelAndNotify(args._event.replyChannel)
    turtle.back()
  end,
  up = function()
    checkFuelAndNotify(args._event.replyChannel)
    turtle.up()
  end,
  down = function()
    checkFuelAndNotify(args._event.replyChannel)
    turtle.down()
  end,
  turnLeft = function()
    turtle.turnLeft()
  end,
  turnRight = function()
    turtle.turnRight()
  end
}

local cmds = {
  refuel = function()
    for i = 1, 16, 1 do
      turtle.select(i)
      turtle.refuel()
    end
    turtle.select(1)
  end
}

function Main()
  modem.open(commandsChannel)
  modem.open(shipSyncChannel)

  print("Listening for commands...")

  repeat
    local event = {
      os.pullEvent("modem_message")
    }

    print("Received a command: '" .. tostring(event.message))

    local args = split(event.message, " ")
    args._event = event

    if not cmds[args[1]] then
      print("Command not found")
      goto continue
    end

    local success, result = false, nil
    if (event.channel == commandsChannel) then
      success, result = pcall(cmds[args[1]], args)
    elseif (event.channel == shipSyncChannel) then
      success, result = pcall(syncCalls[args[1]], args)
    end

    if not success then
      print("Error: " .. tostring(result))
    end

    ::continue::
  until ship.status == -1
  print("Stop message received")
end
Main()
