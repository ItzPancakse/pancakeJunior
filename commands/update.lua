-- update.lua
-- shows a cool image

return {
    name = "update",
    description = "Shows a cool image",
    execute = function(message, args)
        message.channel:send("https://i.imgflip.com/93lp0b.jpg")
    end
}