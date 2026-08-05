-- help.lua
-- its the help command lol
return {
    name = "help",
    description = "Lists all available commands",
    execute = function(message, args, commands)
        -- help <command> for description on a command
        if args[1] then
            local cmd = commands[args[1]]
            if cmd then
                message.channel:send("**" .. cmd.name .. "** - " .. (cmd.description or "No description"))
            else
                message.channel:send("No command called '" .. args[1] .. "'")
            end
            return
        end

        -- list all commands
        local lines = {"**Available commands:**"}
        for name, cmd in pairs(commands) do
            table.insert(lines, "`" .. name .. "` - " .. (cmd.description or "No description"))
        end
        message.channel:send(table.concat(lines, "\n"))
    end
}
