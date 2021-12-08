-- working
peripheral = {}

local example_chest = {
  {name="minecraft:dirt", count=2},
  {name="minecraft:iron_ingot",count=5},
}

local example_scan = {
  {x=5,y=3,z=2,name="minecraft:diamond_ore"},
  {x=5,y=2,z=2,name="minecraft:diamond_ore"},
  {x=5,y=3,z=3,name="minecraft:diamond_ore"},
  {x=5,y=3,z=1,name="minecraft:diamond_ore"},
  {x=1,y=3,z=3,name="minecraft:iron_ore"},
  {x=1,y=3,z=2,name="minecraft:iron_ore"},
  {x=1,y=3,z=4,name="minecraft:iron_ore"},
  
}

function peripheral.getNames()
  return {"top", "bottom", "left", "minecraft:chest_0", "minecraft:chest_1", "right"}
end
function peripheral.call(a,b)
  if b == "list" then
    return example_chest
  end
  if b == "scan" then
    return example_scan
  end
end

textutils = {}
function textutils.serialize()
  
end

shell = {}
function shell.run()
  
end

cc = {shell={completion={}}}


turtle = {}
function turtle.up()
  print("up")
  return true
end
function turtle.down()
  print("down")
  return true
end
function turtle.forward()
  print("forward")
  return true
end
function turtle.back()
  print("back")
  return true
end
function turtle.turnLeft()
  print("turn left")
  return true
end
function turtle.turnRight()
  print("turn right")
  return true
end
function turtle.dig()
  print("dig")
  return true
end

function turtle.digUp()
  print("dig up")
  return true
end

function turtle.digDown()
  print("dig down")
  return true
end

function turtle.select(i)
  print("select "..tostring(i))
  return true
end

function turtle.getItemCount(i)
  print("getItemCount "..tostring(i))
  return math.random(1,10)
end

function turtle.getItemDetail(i)
  print("getItemDetail " .. tostring(i))
  return {name="minecraft:coal", count=63}
end

function turtle.refuel(i)
  print("refuel")
  return true
end

function turtle.getFuelLevel()
  print("getFuelLevel")
  return 1000
end

function turtle.placeDown()
  print("place down")
  return true
end

function turtle.drop()
  print("drop")
  return true
end

function turtle.dropDown()
  print("drop down")
  return true
end

function turtle.inspectDown()
  print("inspect down")
  return false, nil
end