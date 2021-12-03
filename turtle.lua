
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

local function backup_dir(dir)
  local h = io.open("backup_dir", "w")
  h:write(dir)
  h:close()
end

local function get_dir_backup()
  local h = io.open("backup_dir", "r")
  local string = h:read()
  h:close()
  return string
end

function modulus_incr(num, amount, divisor)
  local res = num + amount
  res = res % divisor
  res = res + 1
  return res
end

function turtle.reset(dir,x,y,z)
  assert(dir, "must specify direction at least")
  turtle.dir = dir
  turtle.x = x or 0
  turtle.y = y or 0 
  turtle.z = z or 0
end

function turtle.getDir()
  return DIRECTIONS[turtle.dir]
end

function turtle.forward()
  if slurtle.forward() then
    local func = DIR_TO_ATTR[turtle.dir]
    func(1)
  end
end

function turtle.back()
  if slurtle.back() then
    local func = DIR_TO_ATTR[turtle.dir]
    func(-1)
  end
end

function turtle.up()
  if slurtle.up() then
    turtle.y = turtle.y + 1
  end
end

function turtle.down()
  if slurtle.down() then
    turtle.y = turtle.y - 1
  end
end

function turtle.turnRight()
  if slurtle.turnRight() then
    turtle.dir = modulus_incr(turtle.dir, 1, #DIRECTIONS)
  end
end

function turtle.turnLeft()
  if slurtle.turnLeft() then
    turtle.dir = modulus_incr(turtle.dir, -1, #DIRECTIONS)
  end
end







