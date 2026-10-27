-- SPEAR mission 1 (mission301): the patrol launches from the Richelieu and jumps to Nav 1, where
-- the player flies two minutes in formation on Corsair while he makes a few slow turns. The
-- bridge then breaks off the exercise: the wing jumps to Nav 2 to save a Prowler shuttle from
-- Coalition fighters, brings it home, jumps to Nav 4 to find an Alliance group destroyed and its
-- attackers still there, jumps to Nav 6 to cover a convoy's escape, and comes home, where the
-- bridge warns of an attack on its way and the Nanny stands by to rearm the player. Coalition
-- fighters then jump in to attack the Richelieu, and once they are down, two Kamov bombers jump in
-- far off to torpedo it. Once they are destroyed or gone, the player lands on the Richelieu,
-- which ends the mission.
--
-- The Richelieu is the mod's own carrier: ship type 300 of the manifest, a copy of the Victorious
-- under its own name, so the display calls it RICHELIEU and the game's Victorious stays as it is.
-- Its hangar bays and its launch are the Victorious'.
--
-- The Richelieu stands at the origin, facing along Z. Nav 1 lies 3,900,000 ahead and to the
-- right, well out of the carrier's sphere, so the wing jumps there as mission 1 of the campaign
-- jumps to its convoy; Nav 2, 4 and 6 lie as far off. The jumps home come out at a waypoint
-- 140,000 astern of the Richelieu.
--
-- The wing launches from the bow bays and comes home to the stern ones. The mission ends with a
-- landing: once the player has asked PERMISSION TO LAND and reached the recovery point astern of
-- the carrier, the mission gives the player's ship a Land order at bay 0, and OpenReliant lands it
-- as it lands in any hangar bay: the camera cuts away, the ship flies in at the bay's doors by
-- itself, and the mission is over once it is down in the bay. (The game itself has landings for
-- the Reliant and the Yamato alone; the bay landing is OpenReliant's.)
--
-- SPEAR's missions are numbered from 301: the installed mods already take 91 and 92 (the prequel)
-- and 970 to 994, and a mod's mission replaces another's with the same number.
--
-- Build: sltool dte build mission301.mission.luau mission301.dte

mission({ name = "Spear 1: First Blood" })

-- The mission's phase, which says where the next jump goes and what the arrival brings: 0 to
-- Nav 1, 1 to Nav 2, 2 home with the Prowler, 3 to Nav 4, 4 to Nav 6, 5 home to the attack, and
-- 6 once the attack is beaten, for the landing. The player's jump and arrival triggers read it.

phase = global("(GV)phase", 0)

-- Whether the player has asked PERMISSION TO LAND and the bridge has cleared the ship: only then
-- does reaching the recovery point end the mission.

cleared_to_land = global("(GV)cleared to land", 0)
-- How many of the two things the jump waits on are done: the launch, and the patrol's chatter
-- over it. The jump drive comes online once both are.
ready_steps = global("(GV)ready steps", 0)
-- The formation exercise at Nav 1: whether it runs, whether the player's ship was seen in its
-- place in the last second, how many seconds it has flown there, and how many seconds it has
-- been out of it since it last was, and how many seconds the exercise has run.
formation_on = global("(GV)formation on", 0)
in_slot = global("(GV)in slot", 0)
formation_seconds = global("(GV)formation seconds", 0)
drift_seconds = global("(GV)drift seconds", 0)
formation_elapsed = global("(GV)formation elapsed", 0)
-- Whether the radio's chatter is on, so that Corsair's other lines wait for it to end, and
-- whether the halfway lines have been said.
radio_busy = global("(GV)radio busy", 0)
halfway_said = global("(GV)halfway said", 0)
-- Whether the halfway cinematic runs, which holds Corsair's route.
cinema_on = global("(GV)cinema on", 0)
-- Whether the player's ship matches Corsair's speed, which reaching its place turns on.
matching = global("(GV)matching", 0)
-- How many hostiles have been shot down at each fight: Nav 2, Nav 4 (both waves), Nav 6, home.
nav2_kills = global("(GV)nav 2 kills", 0)
nav4_kills = global("(GV)nav 4 kills", 0)
nav6_kills = global("(GV)nav 6 kills", 0)
home_kills = global("(GV)home kills", 0)
-- The Nanny's rearming before the attack at home: 0 until the bridge offers it, 1 while the Nanny
-- waits for the player, 2 while the player's ship is aboard, and 3 once the attack is on its way.
nanny_state = global("(GV)nanny state", 0)
-- The bombers' wave after the fighters at home: whether each Kamov is still in the fight (1 from
-- its jump in, 0 once destroyed or gone), whether the bridge has called the torpedoes, how many
-- Kamovs are out of it, how many torpedoes are flying, and whether the attack is over.
kamov_a_on = global("(GV)kamov A on", 0)
kamov_b_on = global("(GV)kamov B on", 0)
torpedoes_called = global("(GV)torpedoes called", 0)
bombers_out = global("(GV)bombers out", 0)
torpedoes_flying = global("(GV)torpedoes flying", 0)
attack_done = global("(GV)attack done", 0)
-- How many of the Kamovs' torpedoes struck the Richelieu, as campaign.luau counts them: the
-- campaign's first Richelieu hits, which the script keeps as the mission is won.
richelieu_hits = global("(GV)richelieu hits", 0)

-- Flight groups. The player's own is listed in the player's wing.

alpha = flight_group("(FG)Alpha", { wing = "player" })
carrier_group = flight_group("(FG)Richelieu")
shuttle_group = flight_group("(FG)Shuttle")
jump_points = flight_group("(FG)Jump points")
home_points = flight_group("(FG)Home points")
zone_points = flight_group("(FG)Zone points")
formation_points = flight_group("(FG)Formation points")
planets = flight_group("(FG)Planets")
prowler_three = flight_group("(FG)Prowler Three")
prowler_marks = flight_group("(FG)Prowler marks")
nav2_raiders = flight_group("(FG)Nav 2 raiders")
prowler_home = flight_group("(FG)Prowler home")
nav4_wreckage = flight_group("(FG)Nav 4 wreckage")
nav4_wave_a = flight_group("(FG)Nav 4 wave A")
nav4_wave_b = flight_group("(FG)Nav 4 wave B")
nav4_patrol = flight_group("(FG)Nav 4 patrol")
home_convoy = flight_group("(FG)Home convoy")
nav6_convoy = flight_group("(FG)Nav 6 convoy")
nav6_raiders = flight_group("(FG)Nav 6 raiders")
home_attackers = flight_group("(FG)Home attackers")
home_bombers = flight_group("(FG)Home bombers")
home_torpedoes = flight_group("(FG)Home torpedoes")

-- Ships. The first ship is the player's. The wing is six Mirages, the Marauders' fighter, and the
-- Richelieu has four launch points (`sltool shp info Victorious.SHP`): gates 0 and 1 in the stern
-- bays, which open astern, and gates 2 and 3 in the bow bays, which open ahead. The wing launches
-- through the bow bays, towards Nav 1, in three waves of two: the player and Alpha 2 first, then
-- each pair once the pair before has cleared the gates, since a pair launching from both ends of
-- the ship would have to fly through the hull to form up. Alpha 3 to 6 are declared without a
-- launch, parked far astern and disabled until their turn, when `SetupLaunch` puts them at their
-- gate. The Richelieu's type is the mod's, by its number in the manifest, which OpenReliant
-- replaces with the number it gives the type as it loads the mission. The wingmen's pilots are the
-- mod's Marauders by their manifest numbers too; flown from the SPEAR game mode, the mode's wing
-- seats the same pilots in Alpha 2 to 6.

player = ship("Player", {
    type = "mirage",
    group = alpha,
    launch = { from = 300, gate = 3 },
})
a2 = ship("(A2)Mirage", {
    type = "mirage",
    group = alpha,
    pilot = 240,
    launch = { from = 300, gate = 2 },
})
a3 = ship("(A3)Mirage", {
    type = "mirage",
    group = alpha,
    pilot = 241,
    position = { 40000, 0, -700000 },
})
a4 = ship("(A4)Mirage", {
    type = "mirage",
    group = alpha,
    pilot = 242,
    position = { -40000, 0, -700000 },
})
a5 = ship("(A5)Mirage", {
    type = "mirage",
    group = alpha,
    pilot = 243,
    position = { 40000, 0, -720000 },
})
a6 = ship("(A6)Mirage", {
    type = "mirage",
    group = alpha,
    pilot = 244,
    position = { -40000, 0, -720000 },
})

-- The wingmen as one, for their orders, and the four who follow Corsair, Alpha 2, who leads the
-- patrol: the player flies as one of the patrol, behind Corsair, not as its leader.

escorts = squad("(AI)Escorts", { a2, a3, a4, a5, a6 })
followers = squad("(AI)Followers", { a3, a4, a5, a6 })

richelieu = ship("The Richelieu", {
    type = 300,
    group = carrier_group,
    -- The Victorious' bridge officer, whose face the radio shows when the bridge speaks.
    pilot = "victorious_bridge_officer",
})

-- The ships that sail with the Richelieu, in its flight group, so that they set off with it at
-- its speed and on its heading, and are left out of the mission's work with it while the wing
-- is at Nav 1. They stand clear of the bow bays' launch axes and of the way astern to the
-- recovery point: the Richelieu is about 80,000 long and reaches 21,000 to its left and 77,000
-- to its right (`sltool shp info Victorious.SHP`), the Mammoth and the Nanny about 20,000 long,
-- the Prowler 6000. The Mammoth sails off the carrier's left side, a little below it, the Nanny
-- off its right, and the Prowler above and astern of it on its left, each close enough to be
-- seen beside it.

mammoth = ship("Mammoth", {
    type = "mammoth",
    group = carrier_group,
    position = { -48000, 10000, -5000 },
})
nanny = ship("Nanny", {
    type = "nanny",
    group = carrier_group,
    position = { 105000, -6000, -20000 },
})
prowler = ship("Prowler", {
    type = "prowler",
    group = carrier_group,
    position = { -42000, -16000, -55000 },
})

-- A Lonestar shuttle that leaves the carrier as the wing launches: it starts off its right side,
-- above it, flies slowly away to the right and astern, and jumps out.

lonestar = ship("Lonestar", {
    type = "lonestar",
    group = shuttle_group,
    position = { 50000, -14000, -25000 },
    yaw = 120,
})

