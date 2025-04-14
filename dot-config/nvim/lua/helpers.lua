local M = {}

local repr = vim.inspect

local function _flatten(t, into, depth)
  into = into or {}
  assert(type(t) == "table", "can only flatten tables")
  for k, v in pairs(t) do
    local is_table = type(v) == "table"

    if type(k) == "number" then
      if is_table and depth > 0 then
        _flatten(v, into, depth - 1)
      elseif is_table and depth == -1 then
        -- arbitrary depth
        _flatten(v, into, depth)
      else
        table.insert(into, v)
      end
    else
      if is_table and depth > 0 then
        into[k] = _flatten(v, {}, depth - 1)
      elseif is_table and depth == -1 then
        into[k] = _flatten(v, {}, depth)
      else
        into[k] = v
      end
    end
  end
  return into
end

--- flatten a table (in array form)
--- with nested children (that are either arrays or map form)
--- into a table with only one level
--- NOTE: if keys overlap, the last value for a key takes precedence (i.e. clobbering semantics)
--- @param t any
--- @param into? table
--- @param depth? number
--- @return table
function M.flat_merge(t, into, depth)
  return _flatten(t, into, depth or -1)
end

--- filter a table
--- @generic K,V
--- @param t table<K,V>
--- @param predicate fun(k: K, v: V): boolean
--- @param into? table<K,V>
--- @return table<K,V>
function M.filter(t, predicate, into)
  into = into or {}
  for k, v in pairs(t) do
    if predicate(k, v) then
      into[k] = v
    end
  end
  return into
end

--- filter an array-like table
--- @generic V
--- @param t V[]
--- @param predicate fun(i: integer, v: V): boolean
--- @return V[]
function M.filter_array(t, predicate)
  local into = {}
  local j = 1
  for i = 1, #t do
    if predicate(i, t[i]) then
      into[j] = t[i]
      j = j + 1
    end
  end
  return into
end

--- mutate values of a table inplace, keeping same keys / indices
--- @generic K,V,R
--- @param t table<K,V>
--- @param mut fun(v: V): R
--- @return table<K,R>
function M.apply(t, mut)
  for k, v in pairs(t) do
    t[k] = mut(v)
  end
  return t
end

--- mutate values of an array inplace
--- @generic V,R
--- @param t V[]
--- @param mut fun(v: V): R
--- @return R[]
function M.apply_array(t, mut)
  for i = 1, #t do
    t[i] = mut(t[i])
  end
  return t
end

--- map values of a table, possibly changing keys
--- must return a tuple from mapper
--- @generic K,V,K2,V2
--- @param t table<K,V>
--- @param mapper fun(k: K, v: V): K2, V2
--- @param into? table<K2, V2>
--- @return table<K2, V2>
function M.map(t, mapper, into)
  into = into or {}
  for k, v in pairs(t) do
    local k2, v2 = mapper(k, v)
    into[k2] = v2
  end
  return into
end

--- map an array-like table to a new array
--- @generic V,V2
--- @param t V[]
--- @param mapper fun(i: integer, v: V): any, V2
--- @return {[any]: V2}
function M.map_array(t, mapper)
  local into = {}
  for i = 1, #t do
    local k2, v2 = mapper(i, t[i])
    into[k2] = v2
  end
  return into
end

--- remove top level keys such that the passed table
--- becomes array-like
--- @generic V
--- @param t table<any, V>
--- @param into? V[]
--- @return V[]
function M.unkey(t, into)
  into = into or {}
  for _, v in pairs(t) do
    table.insert(into, v)
  end
  return into
end

M.agg = {}

--- @param t boolean[]
--- @return boolean
function M.agg.any(t)
  for i = 1, #t do
    if t[i] then
      return true
    end
  end
  return false
end

--- @param t boolean[]
--- @return boolean
function M.agg.all(t)
  for i = 1, #t do
    if not t[i] then
      return false
    end
  end
  return true
end

--- @param t boolean[]
--- @return boolean
function M.agg.none(t)
  return not M.agg.any(t)
end

--- shorthand to print vim.inspect value
--- @param x any
--- @param opts? vim.inspect.Opts
function M.inspect(x, opts)
  print(repr(x, opts))
end

return M
