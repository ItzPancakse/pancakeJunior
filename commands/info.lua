-- info.lua
-- bot info

local version = require("../version")
local discordia = require("discordia")
local luvi = require("luvi")

return {
    name = "info",
    description = "PancakeJr info",
    execute = function(message, args, command, client)
        local lines = {
            "**pancakeJr Info**",
            "Bot name: `" .. client.user.username .. "`",
            "Bot Version: `" .. version.version .. "`",
            "Discordia version: `" .. discordia.package.version .. "`",
            "Lua version: `" .. _VERSION .. "`",
            "Luvi version: `" .. luvi.version .. "`",
            "pancakeJr is open source! Check it out: <https://github.com/ItzPancakse/pancakeJunior>"
        }
        message.channel:send(table.concat(lines, "\n"))
    end
}