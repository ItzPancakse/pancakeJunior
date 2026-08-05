-- tryitandsee.lua
-- Try and see!

return {
    name = "tryitandsee",
    description = "Try it and see!",
    execute = function(message, args)
        message.channel:send("https://www.youtube.com/watch?v=cdVPFcd6ByM")
    end
}