-- ping.lua
-- it replies pong
-- oui oui oui

return {
    name = "ping",
    description = "Replies with pong",
    execute = function(message, args)
        message.channel:send("Pong!")
    end
}