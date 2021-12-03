-- works perfectly as is

-- connect chests to computer with wired modems
-- specify name of dump chest and pickup chest (all the other chests will be used as storage)
local DUMP_CHEST_NAME = "minecraft:chest_9"
local PICKUP_CHEST_NAME = "minecraft:chest_8"
local tArgs = {...}

-- used for testing in IDE
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

local silo = {
  dict = {},
  chest_names = {},
  dump_chest = DUMP_CHEST_NAME,
  pickup_chest = PICKUP_CHEST_NAME,
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
end

function silo.grab(chest_name, slot, stack_size)
  peripheral.call(silo.pickup_chest, "pullItems", chest_name, slot, stack_size)
end

-- go through all items and take the specified item until count rem <= 0
function silo.get_item(item_name, count)
  local rem = count
  item_name = item_name:lower()
  for chest_name in all(silo.chest_names) do
    local items = peripheral.call(chest_name, "list")
    for i,item in pairs(items) do
      if item.name:find(item_name) then
        local amount = math.min(64, rem)
        silo.grab(chest_name, i, amount)
        rem = rem - amount
        if rem <= 0 then
          break
        end
      end
    end
  end
end

-- try to suck the slot of dump chest with storage chests
function silo.try_to_dump(slot, count)
  for chest_name in all(silo.chest_names) do
    local num = peripheral.call(silo.dump_chest, "pushItems", chest_name, slot, count)
    if num >= count then
      return true
    end
  end
end

-- for all storage chest try to suck everythin in the dump chest
function silo.dump()
  local suck_this = peripheral.call(silo.dump_chest, "list")
  for k,v in pairs(suck_this) do
    if not silo.try_to_dump(k,v.count) then
      return false
    end
  end
  return true
end

function silo.search(item_name)
  item_name = item_name:lower()
  for name in all(silo.chest_names) do
    local items = peripheral.call(name, "list")
    forEach(items, function(item) if item.name:find(item_name) then silo.add(item) end end)
  end
end

function silo.get_capacity()
  local total_slots = 0
  local used_slots = 0
  local used_items = 0
  
  for name in all(silo.chest_names) do
    total_slots = total_slots + peripheral.call(name, "size")
    local items = peripheral.call(name, "list")
    used_slots = used_slots + #items
    forEach(items, function(item) used_items = used_items + item.count end)
  end
  
  
  print("slots used ".. tostring(used_slots) .. "/" .. tostring(total_slots))
  print("items stored "..tostring(used_items) .. "/" .. tostring(total_slots*64))
  
end

function main()
  silo.startup()
  if #tArgs == 0 then
    silo.update_all_items()
    t2f(silo.dict)
  elseif #tArgs==1 then
    if tArgs[1] == "dump" then
      if silo.dump() then
        print("Dump chest successfully emptied")
      else
        print("Inventory Full: Could not dump the dump chest")
      end
    elseif tArgs[1] == "info" then
      silo.get_capacity()
    end
  elseif #tArgs>=2 then
    local item = tArgs[2]
    assert(item, "must specify item name with that command")
    local count = tArgs[3] or 1
    
    if tArgs[1] == "search" then
      silo.search(item)
      t2f(silo.dict)
    elseif tArgs[1] == "get" then
      silo.get_item(item, count)
      print(tostring(item).. " transferred to pickup chest")
    end
  end
end

main()