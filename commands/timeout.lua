-- timeout.lua
-- timeout a user 

local permissions = require("../permissions")
local notify = require("../notify")

return {
    name = "timeout",
    description = "Times out a user for a number of minutes (mod only)",
    execute = function(message, args, commands, client)
        if not permissions.isModOrOwner(message) then
            message.channel:send("Bro you don't have permission to do that.")
            return
        end

        local target = message.mentionedUsers.first
        if not target then
            message.channel:send("Usage: `!timeout @user <minutes> [reason]`")
            return
        end

        local minutes = tonumber(args[2])
        if not minutes or minutes <= 0 then
            message.channel:send("Usage: `!timeout @user <minutes> [reason]`")
            return
        end

        if minutes > 40320 then -- 28 days in minutes
            message.channel:send("Discord's max timeout is 28 days (40320 minutes).")
            return
        end

        table.remove(args, 1) -- remove mention
        table.remove(args, 1) -- remove minutes
        local reason = table.concat(args, " ")
        if reason == "" then reason = "No reason given" end

        local member = message.guild:getMember(target.id)
        if not member then
            message.channel:send("Couldn't find that member in this server.")
            return
        end

        local ok, err = member:timeoutFor(minutes * 60) -- expects seconds
        if ok then
            notify.dm(target, "timeout", reason, {guildName = message.guild.name, duration = minutes})
            message.channel:send(target.username .. " has been timed out for " .. minutes .. " minute(s). Reason: " .. reason)
        else
            message.channel:send("Failed to timeout: " .. tostring(err))
        end
    end
}
