-- Configs
local sculkSide_In = "left" -- El lado en donde se programa el sculk calibrado
local sculkPower_In = 15 -- La potencia para el sculk calibrado
local sculkSide_Out = "bottom" -- El lado en donde se recibe la señal del sculk calibrado
local resultSide = "right" -- El lado resultante del sculk calibrado

-- Main

function Main()
    redstone.setAnalogOutput(sculkSide_In, sculkPower_In)
    while true do
        os.pullEvent("redstone")
        if redstone.getInput(sculkSide_Out) then
            redstone.setAnalogOutput(resultSide, 15)
            sleep(0.5)
            redstone.setAnalogOutput(resultSide, 0)
        end
    end
end
Main()
