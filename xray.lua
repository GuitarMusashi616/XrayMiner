-- y level 14 diamond miner
-- messes with turtle library

require("turtle")

-- mines blocks whose names have these following strings in them
local TARGETS = {"diamond"}


local tArgs = {...}
if #tArgs==0 then
  print("Usage: xray <dir> [x] [y] [z]")
  print("eg. xray north 0 0 0")
end


function mine_to(x,y,z)
  
end
