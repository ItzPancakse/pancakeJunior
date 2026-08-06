-- warnList.lua
-- lets you see warnings

local warnings = require("../warnings")
local permissions = require("../permissions")

return {
    name = "warnlist",
    description = "Shows your own warnings, or another user's if you're a mod",
    execute = function(message, args, commands, client)
        local target = message.mentionedUsers.first

        if target and target.id ~= message.author.id then
            if not permissions.isModOrOwner(message) then
                message.channel:send("Bro you don't have permission to view other users' warnings.")
                return
            end
        end

        target = target or message.author

        local userWarnings = warnings.getWarnings(message.guild.id, target.id)
        if #userWarnings == 0 then
            message.channel:send(target.username .. " has no warnings.")
            return
        end

        local lines = {"**Warnings for " .. target.username .. "**"}
        for i, w in ipairs(userWarnings) do
            table.insert(lines, "#" .. w.id .. ": " .. w.reason .. " (by <@" .. w.moderator .. ">)")
        end
        message.channel:send(table.concat(lines, "\n"))
    end
}
