local modem = peripheral.find("modem") or error("No modem attached", 0)
rednet.open(peripheral.getName(modem))

-- Config

local conf = {
    -- The maximum number of messages to display
    maxMessages = 9
}

-- Vars

local networkHostname = (
    "%s.%s"
):format((function()
    local deviceType = "Computer"
    if turtle then
        deviceType = "Turtle"
    elseif pocket then
        deviceType = "Pocket"
    end
    return deviceType .. "Os"
end)(), tostring(os.getComputerID())
)
local networkMessages = {}
local currentMessage = ""

-- Utils

local function formatMessage(id, message)
    if id == os.getComputerID() then
        return ("[You] %s"):format(message)
    end
    return ("<%d> %s"):format(id, message)
end

local function getLastMessages(max)
    local returnMessages = {}
    for i = #networkMessages, math.max(#networkMessages - max, 1), -1 do
        table.insert(returnMessages, networkMessages[i])
    end
    return returnMessages
end

-- Main Functions

function UpdateFlex()
    local lastMessages = {}
    term.clear()
    term.setCursorPos(1, 1)

    lastMessages = getLastMessages(conf.maxMessages)

    print("Chat - " .. networkHostname)
    print("----")
    print("Press enter to send a message")
    print("Press tab to quit")
    print("----")
    print()

    if #lastMessages > 0 then
        for i = #lastMessages, 1, -1 do
            print(lastMessages[i])
        end
        print()
    end

    if #currentMessage > 0 then
        print(">" .. currentMessage)
    end
end

function RecieveCommand()

end

function Recieve()
    while true do
        local id, message = rednet.receive("chat")
        -- print(("<%d> %s"):format(id, message))
        table.insert(networkMessages, formatMessage(id, message))
        UpdateFlex()
    end
end

function Main()
    local char = ""
    rednet.host("chat", networkHostname)
    rednet.host("chat/commad", networkHostname)

    local function waitForEspecial()
        while true do
            local event, key = os.pullEvent("key")
            if key == 257 then
                char = "enter"
                break
            elseif key == 259 then
                char = "backspace"
                break
            elseif key == 258 then
                char = "tab"
                break
            end
        end
    end

    local function waitForChar()
        local event, newChar = os.pullEvent("char")
        char = newChar
    end

    while true do
        while true do
            UpdateFlex()
            parallel.waitForAny(waitForEspecial, waitForChar)

            if char == "tab" then
                break
            elseif char == "enter" then
                break
            elseif char == "backspace" then
                currentMessage = currentMessage:sub(1, -2)
            else
                currentMessage = currentMessage .. char
            end
        end

        if char == "tab" then
            print("Goodbye!")
            break
        elseif char == "enter" and #currentMessage > 0 then
            rednet.broadcast(currentMessage, "chat")
            table.insert(networkMessages, formatMessage(os.getComputerID(), currentMessage))
            currentMessage = ""
            char = ""

            UpdateFlex()
        end
    end

    rednet.unhost("chat")
    rednet.unhost("chat/commad")
end

-- Execution

parallel.waitForAny(Recieve, Main)
