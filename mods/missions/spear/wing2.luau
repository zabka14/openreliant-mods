-- wing2.luau: runs with mission 302, to keep the 205th Marauders' main characters alive, as
-- wing.luau does in mission 301: every one of the mod's pilots but Rook and Mako, the new pilots in
-- Alpha 5 and 6, wears down to 30% of the hull and is never destroyed. Rook and Mako can be lost,
-- and each says a line of his or her own as it happens. The player's ship is not one of them.
--
-- A dying ship says nothing, so the line is said through the pilot, with the pilot's dying face.
-- The game's own last words for their voices as a wingman is lost (`cutdth_001`, Rook's, and
-- `fladth_001`, Mako's) would double it, so they are dropped: no other pilot in the mission speaks
-- with those voices. Moose's remark on the loss after them stays.

local hooks = require("openreliant.hooks")
local radio = require("openreliant.radio")

local FLOOR = 0.3

-- The pilots who can be lost, and the line each says.
local LOSABLE = {
    ["spear:rook"] = "rok_m2_l1",
    ["spear:mako"] = "mak_m2_l1",
}

local lost = {}

-- Whether `object` is one of the mod's protected pilots' ships, the player's apart.
local function protected(object)
    if object.is_player then
        return false
    end
    local pilot = object.pilot
    return type(pilot) == "string" and string.sub(pilot, 1, 6) == "spear:" and LOSABLE[pilot] == nil
end

hooks.add("object_armor_damage", function(e)
    if protected(e.object) and e.object.hull ~= nil and e.object.hull <= FLOOR then
        return false
    end
end)

hooks.add("object_destroyed", function(e)
    if protected(e.object) then
        return false
    end
end)

-- The line comes with the ship's Destroyed, which every way of losing it posts.
hooks.add("destroyed", function(e)
    local object = e.object
    if e.component ~= nil or object.is_player then
        return
    end
    local line = LOSABLE[object.pilot]
    if line and not lost[object.pilot] then
        lost[object.pilot] = true
        radio.say_pilot(object.pilot, line, { face = "dying" })
    end
end)

hooks.add("radio_say", function(e)
    local speech = string.lower(e.speech)
    if string.find(speech, "cutdth_", 1, true) or string.find(speech, "fladth_", 1, true) then
        return false
    end
end)
