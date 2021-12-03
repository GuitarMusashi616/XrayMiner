peripheral = {}
peripheral.call = function(a, b) print("peripheral.call(" .. tostring(a) .. ", " .. tostring(b) ..")") return {name="lemon", count=5} end
peripheral.getType = function(a) return "minecraft:chest" end

local height = 1
turtle = {}
turtle.detectDown = function() print("turtle.detectDown()") return height == 1 end
turtle.up = function() print("turtle.up()") height = height + 1 end
turtle.down = function() print("turtle.down()") height = height - 1 end