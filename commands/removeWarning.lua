-- removeWarning.lua
-- removes warnings

local warnings = require("../warnings")
local permissions = require("../permissions")

return {
    name = "removewarning",
    description = "Removes a specific warning from a user by number (mod only)",
    execute = function(message, args, commands, client)
        if not permissions.isModOrOwner(message) then
            message.channel:send("Bro you don't have permission to do that.")
            return
        end

        local target = message.mentionedUsers.first
        if not target then
            message.channel:send("Usage: `!removewarning @user <warning number>`")
            return
        end

        local index = tonumber(args[2])
        if not index then
            message.channel:send("Usage: `!removewarning @user <warning number>`")
            return
        end

        local ok = warnings.removeWarning(message.guild.id, target.id, index)
        if ok then
            message.channel:send("Removed warning #" .. index .. " from " .. target.username)
        else
            message.channel:send("Couldn't find warning #" .. index .. " for " .. target.username)
        end
    end
}
