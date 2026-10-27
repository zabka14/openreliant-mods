-- records.luau: the records SPEAR changes for its own missions alone; the game mode runs it before
-- each of them, and the changes go back as the mission ends. Each SPEAR mission flies as the
-- campaign's mission after its own number (menu.luau): mission 1 as 2, mission 2 as 3, mission 3
-- as 4. So what the game reads by that number is set there: the loadout's ships, the pilots of
-- Alpha 5 and 6, the launch's date and the debriefing.

local core = require("openreliant.core")
local records = require("openreliant.records")
local storage = require("openreliant.storage")

-- The SPEAR mission next, from 1, and the campaign's mission it flies as.
local place = core.game_mode_mission and core.game_mode_mission.place or 1
local flown_as = place + 1

-- What the campaign carries from one mission to the next (campaign.luau): the Richelieu hits and
-- mission 2's evacuation result. A run from the first mission starts afresh.
local campaign = storage.global_section("campaign")
if place == 1 then
    local kept = {}
    for name in campaign do
        table.insert(kept, name)
    end
    for _, name in kept do
        campaign[name] = nil
    end
end

-- The loadout opens the ships of the highest tier the campaign's missions before the number a
-- mission flies as give, and those the player's rank opens. Campaign mission 1, the empty slot
-- before SPEAR's first, gives tier 1: the Predator, Naginata, Grendel, Crusader, Coyote, Mirage and
-- Tempest, with the tier's missiles. Mission 1 offers the Mirage alone, the Marauders' standard
-- fighter, which the tier loads. Mission 3 offers what mission 2's evacuation result earned: tier
-- 2 for a Grand success, tier 1 for a Success, the Mirage alone for a Failure.
records.missions[1].tier = 1
if place == 1 then
    records.missions[flown_as].only_ship = "mirage"
elseif place == 3 then
    local result = campaign.evacuation_result
    if result == "grand_success" then
        records.missions[1].tier = 2
    elseif result == "failure" then
        records.missions[flown_as].only_ship = "mirage"
    end
end

-- Alpha 5 and 6, whom the mode's wing leaves to each mission: Pitbull and Stardust in mission 1,
-- Rook and Mako, new to the squadron, in mission 2.
if place == 1 then
    records.missions[flown_as].alpha_5_pilot = "spear:pitbull"
    records.missions[flown_as].alpha_6_pilot = "spear:stardust"
elseif place == 2 then
    records.missions[flown_as].alpha_5_pilot = "spear:rook"
    records.missions[flown_as].alpha_6_pilot = "spear:mako"
end

-- The launch shows the date of the campaign's mission 1, the day the war comes back, as SPEAR's
-- first two missions are flown on it.
if place <= 2 then
    records.missions[flown_as].date = records.missions[1].date
end

-- The call signs the comms menu gives the places of the wing, after each pilot's name: the game
-- calls the sixth place Alpha Leader. In SPEAR, Corsair leads the patrol from the second place, so
-- his place is Alpha Leader and the sixth is Alpha 6. (The first place is the player's, which the
-- menu never lists.)
records.text[339] = "Alpha Leader"
records.text[343] = "Alpha 6"

-- The ITAC's debriefings, which the missions flown as 2 and 3 have: the Marauders' squadron
-- commander's, not Enriquez's, so the header names the commander in her place. Every way mission
-- 1 ends rates it a success.
records.itac_text[10] = "SQUADRON COMMANDER"
records.missions[2].debriefing = {
    success = {
        "The Captain is pleased with the Marauders' performance today. What began as a routine patrol and formation exercise quickly turned into a series of desperate engagements. Your flight responded well to the changing situation and helped protect Alliance personnel and assets under attack.",
        "Prowler Three made it safely back to the Richelieu, and your actions at Nav Point Six allowed the surviving convoy vessels to withdraw. You also helped repel the attack on the Richelieu herself. The carrier sustained damage, but she remains operational. Considering how quickly the situation deteriorated, this is a good result.",
        "Unfortunately, we were too late to help the Alliance group at Nav Point Four. The entire group had been destroyed before we reached the engagement area, and no survivors have been confirmed. We still don't know how many ships and personnel have been lost across the sector. Command is working to establish the full extent of the damage.",
        "What happened today was no isolated incident. Coalition forces launched coordinated attacks across the Sol System while the Treaty of Balma was supposed to bring the fighting to an end. The timing leaves little doubt that the Coalition used the peace negotiations to its advantage, striking while Alliance forces were standing down in anticipation of the ceasefire.",
        "The Coalition has betrayed the negotiations. The Treaty of Balma is dead, and the war has resumed. Whatever chance we had for a peaceful settlement is gone.",
        "For now, the Richelieu remains on station, and the 205th Marauders will stay assigned to the carrier until Command issues further orders. We can expect things to get a lot harder from here. The Alliance has been caught off guard, and we don't yet know the full strength of the attack we're facing.",
        "You did well out there today, pilot. Be proud of that, but don't let it make you complacent. We've lost good people already, and there will be more hard days ahead. Get some rest while you can, and stay ready. I doubt we'll have much time to catch our breath.",
        "We also managed to recover some equipment from a few of the transports you helped save. It's not much, and supplies remain scarce, but we've salvaged enough to give you access to a limited selection of fighters for your next mission. Make your choice carefully. We won't have many spares to fall back on.",
        "Squadron Commander",
    },
}

