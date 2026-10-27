-- campaign.luau: runs with SPEAR's missions, to keep what the campaign carries from one mission to
-- the next: the Richelieu hits, how many enemy torpedoes have struck the Richelieu, and mission 2's
-- evacuation result. They are kept in the mod's global storage, section `campaign`, written as a
-- mission is won, so that each mission counts only the attempt that won it; records.luau clears
-- the section as the campaign starts from its first mission, and reads it before the later ones.
--
-- A torpedo that strikes a ship which lists components, as the Richelieu does, hits one of its
-- parts as a crash, with the torpedo as the attacker, and is destroyed; one shot down is destroyed
-- by its damage alone. So the Richelieu's component damage from a Coalition torpedo is a hit. The
-- Richelieu is invulnerable, but the hook runs before that is checked. In mission 2 each hit draws
-- the bridge's damage line.
--
-- The missions talk to this script through their PrintShipName command, which they use for
-- nothing else, its second argument a number: 1 asks for this attempt's hits, which the command
-- gives back as its result; 100 plus a number reports how many priority transports mission 2 has
-- saved as its evacuation window ends.

local core = require("openreliant.core")
local hooks = require("openreliant.hooks")
local radio = require("openreliant.radio")
local storage = require("openreliant.storage")
local world = require("openreliant.world")

local MODE = "spear:spear"
-- SPEAR's missions by their files, and the campaign's mission each is.
local MISSIONS = { [301] = 1, [302] = 2 }

local hits = 0
local struck = {}
local saved = nil

-- A salvo's torpedoes strike within moments of each other: the bridge's damage line answers the
-- first, and the hits for the next seconds go without one.
local QUIET = 8
local quiet = 0

hooks.add("component_damage", function(e)
    local torpedo = e.attacker
    if e.object.type ~= "spear:richelieu" or torpedo == nil or torpedo.type ~= "russian_torpedo" then
        return
    end
    if e.kind ~= "crash" or struck[torpedo] then
        return
    end
    struck[torpedo] = true
    hits += 1
    if world.mission.number == 302 and quiet <= 0 then
        quiet = QUIET
        radio.say_pilot("victorious_bridge_officer", "ctl_m2_l13", { mode = "queued" })
    end
end)

hooks.add("vm_command", function(e)
    if e.command ~= "print_ship_name" then
        return
    end
    local code = e.arguments[2]
    if code == 1 then
        e.result = hits
    elseif code >= 100 and code <= 112 then
        saved = code - 100
    end
    return false
end)

-- Grand success with all 12 priority transports saved, Success with 6 to 11, Failure with fewer.
local function evacuation_result(count)
    if count == 12 then
        return "grand_success"
    elseif count >= 6 then
        return "success"
    end
    return "failure"
end

-- A mission is won when it goes on to the next: not with the player's ship destroyed, the pilot
-- captured or sent home, a total failure, or the mission left from the pause menu.
local LOST = { destroyed = true, captured = true, friendly_fire = true, total_failure = true, left = true }

hooks.add("mission_ended", function(e)
    local mission = MISSIONS[world.mission.number]
    if core.game_mode ~= MODE or mission == nil then
        return
    end
    if LOST[e.ending] or e.rating == "total_failure" then
        return
    end
    local campaign = storage.global_section("campaign")
    local each = campaign.hits or {}
    each[mission] = hits
    campaign.hits = each
    local total = 0
    for _, count in each do
        total += count
    end
    campaign.richelieu_hits = total
    if mission == 2 and saved ~= nil then
        campaign.transports_saved = saved
        campaign.evacuation_result = evacuation_result(saved)
    end
end)

return {
    engine_handlers = {
        on_update = function(seconds)
            if quiet > 0 then
                quiet -= seconds
            end
        end,
    },
}
