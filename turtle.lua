-- extends default turtle api with coord tracking
-- now working

-- used for testing in IDE
if io.open("peripheral.lua", "r") then
  require "peripheral"
end

local slurtle = turtle

-- note: wont keep track of coords unless starting dir is initialized
local turtle = {
  x = 0,
  y = 0,
  z = 0,
  dir = 1,
}
setmetatable(turtle, slurtle)
slurtle.__index = slurtle

local DIRECTIONS = {"north","east","south","west"}

-- maps direction name to attr affected when moving forward that direction
local DIR_TO_ATTR = {
  function(val) turtle.z = turtle.z-val end,
  function(val) turtle.x = turtle.x+val end,
  function(val) turtle.z = turtle.z+val end,
  function(val) turtle.x = turtle.x-val end,
}

local DIR_TO_INDEX = {
  north=1,
  east=2,
  south=3,
  west=4
}

local function modulus_incr(num, amount, divisor)
  local res = num-1
  res = res + amount
  res = res % divisor
  res = res + 1
  return res
end

function turtle.reset(x,y,z,dir)
  assert(dir, "must specify direction at least")
  if not tonumber(dir) then
    dir = DIR_TO_INDEX[dir]
  end  
  turtle.dir = dir
  turtle.x = x or 0
  turtle.y = y or 0 
  turtle.z = z or 0
end

function turtle.getDir()
  return DIRECTIONS[turtle.dir]
end

function turtle.xyz()
  return turtle.x, turtle.y, turtle.z, turtle.getDir()
end

function turtle.show_xyz()
  local x,y,z,dir = turtle.xyz()
  print("x: "..tostring(x))
  print("y: "..tostring(y))
  print("z: "..tostring(z))
  print("dir: "..tostring(dir))
end

function turtle.forward()
  if slurtle.forward() then
    local func = DIR_TO_ATTR[turtle.dir]
    func(1)
    return true
  end
  return false
end

function turtle.back()
  if slurtle.back() then
    local func = DIR_TO_ATTR[turtle.dir]
    func(-1)
    return true
  end
  return false
end

function turtle.up()
  if slurtle.up() then
    turtle.y = turtle.y + 1
    return true
  end
  return false
end

function turtle.down()
  if slurtle.down() then
    turtle.y = turtle.y - 1
    return true
  end
  return false
end

function turtle.turnRight()
  if slurtle.turnRight() then
    turtle.dir = modulus_incr(turtle.dir, 1, #DIRECTIONS)
    return true
  end
  return false
end

function turtle.turnLeft()
  if slurtle.turnLeft() then
    turtle.dir = modulus_incr(turtle.dir, -1, #DIRECTIONS)
    return true
  end
  return false
end

function turtle.turnTo(dir)
  --dir is a num
  local num = dir - turtle.dir
  if num == 0 then
    return
  elseif num == -3 or num == 1 then
    turtle.turnRight()
  elseif num == 3 or num == -1 then
    turtle.turnLeft()
  else
    turtle.turnRight()
    turtle.turnRight()
  end
end

function turtle.forward_or_dig()
  turtle.dig()
  return turtle.forward()
end

function turtle.back()
  return turtle.back()
end

function turtle.up_or_dig()
  turtle.digUp()
  return turtle.up()
end
function turtle.down_or_dig()
  turtle.digDown()
  return turtle.down()
end

function turtle.goToVar(dist, dir_pos, dir_neg)
  if dist < 0 then
    turtle.turnTo(dir_neg)
    dist = dist * -1
  else
    turtle.turnTo(dir_pos)
  end
  
  for _=1,dist do
    turtle.forward_or_dig()
  end
end

function turtle.goToHeight(dist)
  move_func = turtle.up_or_dig
  if dist < 0 then
    move_func = turtle.down_or_dig
    dist = dist * -1
  end
  
  for _=1,dist do
    move_func()
  end
end

function turtle.goTo(x,y,z)
  turtle.goToVar(z-turtle.z, 3, 1)
  turtle.goToVar(x-turtle.x, 2, 4)
  turtle.goToHeight(y-turtle.y)
end

--for key, func in pairs(slurtle) do
  --if not turtle[key] then
    --turtle[key] = func
  --end
--end

return turtle