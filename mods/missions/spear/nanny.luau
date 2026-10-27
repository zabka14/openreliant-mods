-- nanny.luau: runs with mission 301, so that the Nanny repairs the player's ship as well as
-- rearming it.
--
-- The mission takes the player's ship aboard the Nanny with a Dock order, which OpenReliant flies
-- as the game does: the ship goes in at the bow, has its missiles, countermeasures, afterburner
-- fuel and guns refilled, and comes out astern, which posts its Docked. The game's Nanny leaves the
-- hull and the shields as they are. This script notes the ship's armour as it launches, when it is
-- whole, and gives it back as the ship's Docked comes, with its shields full.

local hooks = require("openreliant.hooks")
local records = require("openreliant.records")

local whole_armor = nil

hooks.add("launched", function(e)
    if e.object.is_player and whole_armor == nil then
        whole_armor = e.object.armor
    end
end)

hooks.add("docked", function(e)
    local ship = e.object
    if not ship.is_player then
        return
    end
    if whole_armor then
        ship.armor = whole_armor
    end
    -- A quadrant's full shields are six times the ship's shield power; the object takes up to one
    -- less.
    local full = records.ships[ship.type].shield_power * 6 - 1
    ship.shields = { left = full, right = full, fore = full, aft = full }
end)
