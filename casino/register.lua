local drive = peripheral.find('drive') or error('No disk drive found', 0);
local modem = peripheral.find('modem') or error('No modem found', 0);

rednet.open(peripheral.getName(modem));
math.randomseed(os.time());

-- shell.openTab('casino/register.lua')

-- Config

local driveLabel = "§r§4/user/§f's §bCasino §bDisk";

-- /Config

local usageTxt = {
  "register <playerName> <somePassCode>",
  "register format"
};

local function generateUUID()
  local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
  return string.gsub(template, '[xy]', function(c)
    local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
    return string.format('%x', v)
  end)
end

if type(arg[1]) ~= "string" then
  print("Usage: " .. usageTxt[1]);
  for i = 2, #usageTxt do
    print("       " .. usageTxt[i]);
  end
  return;
end

if (drive.isDiskPresent() == false) then
  error("No disk found", 0)
end

local function init()
  if (arg[1] == "format") then
    shell.run("rm", drive.getMountPath() .. "/*");
    drive.setDiskLabel(nil);
    print("Formatted disk.");
    sleep(1);
    drive.ejectDisk();
    return;
  end
  if (type(arg[2]) ~= "string") then
    print("Usage: " .. usageTxt[1]);
    for i = 2, #usageTxt do
      print("       " .. usageTxt[i]);
    end
    return;
  end

  local playerName = arg[1];
  local passCode = arg[2];
  local uuid = generateUUID();

  -- local file = fs.open(driveLabel .. "/register", "w");
  -- file.writeLine(playerName);
  -- file.writeLine(passCode);
  -- file.writeLine(uuid);
  -- file.close();

  settings.define("walletData", {
    description = "Los datos del casino",
    type = "table",
    default = {}
  })
  settings.set("walletData", {
    playerName = playerName,
    passCode = passCode,
    account_id = uuid
  })

  settings.save(fs.combine(drive.getMountPath(), ".meta.db"));
  fs.open(fs.combine(drive.getMountPath(), "TheNocht_was_here"), "w").close();

  local newLabel = driveLabel:gsub("/user/", playerName):gsub("/uuid/", uuid):gsub("/id/", drive.getDiskID()):gsub(
      "/cid/", os.getComputerID());
  drive.setDiskLabel(newLabel);

  print("Registered " .. playerName .. " [" .. uuid .. "] on the system.");

  sleep(1);
  drive.ejectDisk();
end
init();
