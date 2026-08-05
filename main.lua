-- main.lua
-- its literally the main file
-- run luvit main.lua to run the bot

local env = require("./env")
local discordia = require("discordia")

local CLIENT = discordia.Client()

if env.DISCORD_TOKEN == "your_token_here" then
    print("Change your bot token in .env")
else
    CLIENT:run("Bot " .. env.DISCORD_TOKEN)
end
