-- SPEAR: a campaign of the mod's own, listed on GAME MODES. Each mission is a standard .DTE file
-- in the mod's folder, built from mission source with `sltool dte build`. A mission's `as` is the
-- campaign mission it is flown as, its own number in the mode: the ITAC lists the mode's
-- debriefings by it, the loadout offers what the records give for it, and the wing's pilots fly
-- Alpha 2 to 6, as the mode and its records seat them.

local core = require("openreliant.core")
local ui = require("openreliant.ui")

-- The campaign's opening movie, played once each time the campaign starts from its first
-- mission, before that mission's briefing room. The mode's briefing screen plays it and goes
-- straight on to the room: the front end plays the movie as it shows the screen's next frame,
-- and the frame after that asks for the mission. A mission flown again after a loss skips it,
-- and leaving to the main menu starts it afresh. Escape skips the movie.
local intro_movie = "spear_intro.bik"
local intro_played = false

ui.register_screen("intro", {
    frame = function()
        local mission = core.game_mode_mission
        if not mission then
            return
        end
        if mission.place == 1 and not intro_played then
            intro_played = true
            ui.play_movie(intro_movie)
            return
        end
        ui.launch_mission()
    end,
    key = function(key, down)
        if down and key == "escape" then
            ui.go_to("main_menu")
        end
    end,
})

-- The mode. `walk_in` is OpenReliant's walk into the briefing room for game modes, which older
-- engines don't know and refuse the whole definition for: the mode is registered without it
-- then, and the briefing starts in the room.
local definition = {
    name = "spear",
    label = "SPEAR",
    description = "A campaign of its own. The 205th Marauders, on the day the war comes back.",
    missions = {
        {
            number = 301,
            as = 1,
            -- The briefing room's screen plays the mission's hologram, a Bink file of the mod's
            -- (352 by 305, drawn onto the Reliant's screen), then Enriquez says the last word.
            -- Both are placeholders: the hologram a test pattern, the last word the game's own
            -- mission 1 tag.
            hologram = "spear_m01.bik",
            last_word = "ms_speech\\enrbr_tag01.ut",
            objectives = {
                "Launch and follow Corsair to Nav 1",
                "Fly two minutes in formation on Corsair",
                "Jump to Nav 2 and protect the Prowler",
                "Escort Prowler Three to the Richelieu",
                "Jump to Nav 4 and assist the Alliance group",
                "Jump to Nav 6 and protect the convoy",
                "Return to the Richelieu and rearm at the Nanny",
                "Defend the Richelieu",
                "Ask permission to land",
                "Fly to the landing zone",
            },
        },
        {
            number = 302,
            as = 2,
            -- Placeholders too, as mission 1's: the same test pattern, and the game's own
            -- mission 2 tag.
            hologram = "spear_m01.bik",
            last_word = "ms_speech\\enrbr_tag02.ut",
            objectives = {
                "Launch and jump to Forte San Marco",
                "Destroy the Azans and Kurgens attacking the fort",
                "Destroy the Kazan's escort",
                "Disable the Kazan's, then the Murmansk's shield generator and engines",
                "Protect the evacuation for ten minutes",
                "Cover the convoy's departure",
                "Intercept the Sevastopol's torpedoes",
                "Destroy the Sevastopol's Sabres",
                "Jump to the Richelieu and land",
            },
        },
    },
    campaign = true,
    -- The mod's screen before each mission's briefing room: it plays the opening movie.
    briefing = "intro",
    briefing_room = "reliant",
    -- The pilot walks into the room before each briefing, as in the campaign (OpenReliant's
    -- `walk_in`, since 0.17).
    walk_in = true,
    -- The ITAC debriefs each mission before the next one's briefing.
    debriefing = true,
    -- The records the mode changes for its missions (records.luau): the wing's call signs, the
    -- loadout's tier and ships, the pilots of Alpha 5 and 6, and the debriefings.
    records = "records.luau",
    -- The wing is the 205th Marauders': the mod's pilots (mod.ini), with the Marauders' faces on
    -- the radio. Corsair, Fahrenheit and Walk'n fly Alpha 2 to 4 in every mission; Alpha 5 and 6
    -- change from one mission to the next, which the records seat. Grizzly is held back for the
    -- missions' other ships.
    wing_pilots = { "spear:corsair", "spear:fahrenheit", "spear:walkn", "none", "none" },
}
if not pcall(core.register_game_mode, definition) then
    definition.walk_in = nil
    core.register_game_mode(definition)
end

return {
    engine_handlers = {
        -- Out of the mode, back in the main menu, the next campaign start plays the movie again.
        on_frame = function()
            if core.game_mode == nil then
                intro_played = false
            end
        end,
    },
}
