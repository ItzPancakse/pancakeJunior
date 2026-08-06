-- clearWarnings.lua
-- clears all warnings for a user

local warnings = require("../warnings")
local permissions = require("../permissions")

return {
    name = "clearwarnings",
    description = "Clears all warnings for a user (mod only)",
    execute = function(message, args, commands, client)
        if not permissions.isModOrOwner(message) then
            message.channel:send("Bro you don't have permission to do that.")
            return
        end

        local target = message.mentionedUsers.first
        if not target then
            message.channel:send("Usage: `!clearwarnings @user`")
            return
        end

        local cleared = warnings.clearWarnings(message.guild.id, target.id)
        if cleared > 0 then
            message.channel:send("Cleared " .. cleared .. " warning(s) for " .. target.username .. ".")
        else
            message.channel:send("Bro " .. target.username .. " had no warnings to clear.")
        end
    end
}
