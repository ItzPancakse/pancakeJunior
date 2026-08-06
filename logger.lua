-- logger.lua
-- a logging system for the bot

local fs = require("fs")

local M = {}

local colors = {
    INFO = "\27[36m",  -- cyan
    WARN = "\27[33m",  -- yellow
    ERROR = "\27[31m", -- red
    RESET = "\27[0m"
}

local function timestamp()
    return os.date("%Y-%m-%d %H:%M:%S")
end

local function ensureLogsDir()
    if not fs.existsSync("logs") then
        local ok, err = pcall(fs.mkdirSync, "logs", 511) -- 511 = 0777 permissions
        if not ok then
            print("Failed to create logs directory:", err)
        end
    end
end

local function writeToFile(line)
    local date = os.date("%Y-%m-%d")
    local path = "logs/" .. date .. ".log"
    ensureLogsDir()
    local ok, err = pcall(function()
        local file = fs.openSync(path, "a")
        fs.writeSync(file, -1, line .. "\n")
        fs.closeSync(file)
    end)
    if not ok then
        print("Failed to write log file:", err)
    end
end

local function log(level, ...)
    local args = {...}
    local out = {}
    for i, v in ipairs(args) do out[i] = tostring(v) end
    local msg = table.concat(out, " ")

    local plainLine = string.format("[%s] [%s] %s", timestamp(), level, msg)
    local coloredLine = string.format("[%s] %s[%s]%s %s", timestamp(), colors[level] or "", level, colors.RESET, msg)

    print(coloredLine)
    writeToFile(plainLine)
end

function M.info(...) log("INFO", ...) end
function M.warn(...) log("WARN", ...) end
function M.error(...) log("ERROR", ...) end

return M
