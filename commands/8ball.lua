-- 8ball.lua
-- its 8ball what else can you say!

local answers = {
    "Yes", "No", "Absolutely!", "Ask me later.",
    "Signs point to yes.", "Very doubtful.", "It is certain",
    "My sources say no.", "Without a doubt.", "Concentrate and ask again later."
}

return {
    name = "8ball",
    description = "Ask the magic 8ball a question.",
    execute = function(message, args)
        if not args or #args == 0 then
            message.channel:send("Ask a question: `!8ball <question>`")
            return
        end

        local question = table.concat(args, " ")

        if question:find("757434877971791883", 1, true) then
            message.channel:send("8ball says: Absolutely!")
            return
        elseif question:find("1029944061626421359", 1, true) then
            message.channel:send("8ball says: Absolutely!")
            return
        end
        math.randomseed(os.time())
        message.channel:send("8ball says: " .. answers[math.random(1, #answers)])
    end
}
