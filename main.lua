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
    if not message.content:sub(1, #PREFIX) == PREFIX then return end

    local content = message.content:sub(#PREFIX + 1)
    local args = {}
    for word in content:gmatch("%S+") do
        table.insert(args, word)
    end

    local commandName = table.remove(args, 1)
    if commandName and commands[commandName] then
    commands[commandName].execute(message, args, commands, CLIENT)
    end
end)
