-- program that simply parses and interprets a string (of turtle commands)

local tArgs = {"fd", "5", "bk", "6"}
for i,word in pairs(tArgs) do
  print(word)
end
local string_to_command = {
  
}

local CommandInterpreter = {
  local prev
  local cmds = {}
  
  local function parse(self, item)
    if tonumber(item) then
      self.handle_number(item)
    else
      
      
      self.cmds[#self.cmds+1] = {item, 1}
    
  end
  
  local function handle_number(num)
    
  end
  
  local function execute()
    
  end
}


local fn, args, prev
local stack = {}
function stack:push(a)
  self[#self+1]=a
end
function stack:pop(a)
  local item = self[#self]
  self[#self] = nil
  return item
end

while tArgs do
  local item = tArgs.pop()
  if tonumber(item) and fn then
    -- if given a number, check to see if it can be combined with a prev fn
    local prev = stack:pop()
    
    
  end
  if item in matching then
    stack.push({matching[item], 1})
  end
  
  
end