-- ratelimit.lua
-- to stop spam

local M = {}

local cooldowns = {}

local DEFAULT_COOLDOWN = 3 -- seconds

function M.isOnCooldown(userId, commandName, cooldownSeconds)
    cooldownSeconds = cooldownSeconds or DEFAULT_COOLDOWN
    local key = userId .. ":" .. commandName
    local lastUsed = cooldowns[key]

    if lastUsed then
        local elapsed = os.time() - lastUsed
        if elapsed < cooldownSeconds then
            local remaining = cooldownSeconds - elapsed
            return true, remaining
        end
    end

    return false
end

function M.setUsed(userId, commandName)
    local key = userId .. ":" .. commandName
    cooldowns[key] = os.time()
end

return M
