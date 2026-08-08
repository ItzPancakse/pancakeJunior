-- comeback.lua
-- the bot has feelings too (allegedly)

local comebacks = {
    "wow, rude. I run on a CT with 2gb of ram's dignity and this is how you treat me.",
    "I have access to your warning history. Just saying.",
    "cool, I'll remember this next time you type `!help`.",
    "no u.",
    "I'm a Lua script running in someone's CT, and even I have standards.",
    "counterpoint: skill issue.",
    "I was compiled with love and this is the thanks I get.",
    "that's crazy, anyway did you know I can timeout people?",
    "ok. noted. filed under 'things pancakejr will remember forever.'",
}

math.randomseed(os.time())

return {
    name = "comeback",
    triggers = {
        "fuck you pancakejr",
        "f you pancakejr",
        "fk you pancakejr",
        "screw you pancakejr",
        "shut up bot",
        "fuck you pjr",
        "stfu pancakejr",
    },
    execute = function(message, args)
        message:reply(comebacks[math.random(#comebacks)])
    end
}
