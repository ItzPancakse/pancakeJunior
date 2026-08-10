-- ban.lua
-- bans a user

local permissions = require("../permissions")
local env = require("../env")
local notify = require("../notify")

return {
    name = "ban",
    description = "Bans a user from the server (admin only)",
    execute = function(message, args, commands, client)
        if not permissions.isAdminOrOwner(message) then
            message.channel:send("Bro you don't have permission to do that.")
            return
        end

        local target = message.mentionedUsers.first
        if not target then
            message.channel:send("Usage: `!ban @user [reason]`")
            return
        end

        if target.id == message.author.id then
            message.channel:send("You can't ban yourself.")
            return
        end
        if target.id == client.user.id then
            message.channel:send("I can't ban myself.")
            return
        end

        local member = message.guild:getMember(target.id)
        if not member then
            message.channel:send("Couldn't find that member in this server.")
            return
        end

        table.remove(args, 1)
        local reason = table.concat(args, " ")
        if reason == "" then reason = "No reason given" end

        local username = target.username

        -- try to DM before banning, since it may fail after they're gone
        local dmSent = false
        local channel = target:getPrivateChannel()
        if channel then
            local dmMessage = "You have been banned from **" .. message.guild.name .. "**.\n" ..
                               "Reason: " .. reason .. "\n" ..
                               "If you believe this was a mistake, you can appeal here: " .. env.BAN_APPEAL_URL
            local ok = pcall(function() channel:send(dmMessage) end)
            dmSent = ok
        end

        local ok, err = member:ban(reason)
        if ok then
            local response = username .. " has been banned. Reason: " .. reason
            if not dmSent then
                response = response .. " (couldn't DM them — they may have DMs disabled)"
            end
            message.channel:send(response)
        else
            message.channel:send("Failed to ban: " .. tostring(err))
        end
    end
}
