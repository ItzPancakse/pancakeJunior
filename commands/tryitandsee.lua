-- tryitandsee.lua
-- Try and see!

return {
    name = "tryitandsee",
    description = "Try it and see!",
    triggers = { 
        "^will this work",
        "^does this work",
        "^is this going to work",
        "^do you think this will work",
        "^is this going to be okay",
        "^is this going to be alright",
        "^is this going to be fine",
        "^is this going to be good",
        "^is this going to be acceptable",
        "^is this going to be suitable",
    },
    execute = function(message, args)
        message.channel:send("https://geo.thei.rs/public/tias.mp4")
    end
}