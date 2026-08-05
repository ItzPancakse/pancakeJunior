-- env.lua
-- loads the env file
local env = {}

local function loadEnv(path)
    path = path or ".env"
    local file = io.open(path, "r")
    if not file then
        print("Warning: " .. path .. " not found")
        return env
    end

    for line in file:lines() do
        line = line:gsub("^%s+", ""):gsub("%s+$", "")
        if line ~= "" and not line:match("^#") then
            local key, value = line:match("^([%w_]+)%s*=%s*(.*)$")
            if key then
                -- strip surrounding quotes if present
                value = value:gsub('^"(.*)"$', "%1"):gsub("^'(.*)'$", "%1")
                env[key] = value
            end
        end
    end
    file:close()
    return env
end

loadEnv()
return env
