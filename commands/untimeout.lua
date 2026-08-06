-- untimeout.lua
-- removes a timeout from a user

local permissions = require("../permissions")

return {
    name = "untimeout",
    description = "Removes an active timeout from a user (mod only)",
    execute = function(message, args, commands, client)
        if not permissions.isModOrOwner(message) then
            message.channel:send("Bro you don't have permission to do that.")
            return
        end

        local target = message.mentionedUsers.first
        if not target then
            message.channel:send("Usage: `!untimeout @user`")
            return
        end

        local member = message.guild:getMember(target.id)
        if not member then
            message.channel:send("Couldn't find that member in this server.")
            return
        end

        local ok, err = member:timeoutFor(0)
        if ok then
            message.channel:send("Removed timeout from " .. target.username .. ".")
        else
            message.channel:send("Failed to remove timeout: " .. tostring(err))
        end
    end
}
