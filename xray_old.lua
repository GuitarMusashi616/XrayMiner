-- y level 14 diamond miner
-- messes with turtle library

require("turtle")

-- mines blocks whose names have these following strings in them
local TARGET = "diamond"
local DEFAULT_RADIUS = 8
local GEOSCAN_SLOT = 16


function main(tArgs)
  if #tArgs==0 then
    print("Usage: xray <dir> [x] [y] [z]")
    print("eg. xray north 0 0 0")
  end

  local dir = tArgs[1]
  local x = tArgs[2] or 0
  local y = tArgs[3] or 0
  local z = tArgs[4] or 0

  turtle.reset(tArgs[2], tArgs[3], tArgs[4], tArgs[1])
  tunnel()
  
end

function tunnel()
  for _=1,9 do
    turtle.forward_or_dig()
  end
  local tbl = scanBlocks()
  local dir = turtle.dir
  turtle.reset(0,0,0,dir)
  for i,item in pairs(tbl) do
    if item.name:find(TARGET) then
      turtle.go(item.x,item.y,item.z)
    end
  end
  turtle.go(0,0,0)
end

function scanBlocks()
  turtle.select(GEOSCAN_SLOT)
  turtle.up()
  turtle.placeDown()
  local tbl = peripheral.call("bottom","scan", DEFAULT_RADIUS)
  turtle.digDown()
  turtle.down()
  return tbl
end

main{...}