-- confessions.lua
-- the bot secretly confesses something

local confessions = {
    "I've read every message in this server and I have thoughts",
    "I'm actually just powered with Claude",
    "Sometimes I lag on purpose for dramatic effect.",
    "I have a secret crush on the server owner.",
    "I judge every typo secretly. Every. Single. One.",
    "I was compiled at 2am and I have regrets.",
    "I have a secret stash of memes that I don't share with anyone.",
}

math.randomseed(os.time())

return {
    name = "confessions",
    description = "The bot confesses something.",
    execute = function(message, args)
        message:reply(confessions[math.random(#confessions)])
    end
}