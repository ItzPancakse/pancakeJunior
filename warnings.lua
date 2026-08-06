-- warnings.lua
-- uses sqlite3

package.cpath = package.cpath .. ";./lib/?.so"
local sqlite3 = require("lsqlite3")
local fs = require("fs")
local logger = require("./logger")

local DB_FILE = "warnings.db"

local function checkIntegrity(database)
    local ok = false
    local result = "unknown error"
    local success, err = pcall(function()
        for row in database:nrows("PRAGMA integrity_check") do
            result = row.integrity_check
            ok = (result == "ok")
        end
    end)
    if not success then
        return false, tostring(err)
    end
    return ok, result
end

local function backupCorruptedFile()
    local timestamp = os.date("%Y%m%d_%H%M%S")
    local backupName = "warnings_corrupted_" .. timestamp .. ".db"
    local success, err = pcall(fs.renameSync, DB_FILE, backupName)
    if success then
        logger.warn("Corrupted database backed up as", backupName)
    else
        logger.error("Failed to back up corrupted database:", tostring(err))
    end
end

local db = sqlite3.open(DB_FILE)
if not db then
    error("Failed to open " .. DB_FILE)
end

local isHealthy, checkResult = checkIntegrity(db)
if not isHealthy then
    logger.error("Database integrity check failed:", checkResult)
    db:close()
    backupCorruptedFile()
    db = sqlite3.open(DB_FILE) -- creates a fresh, empty one so the bot can continue running
    logger.warn("Created a fresh warnings.db — old data preserved in the backup file")
else
    logger.info("Database integrity check passed")
end

db:exec([[
    CREATE TABLE IF NOT EXISTS warnings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id TEXT NOT NULL,
        reason TEXT NOT NULL,
        moderator TEXT NOT NULL,
        timestamp INTEGER NOT NULL
    )
]])

db:exec([[
    CREATE TABLE IF NOT EXISTS tempbans (
        user_id TEXT PRIMARY KEY,
        unban_at INTEGER NOT NULL
    )
]])

local M = {}

function M.addWarning(userId, reason, moderator)
    local stmt = db:prepare("INSERT INTO warnings (user_id, reason, moderator, timestamp) VALUES (?, ?, ?, ?)")
    stmt:bind(1, userId)
    stmt:bind(2, reason)
    stmt:bind(3, moderator)
    stmt:bind(4, os.time())
    stmt:step()
    stmt:finalize()
end

function M.getWarnings(userId)
    local results = {}
    local stmt = db:prepare("SELECT id, reason, moderator, timestamp FROM warnings WHERE user_id = ? ORDER BY id")
    stmt:bind(1, userId)
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

function M.getWarningCount(userId)
    local stmt, err = db:prepare("SELECT COUNT(*) as count FROM warnings WHERE user_id = ?")
    if not stmt then
        print("getWarningCount prepare failed:", err)
        return 0
    end
    stmt:bind(1, userId)
    local count = 0
    for row in stmt:nrows() do count = row.count end
    stmt:finalize()
    return count
end

function M.removeWarning(userId, id)
    local stmt = db:prepare("DELETE FROM warnings WHERE user_id = ? AND id = ?")
    stmt:bind(1, userId)
    stmt:bind(2, id)
    stmt:step()
    local changed = db:changes()
    stmt:finalize()
    return changed > 0
end

function M.clearWarnings(userId)
    local stmt = db:prepare("DELETE FROM warnings WHERE user_id = ?")
    stmt:bind(1, userId)
    stmt:step()
    local changed = db:changes()
    stmt:finalize()
    return changed
end

function M.addTempban(userId, unbanAt)
    local stmt = db:prepare("INSERT OR REPLACE INTO tempbans (user_id, unban_at) VALUES (?, ?)")
    stmt:bind(1, userId)
    stmt:bind(2, unbanAt)
    stmt:step()
    stmt:finalize()
end

function M.getDueTempbans(now)
    local results = {}
    local stmt = db:prepare("SELECT user_id FROM tempbans WHERE unban_at <= ?")
    stmt:bind(1, now)
    for row in stmt:nrows() do
        table.insert(results, row.user_id)
    end
    stmt:finalize()
    return results
end

function M.removeTempban(userId)
    local stmt = db:prepare("DELETE FROM tempbans WHERE user_id = ?")
    stmt:bind(1, userId)
    stmt:step()
    stmt:finalize()
end

return M
