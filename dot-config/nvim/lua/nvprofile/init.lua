local util = require("nvprofile.util")
local predicates = require("nvprofile.predicates")

local M = {}

---@param profiles { [string]: ProfileCfg }
M.setup = function(profiles)
  local profiles = util.make_profiles(profiles)
  local user = {
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

    eval = predicates.evaluator(profiles),

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
  M.user = user
  return user
end

M.util = util
M.predicates = predicates
return M
