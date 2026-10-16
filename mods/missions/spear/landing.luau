-- landing.luau: runs with mission 301, to tie the mission's end to PERMISSION TO LAND.
--
-- The player asks PERMISSION TO LAND as in any mission, and the bridge answers: once the mission
-- sets `landing_cleared`, the request gives the player's ship a Land order aimed at the Richelieu
-- as a whole. This script refuses that order, so that the ship flies on to the recovery point
-- first, and notes the request: it holds the mission's "Await landing request" part, which waits
-- on a PrintDebugMessage command the mission uses for nothing else, until the request has come.
-- The mission then lands the ship itself, with a Land order aimed at the Richelieu's bay 0 (its
-- component 0), which the script lets through: OpenReliant flies the ship into the bay and ends
-- the mission.

local hooks = require("openreliant.hooks")

local requested = false

-- The player's ship is given a Land order. The request's names no bay: it is refused and noted.
-- The mission's names bay 0, and goes through.
hooks.add("order_push", function(e)
    if e.order ~= "land" or not e.object.is_player then
        return
    end
    if e.target.component == nil then
        requested = true
        return false
    end
end)

-- The mission's debug message command is held until the request has come, then runs.
hooks.add("vm_command", function(e)
    if e.command == "print_debug_message" and not requested then
        e.result = "hold"
        return false
    end
end)

-- The bridge's answers are the Reliant's lines, said with the Reliant's bridge officer's face. The
-- Richelieu's officer, the Victorious', speaks them here.
hooks.add("radio_say", function(e)
    if string.find(e.speech, "_lnd_", 1, true) then
        e.film = "pilots\\Victorious_Brdge_Off.fm8"
    end
end)
