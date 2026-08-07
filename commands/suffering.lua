-- suffering.lua
-- you are now suffering
-- reference to my game

local responses = {
    "You are now suffering.",
    "The suffering has begun. There is no escape.",
    "Congratulations, you have unlocked: SUFFERING.",
    "Suffering levels critical. Please remain calm.",
    "You didn't ask for this, but you're suffering now.",
    "SUFFERING intensifies.",
    "This is fine. You are suffering. This is fine.",
    "Somewhere, a developer nods knowingly. You suffer.",
    "Achievement unlocked: Endured Suffering (1/???)",
    "The bot has deemed you worthy of suffering."
}

math.randomseed(os.time())

return {
    name = "suffering",
    description = "Inflicts suffering upon yourself",
    execute = function(message, args)
        local name = message.author.username
        if math.random(1, 20) == 1 then
            message.channel:send("💀 **MAXIMUM SUFFERING ACHIEVED** 💀 " .. name .. " has transcended into pure suffering.")
            return
        end

        local pick = responses[math.random(#responses)]

        message.channel:send(message.author.username .. ": " .. pick)

    end
}
