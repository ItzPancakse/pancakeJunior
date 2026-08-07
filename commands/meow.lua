-- meow.lua
-- mrrp mrrp meow

return {
    name = "meow",
    description = "Mrrp mrrp meow",
    triggers = { 
        "^meoww", -- mrrp mrrp meow
    },
    execute = function(message, args)
        message.channel:send("meowwwwwwwwww mrrp mrrp meowww")
    end
}
