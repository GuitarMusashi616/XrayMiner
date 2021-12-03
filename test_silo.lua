require("silo")
require("peripheral_silo")

function test_begins_with()
  local tbl = {"bottom", "minecraft:chest_7", "top", "right", "minecraft:chest_0", "left"}
  for name in all(tbl) do
    if beginsWith(name, "minecraft:chest") then
      print(name)
    end
  end
end

