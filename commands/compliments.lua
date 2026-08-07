-- compliment.lua
-- totally compliments totally

local compliments = {
    "you have the confidence of someone who's never read their own error logs.",
    "you're proof that even a broken clock is right twice a day.",
    "you light up a room the moment you leave it.",
    "you have such a unique way of doing things — mostly wrong, but unique.",
    "you're like a Monday morning: nobody's thrilled, but you keep showing up.",
    "you make bad decisions look so effortless.",
    "you're one in a million, statistically speaking, someone had to be the worst.",
    "your code compiles sometimes, and that's beautiful.",
    "you have the energy of someone who peaked in the tutorial level.",
    "you're not the reason the server's on fire, but you're definitely fanning it.",
    "you have great posture for someone carrying that much red flags.",
    "you're a 10/10, if the scale went to 100.",
}

math.randomseed(os.time())

return {
    name = "compliment",
    description = "Gives you a totally good compliment compliment",
    execute = function(message, args)
        local target = message.mentionedUsers.first or message.author
        local pick = compliments[math.random(#compliments)]
        message.channel:send(target.mentionString .. ", " .. pick)
    end
}
