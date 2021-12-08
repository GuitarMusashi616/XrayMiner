-- y level 14 diamond miner
-- messes with turtle library

local turtle = require "turtle"

-- mines blocks whose names have these following strings in them
local TARGETS = {"diamond"}
local DEFAULT_RADIUS = 8
local GEOSCAN_SLOT = 16


function main(tArgs)
  if #tArgs==0 then
    print("Usage: xray <dir> [dist]")
    print("eg. xray north 5")
  end

  local dir = tArgs[1]
  local x = 0
  local y = 0
  local z = 0
  local dist = tArgs[2] or 1

  turtle.reset(x,y,z,dir)
  for _=1,dist do
    tunnel()
  end
end

function is_target(ore_name)
  for i,target in pairs(TARGETS) do
    if ore_name:find(target) then
      return true
    end
  end
  return false
end


function tunnel()
  turtle.digUp()
  for i=1,17 do
    turtle.dig()
    turtle.forward()
    turtle.digUp()
  end
  local tbl = scanBlocks()
  local dir = turtle.dir
  turtle.reset(0,0,0,dir)
  for i,item in pairs(tbl) do
    if is_target(item.name) then
      turtle.goTo(item.x,item.y,item.z)
    end
  end
  turtle.goTo(0,0,0)
  turtle.turnTo(dir)
end

function scanBlocks()
  turtle.select(GEOSCAN_SLOT)
  turtle.up_or_dig()
  turtle.placeDown()
  local tbl = peripheral.call("bottom","scan", DEFAULT_RADIUS)
  turtle.digDown()
  turtle.down()
  return tbl
end

main{...}