-- warn.lua
-- warns a user

local warnings = require("../warnings")
local permissions = require("../permissions")
local punishments = require("../punishments")
local notify = require("../notify")

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

        local dmSent = notify.dm(target, "warning", reason, {guildName = message.guild.name})
        local response = target.username .. " has been warned. Reason: " .. reason
        if not dmSent then
            response = response .. " (couldn't DM them — they may have DMs disabled) "
        end
        message.channel:send(response)

        local member = message.guild:getMember(target.id)
        if member then
            local result = punishments.checkAndApply(message.guild, member, target, reason)
            if result then
                message.channel:send(result)
            end
        end
    end
}
