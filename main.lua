-- main.lua
-- its literally the main file
-- run luvit main.lua to run the bot

local los = require("los")

if los.type() ~= "linux" then
    print("This bot requires binaries that are compiled for Linux.")
    if los.type() == "Windows" then
        print("You're on Windows — you can run this bot inside WSL (Windows Subsystem for Linux) instead.")
        print("See: https://learn.microsoft.com/en-us/windows/wsl/install")
        os.exit(1)
    end
    if los.type() == "OSX" then
        print("macOS isn't supported — you'd need to recompile LuaSQLite3 for macOS, or run this inside a Linux VM.")
        os.exit(1)
    end
    if los.type() == "BSD" then
        print("BSD isn't supported - you'd need to recompile LuaSQLite3 for BSD, or run this inside a Linux VM")
        os.exit(1)
    end
end

local env = require("./env")
local filesystem = require("fs")
local discordia = require("discordia")
local timer = require("timer")
local warnings = require("./warnings")
local logger = require("./logger")

local CLIENT = discordia.Client()
local PREFIX = env.PREFIX

if env.DISCORD_TOKEN == "your_token_here" then
    print("Please setup the bot in .env")
elseif env.OWNER_ID == "put_your_user_id_here" then
    print("Please setup the bot in .env")
else
    CLIENT:run("Bot " .. env.DISCORD_TOKEN)
end

local commands = {}

local function loadCommands()
    local files = filesystem.readdirSync("commands")
    for _, filename in ipairs(files) do
        if filename:match("%.lua$") then
            local name = filename:gsub("%.lua$", "")
            local ok, mod = pcall(require, "./commands/" .. name)
            if ok then
                commands[mod.name] = mod
                print("Loaded command: " .. mod.name)
            else
                print("Failed to load " .. filename .. ": " .. tostring(mod))
            end
        end
    end
end

loadCommands()

CLIENT:on("messageCreate", function(message)
    if message.author.bot then return end

    if message.content:sub(1, #PREFIX) == PREFIX then
        local content = message.content:sub(#PREFIX + 1)
        local args = {}
        for word in content:gmatch("%S+") do
            table.insert(args, word)
        end

        local commandName = table.remove(args, 1)
        if commandName then
            commandName = commandName:lower()
        end

        if not commandName or not commands[commandName] then
            return
        end

        local who = message.author.username .. " (" .. message.author.id .. ")"
        local where = message.guild and (message.guild.name .. " #" .. message.channel.name) or "DM"

        local ok, err = pcall(commands[commandName].execute, message, args, commands, CLIENT)

        if ok then
            logger.info(who, "successfully ran !" .. commandName, "in", where)
        else
            logger.error(who, "failed running !" .. commandName, "in", where, "-", tostring(err))
            message.channel:send("Something went wrong running that command.")
        end
        return
    end

    -- trigger detection for non-prefixed short messages
    if #message.content < 30 then
        local content = message.content:lower()
        for _, cmd in pairs(commands) do
            if cmd.triggers then
                for _, pattern in ipairs(cmd.triggers) do
                    if content:match(pattern) then
                        pcall(cmd.execute, message, {})
                        return
                    end
                end
            end
        end
    end
end)

CLIENT:on("ready", function()
    print("Logged in as " .. CLIENT.user.username)

    timer.setInterval(60000, function() -- check every 60 seconds
        local due = warnings.getDueTempbans(os.time())
        for _, entry in ipairs(due) do
            local guild = CLIENT:getGuild(entry.guild_id)
            if guild then
                guild:unbanUser(entry.user_id, "Temp ban expired")
            end
            warnings.removeTempban(entry.guild_id, entry.user_id)
        end
    end)
end)
