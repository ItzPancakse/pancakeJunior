-- roast.lua
-- roasts whoever you point it at

local specificRoasts = {
    ["timsweeney"] = {
        "Tim please stop posting on X.",
    },
    ["gaben"] = {
        "No one shall roast Gabe Newell, the god of PC gaming. You are not worthy.",
        "Half-Life 3 will release before anyone successfully roasts Gaben.",
    },
}

local genericRoasts = {
    "has the confidence of a founder and the debugging skills of a rubber duck.",
    "ships more bugs than features and calls it 'iterative design.'",
    "reads documentation like it's optional. It is not optional.",
    "has never once closed a pull request without at least three merge conflicts.",
    "thinks 'it works on my machine' is a valid deployment strategy.",
    "has a GitHub contribution graph that looks like Morse code for 'help.'",
    "still hasn't figured out that `git push --force` is not a personality trait.",
    "has more open tabs than open-source contributions.",
    "treats every code review like a personal attack, and every personal attack like a code review.",
    "has the energy of someone who just discovered `sudo` and won't shut up about it.",
}

math.randomseed(os.time())

return {
    name = "roast",
    description = "Roasts a mentioned user or any name you type",
    execute = function(message, args)
    local target = message.mentionedUsers.first
    local name
    local lookupKey

    if target then
        name = target.mentionString
        lookupKey = target.username:lower()
    elseif args[1] then
        name = args[1]
        lookupKey = args[1]:lower()
    else
        name = message.author.mentionString
        lookupKey = message.author.username:lower()
    end

    local specificPool = specificRoasts[lookupKey]
    if specificPool then
        local pick = specificPool[math.random(#specificPool)]
        message.channel:send(pick) -- full sentence, no name prefix
    else
        local pick = genericRoasts[math.random(#genericRoasts)]
        message.channel:send(name .. " " .. pick) -- fragment, needs name prefix
    end
end
}