-- Markers near the Richelieu: where the jump home comes out, the recovery point the player flies
-- to, and where the wingman waits meanwhile. The stern bays open astern, so the wing comes home
-- astern of the carrier, and the recovery point stands in the axis of bay 0, the one the player
-- lands in: its launch point lies at x = -12867, 4057 below the carrier's axis, and the bay's
-- mouth 36,963 astern of the carrier's origin. The recovery point stands 16,000 astern of the
-- mouth, right where the bay landing's cutaway sets the ship before it flies in (OpenReliant logs
-- the place in a debug build: `the ship set at (...)`), so that the landing carries on from where
-- the player has flown to. The Victorious' model reaches 77,000 to one side (`sltool shp info
-- Victorious.SHP`): a nav point inside the hull can never be reached.
--
-- The home points ride the carrier (`object_attach`), which turns them as it is turned. The jump
-- point stays on its own, so that the wing comes out of the jump facing the carrier, as its yaw
-- says. The carrier flies at a tenth of its speed, so the jump point hardly drifts from it.

jump_home_point = waypoint("Jump home point", {
    group = jump_points,
    position = { 0, 0, -140000 },
})
-- Where the camera stands for the launch: ahead of the bow, a little below the bays, so that the
-- fighters come out of the bow doors towards it and pass it. The bow bays' launch points lie at
-- x = -12658 (gate 3) and 12382 (gate 2), 17325 ahead of the carrier's origin and 4000 below its
-- axis, and the bow ends 45000 ahead of the origin.
launch_camera = point("Launch camera", {
    group = jump_points,
    position = { -3000, 9000, 69000 },
})
test_view = waypoint("Test view", {
    group = jump_points,
    position = { -12867, 4057, -66000 },
})
recovery_point = nav_point("Recovery point", {
    group = home_points,
    position = { -12867, 4057, -53000 },
})
wingman_hold = waypoint("Wingman hold", {
    group = home_points,
    position = { -24000, 0, -90000 },
})
-- Where the player flies to rearm at the Nanny: 21,000 ahead of it, where its Dock order begins
-- the way in, as mission 10's dock point stands ahead of its Nanny. It rides the carrier with the
-- other home points, as the Nanny sails with it; its ShipReached trigger, within 4000, takes the
-- player aboard.
nanny_approach = nav_point("Nanny approach", {
    group = home_points,
    position = { 105000, -6000, 1000 },
})
-- Where `--part "test convoy"` looks at the carrier and the ships about it from: off its right
-- side, astern and above it.
convoy_view = point("Convoy view", {
    group = jump_points,
    position = { 90000, -70000, -230000 },
})
-- Where the Lonestar shuttle flies off to before it jumps out, far off the carrier's right side,
-- astern and above it.
shuttle_away = waypoint("Shuttle away", {
    group = jump_points,
    position = { 400000, -60000, -250000 },
})
-- Where each wingman flies to as it comes out of its bay, while the rest of the wing launches:
-- far ahead of the bow and above the carrier's axis, out of the way of the bays' launch axes,
-- which the waves after it come out along. Each flies there at 130 a step, a fifth of a
-- fighter's top speed, and is still on the way when the wing sets off, so that none slows down
-- or circles round it. Each wingman has a point of its own, 5000 from the next, so that none
-- flies into another: Corsair in the middle, the others on the sides the Formation order puts
-- them on once the wing sets off, the first to his left, the next to his right, and so on.
form_up_point = waypoint("Form up point", {
    group = home_points,
    position = { 0, 25000, 400000 },
})
a3_form_up = waypoint("A3 form up", {
    group = home_points,
    position = { -5000, 25000, 400000 },
})
a4_form_up = waypoint("A4 form up", {
    group = home_points,
    position = { 5000, 25000, 400000 },
})
a5_form_up = waypoint("A5 form up", {
    group = home_points,
    position = { -10000, 25000, 400000 },
})
a6_form_up = waypoint("A6 form up", {
    group = home_points,
    position = { 10000, 25000, 400000 },
})

-- Mars, Realistic Planets' (type 301 in mod.ini), close ahead of the Richelieu, a little to the
-- left and below the course, 2,480,000 from it: with its radius of 1,280,000 it fills much of the
-- sky as the wing launches towards it. A planet collides with nothing and is always drawn.

mars = ship("Mars", {
    type = 301,
    group = planets,
    position = { -900000, 700000, 2200000 },
})

-- The zone: Nav 1, ahead and to the right of the Richelieu, 3,560,000 from Mars, too far for a
-- fighter to fly to it. The wing comes out of the jump facing Mars, as the nav point's yaw says.

nav_1 = nav_point("Nav 1", {
    group = zone_points,
    position = { 2500000, 0, 3000000 },
    yaw = -103,
})

-- The formation exercise. Once the wing is out of the jump, Corsair is put 15,000 ahead of Nav 1
-- and 12,000 to the right of the line the player comes out on, so that the player flies past the
-- whole wing, the wingman furthest to the left 6000 clear of that line, rather than into it, and
-- the other wingmen at their places in his formation, abreast of him and 3000 apart, the first to
-- his left, the next to his right, and so on, as the Formation order places them, so that none
-- crosses another's way to get there. Corsair then flies five legs of 40 seconds at a steady 130 a
-- step, a fifth of a fighter's top speed, each leg a gentle change of heading from the one before
-- (15 to 20 degrees, once 3 degrees up), then on straight. A fighter banks round to a point more
-- than 18 degrees off its nose and the wing banks with it, so each turn is flown in steps of at
-- most 10 degrees, three seconds apart, which he only yaws and pitches through. Each heading's
-- waypoint stands 250,000 along it, farther than he flies on it, so that he never slows down to
-- reach one (formation_legs.py makes them and the route).
-- The player's place is a waypoint 4000 behind Corsair's start and 600 above, trailing him, which
-- rides him from a second after he is put there: behind him, it is clear of the wingmen abreast
-- of him. The escort point's marker stands on it, and its ShipReached trigger, within 4000, tells
-- the mission once a second that the player is there. (PositionRelative, which mission 25 uses
-- to carry its formation's places to its leader, left the place right on Corsair here.)
-- The halfway cinematic's mark rides him too, 9000 ahead of him, 6000 to his left and 1500 above:
-- as the shot starts the camera is put there and stays, so that the wing flies past it, a fifth
-- of a fighter's top speed taking it by in about three seconds, and on away from it with Mars
-- beyond. A point 250,000 ahead rides him too, which he flies at to keep straight on.

formation_start = waypoint("Formation start", {
    group = zone_points,
    position = { 2482685, 0, 3008318 },
    yaw = -103,
})
a3_start = waypoint("A3 start", {
    group = zone_points,
    position = { 2483360, 0, 3005395 },
    yaw = -103,
})
a4_start = waypoint("A4 start", {
    group = zone_points,
    position = { 2482010, 0, 3011241 },
    yaw = -103,
})
a5_start = waypoint("A5 start", {
    group = zone_points,
    position = { 2484035, 0, 3002472 },
    yaw = -103,
})
a6_start = waypoint("A6 start", {
    group = zone_points,
    position = { 2481335, 0, 3014164 },
    yaw = -103,
})
cinema_mark = waypoint("Cinema mark", {
    group = formation_points,
    position = { 2475265, -1500, 3000447 },
    yaw = -103,
})
cinema_camera = waypoint("Cinema camera", {
    group = zone_points,
    position = { 2475265, -1500, 3000447 },
    yaw = -103,
})
straight_ahead = waypoint("Straight ahead", {
    group = formation_points,
    position = { 2239093, 0, 2952080 },
})
formation_slot = waypoint("Formation slot", {
    group = formation_points,
    position = { 2486583, -600, 3009218 },
    yaw = -103,
})
heading_1 = waypoint("Heading 1", {
    group = zone_points,
    position = { 2239093, 0, 2952080 },
})
heading_2 = waypoint("Heading 2", {
    group = zone_points,
    position = { 2106360, 0, 2965991 },
})
heading_3 = waypoint("Heading 3", {
    group = zone_points,
    position = { 2098144, 0, 3009032 },
})
heading_4 = waypoint("Heading 4", {
    group = zone_points,
    position = { 1984973, -6544, 3055793 },
})
heading_5 = waypoint("Heading 5", {
    group = zone_points,
    position = { 1986012, -13339, 3089183 },
})
heading_6 = waypoint("Heading 6", {
    group = zone_points,
    position = { 1861696, -13093, 3092604 },
})
heading_7 = waypoint("Heading 7", {
    group = zone_points,
    position = { 1846768, -6804, 3051395 },
})
heading_8 = waypoint("Heading 8", {
    group = zone_points,
    position = { 1727590, -6804, 3022906 },
})
heading_9 = waypoint("Heading 9", {
    group = zone_points,
    position = { 1723141, -6804, 2989695 },
})
formation_beyond = waypoint("Formation beyond", {
    group = zone_points,
    position = { 388011, -6804, 2681456 },
})

-- Nav 2, far off to the Richelieu's left: the wing comes out of the jump facing along Z, with
-- Prowler Three 25,000 ahead, fleeing at a crawl towards its rally point far beyond, and four
-- Coalition Sabres on it. The Prowler takes no damage in this draft. Marks ride it: ahead, above
-- and to its left, where the camera is put for the shot of it under fire; and astern, where the
-- wing forms up once the Sabres are down.

nav_2 = nav_point("Nav 2", {
    group = zone_points,
    position = { -2800000, 0, 2400000 },
    yaw = 0,
})
nav2_rally = waypoint("Nav 2 rally", {
    group = zone_points,
    position = { -2800000, 0, 3000000 },
})
nav2_camera = point("Nav 2 camera", {
    group = zone_points,
    position = { -2800000, 0, 2400000 },
})
prowler3 = ship("Prowler Three", {
    type = "prowler",
    group = prowler_three,
    pilot = "prowler",
    position = { -2794000, -1500, 2425000 },
})
prowler_trail = waypoint("Prowler trail", {
    group = prowler_marks,
    position = { -2794000, -3000, 2417000 },
})
nav2_camera_mark = waypoint("Nav 2 camera mark", {
    group = prowler_marks,
    position = { -2800500, -3500, 2437000 },
})
raider2_1 = ship("Raider 1", {
    type = "sabre",
    group = nav2_raiders,
    pilot = "raven",
    position = { -2789000, -1000, 2417000 },
})
raider2_2 = ship("Raider 2", {
    type = "sabre",
    group = nav2_raiders,
    pilot = "raven",
    position = { -2798000, -2500, 2415000 },
})
raider2_3 = ship("Raider 3", {
    type = "sabre",
    group = nav2_raiders,
    pilot = "raven",
    position = { -2787000, -3000, 2411000 },
})
raider2_4 = ship("Raider 4", {
    type = "sabre",
    group = nav2_raiders,
    pilot = "raven",
    position = { -2800000, -700, 2412000 },
})

-- Nav 4, far off ahead and to the right: the wing comes out facing along X, 200,000 short of the
-- wreck of the Alliance group: two destroyers' sterns, two Mammoths broken in two, cargo pods and
-- debris strewn about, turning slowly. Three Sabres patrol round it until the wing has taken it
-- in; three more jump in by it once two of the first are down.

nav_4 = nav_point("Nav 4", {
    group = zone_points,
    position = { 1600000, -200000, -2600000 },
    yaw = 90,
})
nav4_ahead = waypoint("Nav 4 ahead", {
    group = zone_points,
    position = { 2200000, -200000, -2600000 },
})
wreck_1 = ship("Mitchell wreck", {
    type = "mitchell_wreck_back",
    group = nav4_wreckage,
    position = { 1832000, -200000, -2595000 },
    yaw = 40,
})
wreck_2 = ship("Mammoth wreck front", {
    type = "mammoth_wreck_front",
    group = nav4_wreckage,
    position = { 1826000, -203000, -2611000 },
    yaw = 200,
})
wreck_3 = ship("Mammoth wreck back", {
    type = "mammoth_wreck_back",
    group = nav4_wreckage,
    position = { 1838000, -197000, -2617000 },
    yaw = 120,
})
debris_1 = ship("Debris 1", {
    type = "debris_1",
    group = nav4_wreckage,
    position = { 1820000, -202000, -2597000 },
})
debris_2 = ship("Debris 2", {
    type = "debris_2",
    group = nav4_wreckage,
    position = { 1824000, -197500, -2604000 },
})
debris_3 = ship("Debris 3", {
    type = "debris_3",
    group = nav4_wreckage,
    position = { 1829000, -204000, -2607000 },
})
debris_4 = ship("Debris 4", {
    type = "debris_4",
    group = nav4_wreckage,
    position = { 1835000, -198500, -2591000 },
})
debris_5 = ship("Debris 5", {
    type = "debris_5",
    group = nav4_wreckage,
    position = { 1841000, -202500, -2602000 },
})
debris_6 = ship("Debris 6", {
    type = "debris_6",
    group = nav4_wreckage,
    position = { 1827000, -196000, -2588000 },
})
debris_7 = ship("Debris 7", {
    type = "debris_7",
    group = nav4_wreckage,
    position = { 1833000, -205000, -2612000 },
})
debris_8 = ship("Debris 8", {
    type = "debris_8",
    group = nav4_wreckage,
    position = { 1822000, -199000, -2609000 },
})
debris_9 = ship("Debris 9", {
    type = "debris_9",
    group = nav4_wreckage,
    position = { 1837000, -196500, -2598000 },
})
scrap_1 = ship("Scrap 1", {
    type = "debris",
    group = nav4_wreckage,
    position = { 1827469, -199062, -2620478 },
    yaw = 202,
})
scrap_2 = ship("Scrap 2", {
    type = "debris_1",
    group = nav4_wreckage,
    position = { 1843383, -203922, -2622191 },
    yaw = 34,
})
scrap_3 = ship("Scrap 3", {
    type = "debris_2",
    group = nav4_wreckage,
    position = { 1813298, -195841, -2596071 },
    yaw = 30,
})
scrap_4 = ship("Scrap 4", {
    type = "debris_3",
    group = nav4_wreckage,
    position = { 1826544, -191950, -2586782 },
    yaw = 141,
})
scrap_5 = ship("Scrap 5", {
    type = "debris_4",
    group = nav4_wreckage,
    position = { 1823315, -205521, -2599696 },
    yaw = 109,
})
scrap_6 = ship("Scrap 6", {
    type = "debris_5",
    group = nav4_wreckage,
    position = { 1813680, -200472, -2598382 },
    yaw = 99,
})
scrap_7 = ship("Scrap 7", {
    type = "debris_6",
    group = nav4_wreckage,
    position = { 1822801, -198847, -2596037 },
    yaw = 321,
})
scrap_8 = ship("Scrap 8", {
    type = "debris_7",
    group = nav4_wreckage,
    position = { 1859965, -196798, -2622634 },
    yaw = 310,
})
scrap_9 = ship("Scrap 9", {
    type = "debris_8",
    group = nav4_wreckage,
    position = { 1834112, -196289, -2567684 },
    yaw = 127,
})
scrap_10 = ship("Scrap 10", {
    type = "debris_9",
    group = nav4_wreckage,
    position = { 1823651, -200896, -2571926 },
    yaw = 143,
})
scrap_11 = ship("Scrap 11", {
    type = "cargo_pod",
    group = nav4_wreckage,
    position = { 1817855, -191055, -2594647 },
    yaw = 3,
})
scrap_12 = ship("Scrap 12", {
    type = "debris",
    group = nav4_wreckage,
    position = { 1831132, -198785, -2567367 },
    yaw = 99,
})
scrap_13 = ship("Scrap 13", {
    type = "debris_1",
    group = nav4_wreckage,
    position = { 1839128, -195116, -2596225 },
    yaw = 220,
})
scrap_14 = ship("Scrap 14", {
    type = "debris_2",
    group = nav4_wreckage,
    position = { 1841581, -203714, -2603431 },
    yaw = 156,
})
scrap_15 = ship("Scrap 15", {
    type = "debris_3",
    group = nav4_wreckage,
    position = { 1829016, -207584, -2623374 },
    yaw = 23,
})
scrap_16 = ship("Scrap 16", {
    type = "debris_4",
    group = nav4_wreckage,
    position = { 1842321, -199811, -2572234 },
    yaw = 358,
})
scrap_17 = ship("Scrap 17", {
    type = "debris_5",
    group = nav4_wreckage,
    position = { 1834468, -204247, -2608366 },
    yaw = 34,
})
scrap_18 = ship("Scrap 18", {
    type = "debris_6",
    group = nav4_wreckage,
    position = { 1839052, -202359, -2576178 },
    yaw = 141,
})
scrap_19 = ship("Scrap 19", {
    type = "debris_7",
    group = nav4_wreckage,
    position = { 1824039, -197341, -2576863 },
    yaw = 301,
})
scrap_20 = ship("Scrap 20", {
    type = "debris_8",
    group = nav4_wreckage,
    position = { 1833015, -202489, -2591594 },
    yaw = 51,
})
scrap_21 = ship("Scrap 21", {
    type = "debris_9",
    group = nav4_wreckage,
    position = { 1816037, -201501, -2597631 },
    yaw = 298,
})
scrap_22 = ship("Scrap 22", {
    type = "cargo_pod",
    group = nav4_wreckage,
    position = { 1852332, -201221, -2617991 },
    yaw = 169,
})
scrap_23 = ship("Scrap 23", {
    type = "debris",
    group = nav4_wreckage,
    position = { 1823635, -199467, -2573836 },
    yaw = 13,
})
scrap_24 = ship("Scrap 24", {
    type = "debris_1",
    group = nav4_wreckage,
    position = { 1814805, -197300, -2623173 },
    yaw = 146,
})
scrap_25 = ship("Scrap 25", {
    type = "debris_2",
    group = nav4_wreckage,
    position = { 1856250, -198281, -2631617 },
    yaw = 165,
})
scrap_26 = ship("Scrap 26", {
    type = "debris_3",
    group = nav4_wreckage,
    position = { 1830939, -198460, -2613958 },
    yaw = 333,
})
scrap_27 = ship("Scrap 27", {
    type = "debris_4",
    group = nav4_wreckage,
    position = { 1838897, -206453, -2595543 },
    yaw = 316,
})
scrap_28 = ship("Scrap 28", {
    type = "debris_5",
    group = nav4_wreckage,
    position = { 1824544, -194447, -2595728 },
    yaw = 69,
})
scrap_29 = ship("Scrap 29", {
    type = "debris_6",
    group = nav4_wreckage,
    position = { 1828387, -196495, -2613173 },
    yaw = 169,
})
scrap_30 = ship("Scrap 30", {
    type = "debris_7",
    group = nav4_wreckage,
    position = { 1849558, -208693, -2586379 },
    yaw = 22,
})
scrap_31 = ship("Scrap 31", {
    type = "debris_8",
    group = nav4_wreckage,
    position = { 1841804, -203444, -2586134 },
    yaw = 185,
})
scrap_32 = ship("Scrap 32", {
    type = "debris_9",
    group = nav4_wreckage,
    position = { 1831027, -205819, -2576417 },
    yaw = 106,
})
scrap_33 = ship("Scrap 33", {
    type = "cargo_pod",
    group = nav4_wreckage,
    position = { 1839784, -202187, -2619108 },
    yaw = 30,
})
scrap_34 = ship("Scrap 34", {
    type = "debris",
    group = nav4_wreckage,
    position = { 1816076, -207189, -2611893 },
    yaw = 304,
})
scrap_35 = ship("Scrap 35", {
    type = "debris_1",
    group = nav4_wreckage,
    position = { 1856356, -204097, -2628641 },
    yaw = 279,
})
scrap_36 = ship("Scrap 36", {
    type = "debris_2",
    group = nav4_wreckage,
    position = { 1844156, -200839, -2591870 },
    yaw = 18,
})
scrap_37 = ship("Scrap 37", {
    type = "debris_3",
    group = nav4_wreckage,
    position = { 1820013, -191658, -2595609 },
    yaw = 209,
})
scrap_38 = ship("Scrap 38", {
    type = "debris_4",
    group = nav4_wreckage,
    position = { 1854704, -202438, -2571379 },
    yaw = 103,
})
scrap_39 = ship("Scrap 39", {
    type = "debris_5",
    group = nav4_wreckage,
    position = { 1827850, -194621, -2580179 },
    yaw = 251,
})
scrap_40 = ship("Scrap 40", {
    type = "debris_6",
    group = nav4_wreckage,
    position = { 1814416, -201822, -2578790 },
    yaw = 227,
})
scrap_41 = ship("Scrap 41", {
    type = "debris_7",
    group = nav4_wreckage,
    position = { 1828291, -194981, -2605726 },
    yaw = 255,
})
scrap_42 = ship("Scrap 42", {
    type = "debris_8",
    group = nav4_wreckage,
    position = { 1824301, -207963, -2629176 },
    yaw = 130,
})
scrap_43 = ship("Scrap 43", {
    type = "debris_9",
    group = nav4_wreckage,
    position = { 1828605, -201058, -2606729 },
    yaw = 118,
})
scrap_44 = ship("Scrap 44", {
    type = "cargo_pod",
    group = nav4_wreckage,
    position = { 1839337, -200426, -2615427 },
    yaw = 166,
})
scrap_45 = ship("Scrap 45", {
    type = "debris",
    group = nav4_wreckage,
    position = { 1815360, -198694, -2618684 },
    yaw = 291,
})
scrap_46 = ship("Scrap 46", {
    type = "debris_1",
    group = nav4_wreckage,
    position = { 1838408, -207673, -2569213 },
    yaw = 198,
})
scrap_47 = ship("Scrap 47", {
    type = "debris_2",
    group = nav4_wreckage,
    position = { 1818088, -194907, -2606355 },
    yaw = 293,
})
scrap_48 = ship("Scrap 48", {
    type = "debris_3",
    group = nav4_wreckage,
    position = { 1822843, -197971, -2595176 },
    yaw = 336,
})
wreck_4 = ship("Mitchell wreck 2", {
    type = "mitchell_wreck_back",
    group = nav4_wreckage,
    position = { 1852000, -196000, -2578000 },
    yaw = 300,
})
wreck_5 = ship("Mammoth wreck front 2", {
    type = "mammoth_wreck_front",
    group = nav4_wreckage,
    position = { 1846000, -206000, -2626000 },
    yaw = 80,
})
wreck_6 = ship("Mammoth wreck back 2", {
    type = "mammoth_wreck_back",
    group = nav4_wreckage,
    position = { 1818000, -195000, -2576000 },
    yaw = 160,
})
-- The patrol the first Sabres fly round the wreckage, and where the second wave comes out of
-- its jump.
nav4_patrol_1 = waypoint("Nav 4 patrol 1", {
    group = nav4_patrol,
    position = { 1830000, -200000, -2622000 },
})
nav4_patrol_2 = waypoint("Nav 4 patrol 2", {
    group = nav4_patrol,
    position = { 1852000, -202000, -2600000 },
})
nav4_patrol_3 = waypoint("Nav 4 patrol 3", {
    group = nav4_patrol,
    position = { 1830000, -198000, -2578000 },
})
nav4_patrol_4 = waypoint("Nav 4 patrol 4", {
    group = nav4_patrol,
    position = { 1814000, -200000, -2600000 },
})
nav4_wave_in = point("Nav 4 wave in", {
    group = zone_points,
    position = { 1846000, -203000, -2616000 },
    yaw = 270,
})
-- The camera's way through the wreckage as the wing arrives: in at the field's near corner,
-- above it, and out at its far one, below, looking at the first destroyer's wreck all the way.
nav4_dolly_start = curve_point("Nav 4 dolly start", {
    position = { 1802000, -205000, -2564000 },
})
nav4_dolly_end = curve_point("Nav 4 dolly end", {
    position = { 1848000, -197000, -2632000 },
})
nav4_dolly = curve({
    start = nav4_dolly_start,
    finish = nav4_dolly_end,
    from = { 1802000, -205000, -2564000 },
    to = { 1848000, -197000, -2632000 },
    leaving = { 4600, -700, -6800 },
    arriving = { 4600, 2300, -6800 },
})
raider4a_1 = ship("Raider A1", {
    type = "sabre",
    group = nav4_wave_a,
    pilot = "raven",
    position = { 1845000, -199000, -2600000 },
    yaw = 270,
})
raider4a_2 = ship("Raider A2", {
    type = "sabre",
    group = nav4_wave_a,
    pilot = "raven",
    position = { 1848000, -202000, -2606000 },
    yaw = 270,
})
raider4a_3 = ship("Raider A3", {
    type = "sabre",
    group = nav4_wave_a,
    pilot = "raven",
    position = { 1843000, -197500, -2594000 },
    yaw = 270,
})
raider4b_1 = ship("Raider B1", {
    type = "sabre",
    group = nav4_wave_b,
    pilot = "raven",
    position = { 1860000, -200000, -2622000 },
    yaw = 270,
})
raider4b_2 = ship("Raider B2", {
    type = "sabre",
    group = nav4_wave_b,
    pilot = "raven",
    position = { 1863000, -203000, -2626000 },
    yaw = 270,
})
raider4b_3 = ship("Raider B3", {
    type = "sabre",
    group = nav4_wave_b,
    pilot = "raven",
    position = { 1858000, -197000, -2628000 },
    yaw = 270,
})

-- Nav 6, far off behind and to the left: the wing comes out facing along -Z, towards the convoy
-- 160,000 ahead: three Mammoths and their two escorts, a Kestrel leading, fleeing slowly on, with
-- five Sabres on them. The convoy takes no damage in this draft; the second escort blows up
-- once two Sabres are down.

nav_6 = nav_point("Nav 6", {
    group = zone_points,
    position = { -2300000, 100000, -1680000 },
    yaw = 180,
})
nav6_exit = waypoint("Nav 6 exit", {
    group = zone_points,
    position = { -2300000, 100000, -2700000 },
})
convoy_lead = ship("Convoy leader", {
    type = "kestrel",
    group = nav6_convoy,
    pilot = "kestrel_command",
    position = { -2300000, 92000, -1862000 },
    yaw = 180,
})
convoy_escort = ship("Convoy escort", {
    type = "kestrel",
    group = nav6_convoy,
    pilot = "kestrel_bridge_officer",
    position = { -2328000, 98000, -1840000 },
    yaw = 180,
})
transport_1 = ship("Transport 1", {
    type = "mammoth",
    group = nav6_convoy,
    pilot = "mammoth_1",
    position = { -2300000, 100000, -1842000 },
    yaw = 180,
})
transport_2 = ship("Transport 2", {
    type = "mammoth",
    group = nav6_convoy,
    pilot = "mammoth_2",
    position = { -2284000, 103000, -1848000 },
    yaw = 180,
})
transport_3 = ship("Transport 3", {
    type = "mammoth",
    group = nav6_convoy,
    pilot = "mammoth_3",
    position = { -2316000, 97000, -1850000 },
    yaw = 180,
})
raider6_1 = ship("Raider 5", {
    type = "sabre",
    group = nav6_raiders,
    pilot = "raven",
    position = { -2294000, 97000, -1830000 },
    yaw = 180,
})
raider6_2 = ship("Raider 6", {
    type = "sabre",
    group = nav6_raiders,
    pilot = "raven",
    position = { -2309000, 102000, -1833000 },
    yaw = 180,
})
raider6_3 = ship("Raider 7", {
    type = "sabre",
    group = nav6_raiders,
    pilot = "raven",
    position = { -2288000, 101000, -1836000 },
    yaw = 180,
})
raider6_4 = ship("Raider 8", {
    type = "sabre",
    group = nav6_raiders,
    pilot = "raven",
    position = { -2304000, 96000, -1838000 },
    yaw = 180,
})
raider6_5 = ship("Raider 9", {
    type = "sabre",
    group = nav6_raiders,
    pilot = "raven",
    position = { -2298000, 104000, -1828000 },
    yaw = 180,
})

-- Home: where Prowler Three comes out of its jump and the approach it flies to bay 1, astern of the
-- carrier in the axis of its other stern bay, where it goes aboard; and where the Coalition
-- fighters come out of their jump, off the carrier's right side and above it, abreast of its stern,
-- in sight of the wing as it comes home. These ride the carrier with the other home points.

prowler_home_in = waypoint("Prowler home in", {
    group = home_points,
    position = { 30000, -6000, -150000 },
})
prowler_approach = waypoint("Prowler approach", {
    group = home_points,
    position = { 12867, 4057, -60000 },
})
prowler3_home = ship("Prowler Three", {
    type = "prowler",
    group = prowler_home,
    pilot = "prowler",
    position = { 30000, -6000, -150000 },
})
-- The convoy saved at Nav 6, by the carrier when the wing comes home, off its left side: each
-- ship is put at its place, which rides the carrier, as the convoy jumps out of Nav 6.
home_convoy_lead = ship("Convoy leader", {
    type = "kestrel",
    group = home_convoy,
    pilot = "kestrel_command",
    position = { -115000, -6000, 30000 },
})
home_convoy_lead_place = waypoint("Convoy leader place", {
    group = home_points,
    position = { -115000, -6000, 30000 },
})
home_transport_1 = ship("Transport 1", {
    type = "mammoth",
    group = home_convoy,
    pilot = "mammoth_1",
    position = { -100000, 0, -5000 },
})
home_transport_1_place = waypoint("Transport 1 place", {
    group = home_points,
    position = { -100000, 0, -5000 },
})
home_transport_2 = ship("Transport 2", {
    type = "mammoth",
    group = home_convoy,
    pilot = "mammoth_2",
    position = { -130000, 4000, -20000 },
})
home_transport_2_place = waypoint("Transport 2 place", {
    group = home_points,
    position = { -130000, 4000, -20000 },
})
home_transport_3 = ship("Transport 3", {
    type = "mammoth",
    group = home_convoy,
    pilot = "mammoth_3",
    position = { -95000, -4000, -40000 },
})
home_transport_3_place = waypoint("Transport 3 place", {
    group = home_points,
    position = { -95000, -4000, -40000 },
})
attack_in_point = point("Attack in point", {
    group = home_points,
    position = { 90000, -30000, -60000 },
    yaw = 200,
})
attacker_1 = ship("Attacker 1", {
    type = "sabre",
    group = home_attackers,
    pilot = "raven",
    position = { 90000, -30000, -60000 },
    yaw = 200,
})
attacker_2 = ship("Attacker 2", {
    type = "sabre",
    group = home_attackers,
    pilot = "raven",
    position = { 94000, -29000, -57000 },
    yaw = 200,
})
attacker_3 = ship("Attacker 3", {
    type = "sabre",
    group = home_attackers,
    pilot = "raven",
    position = { 86000, -31000, -57000 },
    yaw = 200,
})
attacker_4 = ship("Attacker 4", {
    type = "sabre",
    group = home_attackers,
    pilot = "raven",
    position = { 98000, -28000, -54000 },
    yaw = 200,
})
attacker_5 = ship("Attacker 5", {
    type = "sabre",
    group = home_attackers,
    pilot = "raven",
    position = { 82000, -32000, -54000 },
    yaw = 200,
})
attacker_6 = ship("Attacker 6", {
    type = "sabre",
    group = home_attackers,
    pilot = "raven",
    position = { 90000, -27000, -52000 },
    yaw = 200,
})
attacker_7 = ship("Attacker 7", {
    type = "sabre",
    group = home_attackers,
    pilot = "raven",
    position = { 96000, -33000, -50000 },
    yaw = 200,
})
attacker_8 = ship("Attacker 8", {
    type = "sabre",
    group = home_attackers,
    pilot = "raven",
    position = { 84000, -27000, -50000 },
    yaw = 200,
})

-- The second wave at home: two Kamov bombers that jump in together ahead of the carrier and off
-- its left, about 600,000 from it, then split, each for a firing point of its own 350,000 from the
-- carrier, the two points 360,000 apart, about 350,000 from where they came in. Each launches its
-- two torpedoes at the carrier as it reaches its point, then flies off for its way out and jumps
-- out. The torpedoes are ships of their own, which ride in the Kamov's launch gates until they are
-- launched, as mission 1's do. These points ride the carrier with the other home points.

kamov_a_in = point("Kamov A in", {
    group = home_points,
    position = { -154000, -30000, 580000 },
    yaw = 180,
})
kamov_b_in = point("Kamov B in", {
    group = home_points,
    position = { -146000, -30000, 586000 },
    yaw = 180,
})
kamov_a_fire = waypoint("Kamov A fire", {
    group = home_points,
    position = { -250000, -30000, 245000 },
})
kamov_b_fire = waypoint("Kamov B fire", {
    group = home_points,
    position = { 100000, -30000, 335000 },
})
kamov_a_out = waypoint("Kamov A out", {
    group = home_points,
    position = { -600000, -30000, 300000 },
})
kamov_b_out = waypoint("Kamov B out", {
    group = home_points,
    position = { 450000, -30000, 400000 },
})
kamov_a = ship("Kamov A", {
    type = "kamov",
    group = home_bombers,
    pilot = "coalition_torpedo_leader",
    position = { -154000, -30000, 580000 },
    yaw = 180,
})
kamov_b = ship("Kamov B", {
    type = "kamov",
    group = home_bombers,
    pilot = "russian_bomber",
    position = { -146000, -30000, 586000 },
    yaw = 180,
})
torpedo_a1 = ship("Torpedo A1", {
    type = "russian_torpedo",
    group = home_torpedoes,
    position = { -154000, -30000, 580000 },
})
torpedo_a2 = ship("Torpedo A2", {
    type = "russian_torpedo",
    group = home_torpedoes,
    position = { -154000, -30000, 580000 },
})
torpedo_b1 = ship("Torpedo B1", {
    type = "russian_torpedo",
    group = home_torpedoes,
    position = { -146000, -30000, 586000 },
})
torpedo_b2 = ship("Torpedo B2", {
    type = "russian_torpedo",
    group = home_torpedoes,
    position = { -146000, -30000, 586000 },
})

-- Where the camera stands for the shots of each zone: at Nav 4 beside the wreckage for the second
-- wave (the arrival's shot flies through it on a curve); at Nav 6 off the convoy's left, above it;
-- at home beside where Prowler Three and the Coalition fighters come out of their jumps (these two
-- ride the carrier).

nav4_wave_camera = point("Nav 4 wave camera", {
    group = zone_points,
    position = { 1844000, -206000, -2602000 },
})
nav6_camera = point("Nav 6 camera", {
    group = zone_points,
    position = { -2330000, 91000, -1828000 },
})
prowler_home_camera = point("Prowler home camera", {
    group = home_points,
    position = { 18000, -10000, -132000 },
})
attack_camera = point("Attack camera", {
    group = home_points,
    position = { 72000, -38000, -40000 },
})

-- The fights' hostiles as one, for the wing's orders.

nav4_hostiles = squad("(AI)Nav 4 hostiles", { nav4_wave_a, nav4_wave_b })
-- What the attackers at home go for: the carrier and the ships about it, the convoy and the wing.
home_targets = squad("(AI)Home targets", { carrier_group, home_convoy, alpha })

-- The script.

-- The shuttle's departure: it flies slowly away from the carrier for half a minute, then jumps
-- out of the mission.

shuttle_departs = part("(F)Shuttle departs", function()
    Fly(lonestar, shuttle_away, 60)
    Wait(30)
    SetAI(lonestar, "jump_out", 1, nil)
    return 1
end)

-- The start: the launch, then the jump drive comes online for the jump to Nav 1.

start = part("(F)Start", function()
    -- The carrier's flight group first, so that the wing finds the Richelieu to launch from.
    CreateFlightGroup(carrier_group)
    CreateFlightGroup(shuttle_group)
    CreateFlightGroup(alpha)
    CreateFlightGroup(jump_points)
    CreateFlightGroup(home_points)
    CreateFlightGroup(zone_points)
    CreateFlightGroup(planets)
    -- The orange nebula, the game's sixth, whose fill light is orange too: the dusty sky of Mars.
    SetEnvironmentFXNebula(5)
    UpdateEnvironmentFXState()
    -- The markers near the carrier ride it, so that they keep their places as it flies on.
    SetAI(home_points, "object_attach", 1, richelieu)
    SetRescueProbabilities(100, 0, 0)
    SetShipAvoidance(carrier_group, 1)
    -- The carrier holds its fire over the launch.
    DisableGuns(carrier_group, 1)
    PlayMusic("new_launch.wav", 0)
    -- Alpha 3 to 6 wait their turn out of the way.
    DisableObject(a3, 1)
    DisableObject(a4, 1)
    DisableObject(a5, 1)
    DisableObject(a6, 1)
    -- The patrol's chatter runs over the launch, on a thread of its own, and the shuttle leaves.
    spawn(launch_chatter)
    spawn(shuttle_departs)
    -- The first wave: each launch waits up to two seconds of its own, then its doors take two
    -- seconds to open and the ship two more to fly out.
    StartLaunch(player)
    -- Two seconds into the launch, as the bay's doors open, the camera cuts to a shot from ahead
    -- of the bow that follows the player's ship out of its bay, and comes back to the cockpit six
    -- seconds later, while the rest of the wing launches on. The mission goes on once the wing is
    -- out.
    Wait(2)
    StartDirectorCam(launch_camera, player, 6, nil, nil)
    StartLaunch(a2)
    -- The second wave: once the player's launch is over and gate 3's doors are closing, Alpha 3
    -- takes that gate, and Alpha 4 gate 2 once Alpha 2's is over. The third wave follows the same
    -- way. A wingman out of its bay has no order of its own and would stop right there, in the
    -- way of the wave behind it: as each launch ends, the wingman flies off to the form up point.
    WaitForJumpOrLaunch(player)
    DisableObject(a3, 0)
    SetupLaunch(a3, richelieu, 3)
    StartLaunch(a3)
    WaitForJumpOrLaunch(a2)
    Fly(a2, form_up_point, 130)
    DisableObject(a4, 0)
    SetupLaunch(a4, richelieu, 2)
    StartLaunch(a4)
    WaitForJumpOrLaunch(a3)
    Fly(a3, a3_form_up, 130)
    DisableObject(a5, 0)
    SetupLaunch(a5, richelieu, 3)
    StartLaunch(a5)
    WaitForJumpOrLaunch(a4)
    Fly(a4, a4_form_up, 130)
    DisableObject(a6, 0)
    SetupLaunch(a6, richelieu, 2)
    StartLaunch(a6)
    WaitForJumpOrLaunch(a5)
    Fly(a5, a5_form_up, 130)
    WaitForJumpOrLaunch(alpha)
    Fly(a6, a6_form_up, 130)
    DisableGuns(carrier_group, 0)
    Fly(carrier_group, nil, 10)
    Wait(1)
    PlayMusic("new_searching mission 09.wav", 0)
    -- The first objective, and the nav point the display points the player to.
    SetObjective(0, 2)
    SetNavPoint(alpha, nav_1)
    -- Corsair leads: he sets off towards Nav 1 at an easy speed, which the player can catch up
    -- with, and the other wingmen keep formation on him, abreast and 3000 apart. Their flights to
    -- the form up point are cleared first.
    ClearAI(escorts)
    Fly(a2, nav_1, 200)
    SetAI(followers, "formation", 1, a2)
    jump_when_ready()
    return 1
end, { start = true })

-- The jump drive comes online once the launch is over and the chatter has been said, whichever
-- comes last.

jump_when_ready = part("(F)Jump when ready", function()
    ready_steps += 1
    if ready_steps >= 2 then
        game.jump_ready = 1
    end
    return 1
end)

-- The patrol's chatter, from two seconds into the mission: the mod's own lines, WAV files in the
-- mod's folder named as the script names them, each said with its pilot's face in the comms
-- window, a second apart. Walk'n and Pitbull speak from their parking place before their launch.
-- CommsFromShip loops the face's film for as long as the line plays; CommsFromShipOnce plays it
-- once, four seconds for the Marauders' films, and the window shows static for the rest of a
-- longer line.
-- A comm's line starts only once the radio's window has opened, 92 ticks after the command, so
-- WaitForSpeech right after it would find nothing playing and come back at once, and the next
-- comm would cut the line: each line waits a second first, then for the line's end, then a
-- second more before the next.

launch_chatter = part("(F)Launch chatter", function()
    Wait(2)
    CommsFromPilot("victorious_bridge_officer", "talking", "ctl_m1_l1")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a2, "talking", "cor_m1_l1")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a4, "talking", "wal_m1_l1")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a5, "talking", "pit_m1_l1")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a4, "talking", "wal_m1_l2")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a2, "talking", "cor_m1_l2")
    Wait(1)
    WaitForSpeech()
    jump_when_ready()
    return 1
end)

-- Nav 2. The Prowler and the Sabres on it are there before the wing: they are made as it jumps.

jump_to_nav2 = part("(F)Jump to Nav 2", function()
    CreateFlightGroup(prowler_three)
    CreateFlightGroup(prowler_marks)
    CreateFlightGroup(nav2_raiders)
    SetAI(prowler_marks, "object_attach", 1, prowler3)
    SetInvulnerability(prowler3, 1)
    Fly(prowler3, nav2_rally, 60)
    SetAI(nav2_raiders, "find_new_target", 1, prowler3)
    ClearAI(alpha)
    SetAI(alpha, "jump_out", 1, nav_2)
    return 1
end)

-- Out of the jump: a shot of the Prowler under fire, from ahead of it, the wing held still
-- meanwhile; its mayday; then the wing engages. The fight's lines come as the Sabres go down.

arrive_nav2 = part("(F)Arrive at Nav 2", function()
    WaitForJumpOrLaunch(alpha)
    DisableObject(carrier_group, 1)
    game.jump_ready = 0
    SetNavPoint(alpha, nav_2)
    PlayMusic("new_mission06.wav", 1)
    SnapToPoint(nav2_camera, nav2_camera_mark)
    StartDirectorCam(nav2_camera, prowler3, 7, nil, alpha)
    CommsFromShip(prowler3, "talking", "prw_m1_l1")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    ClearAI(escorts)
    Fly(a2, nav2_rally, 200)
    SetAI(followers, "formation", 1, a2)
    CommsFromShip(a2, "talking", "cor_m1_l15")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(prowler3, "talking", "prw_m1_l2")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a3, "talking", "fah_m1_l3")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a2, "talking", "cor_m1_l16")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    SetAI(escorts, "find_new_target", 1, nav2_raiders)
    CommsFromShip(a4, "talking", "wal_m1_l7")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    return 1
end)

on(nav2_raiders, "destroyed", { repeats = "always" }, function(killer, victim)
    nav2_kills += 1
    if nav2_kills == 1 then
        spawn(nav2_first_down)
    end
    if nav2_kills == 2 then
        spawn(nav2_second_down)
    end
    if nav2_kills == 3 then
        spawn(nav2_third_down)
    end
    if nav2_kills == 4 then
        spawn(nav2_cleared)
    end
    return 1
end)

nav2_first_down = part("(F)Nav 2 first down", function()
    WaitForSpeech()
    CommsFromShip(a5, "talking", "pit_m1_l3")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    return 1
end)

nav2_second_down = part("(F)Nav 2 second down", function()
    WaitForSpeech()
    CommsFromShip(a6, "talking", "sta_m1_l2")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a2, "talking", "cor_m1_l17")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    return 1
end)

nav2_third_down = part("(F)Nav 2 third down", function()
    WaitForSpeech()
    CommsFromShip(prowler3, "talking", "prw_m1_l3")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a2, "talking", "cor_m1_l18")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    return 1
end)

-- Nav 2 clear: the bridge sends the Prowler home, it jumps out, and the wing may follow.

nav2_cleared = part("(F)Nav 2 cleared", function()
    Wait(2)
    ClearAI(escorts)
    SetAI(followers, "formation", 1, a2)
    -- The wing forms up abreast behind the Prowler, on a mark 8000 astern of it and above it.
    ClearAI(escorts)
    SetAI(escorts, "formation", 1, prowler_trail)
    PlayMusic("new_searching mission 09.wav", 0)
    WaitForSpeech()
    CommsFromPilot("victorious_bridge_officer", "talking", "ctl_m1_l7")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a2, "talking", "cor_m1_l19")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(prowler3, "talking", "prw_m1_l4")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromPilot("victorious_bridge_officer", "talking", "ctl_m1_l8")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a2, "talking", "cor_m1_l20")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    SetObjective(2, 1)
    SetObjective(3, 2)
    Wait(2)
    SetAI(prowler3, "jump_out", 1, nil)
    phase = 2
    game.jump_ready = 1
    return 1
end)

-- Home with the Prowler: it jumps in after the wing and flies to the carrier's other stern bay,
-- where it goes aboard, while the bridge gives the wing its next tasking, Nav 4.

arrive_home_prowler = part("(F)Arrive home with the Prowler", function()
    WaitForJumpOrLaunch(alpha)
    game.jump_ready = 0
    SetActionCentre(richelieu, 0)
    ClearAI(escorts)
    Fly(a2, wingman_hold, 150)
    SetAI(followers, "formation", 1, a2)
    CreateFlightGroup(prowler_home)
    SetInvulnerability(prowler3_home, 1)
    SetAI(prowler_home, "fly", 1, nil)
    SetAI(prowler_home, "jump_in", 1, prowler_home_in)
    StartDirectorCam(prowler_home_camera, prowler3_home, 5, nil, alpha)
    WaitForJumpOrLaunch(prowler_home)
    Fly(prowler3_home, prowler_approach, 100)
    CommsFromPilot("victorious_bridge_officer", "talking", "ctl_m1_l9")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(prowler3_home, "talking", "prw_m1_l5")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a2, "talking", "cor_m1_l21")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    SetObjective(3, 1)
    Wait(3)
    CommsFromPilot("victorious_bridge_officer", "talking", "ctl_m1_l10")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a2, "talking", "cor_m1_l22")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromPilot("victorious_bridge_officer", "talking", "ctl_m1_l11")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a4, "talking", "wal_m1_l8")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a3, "talking", "fah_m1_l4")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a2, "talking", "cor_m1_l23")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    SetObjective(4, 2)
    SetNavPoint(alpha, nav_4)
    phase = 3
    game.jump_ready = 1
    return 1
end)

-- The Prowler goes aboard as it reaches its approach astern of the carrier.

on(prowler_approach, "ship_reached", { reached_ship = prowler3_home }, function(reached_ship)
    DisableObject(prowler3_home, 1)
    return 1
end)

-- Nav 4: the wreckage and the first Sabres are made as the wing jumps.

jump_to_nav4 = part("(F)Jump to Nav 4", function()
    CreateFlightGroup(nav4_wreckage)
    CreateFlightGroup(nav4_patrol)
    CreateFlightGroup(nav4_wave_a)
    SetAI(nav4_wreckage, "random_spin_slow", 1, nil)
    SetPatrolRoute(nav4_wave_a, nav4_patrol)
    ClearAI(alpha)
    SetAI(alpha, "jump_out", 1, nav_4)
    return 1
end)

-- Out of the jump: the wing takes in the wreckage and reports; the Sabres turn on it, and it
-- engages.

arrive_nav4 = part("(F)Arrive at Nav 4", function()
    WaitForJumpOrLaunch(alpha)
    DisableObject(carrier_group, 1)
    game.jump_ready = 0
    SetNavPoint(alpha, nav_4)
    ClearAI(escorts)
    Fly(a2, nav4_ahead, 120)
    SetAI(followers, "formation", 1, a2)
    -- A shot that flies through the wreckage, looking at the first destroyer's wreck, the wing
    -- held still meanwhile; Stardust and Walk'n speak over it, one straight after the other.
    Wait(1)
    StartDirectorCam(nav4_dolly, wreck_1, 14, nil, alpha)
    Wait(1)
    CommsFromShip(a6, "talking", "sta_m1_l3")
    Wait(1)
    WaitForSpeech()
    CommsFromShip(a4, "talking", "wal_m1_l9")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a3, "talking", "fah_m1_l5")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a2, "talking", "cor_m1_l24")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromPilot("victorious_bridge_officer", "talking", "ctl_m1_l12")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a2, "talking", "cor_m1_l25")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    SetAI(nav4_wave_a, "find_new_target", 1, alpha)
    PlayMusic("new_mission06.wav", 1)
    CommsFromShip(a5, "talking", "pit_m1_l4")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a2, "talking", "cor_m1_l26")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    SetAI(escorts, "find_new_target", 1, nav4_hostiles)
    return 1
end)

on(nav4_wave_a, "destroyed", { repeats = "always" }, function(killer, victim)
    nav4_kills += 1
    if nav4_kills == 1 then
        spawn(nav4_first_down)
    end
    if nav4_kills == 2 then
        spawn(nav4_wave_b_comes)
    end
    if nav4_kills == 6 then
        spawn(nav4_cleared)
    end
    return 1
end)

on(nav4_wave_b, "destroyed", { repeats = "always" }, function(killer, victim)
    nav4_kills += 1
    if nav4_kills == 6 then
        spawn(nav4_cleared)
    end
    return 1
end)

nav4_first_down = part("(F)Nav 4 first down", function()
    WaitForSpeech()
    CommsFromShip(a6, "talking", "sta_m1_l4")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a2, "talking", "cor_m1_l27")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    return 1
end)

-- Two of the first Sabres down: three more jump in by the wreckage.

nav4_wave_b_comes = part("(F)Nav 4 wave B comes", function()
    CreateFlightGroup(nav4_wave_b)
    SetAI(nav4_wave_b, "fly", 1, nil)
    SetAI(nav4_wave_b, "jump_in", 1, nav4_wave_in)
    StartDirectorCam(nav4_wave_camera, raider4b_1, 5, nil, alpha)
    WaitForJumpOrLaunch(nav4_wave_b)
    SetAI(nav4_wave_b, "find_new_target", 1, alpha)
    SetAI(escorts, "find_new_target", 1, nav4_hostiles)
    WaitForSpeech()
    CommsFromShip(a4, "talking", "wal_m1_l10")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a2, "talking", "cor_m1_l28")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    return 1
end)

-- Nav 4 clear: the wing reports, and the bridge sends it on to Nav 6.

nav4_cleared = part("(F)Nav 4 cleared", function()
    Wait(2)
    ClearAI(escorts)
    SetAI(followers, "formation", 1, a2)
    Fly(a2, nav4_ahead, 120)
    PlayMusic("new_searching mission 09.wav", 0)
    WaitForSpeech()
    CommsFromShip(a2, "talking", "cor_m1_l29")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromPilot("victorious_bridge_officer", "talking", "ctl_m1_l13")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a3, "talking", "fah_m1_l6")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromPilot("victorious_bridge_officer", "talking", "ctl_m1_l14")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a4, "talking", "wal_m1_l11")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a2, "talking", "cor_m1_l30")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromPilot("victorious_bridge_officer", "talking", "ctl_m1_l15")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a2, "talking", "cor_m1_l31")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    SetObjective(4, 1)
    SetObjective(5, 2)
    SetNavPoint(alpha, nav_6)
    phase = 4
    game.jump_ready = 1
    return 1
end)

-- Nav 6: the convoy and the Sabres on it are made as the wing jumps.

jump_to_nav6 = part("(F)Jump to Nav 6", function()
    CreateFlightGroup(nav6_convoy)
    CreateFlightGroup(nav6_raiders)
    SetInvulnerability(nav6_convoy, 1)
    Fly(nav6_convoy, nav6_exit, 30)
    SetAI(nav6_raiders, "find_new_target", 1, nav6_convoy)
    ClearAI(alpha)
    SetAI(alpha, "jump_out", 1, nav_6)
    return 1
end)

arrive_nav6 = part("(F)Arrive at Nav 6", function()
    WaitForJumpOrLaunch(alpha)
    DisableObject(carrier_group, 1)
    game.jump_ready = 0
    SetNavPoint(alpha, nav_6)
    ClearAI(escorts)
    Fly(a2, nav6_exit, 200)
    SetAI(followers, "formation", 1, a2)
    PlayMusic("new_mission06.wav", 1)
    -- A shot of the convoy under attack, its first transport in view, the wing held still.
    Wait(1)
    StartDirectorCam(nav6_camera, transport_1, 8, nil, alpha)
    CommsFromShip(convoy_lead, "talking", "cvy_m1_l1")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a2, "talking", "cor_m1_l32")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(convoy_lead, "talking", "cvy_m1_l2")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a3, "talking", "fah_m1_l7")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a2, "talking", "cor_m1_l33")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    SetAI(escorts, "find_new_target", 1, nav6_raiders)
    return 1
end)

on(nav6_raiders, "destroyed", { repeats = "always" }, function(killer, victim)
    nav6_kills += 1
    if nav6_kills == 2 then
        spawn(nav6_escort_lost)
    end
    if nav6_kills == 4 then
        spawn(nav6_almost)
    end
    if nav6_kills == 5 then
        spawn(nav6_cleared)
    end
    return 1
end)

-- Two Sabres down: the convoy loses its second escort.

nav6_escort_lost = part("(F)Nav 6 escort lost", function()
    SetAI(convoy_escort, "explode", 1, nil)
    WaitForSpeech()
    CommsFromShip(convoy_lead, "talking", "cvy_m1_l3")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    return 1
end)

nav6_almost = part("(F)Nav 6 almost", function()
    WaitForSpeech()
    CommsFromShip(a3, "talking", "fah_m1_l8")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    return 1
end)

-- Nav 6 clear: the transports jump out one after another, and the bridge calls the wing home.

nav6_cleared = part("(F)Nav 6 cleared", function()
    Wait(2)
    ClearAI(escorts)
    SetAI(followers, "formation", 1, a2)
    Fly(a2, nav6_exit, 150)
    PlayMusic("new_searching mission 09.wav", 0)
    WaitForSpeech()
    CommsFromShip(a4, "talking", "wal_m1_l12")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a2, "talking", "cor_m1_l35")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(convoy_lead, "talking", "cvy_m1_l4")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    SetAI(transport_1, "jump_out", 1, nil)
    Wait(3)
    SetAI(transport_2, "jump_out", 1, nil)
    Wait(3)
    SetAI(transport_3, "jump_out", 1, nil)
    CommsFromShip(a6, "talking", "sta_m1_l5")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a5, "talking", "pit_m1_l5")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    SetAI(convoy_lead, "jump_out", 1, nil)
    -- The convoy comes out at the carrier, and waits there.
    CreateFlightGroup(home_convoy)
    SetInvulnerability(home_convoy, 1)
    SnapToPoint(home_convoy_lead, home_convoy_lead_place)
    SnapToPoint(home_transport_1, home_transport_1_place)
    SnapToPoint(home_transport_2, home_transport_2_place)
    SnapToPoint(home_transport_3, home_transport_3_place)
    Wait(3)
    CommsFromShip(a2, "talking", "cor_m1_l36")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromPilot("victorious_bridge_officer", "talking", "ctl_m1_l16")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a2, "talking", "cor_m1_l37")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    SetObjective(5, 1)
    SetObjective(6, 2)
    phase = 5
    game.jump_ready = 1
    return 1
end)

-- Home to the attack: the bridge welcomes the wing back and warns of an attack on its way, with
-- time to rearm at the Nanny first. The objective to return stays current, and the display points
-- the player to the Nanny's approach, ahead of it. Reaching it takes the player's ship aboard: its
-- Dock order cuts to the Nanny's view as the ship flies in at the bow, rearms it to the sound of
-- the work, and flies it out astern, back to the cockpit (mod script nanny.luau repairs it too).
-- The attack comes 15 seconds after the ship is out, or two minutes after the offer if the player
-- hasn't gone aboard by then.

arrive_home_attack = part("(F)Arrive home to the attack", function()
    WaitForJumpOrLaunch(alpha)
    game.jump_ready = 0
    SetActionCentre(richelieu, 0)
    ClearAI(escorts)
    Fly(a2, wingman_hold, 150)
    SetAI(followers, "formation", 1, a2)
    CommsFromPilot("victorious_bridge_officer", "talking", "ctl_m1_l17")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromPilot("victorious_bridge_officer", "talking", "ctl_m1_l24")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    SetNavPoint(alpha, nanny_approach)
    SetEscortPoint(player, nanny_approach)
    SetFlybackMarker(nanny_approach, 4000)
    nanny_state = 1
    spawn(nanny_time_up)
    return 1
end)

-- Two minutes after the offer, the attack comes, unless the player has gone aboard the Nanny.

nanny_time_up = part("(F)Nanny time up", function()
    Wait(120)
    if nanny_state == 1 then
        nanny_state = 3
        SetEscortPoint(player, nil)
        ResetFlybackMarker()
        spawn(home_attack)
    end
    return 1
end)

-- The player's ship reaches the Nanny's approach while the Nanny waits: it goes aboard by port 0.

on(nanny_approach, "ship_reached", { repeats = "always", reached_ship = player }, function(reached_ship)
    if nanny_state == 1 then
        nanny_state = 2
        SetEscortPoint(player, nil)
        ResetFlybackMarker()
        Dock(player, nanny, 0)
    end
    return 1
end)

-- The attack: Coalition fighters jump in ahead of the carrier and go for everything there: the
-- carrier and the ships about it, the convoy and the wing. None of the ships takes damage in this
-- draft; the carrier's guns fire on them.

home_attack = part("(F)Home attack", function()
    CreateFlightGroup(home_attackers)
    SetInvulnerability(carrier_group, 1)
    SetAI(home_attackers, "fly", 1, nil)
    SetAI(home_attackers, "jump_in", 1, attack_in_point)
    StartDirectorCam(attack_camera, attacker_1, 7, nil, alpha)
    PlayMusic("new_mission06.wav", 1)
    CommsFromPilot("victorious_bridge_officer", "talking", "ctl_m1_l18")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromPilot("victorious_bridge_officer", "talking", "ctl_m1_l19")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    SetObjective(6, 1)
    SetObjective(7, 2)
    WaitForJumpOrLaunch(home_attackers)
    SetAI(home_attackers, "find_new_target", 1, home_targets)
    CommsFromShip(a3, "talking", "fah_m1_l9")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a4, "talking", "wal_m1_l13")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromPilot("victorious_bridge_officer", "talking", "ctl_m1_l20")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a2, "talking", "cor_m1_l39")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    SetAI(escorts, "find_new_target", 1, home_attackers)
    CommsFromShip(a5, "talking", "pit_m1_l6")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    return 1
end)

on(home_attackers, "destroyed", { repeats = "always" }, function(killer, victim)
    home_kills += 1
    if home_kills == 3 then
        spawn(home_batteries)
    end
    if home_kills == 8 then
        spawn(bombers_wave)
    end
    return 1
end)

home_batteries = part("(F)Home batteries", function()
    WaitForSpeech()
    CommsFromPilot("victorious_bridge_officer", "talking", "ctl_m1_l21")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    return 1
end)

-- The fighters down, two Kamovs jump in far ahead of the carrier, split up, and each makes for its
-- firing point, while the wing goes after them. The torpedoes are made with them, each in a launch
-- gate of its Kamov and aimed at the carrier, its Explode below, so that it blows up as it hits.

bombers_wave = part("(F)Bombers wave", function()
    Wait(3)
    CreateFlightGroup(home_bombers)
    CreateFlightGroup(home_torpedoes)
    SetAI(home_torpedoes, "explode", 1, nil)
    SetAI(home_torpedoes, "find_new_target", 1, richelieu)
    SetupLaunch(torpedo_a1, kamov_a, 0)
    SetupLaunch(torpedo_a2, kamov_a, 1)
    SetupLaunch(torpedo_b1, kamov_b, 0)
    SetupLaunch(torpedo_b2, kamov_b, 1)
    SetAI(home_bombers, "fly", 1, nil)
    SetAI(kamov_a, "jump_in", 1, kamov_a_in)
    SetAI(kamov_b, "jump_in", 1, kamov_b_in)
    WaitForSpeech()
    CommsFromPilot("victorious_bridge_officer", "talking", "ctl_m1_l25")
    WaitForJumpOrLaunch(home_bombers)
    kamov_a_on = 1
    kamov_b_on = 1
    Fly(kamov_a, kamov_a_fire, 0)
    Fly(kamov_b, kamov_b_fire, 0)
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a2, "talking", "cor_m1_l43")
    ClearAI(escorts)
    SetAI(escorts, "find_new_target", 1, home_bombers)
    SetPlayerTarget(player, kamov_a)
    Wait(1)
    WaitForSpeech()
    Wait(1)
    return 1
end)

-- Each Kamov fires as it reaches its point, 350,000 from the carrier: its bay opens, its two
-- torpedoes go three seconds apart, it closes the bay and turns for its way out, and jumps out 20
-- seconds later if it is still flying.

on(kamov_a_fire, "ship_reached", { reached_ship = kamov_a }, function(reached_ship)
    if kamov_a_on == 1 then
        spawn(kamov_a_attack)
    end
    return 1
end)

on(kamov_b_fire, "ship_reached", { reached_ship = kamov_b }, function(reached_ship)
    if kamov_b_on == 1 then
        spawn(kamov_b_attack)
    end
    return 1
end)

kamov_a_attack = part("(F)Kamov A attack", function()
    StartShipAnimation(kamov_a, "deploy")
    spawn(torpedoes_away)
    Wait(2)
    if kamov_a_on == 1 then
        StartLaunch(torpedo_a1)
    end
    Wait(3)
    if kamov_a_on == 1 then
        StartLaunch(torpedo_a2)
    end
    Wait(2)
    if kamov_a_on == 1 then
        StartShipAnimationReverse(kamov_a, "deploy")
        Fly(kamov_a, kamov_a_out, 0)
    end
    Wait(20)
    if kamov_a_on == 1 then
        kamov_a_on = 0
        SetAI(kamov_a, "jump_out", 1, nil)
        bomber_out()
    end
    return 1
end)

kamov_b_attack = part("(F)Kamov B attack", function()
    StartShipAnimation(kamov_b, "deploy")
    spawn(torpedoes_away)
    Wait(2)
    if kamov_b_on == 1 then
        StartLaunch(torpedo_b1)
    end
    Wait(3)
    if kamov_b_on == 1 then
        StartLaunch(torpedo_b2)
    end
    Wait(2)
    if kamov_b_on == 1 then
        StartShipAnimationReverse(kamov_b, "deploy")
        Fly(kamov_b, kamov_b_out, 0)
    end
    Wait(20)
    if kamov_b_on == 1 then
        kamov_b_on = 0
        SetAI(kamov_b, "jump_out", 1, nil)
        bomber_out()
    end
    return 1
end)

-- The bridge calls the first torpedoes away, once.

torpedoes_away = part("(F)Torpedoes away", function()
    if torpedoes_called == 0 then
        torpedoes_called = 1
        WaitForSpeech()
        CommsFromPilot("victorious_bridge_officer", "talking", "ctl_m1_l26")
        Wait(1)
        WaitForSpeech()
    end
    return 1
end)

on(kamov_a, "destroyed", function(killer, victim)
    if kamov_a_on == 1 then
        kamov_a_on = 0
        bomber_out()
    end
    return 1
end)

on(kamov_b, "destroyed", function(killer, victim)
    if kamov_b_on == 1 then
        kamov_b_on = 0
        bomber_out()
    end
    return 1
end)

-- The torpedoes in flight: each counts from its launch until it hits or is shot down.

on(home_torpedoes, "launched", { repeats = "always" }, function(launched_ship)
    torpedoes_flying += 1
    return 1
end)

on(home_torpedoes, "destroyed", { repeats = "always" }, function(killer, victim)
    if torpedoes_flying > 0 then
        torpedoes_flying -= 1
    end
    attack_over()
    return 1
end)

bomber_out = part("(F)Bomber out", function()
    bombers_out += 1
    attack_over()
    return 1
end)

-- The attack is over once both Kamovs are destroyed or gone and no torpedo is still flying. The
-- torpedoes that struck the Richelieu are counted then: campaign.luau gives them as the result of
-- PrintShipName with 1, which the mission uses for nothing else.

attack_over = part("(F)Attack over", function()
    if bombers_out == 2 and torpedoes_flying == 0 and attack_done == 0 then
        attack_done = 1
        PrintShipName(richelieu, 1)
        richelieu_hits = result()
        Wait(3)
        spawn(home_cleared)
    end
    return 1
end)

-- The attack beaten: the bridge stands down, the wing talks it over, and the landing follows.

home_cleared = part("(F)Home cleared", function()
    Wait(2)
    SetInvulnerability(carrier_group, 0)
    ClearAI(escorts)
    SetAI(followers, "formation", 1, a2)
    Fly(a2, wingman_hold, 150)
    WaitForSpeech()
    CommsFromPilot("victorious_bridge_officer", "talking", "ctl_m1_l22")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a2, "talking", "cor_m1_l40")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromPilot("victorious_bridge_officer", "talking", "ctl_m1_l23")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a2, "talking", "cor_m1_l41")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a3, "talking", "fah_m1_l10")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a4, "talking", "wal_m1_l14")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a6, "talking", "sta_m1_l6")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a5, "talking", "pit_m1_l7")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a2, "talking", "cor_m1_l42")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    SetObjective(7, 1)
    SetObjective(8, 2)
    phase = 6
    arrive_home()
    return 1
end)

-- The jump out, on every leg: the player engages the jump drive, and the wing jumps to the
-- leg's destination, which the phase says.

on(player, "player_ready_to_jump", { repeats = "always" }, function()
    if phase == 0 then
        spawn(jump_to_zone)
    end
    if phase == 1 then
        spawn(jump_to_nav2)
    end
    if phase == 2 then
        spawn(jump_home)
    end
    if phase == 3 then
        spawn(jump_to_nav4)
    end
    if phase == 4 then
        spawn(jump_to_nav6)
    end
    if phase == 5 then
        spawn(jump_home)
    end
    return 1
end)

jump_to_zone = part("(F)Jump to zone", function()
    ClearAI(alpha)
    SetAI(alpha, "jump_out", 1, nav_1)
    return 1
end)

jump_home = part("(F)Jump home", function()
    DisableObject(carrier_group, 0)
    ClearAI(alpha)
    Wait(1)
    SetAI(alpha, "jump_out", 1, jump_home_point)
    return 1
end)

-- The arrival, on every leg.

on(player, "jumped_in", { repeats = "always" }, function(jumped_in_ship)
    if phase == 0 then
        spawn(arrive_at_zone)
    end
    if phase == 1 then
        spawn(arrive_nav2)
    end
    if phase == 2 then
        spawn(arrive_home_prowler)
    end
    if phase == 3 then
        spawn(arrive_nav4)
    end
    if phase == 4 then
        spawn(arrive_nav6)
    end
    if phase == 5 then
        spawn(arrive_home_attack)
    end
    return 1
end)

-- The Nanny's Docked comes as the player's ship leaves it, rearmed: the attack at home follows 15
-- seconds later.

on(player, "docked", { repeats = "always" }, function()
    if nanny_state == 2 then
        nanny_state = 3
        Wait(15)
        spawn(home_attack)
    end
    return 1
end)

arrive_at_zone = part("(F)Arrive at zone", function()
    WaitForJumpOrLaunch(alpha)
    -- The carrier is far away now: it stops being processed until the jump home.
    DisableObject(carrier_group, 1)
    game.jump_ready = 0
    SetObjective(0, 1)
    SetObjective(1, 2)
    -- Corsair takes his place at the route's start, and the other wingmen theirs abreast of him.
    -- The player's place rides him once he stands there, so it is attached a second later, and
    -- the rest of the wing keeps formation on him.
    ClearAI(escorts)
    SnapToPoint(a2, formation_start)
    SnapToPoint(a3, a3_start)
    SnapToPoint(a4, a4_start)
    SnapToPoint(a5, a5_start)
    SnapToPoint(a6, a6_start)
    Wait(1)
    CreateFlightGroup(formation_points)
    SetAI(formation_points, "object_attach", 1, a2)
    SetAI(followers, "formation", 1, a2)
    SetActionCentre(a2, 250000)
    SetFlybackMarker(a2, 40000)
    SetEscortPoint(player, formation_slot)
    SetNavPoint(alpha, formation_slot)
    spawn(formation_briefing)
    spawn(formation_route)
    formation_on = 1
    CreateTimer(1, formation_tick, 1, 0)
    return 1
end)

-- Corsair's route: each heading in turn while the exercise runs, then on straight. While the
-- halfway cinematic runs he flies straight on instead, and takes the route up again at its next
-- heading.

formation_route = part("(F)Formation route", function()
    Fly(a2, heading_1, 130)
    Wait(40)
    if formation_on == 1 then
        if cinema_on == 0 then
            Fly(a2, heading_2, 130)
        end
    end
    Wait(3)
    if formation_on == 1 then
        if cinema_on == 0 then
            Fly(a2, heading_3, 130)
        end
    end
    Wait(37)
    if formation_on == 1 then
        if cinema_on == 0 then
            Fly(a2, heading_4, 130)
        end
    end
    Wait(3)
    if formation_on == 1 then
        if cinema_on == 0 then
            Fly(a2, heading_5, 130)
        end
    end
    Wait(37)
    if formation_on == 1 then
        if cinema_on == 0 then
            Fly(a2, heading_6, 130)
        end
    end
    Wait(3)
    if formation_on == 1 then
        if cinema_on == 0 then
            Fly(a2, heading_7, 130)
        end
    end
    Wait(37)
    if formation_on == 1 then
        if cinema_on == 0 then
            Fly(a2, heading_8, 130)
        end
    end
    Wait(3)
    if formation_on == 1 then
        if cinema_on == 0 then
            Fly(a2, heading_9, 130)
        end
    end
    Wait(37)
    if formation_on == 1 then
        if cinema_on == 0 then
            Fly(a2, formation_beyond, 130)
        end
    end
    return 1
end)

-- The radio over the exercise: the mod's own lines, as the launch chatter's, each a second
-- after the one before it ends. Corsair orders the parade formation as the wing comes out of
-- the jump, the wing chats once the player has had time to join up, and Corsair calls it to
-- order.

formation_briefing = part("(F)Formation briefing", function()
    radio_busy = 1
    Wait(2)
    CommsFromShip(a2, "talking", "cor_m1_l7")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    Wait(8)
    CommsFromShip(a3, "talking", "fah_m1_l1")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a4, "talking", "wal_m1_l3")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a3, "talking", "fah_m1_l2")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a6, "talking", "sta_m1_l1")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a5, "talking", "pit_m1_l2")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a4, "talking", "wal_m1_l4")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a2, "talking", "cor_m1_l8")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a4, "talking", "wal_m1_l5")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a2, "talking", "cor_m1_l9")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    radio_busy = 0
    return 1
end)

formation_drifting = part("(F)Formation drifting", function()
    radio_busy = 1
    CommsFromShip(a2, "talking", "cor_m1_l4")
    Wait(1)
    WaitForSpeech()
    radio_busy = 0
    return 1
end)

-- Halfway: Corsair says so, and a few seconds later the camera leaves the cockpit for ten seconds
-- to show the whole wing in formation flying past it, while Corsair flies straight on.
-- Corsair sets off straight on as the line ends, so that he flies steady by the time the shot
-- starts. cinematic.luau puts the player's ship in its place behind him as it starts, since a
-- player's ship takes none of the orders that would, and holds the player's controls for the
-- shot; the player flies it again as the camera comes back.

formation_halfway = part("(F)Formation halfway", function()
    radio_busy = 1
    CommsFromShip(a2, "talking", "cor_m1_l5")
    Wait(1)
    WaitForSpeech()
    cinema_on = 1
    Fly(a2, straight_ahead, 130)
    Wait(3)
    SnapToPoint(cinema_camera, cinema_mark)
    StartDirectorCam(cinema_camera, a2, 10, nil, nil)
    Wait(10)
    cinema_on = 0
    radio_busy = 0
    return 1
end)

-- Once a second: a second in the player's place counts toward the two minutes; a second out of
-- it counts toward Corsair's reminders, at 10 and 30 seconds out. The first 30 seconds draw none,
-- so that the player has time to join up. Seconds out never undo the time already flown. The
-- halfway lines, the reminders and the end wait for the radio to be free, so that no line cuts
-- another.

formation_tick = part("(F)Formation tick", function()
    if formation_on == 1 then
        formation_elapsed += 1
        if in_slot == 1 then
            -- Reaching the place targets Corsair and matches his speed, as MATCH SPEED does.
            if matching == 0 then
                matching = 1
                SetPlayerTarget(player, a2)
                MatchSpeed(player, 1)
            end
            formation_seconds += 1
            drift_seconds = 0
            if radio_busy == 0 then
                if formation_seconds >= 120 then
                    formation_on = 0
                    halfway_said = 1
                    DestroyTimer(1)
                    spawn(formation_complete)
                end
                if formation_seconds >= 60 then
                    if halfway_said == 0 then
                        halfway_said = 1
                        spawn(formation_halfway)
                    end
                end
            end
        else
            matching = 0
            if formation_elapsed > 30 then
                drift_seconds += 1
                if radio_busy == 0 then
                    if drift_seconds == 10 then
                        spawn(formation_drifting)
                    end
                    if drift_seconds == 30 then
                        spawn(formation_drifting)
                    end
                end
            end
        end
        in_slot = 0
    end
    return 1
end)

on(formation_slot, "ship_reached", { repeats = "always", reached_ship = player }, function(reached_ship)
    in_slot = 1
    return 1
end)

-- Two minutes flown in place: the exercise is over, and the bridge breaks off the next drill: a
-- distress call, then the wing's new tasking, Nav 2.

formation_complete = part("(F)Formation complete", function()
    phase = 1
    game.mission_success = 3
    SetEscortPoint(player, nil)
    ResetFlybackMarker()
    MatchSpeed(player, 0)
    SetObjective(1, 1)
    Wait(2)
    CommsFromPilot("victorious_bridge_officer", "talking", "ctl_m1_l2")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a2, "talking", "cor_m1_l10")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromPilot("victorious_bridge_officer", "talking", "ctl_m1_l3")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a2, "talking", "cor_m1_l11")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromPilot("victorious_bridge_officer", "talking", "ctl_m1_l4")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    Wait(2)
    CommsFromPilot("mitchell_bridge_officer", "talking", "unk_m1_l1")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromPilot("victorious_bridge_officer", "talking", "ctl_m1_l5")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a2, "talking", "cor_m1_l12")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromPilot("victorious_bridge_officer", "talking", "ctl_m1_l6")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a2, "talking", "cor_m1_l13")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    SetObjective(2, 2)
    SetNavPoint(alpha, nav_2)
    CommsFromShip(a4, "talking", "wal_m1_l6")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a2, "talking", "cor_m1_l14")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    game.jump_ready = 1
    return 1
end)

-- The landing, once the attack is beaten.

arrive_home = part("(F)Arrive home", function()
    SetActionCentre(richelieu, 0)
    ResetFlybackMarker()
    -- The display points the player to the recovery point astern of the carrier. The ninth
    -- objective, already current, asks the player to request permission to land.
    SetNavPoint(alpha, recovery_point)
    -- Corsair takes the wing to its hold point astern of the carrier, out of the way of the
    -- player's landing, the others in formation on him, apart from one another.
    ClearAI(escorts)
    Fly(a2, wingman_hold, 150)
    SetAI(followers, "formation", 1, a2)
    PlayMusic("new_victory.wav", 0)
    -- The player may ask PERMISSION TO LAND: the pilot asks, and the bridge clears the ship, as
    -- the game does. The mod's script refuses the Land order the request gives, so that the ship
    -- flies on to the recovery point first, and the mission waits for the request to show the
    -- way there.
    game.landing_cleared = 1
    spawn(await_landing_request)
    return 1
end)

-- Waits for the player to ask PERMISSION TO LAND, then shows the escort marker on the recovery
-- point, the display points the player to it (the flyback marker, until the ship is within 4000,
-- where the landing begins), and the last objective asks the player to fly there. The wait is
-- the mod's script's, landing.luau: it holds the debug message command until the player's ship
-- is given its Land order, which the request gives it.

await_landing_request = part("(F)Await landing request", function()
    PrintDebugMessage("spear: landing request")
    cleared_to_land = 1
    SetObjective(8, 1)
    SetObjective(9, 2)
    SetEscortPoint(player, recovery_point)
    SetFlybackMarker(recovery_point, 4000)
    return 1
end)

-- For checking the mission from the command line: `--part "target carrier"` targets the Richelieu,
-- so that a screenshot shows the target display with its name.

target_carrier = part("(F)Target carrier", function()
    SetPlayerTarget(player, richelieu)
    return 1
end)

-- `--part "test recovery"` plays the end of the mission: the attack on the Richelieu counted as
-- beaten, and the player's ship put at the recovery point, which ends the mission a few seconds
-- later.
-- `--part "test marker"` puts it at the test view instead, 13,000 short of the recovery point and
-- facing it, with the escort marker in view.

test_recovery = part("(F)Test recovery", function()
    -- After the start's launch shot, which would take the camera from the landing's.
    Wait(9)
    phase = 6
    cleared_to_land = 1
    game.mission_success = 3
    SetObjective(8, 1)
    SetObjective(9, 2)
    SetNavPoint(alpha, recovery_point)
    SetEscortPoint(player, recovery_point)
    SetFlybackMarker(recovery_point, 4000)
    SnapToPoint(player, recovery_point)
    return 1
end)

test_marker = part("(F)Test marker", function()
    phase = 6
    SetNavPoint(alpha, recovery_point)
    SetEscortPoint(player, recovery_point)
    SetFlybackMarker(recovery_point, 4000)
    SnapToPoint(player, test_view)
    return 1
end)

-- `--part "test zone"` puts the player at Nav 1 as the jump there leaves it, to see the zone.

test_zone = part("(F)Test zone", function()
    Wait(7)
    SnapToPoint(player, nav_1)
    arrive_at_zone()
    return 1
end)

-- `--part "test formation"` does the same, and gives the player's ship an Escort order on its
-- place in the formation, so that the exercise flies itself.

test_formation = part("(F)Test formation", function()
    Wait(7)
    SnapToPoint(player, nav_1)
    spawn(arrive_at_zone)
    Wait(2)
    SetAI(player, "escort", 1, formation_slot)
    return 1
end)

-- `--part "test cinema"` puts the player at Nav 1 as `test formation` does, and plays the halfway
-- lines and cinematic a few seconds into the exercise.

test_cinema = part("(F)Test cinema", function()
    Wait(7)
    SnapToPoint(player, nav_1)
    spawn(arrive_at_zone)
    Wait(5)
    halfway_said = 1
    spawn(formation_halfway)
    return 1
end)

-- `--part "test convoy"` shows the carrier and the ships about it from afar for 40 seconds,
-- from the mission's start, as the shuttle flies off and jumps out.

test_convoy = part("(F)Test convoy", function()
    Wait(3)
    StartDirectorCam(convoy_view, richelieu, 40, nil, nil)
    return 1
end)

-- `--part "test nav2"`, `"test prowler home"`, `"test nav4"`, `"test nav6"` and `"test attack"`
-- jump the wing straight to that leg once it has launched (`"test attack"` to the Nanny's offer,
-- which the attack follows two minutes later).

test_nav2 = part("(F)Test nav2", function()
    Wait(40)
    phase = 1
    spawn(jump_to_nav2)
    return 1
end)

test_prowler_home = part("(F)Test prowler home", function()
    Wait(40)
    phase = 2
    spawn(jump_home)
    return 1
end)

test_nav4 = part("(F)Test nav4", function()
    Wait(40)
    phase = 3
    spawn(jump_to_nav4)
    return 1
end)

test_nav6 = part("(F)Test nav6", function()
    Wait(40)
    phase = 4
    spawn(jump_to_nav6)
    return 1
end)

test_attack = part("(F)Test attack", function()
    Wait(40)
    phase = 5
    spawn(jump_home)
    return 1
end)

-- `--part "test nanny"` does the same, and puts the player's ship at the Nanny's approach 45
-- seconds after the jump, once the bridge has offered it, so that it goes aboard at once.

test_nanny = part("(F)Test nanny", function()
    Wait(40)
    phase = 5
    spawn(jump_home)
    Wait(45)
    SnapToPoint(player, nanny_approach)
    return 1
end)

-- `--part "test jump"` jumps the wing to Nav 1 once it has launched, as the player's jump would,
-- and targets Corsair, to see the wing come out of the jump.

-- `--part "test bombers"` jumps the wing home once it has launched, with neither the Nanny nor
-- the fighters' attack, and sends the Kamovs in 15 seconds after the jump.

test_bombers = part("(F)Test bombers", function()
    Wait(40)
    phase = 6
    spawn(jump_home)
    Wait(15)
    SetInvulnerability(carrier_group, 1)
    spawn(bombers_wave)
    return 1
end)

test_jump = part("(F)Test jump", function()
    Wait(40)
    jump_to_zone()
    Wait(20)
    SetPlayerTarget(player, a2)
    return 1
end)

-- `--part "test ending"` plays the end of the mission from the landing on: the attack on the
-- Richelieu counted as beaten, the player's ship put astern of the carrier facing it, and the
-- landing request awaited, as `arrive_home` leaves it.

test_ending = part("(F)Test ending", function()
    phase = 6
    game.mission_success = 3
    SetObjective(8, 2)
    SnapToPoint(player, test_view)
    SnapToPoint(a2, wingman_hold)
    arrive_home()
    return 1
end)

-- Back at the carrier: once the bridge has cleared the ship and the player's ship comes within
-- 4000 of the recovery point, the ship lands in bay 0, the one the point stands in the axis of.
-- The Land order names the bay as the Richelieu's component 0, so OpenReliant begins the landing
-- at once: the camera cuts to a view by the bay, the ship flies in at the doors by itself, and the
-- mission is over once it is down at the bay's launch point. The trigger fires again each time
-- the ship is seen at the point, so that reaching it before asking changes nothing. Should
-- nothing land the ship, the mission still ends a minute and a half later.

on(recovery_point, "ship_reached", { repeats = "always", reached_ship = player }, function(reached_ship)
    if phase == 6 and cleared_to_land == 1 then
        cleared_to_land = 2
        SetObjective(9, 1)
        SetEscortPoint(player, nil)
        ResetFlybackMarker()
        game.landing_cleared = 0
        SetAI(player, "land", 1, component(richelieu, 0))
        Wait(90)
        game.mission_over = 1
    end
    return 1
end)
