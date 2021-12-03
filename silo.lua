if io.open("peripheral_silo.lua", "r") then
  require("peripheral_silo")
end

function all(tbl) 
  local prev_k = nil
  return function()
    local k,v = next(tbl, prev_k)
    prev_k = k
    return v
  end
end

function inc_tbl(tbl, key, val)
  assert(key, "key cannot be false or nil")
  val = val or 1
  if not tbl[key] then
    tbl[key] = 0
  end
  tbl[key] = tbl[key] + val
end

silo = {
  dict = {},
  chest_names = {},
}

local function beginsWith(string, beginning)
  return string:sub(1,#beginning) == beginning
end

function forEach(tbl, func)
  for val in all(tbl) do
    func(val)
  end
end

function t2f(tbl, filename)
  filename = filename or "output"
  local h = io.open(filename, "w")
  h:write(textutils.serialize(tbl))
  h:close()
  shell.run("edit "..tostring(filename))
end

-- scan through all connected chests and add to table
function silo.find_chests()
  for name in all(peripheral.getNames()) do
    if beginsWith(name, "minecraft:chest") then
      table.insert(silo.chest_names, name)
    end
  end
end

-- add the item to the record
function silo.add(item)
  inc_tbl(silo.dict, item.name, item.count)
end

-- scan through all invos and put into dict
function silo.update_all_items()
  for name in all(silo.chest_names) do
    local items = peripheral.call(name, "list")
    forEach(items, function(item) silo.add(item) end)
  end
end

function silo.startup()
  silo.find_chests()
  silo.update_all_items()
end


silo.startup()
for k,v in pairs(silo.dict) do
  print(k,v)
end
--t2f(silo.dict)
