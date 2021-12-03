local tArgs = {...}

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
  dump_chest = "minecraft:chest_9",
  pickup_chest = "minecraft:chest_8",
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
  silo.chest_names = {}
  for name in all(peripheral.getNames()) do
    if beginsWith(name, "minecraft:chest") and name ~= silo.dump_chest and name ~= silo.pickup_chest then
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

function silo.grab(chest_name, slot, stack_size)
  peripheral.call(silo.pickup_chest, "pullItems", chest_name, slot, stack_size)
end

-- go through all items and take the specified item until count rem <= 0
function silo.get_item(item_name, count)
  local rem = count
  silo.find_chests()
  for chest_name in all(silo.chest_names) do
    local items = peripheral.call(chest_name, "list")
    for i,item in pairs(items) do
      if item.name == item_name then
        local amount = math.min(64, rem)
        silo.grab(chest_name, i, amount)
        rem = rem - amount
        if rem <= 0 then
          break
        end
      end
    end
  end
  return rem
end


function silo.try_to_dump(slot)
  -- try to suck the slot of dump chest with storage chest
  for chest_name in all(silo.chest_names) do
    local bool = peripheral.call(silo.dump_chest, "pullItems", chest_name, slot, 64)
    if bool then
      return true
    end
  end
end

-- for all storage chest try to suck everythin in the dump chest
function silo.dump()
  local suck_this = peripheral.call(silo.dump_chest, "list")
  for k,_ in pairs(suck_this) do
    if silo.try_to_dump(k) then
      return true
    end
  end
end

function main()
  if #tArgs == 0 then
    silo.startup()
    t2f(silo.dict)
  elseif #tArgs==1 and tArgs[1] == "dump" then
    if silo.dump() then
      print("Dump chest successfully emptied")
    else
      print("Inventory Full: Could not dump the dump chest")
    end
  elseif #tArgs>=2 and tArgs[1] == "get" then
    local item = tArgs[2]
    assert(item, "must specify item name with silo get")
    local count = tArgs[3] or 1
    local rem = silo.get_item(item, count)
    print(tostring(count-rem).. "x "..tostring(item).. " transferred to pickup chest")
  end
end

main()