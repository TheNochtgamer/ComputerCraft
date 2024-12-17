if (not pocket) then
  error("This script is meant to be used on a pocket device")
end
local modem = peripheral.find("modem") or error("No modem attached", 0)

-- Configs

local commandsChannel = 4;
local shipSyncChannel = 109;
local shipRecieveChannel = 110;

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

-- Main

function WaitForInput()
  local input = read()

  local args = split(input, " ")

end

function ShipHead()

end

function Main()
  modem.open(shipRecieveChannel)

  while true do
    parallel.waitForAny(WaitForInput, ShipHead)
  end
end
Main()
