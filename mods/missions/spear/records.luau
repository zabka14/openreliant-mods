-- records.luau: the records SPEAR changes for its own missions alone; the game mode runs it before
-- each of them, and the changes go back as the mission ends.

local records = require("openreliant.records")

-- The call signs the comms menu gives the places of the wing, after each pilot's name: the game
-- calls the sixth place Alpha Leader. In SPEAR, Corsair leads the patrol from the second place, so
-- his place is Alpha Leader and the sixth is Alpha 6. (The first place is the player's, which the
-- menu never lists.)
records.text[339] = "Alpha Leader"
records.text[343] = "Alpha 6"

-- The ITAC's debriefing of mission 1, which SPEAR's mission 301 flies as: every way it ends rates
-- it a success. The debriefing is the Marauders' squadron commander's, not Enriquez's, so the
-- header names the commander in her place.
records.itac_text[10] = "SQUADRON COMMANDER"
records.missions[1].debriefing = {
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
