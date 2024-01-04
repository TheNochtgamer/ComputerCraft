local modem = peripheral.find("modem") or error("No modem attached", 0)
local _configFile = "send_conf.cfg"

settings.define("modem_channel", {
    description = "The channel to listen on",
    type = "number",
    default = -1,
})

settings.define("modem_reply_channel", {
    description = "The channel to reply on",
    type = "number",
    default = -1,
})

settings.define("send_delay", {
    description = "The delay to send a message",
    type = "number",
    default = 0,
})

settings.define("response_timeout", {
    description = "The timeout to wait for a response",
    type = "number",
    default = 5,
})

settings.define("wait_for_response", {
    description = "Wait for a response",
    type = "boolean",
    default = true,
})

settings.load(_configFile)

if arg[1] == "config" then
    if arg[2] == "channel" then
        if arg[3] == nil then
            print("Channel: " .. tostring(settings.get("modem_channel")) .. " | " .. settings.getDetails("modem_channel"))
            print("Reply Channel: " ..
                tostring(settings.get("modem_reply_channel")) .. " | " .. settings.getDetails("modem_reply_channel"))
            return
        end

        if arg[4] == nil then
            print("send config channel <channel> <reply channel>")
            return
        end

        settings.set("modem_channel", tonumber(arg[3]))
        settings.set("modem_reply_channel", tonumber(arg[4]))
    elseif arg[2] == "delay" then
        if arg[3] == nil then
            print("Delay: " ..
                tostring(settings.get("send_delay")) .. " | " .. settings.getDetails("send_delay"))
            return
        end

        settings.set("send_delay", tonumber(arg[3]))
    elseif arg[2] == "timeout" then
        if arg[3] == nil then
            print("Timeout: " ..
                tostring(settings.get("response_timeout")) .. " | " .. settings.getDetails("response_timeout"))
            return
        end

        settings.set("response_timeout", tonumber(arg[3]))
    elseif arg[2] == "waitResponse" then
        if arg[3] == nil then
            print("Wait for response: " ..
                tostring(settings.get("wait_for_response")) .. " | " .. settings.getDetails("wait_for_response"))
            return
        end

        settings.set("wait_for_response", arg[3] == "true")
    else
        print("send config <channel|delay|timeout|waitResponse>")
        return
    end


    settings.save(_configFile)
    return
end

local function listenTo()
    local response = false

    local function do_sleep() sleep(settings.get("response_timeout")) end

    local function onMessage()
        local event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")

        response = true

        print("Received a reply: '" ..
            tostring(message) ..
            "' at distance of " .. tostring(math.floor(distance * 100) / 100) .. " blocks")
    end

    parallel.waitForAny(onMessage, do_sleep)

    if not response then
        print("Timed out - No response")
    end
end

if settings.get("modem_channel") < 0 or settings.get("modem_reply_channel") < 0 then
    print("Please set the modem channel")
    print("send config channel <channel> <reply channel>")
    return
end

sleep(settings.get("send_delay"))
modem.transmit(settings.get("modem_channel"), settings.get("modem_reply_channel"), table.concat(arg, " "))
print("Sent " .. #table.concat(arg, "") .. " bytes")

modem.open(settings.get("modem_reply_channel"))
if settings.get("wait_for_response") and settings.get("response_timeout") > 0 then
    listenTo()
end