-- Mission 2 rates itself by its evacuation result and by whether any original defender jumped
-- out with the convoy: a Grand success (all 12 priority transports saved) is a success with its
-- bonus with the defenders and a success without them, a Success (6 to 11) a partial success with
-- them and a partial failure without, and a Failure (fewer) a failure, whatever the defenders.
records.missions[3].debriefing = {
    success_bonus = {
        "Marauders, the operation at Forte San Marco is complete.",
        "All twelve priority transports survived the evacuation window. The evacuation was a complete success, and the original defenders of the installation survived the attack.",
        "Unfortunately, Forte San Marco itself has been lost and must be abandoned. Nevertheless, the personnel and equipment recovered from the operation will provide a valuable contribution to the war effort.",
        "Your performance has secured additional equipment and fighter options for the next operation.",
        "The Richelieu is resuming its course toward Neptune. Stand by for your next assignment.",
        "Squadron Commander",
    },
    success = {
        "Marauders, the operation at Forte San Marco is complete.",
        "All twelve priority transports survived the evacuation window. The evacuation was a complete success, and a substantial amount of personnel and equipment has been recovered.",
        "However, the original defenders of the installation did not survive the attack. Forte San Marco has been lost and must be abandoned.",
        "Despite these losses, your performance has secured additional equipment and fighter options for the next operation.",
        "The Richelieu is resuming its course toward Neptune. Stand by for your next assignment.",
        "Squadron Commander",
    },
    partial_success = {
        "Marauders, the operation at Forte San Marco is complete.",
        "The evacuation was partially successful. Several priority transports were lost during the operation, but a portion of the personnel and equipment assigned to the evacuation was recovered. The original defenders of the installation also survived the attack.",
        "Forte San Marco itself has been lost and must be abandoned. The losses sustained during the evacuation mean that we cannot count on additional equipment for the next operation.",
        "Your fighter selection for Mission 3 will remain unchanged.",
        "The Richelieu is resuming its course toward Neptune. Stand by for your next assignment.",
        "Squadron Commander",
    },
    partial_failure = {
        "Marauders, the operation at Forte San Marco is complete.",
        "The evacuation was partially successful. Several priority transports were lost during the operation, but a portion of the personnel and equipment assigned to the evacuation was recovered.",
        "The original defenders of the installation did not survive the attack. Forte San Marco has been lost and must be abandoned.",
        "The losses sustained during the operation mean that we cannot count on additional equipment for the next mission. Your fighter selection for Mission 3 will remain unchanged.",
        "The Richelieu is resuming its course toward Neptune. Stand by for your next assignment.",
        "Squadron Commander",
    },
    failure = {
        "Marauders, the operation at Forte San Marco is complete.",
        "The evacuation suffered catastrophic losses. Seven or more of the twelve priority transports were destroyed during the operation, and the personnel and equipment recovered fall far short of what was required.",
        "Forte San Marco has been lost and must be abandoned.",
        "Our losses have severely restricted the resources available for the next operation. For Mission 3, the Mirage will be the only available fighter.",
        "The Richelieu is resuming its course toward Neptune. Stand by for your next assignment.",
        "Squadron Commander",
    },
}
