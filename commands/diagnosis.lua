-- diagnosis.lua
-- as people say dont trust Doctor Google so why would you trust pancake junior
-- totally real accreddited medical diagnosis
-- Source: Dr. Pancakse

local diagnoses = {
    "Chronic Mondayitis. Prognosis: will persist until Friday.",
    "Acute RAM Hoarder Syndrome. 47 browser tabs opened, none of them needed.",
    "Terminal case of Doomscrolling. Prognosis: will persist until you put down your phone.",
    "Terminal case of `I'll fix this later.` Its been 3 months.",
    "Advance Keyboard Warrior Disorder. Symptoms include typing at 140wpm",
    "Servere Caffeine Difciency. Immediate coffee (or tea) intervention required.",
    "Early onset of Procrastinitis. Complicated by Doomscrolling or a secondary Netflix infection.",
    "Diagnosed with a servere case of `I use arch btw`. Prognosis: will persist until you switch to a more user friendly Linux distro.",
    "Stage 4 Ihatewindowsitis. Prognosis: will persist until you switch to Linux.",
    "Diagnosed with Terminal uniqueness. There is no cure",
    "Presenting with symptoms of Compulsive Lurking Disorder. Always online never chatting.",
    "Confirmed case of Chronic `It works on my machine` Syndrome.",
    "Diagnosed with Rare Main Character Energy, in remission since last Tuesday.",
}

math.randomseed(os.time())

return {
    name = "diagnosis",
    description = "Delivers a totally accurate medical diagnosis.",
    execute = function(message, args)
        local target = message.mentionedUsers.first or message.author
        local pick = diagnoses[math.random(#diagnoses)]
        message.channel:send("**Diagnosis** for" .. target.mentionString .. ": **" .. pick .. "**")
        
    end
}