-- afk.lua
-- it makes a simple table of whos afk and whos not

local M = {}
local afkUser = {}

function M.setAfk(userId, reason)
    afkUser[userId] ={ reason = reason, since = os.time() }
end

function M.isAfk(userId)
    return afkUser[userId] ~= nil
end

function M.getAfk(userId)
    return afkUser[userId]
end

function M.removeAfk(userId)
    local was = afkUser[userId]
    afkUser[userId] = nil
    return was
end

return M
