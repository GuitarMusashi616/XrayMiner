peripheral = {}

local example_chest = {
  {name="minecraft:dirt", count=2},
  {name="minecraft:iron_ingot",count=5},
}

function peripheral.getNames()
  return {"top", "bottom", "left", "minecraft:chest_0", "minecraft:chest_1", "right"}
end
function peripheral.call(a,b)
  if b == "list" then
    return example_chest
  end
end

textutils = {}
function textutils.serialize()
  
end

shell = {}
function shell.run()
  
end

cc = {shell={completion={}}}