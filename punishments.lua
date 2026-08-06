-- punishment.lua
-- its the punishment system 

local warnings = require("./warnings")
local env = require("./env")

local DAY = 86400
local WEEK = 604800

local thresholds = {
    [3]  = { type = "timeout", seconds = DAY },
    [5]  = { type = "timeout", seconds = WEEK },
    [7]  = { type = "kick" },
    [10] = { type = "tempban", seconds = WEEK },
    [12] = { type = "permban" },
}

local M = {}

function M.checkAndApply(guild, member, target, reason)
    local count = warnings.getWarningCount(guild.id, target.id)
    local punishment = thresholds[count]
    if not punishment then
        return nil
    end

    if punishment.type == "timeout" then
        local ok, err = member:timeoutFor(punishment.seconds)
        if ok then
            local label = punishment.seconds == DAY and "1 day" or "1 week"
            return "Reached " .. count .. " warnings — timed out for " .. label .. "."
        else
            return "Reached " .. count .. " warnings, but timeout failed: " .. tostring(err)
        end

    elseif punishment.type == "kick" then
        local ok, err = member:kick("Reached " .. count .. " warnings")
        if ok then
            return "Reached " .. count .. " warnings — kicked."
        else
            return "Reached " .. count .. " warnings, but kick failed: " .. tostring(err)
        end

    elseif punishment.type == "tempban" then
        local ok, err = member:ban("Reached " .. count .. " warnings")
        if ok then
            warnings.addTempban(guild.id, target.id, os.time() + punishment.seconds)
            return "Reached " .. count .. " warnings — banned for 1 week."
        else
            return "Reached " .. count .. " warnings, but ban failed: " .. tostring(err)
        end

    elseif punishment.type == "permban" then
        local ok, err = member:ban("Reached " .. count .. " warnings")
        if ok then
            return "Reached " .. count .. " warnings — permanently banned."
        else
            return "Reached " .. count .. " warnings, but ban failed: " .. tostring(err)
        end
    end
end

return M
