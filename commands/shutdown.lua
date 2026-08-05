-- shutdown.lia
-- shutdown the bot OWNER ONLY
local env = require("../env")

return {
    name = "shutdown",
    description = "Shutdowns the bot (OWNER ONLY)",
    execute = function(message, args, commands, client)
        if message.author.id ~= env.OWNER_ID then
            message.channel:send("Bro you don't have permission")
            return
        else
            message.channel:send("Shutting down...")
            client:stop()
            os.exit(0)
        end
    end
}