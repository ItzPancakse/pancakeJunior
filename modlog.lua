-- modlog.lua
-- its the modlog

local env = require("./env")

local M = {}

local COLORS = {
    warn = 0xFFA500,   -- orange
    kick = 0xFF6B00,   -- darker orange
    ban = 0xFF0000,    -- red
    timeout = 0xFFFF00 -- yellow
}

function M.send(client, actionType, title, fields)
    local channel = client:getChannel(env.LOG_CHANNEL_ID)
    if not channel then
        print("Mod log channel not found — check LOG_CHANNEL_ID in .env")
        return
    end

    local embedFields = {}
    for _, field in ipairs(fields) do
        table.insert(embedFields, { name = field.name, value = field.value, inline = true })
    end

    channel:send({
        embed = {
            title = title,
            color = COLORS[actionType] or 0x808080,
            fields = embedFields,
            timestamp = os.date("!%Y-%m-%dT%H:%M:%S")
        }
    })
end

return M
