-- warnings.lua
-- uses sqlite3

package.cpath = package.cpath .. ";./lib/?.so"
local sqlite3 = require("lsqlite3")

local db = sqlite3.open("warnings.db")
db:exec([[
    CREATE TABLE IF NOT EXISTS tempbans (
        guild_id TEXT NOT NULL,
        user_id TEXT NOT NULL,
        unban_at INTEGER NOT NULL,
        PRIMARY KEY (guild_id, user_id)
    )
]])

local M = {}

function M.getWarningCount(guildId, userId)
    local stmt = db:prepare("SELECT COUNT(*) as count FROM warnings WHERE guild_id = ? AND user_id = ?")
    stmt:bind(1, guildId)
    stmt:bind(2, userId)
    local count = 0
    for row in stmt:nrows() do
        count = row.count
    end
    stmt:finalize()
    return count
end

function M.addTempban(guildId, userId, unbanAt)
    local stmt = db:prepare("INSERT OR REPLACE INTO tempbans (guild_id, user_id, unban_at) VALUES (?, ?, ?)")
    stmt:bind(1, guildId)
    stmt:bind(2, userId)
    stmt:bind(3, unbanAt)
    stmt:step()
    stmt:finalize()
end

function M.getDueTempbans(now)
    local results = {}
    local stmt = db:prepare("SELECT guild_id, user_id FROM tempbans WHERE unban_at <= ?")
    stmt:bind(1, now)
    for row in stmt:nrows() do
        table.insert(results, { guild_id = row.guild_id, user_id = row.user_id })
    end
    stmt:finalize()
    return results
end

function M.removeTempban(guildId, userId)
    local stmt = db:prepare("DELETE FROM tempbans WHERE guild_id = ? AND user_id = ?")
    stmt:bind(1, guildId)
    stmt:bind(2, userId)
    stmt:step()
    stmt:finalize()
end

function M.addWarning(guildId, userId, reason, moderator)
    local stmt = db:prepare("INSERT INTO warnings (guild_id, user_id, reason, moderator, timestamp) VALUES (?, ?, ?, ?, ?)")
    stmt:bind(1, guildId)
    stmt:bind(2, userId)
    stmt:bind(3, reason)
    stmt:bind(4, moderator)
    stmt:bind(5, os.time())
    stmt:step()
    stmt:finalize()
end

function M.getWarnings(guildId, userId)
    local results = {}
    local stmt = db:prepare("SELECT id, reason, moderator, timestamp FROM warnings WHERE guild_id = ? AND user_id = ? ORDER BY id")
    stmt:bind(1, guildId)
    stmt:bind(2, userId)

    for row in stmt:nrows() do
        table.insert(results, {
            id = row.id,
            reason = row.reason,
            moderator = row.moderator,
            timestamp = row.timestamp
        })
    end
    stmt:finalize()
    return results
end

function M.removeWarning(guildId, userId, id)
    local stmt = db:prepare("DELETE FROM warnings WHERE guild_id = ? AND user_id = ? AND id = ?")
    stmt:bind(1, guildId)
    stmt:bind(2, userId)
    stmt:bind(3, id)
    stmt:step()
    local changed = db:changes()
    stmt:finalize()
    return changed > 0
end

return M
