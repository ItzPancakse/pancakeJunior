-- warn.lua
-- warns a user

local warnings = require("../warnings")
local permissions = require("../permissions")
local punishments = require("../punishments")

return {
    name = "warn",
    description = "Warns a user (mod only)",
    execute = function(message, args, commands, client)
        if not permissions.isModOrOwner(message) then
            message.channel:send("Bro you don't have permission to do that.")
            return
        end

        local target = message.mentionedUsers.first
        if not target then
            message.channel:send("Mention a user to warn: `!warn @user reason`")
            return
        end

        table.remove(args, 1)
        local reason = table.concat(args, " ")
        if reason == "" then reason = "No reason given" end

        warnings.addWarning(message.guild.id, target.id, reason, message.author.id)
        message.channel:send(target.username .. " has been warned: " .. reason)

        local member = message.guild:getMember(target.id)
        if member then
            local result = punishments.checkAndApply(message.guild, member, target, reason)
            if result then
                message.channel:send(result)
            end
        end
    end
}
