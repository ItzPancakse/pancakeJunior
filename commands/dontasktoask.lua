-- dontasktoask.lua
-- Dont ask to ask

return {
    name = "dontasktoask",
    description = "Don't ask to ask!",
    execute = function(message, args)
        message.channel:send("https://dontasktoask.com/")
    end
}