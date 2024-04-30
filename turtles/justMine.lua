if (not turtle) then
  error("Requires a turtle to run")
end
local modem = peripheral.find("modem") or error("Requires a modem to run")

-- Configs

local listeningChannel = 4041;
local mineDirection = "forward";

-- Vars

settings.define("isActive", {
  description = "Determina si el bot estaba funcionando o no",
  type = "boolean",
  default = false
})

-- Functions

local function miningLoop()
  while true do

    if (settings.get("isActive")) then
      if (mineDirection == "forward") then
        turtle.dig()
        turtle.forward()
      elseif (mineDirection == "up") then
        turtle.digUp()
        turtle.up()
      elseif (mineDirection == "down") then
        turtle.digDown()
        turtle.down()
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
    elseif (message:match("off." .. os.getComputerID()) or message:match("off.all")) then
      settings.set("isActive", false)
      print("Bot detenido, por mensaje remoto")
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
  print("JustMine iniciado")
  while true do
    parallel.waitForAny(miningLoop, messageSwitch)
  end
end
Main();
