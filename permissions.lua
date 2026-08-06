-- permission.lua
-- its a permission system

local env = require("./env")

local M = {}

function M.isModOrOwner(message)
    if message.author.id == env.OWNER_ID then
        return true
    end
    if message.member and message.member:hasRole(env.MOD_ROLE_ID) then
        return true
    end
    return false
end

function M.isAdminOrOwner(message)
    if message.author.id == env.OWNER_ID then
        return true
    end
    if message.member and message.member:hasRole(env.ADMIN_ROLE_ID) then
        return true
    end
    return false
end

return M
