-- dontasktoask.lua
-- Dont ask to ask

return {
    name = "dontasktoask",
    description = "Don't ask to ask!",
    triggers = { 
        "^can i ask",
        "^anyone here",
        "^is anyone here",
        "^does anyone know",
        "^how do i",
        "^how do you",
        "^can someone help",
        "^anyone know how",
    },
    execute = function(message, args)
        message.channel:send("https://dontasktoask.com/")
    end
}