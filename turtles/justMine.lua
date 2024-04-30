if (not turtle) then
  error("Requires a turtle to run")
end
local modem = peripheral.find("modem") or error("Requires a modem to run")

-- Configs

local _debug = false
local listeningChannel = 23;
local mineDirection = "forward";

-- Vars

settings.define("isActive", {
  description = "Determina si el bot estaba funcionando o no",
  type = "boolean",
  default = true
})

-- Functions

local function miningLoop()
  while true do

    if (settings.get("isActive")) then
      if (mineDirection == "forward") then
        turtle.dig()
      elseif (mineDirection == "up") then
        turtle.digUp()
      elseif (mineDirection == "down") then
        turtle.digDown()
      end
    end
  end
end

local function messageSwitch()
  local event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")

  if (channel == listeningChannel) then
    if (message:match("on." .. os.getComputerID()) or message:match("on.all")) then
      settings.set("isActive", true)
      print("Bot iniciado, por mensaje remoto")

      modem.send(replyChannel, listeningChannel, "Bot online")
    elseif (message:match("off." .. os.getComputerID()) or message:match("off.all")) then
      settings.set("isActive", false)
      print("Bot detenido, por mensaje remoto")

      modem.send(replyChannel, listeningChannel, "Bot offline")
    end
    settings.save("justMine.cfg")
  end

end

-- Main
function Main()
  settings.load("justMine.cfg")
  settings.set("isActive", settings.get("isActive"))
  settings.save("justMine.cfg")
  modem.open(listeningChannel)

  term.clear()
  term.setCursorPos(1, 1)

  print("JustMine iniciado")
  print("Escuchando en canal " .. listeningChannel)
  print("Estado: " .. (settings.get("isActive") and "activo" or "inactivo"))
  print("")

  local debug_loops = 0;
  while true do
    parallel.waitForAny(miningLoop, messageSwitch)

    debug_loops = debug_loops + 1
    if (_debug) then
      print("loop " .. debug_loops)
    end
  end
end
Main();
