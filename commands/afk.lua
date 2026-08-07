-- afk.lua
-- its the command lol

local afk = require("../afk")

return {
    name = "afk",
    description = "Sets your AFK status with an optional reason.",
    execute = function(message, args)
        local reason = table.concat(args, " ")
        if reason == "" then reason = "AFK" end

        afk.setAfk(message.author.id, reason)
        message.channel:send("Bro, " .. message.author.username .. " is now AFK: " .. reason)
    end
}