if (not turtle) then
  error("Requires a turtle to run")
end
local modem = peripheral.find("modem") or error("Requires a modem to run")

-- Configs

local _debug = false;
local listeningChannel = 23;
local mineDirection = "forward";
local throwDirection = "down";

-- Vars

settings.define("isActive", {
  description = "Determina si el bot estaba funcionando o no",
  type = "boolean",
  default = true
})
settings.define("totalMined", {
  description = "Cantidad total de bloques minada",
  type = "number",
  default = 0
})

-- Functions

local function miningLoop()
  local everyXUpdates = 0;

  while true do

    if (settings.get("isActive")) then
      local success = false

      if (mineDirection == "forward") then
        success = turtle.dig()
      elseif (mineDirection == "up") then
        success = turtle.digUp()
      elseif (mineDirection == "down") then
        success = turtle.digDown()
      end

      if (success) then
        settings.set("totalMined", settings.get("totalMined") + 1)
        everyXUpdates = everyXUpdates + 1

        if (throwDirection == "forward") then
          turtle.drop()
        elseif (throwDirection == "up") then
          turtle.dropUp()
        elseif (throwDirection == "down") then
          turtle.dropDown()
        end

        if (everyXUpdates >= 10) then
          Flex()
          settings.save("justMine.cfg")
          everyXUpdates = 0
        end
      end
    end

    sleep(1)
  end
end

local function messageSwitch()
  local event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")

  if (channel == listeningChannel) then
    if (message:match("on." .. os.getComputerID()) or message:match("on.all")) then
      settings.set("isActive", true)

      modem.transmit(replyChannel, listeningChannel, "Bot online")

    elseif (message:match("off." .. os.getComputerID()) or message:match("off.all")) then
      settings.set("isActive", false)

      modem.transmit(replyChannel, listeningChannel, "Bot offline")

    elseif (message:match("status." .. os.getComputerID()) or message:match("status.all")) then
      modem.transmit(replyChannel, listeningChannel, "Bot " .. (settings.get("isActive") and "activo" or "inactivo") ..
          " y " .. settings.get("totalMined") .. "bl. minados")
    end
    Flex()
    settings.save("justMine.cfg")
  end

end

-- Main

function Flex()
  term.clear()

  local lines = {
    "",
    " ---- JustMine Bot ---- ",
    "",
    " Mi ID es #" .. os.getComputerID(),
    "",
    " Estado: " .. (settings.get("isActive") and "activo" or "inactivo"),
    " Escuchando el canal: " .. listeningChannel,
    "",
    " Total minado: " .. settings.get("totalMined") .. " bloques",
    ""
  }

  for i = 1, #lines, 1 do
    term.setCursorPos(1, i);
    term.write(lines[i]);
  end
end

function Main()
  settings.load("justMine.cfg")
  settings.set("isActive", settings.get("isActive"))
  settings.set("totalMined", settings.get("totalMined"))
  settings.save("justMine.cfg")

  modem.open(listeningChannel)
  local debug_loops = 0;

  Flex()

  while true do
    if not settings.get("isActive") then
      messageSwitch()
    else
      parallel.waitForAny(miningLoop, messageSwitch)
    end

    debug_loops = debug_loops + 1
    Flex()
    if (_debug) then
      print("loop " .. debug_loops)
    end
  end
end
Main();
