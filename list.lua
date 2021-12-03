-- python list class for lua


function assertEqual(left, right)
  --if left ~= right then
    --print(tostring(left) .. " != " .. tostring(right))
  --end
  assert(left == right, tostring(left) .. " != " .. tostring(right))
end

function assertNotEqual(left, right)
  if left == right then
    print(tostring(left) .. " == " .. tostring(right))
  end
end

function assertListEqual(left, right)
  if #left ~= #right then
    assert(false, tostring(left) .. " != " .. tostring(right))
  end
  for i=1,#left do
    if left[i] ~= right[i] then
      assert(false, tostring(left) .. " != " .. tostring(right))
    end
  end
end

function assertListNotEqual(left, right)
  
end

local function test()
  stuff = List(5,4,3,2,1)
  stuff.append(4)
  stuff.pop(0)
  stuff.pop()
  
end


local function test_assert_equal() 
  assertEqual(5,4)
  assertEqual(5,5)
end

local function test_assert_list_equal()
  local ls1 = {5,4,3,2,1}
  local ls2 = {5,4,3,2,1}
  local ls3 = {5,6,3,2,2}
  assertListEqual(ls1, ls3)
  
end


test_assert_list_equal()