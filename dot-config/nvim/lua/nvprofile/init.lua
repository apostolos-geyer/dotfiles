local util = require("nvprofile.util")

local user = {}

return {
    user = user,
    ---@param profiles { [string]: ProfileCfg }
    setup = function(profiles)
        profiles = util.make_profiles(profiles)
        user = {
            profiles = profiles,
            ---initialize profiles
            ---@param opts? { force?: string[] }
            activate = function(opts)
                opts = opts or {}
                local forced = (function(list)
                    local set = {}
                    for _, key in ipairs(list) do
                        set[key] = true
                    end
                    return set
                end)(opts.force or {})

                for name, profile in pairs(profiles) do
                    local should_apply = forced[name] or (profile.cond and profile.cond())
                    if should_apply then
                        local ok = profile.apply()
                    end
                end
            end,

            --- evaluate to filter only for active
            --- profiles
            --- @generic T
            --- @param configurations {[string]: T}
            --- @return T[]
            evaluate = function(configurations)
                local tbl = {}
                for profile, conf in pairs(configurations) do
                    if (profile == "all") or (profiles[profile].applied == true) then
                        tbl[#tbl + 1] = conf
                    end
                end
                return tbl
            end,
        }
        return user
    end,
    util = util,
}
