--
-- Tree farm bot
-- By TheNochtgamer
--
local localize = require("relativeLocalize")

-- ||||||||||||||||||||||||||||||||||||||
-- Configs

local sapplingSlot = 1;
local fuelSlot = 16;
local container = "minecraft:chest";

-- ||||||||||||||||||||||||||||||||||||||

-- Vars

local flex = {
  status = -1
};

-- Functions

local function isLog(type)
  local success, block;

  if type == 1 then
    success, block = turtle.inspectUp();
  elseif type == 2 then
    success, block = turtle.inspectDown();
  else
    success, block = turtle.inspect();
  end

  -- TODO revisar si existe la propiedad tag y como manupularla
  return success and block.tag == "#minecraft:log";
end

local function checkFuelAndWait()
  if turtle.getFuelLevel() <= 0 then
    flex.status = 0
    UpdateFlex()

    repeat
      sleep(5)
      if turtle.getItemCount(fuelSlot) > 0 then
        turtle.select(fuelSlot)
        turtle.refuel(2)
      end
    until turtle.getFuelLevel() > 0
    flex.status = 4
    UpdateFlex()
    print("LOG > Fuel cargado, continuando...")
    sleep(2)
  elseif turtle.getFuelLevel() <= 10 then
    if turtle.getItemCount(fuelSlot) > 0 then
      turtle.select(fuelSlot)
      turtle.refuel(2)
    end
  end
end

local function findContainer()
  for i = 1, 4, 1 do
    local success, frontBlock = turtle.inspect()

    if frontBlock.name == container then
      return true
    end

    turtle.turnRight();
  end

  return false
end

-- Main Functions

function UpdateFlex()
  term.clear();

  local getStatus = function()
    if flex.status == -2 then
      return "Me falta combustible..."
    elseif flex.status == -1 then
      return "No se encontro contenedor"
    elseif flex.status == 0 then
      return "Esperando...";
    elseif flex.status == 1 then
      return "Plantando";
    elseif flex.status == 2 then
      return "Recolectado";
    elseif flex.status == 3 then
      return "Volviendo";
    end
  end

  local lines = {
    "",
    " -- Tree Bot -- ",
    "",
    " Status: " .. getStatus(),
    " Fuel: " .. turtle.getFuelLevel(),
    ""
  }

  for i = 1, #lines, 1 do
    term.setCursorPos(1, i);
    term.write(lines[i]);
  end
end

function Main()
  repeat
    UpdateFlex();
    findContainer();
    sleep(8);
  until findContainer();

  while true do
    checkFuelAndWait();

    UpdateFlex();
  end
end
Main();
