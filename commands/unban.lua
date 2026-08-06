-- unban.lua
-- unbans a user from the server

local permissions = require("../permissions")

return {
    name = "unban",
    description = "Unbans a user by ID (admin only)",
    execute = function(message, args, commands, client)
        if not permissions.isAdminOrOwner(message) then
            message.channel:send("Bro you don't have permission to do that.")
            return
        end

        local userId = args[1]
        if not userId then
            message.channel:send("Usage: `!unban <user id>`")
            return
        end

        local ban, err = message.guild:getBan(userId)
        if not ban then
            message.channel:send("That user isn't banned.")
            return
        end

        local ok, unbanErr = message.guild:unbanUser(userId, "Unbanned by " .. message.author.username)
        if ok then
            message.channel:send("Unbanned " .. ban.user.username .. ".")
        else
            message.channel:send("Failed to unban: " .. tostring(unbanErr))
        end
    end
}
