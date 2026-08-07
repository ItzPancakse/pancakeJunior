-- excuse.lua
-- generates increasingly unhinged excuses
-- now i have a excuse for being afk

local excuses = {
    "I was being chased by a raccoon with a personal vendetta.",
    "My WiFi got into an argument with my router and they haven't spoken since.",
    "I accidentally ran `sudo rm -rf /` on my own machine and had to reinstall everything from scratch.",
    "A squirrel unplugged my ethernet cable and looked me dead in the eyes while doing it.",
    "I was legally obligated to stare at a wall for 20 minutes, don't ask.",
    "My cat sat on the power button. She has no regrets.",
    "I opened Task Manager and it opened Task Manager and it opened Task Manager and—",
    "Time moves differently in my house, it's a whole thing.",
    "I was recompiling my entire life and forgot to `make install`.",
    "I got distracted watching my code compile. It's mesmerizing.",
    "My computer chose violence today and I had to negotiate with it.",
    "Windows forced a update on me.",
}

math.randomseed(os.time())

return {
    name = "excuse",
    description = "Generates a random unhinged excuse",
    execute = function(message, args)
        local pick = excuses[math.random(#excuses)]
        message.channel:send(message.author.mentionString .. "'s official excuse: " .. pick)
    end
}
