local SIDES = {"top", "bottom", "left", "right", "front", "back"}
-- require("peripheral")

local function all(tbl) 
  local prev_k = nil
  return function()
    local k,v = next(tbl, prev_k)
    prev_k = k
    return v
  end
end

local function inc_tbl(tbl, key, val)
  val = val or 1
  if not tbl[key] then
    tbl[key] = 0
  end
  tbl[key] = tbl[key] + val
end


storage = {
  max_height = 3,
  height = 1,
  chests = {},
  dict = {},
}

function storage.go_to_floor()
  while not turtle.detectDown() do
    turtle.down()
  end
  storage.height = 1
end

function storage.startup()
  storage.go_to_floor()
  for i=1,storage.max_height do
    storage.scan_at_height(i)
  end
end

function storage.add_to_chests(item, height, side)
  local key = tostring(height) + tostring(side)
  if not storage.chests[key] then
    storage.chests[key] = {}
  end
  table.insert(storage.chests[key], item)
end

function storage.add_to_dict(item)
  inc_tbl(storage.dict, item.name, item.count)
end

function storage.add(item, height, side)
  storage.add_to_dict(item)
  storage.add_to_chests(item, height, side)
end

function storage.go_to_height(height)
  while storage.height < height do
    turtle.up()
    storage.height = storage.height + 1
  end
  while storage.height > height do
    turtle.down()
    storage.height = storage.height - 1
  end
  
end

function storage.scan_at_height(height)
  storage.go_to_height(height)
  for side in all(SIDES) do
    if peripheral.getType(side) == "minecraft:chest" then
      local items = peripheral.call(side, "list")
      for item in all(items) do
        storage.add(item, height, side)
      end
    end
  end
end

storage.startup()