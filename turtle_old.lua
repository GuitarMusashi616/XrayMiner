-- extends default turtle api with coord tracking

-- used for testing in IDE
if io.open("peripheral_silo.lua", "r") then
  require("peripheral_silo")
end

local slurtle = turtle

-- note: wont keep track of coords unless starting dir is initialized
turtle = {
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

function modulus_incr(num, amount, divisor)
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

function turtle.turnto(dir)
  dir = DIR_TO_INDEX[dir]
  while turtle.dir ~= dir do
    turtle.turnRight()
  end
end

function turtle.move_or_dig(move_func, break_func)
  if not move_func() then
    break_func()
  end
  return true
end

function turtle.forward_or_dig()
  return turtle.move_or_dig(turtle.forward, turtle.dig)
end
function turtle.back_or_dig()
  return turtle.move_or_dig(turtle.back, function() turtle.turnRight() turtle.dig() turtle.turnRight() end)
end
function turtle.up_or_dig()
  return turtle.move_or_dig(turtle.up, turtle.digUp)
end
function turtle.down_or_dig()
  return turtle.move_or_dig(turtle.down, turtle.digDown)
end

function turtle.gotovar(condlt, condgt, forward_case, back_case)
  while turtle.getDir() ~= forward_case and turtle.getDir() ~= back_case do
    turtle.turnRight()
  end
  local move_func = turtle.getDir() == forward_case and turtle.forward_or_dig or turtle.back_or_dig
  local ret_func = turtle.getDir() == forward_case and turtle.back_or_dig or turtle.forward_or_dig
  while condlt() do
    move_func()
  end
  while condgt() do
    ret_func()
  end
end

function turtle.gotoheight(y)
  while turtle.y < y do
    turtle.up_or_dig()
  end
  while turtle.y > y do
    turtle.down_or_dig()
  end
end

function turtle.go(x,y,z)
  turtle.gotovar(function() return turtle.z>z end, function() return turtle.z<z end, "north", "south")
  turtle.gotovar(function() return turtle.x<x end, function() return turtle.x>x end, "east", "west")
  turtle.gotoheight(y)
end

for key, func in pairs(slurtle) do
  if not turtle[key] then
    turtle[key] = func
  end
end

turtle.go(1,2,3)
