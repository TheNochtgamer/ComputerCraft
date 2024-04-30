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
local timeout = 20;

-- ||||||||||||||||||||||||||||||||||||||

-- Vars

local flex = {
  status = -1,
  collected = 0
};

-- Functions

local function zSuck()
  turtle.suck()
  turtle.suckUp()
  turtle.suckDown()
end

local function isLog(direction)
  local x, block;

  if direction == 1 then
    x, block = turtle.inspectUp();
  elseif direction == 2 then
    x, block = turtle.inspectDown();
  else
    x, block = turtle.inspect();
  end

  if (type(block.tags) == "nil" or not block.tags["minecraft:logs"]) then
    return false;
  end

  return true;
end

local function checkFuelAndWait()
  if turtle.getFuelLevel() <= 0 then
    UpdateFlex(-2)

    repeat
      sleep(5)
      if turtle.getItemCount(fuelSlot) > 0 then
        turtle.select(fuelSlot)
        turtle.refuel(2)
      end
    until turtle.getFuelLevel() > 0
    UpdateFlex(0)
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

local function totalLoot()
  for i = 1, 16, 1 do
    if i == sapplingSlot then
      goto next
    elseif i == fuelSlot then
      goto next
    end

    flex.collected = flex.collected + turtle.getItemCount(i);
    ::next::
  end
end

local function saveLoot()
  for i = 1, 16, 1 do
    if i == sapplingSlot then
      goto next
    elseif i == fuelSlot then
      goto next
    end

    turtle.select(i);
    turtle.drop();
    ::next::
  end

  turtle.select(sapplingSlot);
end

-- Main Functions

function UpdateFlex(level)
  term.clear();

  if type(level) == "number" then
    flex.status = level
  end

  local getStatus = function()
    if flex.status == -2 then
      return "Me falta combustible..."
    elseif flex.status == -1 then
      return "No se encontro contenedor"
    elseif flex.status == 0 then
      return "Esperando...";
    elseif flex.status == 1 then
      return "Trabajando...";
    elseif flex.status == 2 then
      return "Recolectando";
    elseif flex.status == 3 then
      return "Volviendo";
    elseif flex.status == 99 then
      return "Volviendo al punto de partida..."
    end
  end

  local lines = {
    "",
    " ---- Tree Bot ---- ",
    "",
    " Status: " .. getStatus(),
    " Fuel: " .. turtle.getFuelLevel(),
    "",
    "",
    ""
  }

  if flex.collected > 0 then
    lines[7] = " Loot: " .. flex.collected;
  end

  for i = 1, #lines, 1 do
    term.setCursorPos(1, i);
    term.write(lines[i]);
  end
end

function Main()
  if not localize.isBackHome() then
    UpdateFlex(99);
    checkFuelAndWait();
  end
  localize.simpleGoBackHome();

  if not findContainer() then
    repeat
      UpdateFlex(-1);
      sleep(8);
    until findContainer();
  end
  UpdateFlex(0);

  while true do
    checkFuelAndWait();
    UpdateFlex(1);

    for i = 1, 4, 1 do
      zSuck();
      localize.turnRight();

      if isLog() then
        UpdateFlex(2);

        turtle.dig();
        localize.forward();

        repeat
          turtle.digUp();
          zSuck();

          checkFuelAndWait();
          localize.up();
          UpdateFlex();
        until not isLog(1);

        local desY = localize.relativeDisplacement.dy - 1;

        UpdateFlex(3);
        for i = 1, desY, 1 do
          checkFuelAndWait();
          localize.down();
        end

        zSuck();
        turtle.select(sapplingSlot);
        turtle.placeDown();

        checkFuelAndWait();
        localize.back();
        zSuck();
        checkFuelAndWait();
        localize.down();
        zSuck();

        totalLoot();
        UpdateFlex(1);
      end
    end

    if not findContainer() then
      repeat
        UpdateFlex(-1);
        sleep(8);
      until findContainer();
    end

    saveLoot();
    UpdateFlex(0);

    sleep(timeout)
  end
end
Main();
