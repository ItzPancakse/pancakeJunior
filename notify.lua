-- notify.lua
-- notifies users when they are punished

local env = require("env")

local M = {}

function M.dm(target, action, reason, extra)
    local channel = target:getPrivateChannel()
    if not channel then
        print("Failed to get private channel for user " .. target.username)
        return false
    end

    local lines = {
    "You have received a **" .. action .. "** in **" .. (extra and extra.guildName or "a server") .. "**.",
    "Reason: " .. reason,
    "If you believe this was a mistake, please contact the moderators."
}

    if extra and extra.duration then
        table.insert(lines, "Duration: " .. extra.duration)
    end

    if action == "ban" then
        table.insert(lines, "You can appeal your ban here: " .. env.APPEAL_LINK)
    end

    local ok = pcall(function()
        channel:send(table.concat(lines, "\n"))
    end)

    return ok
end

return M
