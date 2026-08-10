-- kick.lua
-- kicks a user

local permissions = require("../permissions")
local notify = require("../notify")

return {
    name = "kick",
    description = "Kicks a user from the server (mod only)",
    execute = function(message, args, commands, client)
        if not permissions.isModOrOwner(message) then
            message.channel:send("Bro you don't have permission to do that.")
            return
        end

        local target = message.mentionedUsers.first
        if not target then
            message.channel:send("Usage: `!kick @user [reason]`")
            return
        end

        local member = message.guild:getMember(target.id)
        if not member then
            message.channel:send("Couldn't find that member in this server.")
            return
        end

        table.remove(args, 1) -- remove mention
        local reason = table.concat(args, " ")
        if reason == "" then reason = "No reason given" end

        local username = target.username -- grab this before kicking, since target becomes unreachable after
        local dmSent = notify.dm(target, "kick", reason, {guildName = message.guild.name})

        local ok, err = member:kick(reason)
        if ok then
            message.channel:send(username .. " has been kicked. Reason: " .. reason)
            if not dmSent then
                message.channel:send("(couldn't DM them — they may have DMs disabled)")
            end
        else
            message.channel:send("Failed to kick: " .. tostring(err))
        end
    end
}
