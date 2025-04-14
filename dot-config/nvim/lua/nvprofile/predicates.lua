local helpers = require("helpers")

--- conditional evaluation and filtering
--- for profiles
local M = {}

do
  --- predicates for assembling tables based on active profile
  M.when = {}
  ---@param kind string
  local function whentbl(kind)
    ---@param ... string
    return function(...)
      return { __WHEN_KIND__ = kind, ... }
    end
  end
  ---@enum WhenKind
  local kind = {
    none_of = "none_of",
    any_of = "any_of",
    all_of = "all_of",
  }

  M.when.kind = kind
  --- internal helper
  ---@param t table
  M.when.get_evaluator = function(t)
    assert(t["__WHEN_KIND__"] ~= nil, "must construct conditional configurations in tables using `predicates.when`")
    local wk = t["__WHEN_KIND__"]
    if wk == kind.none_of then
      return helpers.agg.none
    elseif wk == kind.any_of then
      return helpers.agg.any
    elseif wk == kind.all_of then
      return helpers.agg.all
    end
    assert(not true, "did not match any predicates")
  end

  M.when.always = true
  M.when.none_of = whentbl(M.when.kind.none_of)
  M.when.any_of = whentbl(M.when.kind.any_of)
  M.when.all_of = whentbl(M.when.kind.all_of)
end

--- get an evaluator for predicates to
--- activate certain configs based on profile
--- @param profiles { [string]: Profile }
M.evaluator = function(profiles)
  local function evaluate_cond(predicate)
    if type(predicate) == "boolean" then
      --- interpret as always on
      return predicate
    elseif type(predicate) == "string" then
      --- interpret as profile name
      return profiles[predicate].applied == true
    elseif type(predicate) == "table" then
      --- interpret as conditionals expressed thru table
      return M.when.get_evaluator(predicate)(helpers.map_array(predicate, function(_, pred)
        return _, evaluate_cond(pred)
      end))
    end
  end

  --- @generic T
  --- @param conf { [boolean]: T, [string]: T, [table]: T}
  --- @param depth? number
  return function(conf, depth)
    -- print("evaluating configuration with depth: " .. (depth or -1) .. "\nconfiguration:\n.." .. vim.inspect(conf))
    local filtered = helpers.filter(conf, evaluate_cond)
    -- print("filtered: \n" .. vim.inspect(filtered))
    local unkeyed = helpers.unkey(filtered)
    -- print("unkeyed: \n" .. vim.inspect(unkeyed))

    return helpers.flat_merge(helpers.unkey(helpers.filter(conf, evaluate_cond)), {}, depth)
  end
end

return M
