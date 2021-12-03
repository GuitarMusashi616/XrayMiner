-- view function that lets you look inside a table (while using console)
-- uses a recursive table serialize that includes functions 


local Slicer = {}

function Slicer:new(tbl, start, stop, inc)
    -- return a dictionary with data members and references to functions
    local ins = {}

    
    ins.tbl = tbl
    ins.start = start or 1
    ins.stop = stop or 1/0
    ins.inc = inc or 1
    ins.prev_k = nil
    ins.i = 1
    setmetatable(ins, self)
    self.__index = self
    return ins
end

function Slicer:slice()
  local new_tbl = {}
  while true do
    local k,v = self:next_inc_item()
    if not k then
      break
    end
    
    if self.start <= self.i and self.i <= self.stop then
      new_tbl[k] = v
    else
      break
    end
  end
  return new_tbl
end

function Slicer:next_inc_item()
  while self.i % self.inc ~= 0 do
    self:next_item()
  end
  return self:next_item()
end

function Slicer:next_item()
  local k,v = next(self.tbl, self.prev_k)
  self.i = self.i + 1
  return k,v
end


function slice(tbl, start, stop, inc)
    stop = stop or #tbl
    start = start or 1
    inc = inc or 1
    
    local new_tbl = {}
    local skips = start - 1
    local k,v = next(tbl)
    local i = start
    
    
    while k and i <= stop do
      if i%inc == 0 then
          new_tbl[k] = v 
      end
      k,v = next(tbl, k)
      i = i + 1
    end
    return new_tbl    
end


function slice2(tbl, start, stop, inc)
  local slicer = Slicer:new(tbl, start, stop, inc)
  return slicer:slice()
end

local tbl = {thing=4, stuff=6, happy=8}
for i,v in pairs(slice2(tbl,1,3)) do
    print(i,v)
end