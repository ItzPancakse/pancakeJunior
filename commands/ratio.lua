-- ratio.lua
-- ratio

local responses = {
    "ratio",
    "ratio + you fell off",
    "ratio + didn't ask",
    "ratio (and this is the final ratio, appeal is not available)",
    "L + ratio"
}

math.randomseed(os.time())

return {
    name = "ratio",
    execute = function(message, args)
        local pick = responses[math.random(#responses)]
        message:reply(pick)
    end
}
