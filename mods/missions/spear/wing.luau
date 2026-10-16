-- wing.luau: runs with mission 301, to keep the 205th Marauders' pilots alive. They are the story's
-- main characters, and none of them is to be lost in this mission: their ships take hits and wear
-- down as any other, but their armour stops wearing once their hull is down to 30%, and should a
-- single hit take it the rest of the way, the ship is not destroyed. The player's ship is not one
-- of them.

local hooks = require("openreliant.hooks")

local FLOOR = 0.3

-- Whether `object` is one of the mod's pilots' ships, the player's apart.
local function marauder(object)
    if object.is_player then
        return false
    end
    local pilot = object.pilot
    return type(pilot) == "string" and string.sub(pilot, 1, 6) == "spear:"
end

hooks.add("object_armor_damage", function(e)
    if marauder(e.object) and e.object.hull ~= nil and e.object.hull <= FLOOR then
        return false
    end
end)

hooks.add("object_destroyed", function(e)
    if marauder(e.object) then
        return false
    end
end)
