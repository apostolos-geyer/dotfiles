--- @class ProfileCfg
--- @field cond? fun(...): boolean
--- @field apply fun(...): boolean
--- @field [any] any

--- @class Profile : ProfileCfg
--- @field name string
--- @field applied boolean

local M = {}

---create a proper profile table from config
---@param name string
---@param profile ProfileCfg
---@return Profile
function M.make_profile(name, profile)
    profile.name = name
    profile.applied = false

    local base_apply = profile.apply
    profile.apply = function(...)
        ---eagerly set so that we can access it during other initializations
        profile.applied = true
        local ok = base_apply(...)
        if ok then
            vim.notify("[[neovim-profile]] applied: " .. name)
        else
            ---fallback if we fail
            profile.applied = false
            vim.notify("[[neovim-profile]] failed to apply: " .. name)
        end
        return ok
    end
    ---@cast profile Profile
    return profile
end

---@param configs { [string]: ProfileCfg }
---@return { [string]: Profile }
function M.make_profiles(configs)
    local map = {}
    for name, cfg in pairs(configs) do
        map[name] = M.make_profile(name, cfg)
    end
    return map
end

---create a function to check availability of api
---under vim.g
---@param key string
function M.gavailable(key)
    return function()
        return vim.g[key] ~= nil
    end
end

return M
