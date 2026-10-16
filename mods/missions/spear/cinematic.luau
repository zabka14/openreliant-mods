-- cinematic.luau: runs with mission 301, to put the player's ship in its place behind Corsair while
-- the director's camera shows the wing in formation, halfway through the exercise at Nav 1.
--
-- A player's ship refuses the orders that would fly it there, Escort and Object Attach among them,
-- so this script puts it there itself as the camera's shot starts: 4000 behind Corsair and 600
-- above him, as the mission's escort point stands, turned as he is, with his velocity and his
-- throttle. Corsair flies straight on through the shot, so the ship flies on along with him. The
-- player's controls are held for as long as the shot lasts, so that the ship keeps his speed and
-- heading, and the player flies it again once the shot is over, from there.
--
-- The mission starts two shots: the launch's, while the player's ship follows its Launch order,
-- and the cinematic's, while the player flies. Only the second puts the ship in its place, and
-- holds the controls for the shot's seconds, its third argument.

local hooks = require("openreliant.hooks")
local world = require("openreliant.world")

local BACK = 4000
local UP = 600

local holding = 0

local function find_corsair()
    for _, object in world.objects() do
        if object.pilot == "spear:corsair" then
            return object
        end
    end
    return nil
end

hooks.add("vm_command", function(e)
    if e.command ~= "start_director_cam" then
        return
    end
    local player = world.player
    if not player or player.order ~= "player_control" then
        return
    end
    local corsair = find_corsair()
    if not corsair then
        return
    end
    local axes = corsair.orientation
    player.position = corsair.position - axes.forward * BACK - axes.down * UP
    player.orientation = axes
    player.velocity = corsair.velocity
    player.throttle = corsair.throttle
    player.roll_input = 0
    player.pitch_input = 0
    player.yaw_input = 0
    holding = e.arguments[3]
end)

-- The player's controls are held while the shot lasts.
hooks.add("player_controls", function(e)
    if holding > 0 then
        return false
    end
end)

return {
    engine_handlers = {
        on_update = function(seconds)
            if holding > 0 then
                holding -= seconds
            end
        end,
    },
}
