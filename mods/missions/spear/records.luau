-- records.luau: the records SPEAR changes for its own missions alone; the game mode runs it before
-- each of them, and the changes go back as the mission ends.

local records = require("openreliant.records")

-- The call signs the comms menu gives the places of the wing, after each pilot's name: the game
-- calls the sixth place Alpha Leader. In SPEAR, Corsair leads the patrol from the second place, so
-- his place is Alpha Leader and the sixth is Alpha 6. (The first place is the player's, which the
-- menu never lists.)
records.text[339] = "Alpha Leader"
records.text[343] = "Alpha 6"
