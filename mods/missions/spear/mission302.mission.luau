-- SPEAR mission 2 (mission302): Silence Radio. The patrol launches from the Richelieu and jumps to
-- Forte San Marco, in outer Earth orbit, which has gone silent: the fort is under Coalition attack.
-- The wing beats the first engagement, 8 Azans and 2 Kurgens; the CS Kazan jumps in with 8 more
-- Azans as soon as the first Azans are down; once its escort and the Kurgens are down, the wing
-- disables the Kazan's and the CS Murmansk's shield generators and engines, in that order. The
-- Richelieu then jumps in between the two carriers with the evacuation convoy and torpedoes both.
-- The wing defends the fort's evacuation through a ten-minute window of Sabre waves, covers the
-- convoy's departure, intercepts two torpedo salvos from the CS Sevastopol while the Richelieu
-- readies its jump, clears the Sevastopol's Sabres, and jumps after the Richelieu to land on it.
--
-- The campaign's ships fly as the game's models under their campaign names, the mod's ship types
-- (mod.ini): the Richelieu (300, the Victorious), the Murmansk (302, the Kozlov, whose model is the
-- Krasnaya's), the Kazan (303, the Badanov), the Sevastopol (304, the Kiev) and Forte San Marco
-- (305, Fort Baxter). Rook and Mako, Alpha 5 and 6, are the mod's pilots 246 and 247.
--
-- The mission hands what the campaign keeps to campaign.luau through PrintShipName, whose second
-- argument is a number the script reads: 1 asks for the Richelieu hits of this attempt, which the
-- command gives back as its result, and 100 plus a number reports the priority transports saved.
-- The mission uses PrintShipName for nothing else.
--
-- The Richelieu stands at the origin, facing along Z, as in mission 1. Forte San Marco stands
-- 3,000,000 ahead, and the wing comes out of its jump 150,000 short of it. The Richelieu's new
-- place, after its jump away from the fort, lies 2,000,000 to its left.
--
-- Build: sltool dte build mission302.mission.luau mission302.dte

mission({ name = "Spear 2: Silence Radio" })

-- The mission's phase, which says where the player's jump goes and what the arrival brings: 0 to
-- Forte San Marco, 1 at the fort, 2 once the bridge has called the wing home, 3 home for the
-- landing.
phase = global("(GV)phase", 0)
-- Whether the bridge has cleared the ship to land, as in mission 1.
cleared_to_land = global("(GV)cleared to land", 0)
-- How many of the two things the first jump waits on are done: the launch and the radio over it.
ready_steps = global("(GV)ready steps", 0)

-- The first engagement: the first Azans and Kurgens down, and whether it is over; the Kazan's
-- escort down; whether the window of opportunity is open.
azan_kills = global("(GV)azan kills", 0)
kurgen_kills = global("(GV)kurgen kills", 0)
engagement_done = global("(GV)engagement done", 0)
escort_kills = global("(GV)escort kills", 0)
window_open = global("(GV)window open", 0)
-- The carriers' systems: the step reached (0 to 4: the Kazan's shield generator, its engines, the
-- Murmansk's shield generator, its engines), and the engines each carrier has lost.
systems_step = global("(GV)systems step", 0)
kazan_engines = global("(GV)kazan engines", 0)
murmansk_engines = global("(GV)murmansk engines", 0)
-- The Richelieu's strike: how many of each carrier's torpedoes are done with (having hit, or shot
-- down), whether each carrier has exploded, and how many have.
kazan_torpedoes_done = global("(GV)kazan torpedoes done", 0)
murmansk_torpedoes_done = global("(GV)murmansk torpedoes done", 0)
kazan_exploded = global("(GV)kazan exploded", 0)
murmansk_exploded = global("(GV)murmansk exploded", 0)
carriers_down = global("(GV)carriers down", 0)

-- The evacuation window: its seconds, the seconds since the last Sabre wave and the waves come, and
-- whether it is over, which freezes the evacuation result.
evac_seconds = global("(GV)evacuation seconds", 0)
wave_clock = global("(GV)wave clock", 0)
waves = global("(GV)waves", 0)
evac_frozen = global("(GV)evacuation frozen", 0)
-- The priority transports' turns at the fort's bay: whose turn it is (1 to 12), the seconds into
-- the turn, which transport is at the bay, which the Sabre waves go for (0 for none), and whether
-- it has reached the bay's mouth and holds there.
evac_turn = global("(GV)evacuation turn", 1)
turn_clock = global("(GV)turn clock", 0)
at_bay = global("(GV)at bay", 0)
bay_held = global("(GV)bay held", 0)
-- The Rippers' shuttle between the fort and the transports: its seconds.
ripper_clock = global("(GV)ripper clock", 0)
-- The priority transports lost before the window ended, and saved as it ended.
transports_lost = global("(GV)transports lost", 0)
transports_saved = global("(GV)transports saved", 0)
evacuation_failed = global("(GV)evacuation failed", 0)
-- Whether each priority transport flies: Mammoths 1 to 6, Lueneburgs 1 to 6.
mammoth_1_on = global("(GV)mammoth 1 on", 1)
mammoth_2_on = global("(GV)mammoth 2 on", 1)
mammoth_3_on = global("(GV)mammoth 3 on", 1)
mammoth_4_on = global("(GV)mammoth 4 on", 1)
mammoth_5_on = global("(GV)mammoth 5 on", 1)
mammoth_6_on = global("(GV)mammoth 6 on", 1)
lueneburg_1_on = global("(GV)lueneburg 1 on", 1)
lueneburg_2_on = global("(GV)lueneburg 2 on", 1)
lueneburg_3_on = global("(GV)lueneburg 3 on", 1)
lueneburg_4_on = global("(GV)lueneburg 4 on", 1)
lueneburg_5_on = global("(GV)lueneburg 5 on", 1)
lueneburg_6_on = global("(GV)lueneburg 6 on", 1)
-- Whether each of the convoy's other ships flies, so that the departure skips those lost.
lonestar_1_on = global("(GV)lonestar 1 on", 1)
lonestar_2_on = global("(GV)lonestar 2 on", 1)
ripper_1_on = global("(GV)ripper 1 on", 1)
ripper_2_on = global("(GV)ripper 2 on", 1)
ripper_3_on = global("(GV)ripper 3 on", 1)
ripper_4_on = global("(GV)ripper 4 on", 1)
ripper_5_on = global("(GV)ripper 5 on", 1)
ripper_6_on = global("(GV)ripper 6 on", 1)
nanny_1_on = global("(GV)nanny 1 on", 1)
nanny_2_on = global("(GV)nanny 2 on", 1)
kestrel_on = global("(GV)kestrel on", 1)
prowler_1_on = global("(GV)prowler 1 on", 1)
prowler_2_on = global("(GV)prowler 2 on", 1)
-- Whether each original defender flies: Coyotes 1 and 2, the Prowler, Mammoths 1 and 2,
-- Lueneburgs 1 and 2. Those that fly once the convoy has gone have jumped out with it.
defender_1_on = global("(GV)defender 1 on", 1)
defender_2_on = global("(GV)defender 2 on", 1)
defender_3_on = global("(GV)defender 3 on", 1)
defender_4_on = global("(GV)defender 4 on", 1)
defender_5_on = global("(GV)defender 5 on", 1)
defender_6_on = global("(GV)defender 6 on", 1)
defender_7_on = global("(GV)defender 7 on", 1)
defenders_survived = global("(GV)defenders survived", 0)
-- The debriefing's score, 4 to 0 (game.mission_success); -1, a total failure, once all twelve
-- priority transports are lost.
score = global("(GV)score", 0)

-- The Sevastopol: its Sabres launched and down, each salvo's torpedoes flying and done with (shot
-- down or having hit), whether the Richelieu has jumped away, and whether the wing has been called
-- home. The Richelieu hits of this attempt, as campaign.luau counts them.
sabres_deployed = global("(GV)sabres deployed", 0)
sevastopol_kills = global("(GV)sevastopol kills", 0)
salvo_1_flying = global("(GV)salvo 1 flying", 0)
salvo_1_done = global("(GV)salvo 1 done", 0)
salvo_2_flying = global("(GV)salvo 2 flying", 0)
salvo_2_done = global("(GV)salvo 2 done", 0)
richelieu_gone = global("(GV)richelieu gone", 0)
home_called = global("(GV)home called", 0)
richelieu_hits = global("(GV)richelieu hits", 0)

-- Flight groups. The player's own is listed in the player's wing.

alpha = flight_group("(FG)Alpha", { wing = "player" })
carrier_group = flight_group("(FG)Richelieu")
jump_points = flight_group("(FG)Jump points")
home_points = flight_group("(FG)Home points")
zone_points = flight_group("(FG)Zone points")
planets = flight_group("(FG)Planets")
fort_group = flight_group("(FG)San Marco")
defenders = flight_group("(FG)Defenders")
fort_kestrel = flight_group("(FG)Fort Kestrel")
first_azans = flight_group("(FG)First Azans")
first_kurgens = flight_group("(FG)First Kurgens")
murmansk_group = flight_group("(FG)Murmansk")
kazan_group = flight_group("(FG)Kazan")
kazan_escort = flight_group("(FG)Kazan escort")
kazan_torpedoes = flight_group("(FG)Kazan torpedoes")
murmansk_torpedoes = flight_group("(FG)Murmansk torpedoes")
convoy_places = flight_group("(FG)Convoy places")
fort_ring = flight_group("(FG)Fort ring")
convoy_mammoths = flight_group("(FG)Convoy Mammoths")
convoy_lueneburgs = flight_group("(FG)Convoy Lueneburgs")
convoy_lonestars = flight_group("(FG)Convoy Lonestars")
convoy_rippers = flight_group("(FG)Convoy Rippers")
convoy_nannies = flight_group("(FG)Convoy Nannies")
convoy_escorts = flight_group("(FG)Convoy escorts")
wave_points = flight_group("(FG)Wave points")
wave_1 = flight_group("(FG)Wave 1")
wave_2 = flight_group("(FG)Wave 2")
wave_3 = flight_group("(FG)Wave 3")
wave_4 = flight_group("(FG)Wave 4")
wave_5 = flight_group("(FG)Wave 5")
wave_6 = flight_group("(FG)Wave 6")
wave_7 = flight_group("(FG)Wave 7")
wave_8 = flight_group("(FG)Wave 8")
wave_9 = flight_group("(FG)Wave 9")
wave_10 = flight_group("(FG)Wave 10")
sevastopol_group = flight_group("(FG)Sevastopol")
sevastopol_sabres = flight_group("(FG)Sevastopol Sabres")
salvo_1 = flight_group("(FG)Salvo 1")
salvo_2 = flight_group("(FG)Salvo 2")

-- Ships. The first is the player's. The wing launches from the Richelieu's bow bays in three waves
-- of two, as in mission 1 (`sltool shp info Victorious.SHP`: gates 2 and 3 open ahead). Alpha 3 to
-- 6 wait parked far astern, disabled, until their turn. The wingmen are the mod's Marauders by
-- their manifest numbers; flown from the SPEAR game mode, the mode seats Corsair, Fahrenheit and
-- Walk'n in Alpha 2 to 4, and the mode's records Rook and Mako in Alpha 5 and 6.

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
    pilot = 246,
    position = { 40000, 0, -720000 },
})
a6 = ship("(A6)Mirage", {
    type = "mirage",
    group = alpha,
    pilot = 247,
    position = { -40000, 0, -720000 },
})

escorts = squad("(AI)Escorts", { a2, a3, a4, a5, a6 })
followers = squad("(AI)Followers", { a3, a4, a5, a6 })

richelieu = ship("The Richelieu", {
    type = 300,
    group = carrier_group,
    pilot = "victorious_bridge_officer",
})

-- Markers that ride the Richelieu (`object_attach`) wherever it goes: the recovery point in the
-- axis of bay 0, where the landing begins, the wingmen's hold astern, and the places each wingman
-- flies to out of its bay, as mission 1's.

recovery_point = nav_point("Recovery point", {
    group = home_points,
    position = { -12867, 4057, -53000 },
})
wingman_hold = waypoint("Wingman hold", {
    group = home_points,
    position = { -24000, 0, -90000 },
})
test_view = waypoint("Test view", {
    group = home_points,
    position = { -12867, 4057, -66000 },
})
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

-- Where the camera stands for the launch, ahead of the bow, as in mission 1.
launch_camera = point("Launch camera", {
    group = jump_points,
    position = { -3000, 9000, 69000 },
})
-- Where the wing comes out of its jump to the fort: 150,000 short of it, facing it.
san_marco_nav = nav_point("Forte San Marco", {
    group = jump_points,
    position = { 0, -20000, 2850000 },
    yaw = 0,
})
-- Where the Richelieu jumps in, between the two carriers and beyond the fort, beside it rather
-- than in its axis: 60,000 to the Murmansk's side, facing the way the wing came in, so that each
-- carrier lies abeam of it and the fort ahead and off its bow, its bow 100,000 beyond the fort's
-- far side. A ship that lists components flies in from 100,000 behind its arrival. It stops there
-- and holds, rather than flying on as it did off its launch. Its new place after its jump away,
-- and where the wing jumps to join it, 140,000 astern of it, facing it.
richelieu_in = point("Richelieu in", {
    group = jump_points,
    position = { -60000, 0, 3190000 },
    yaw = 180,
})
richelieu_away = point("Richelieu away", {
    group = jump_points,
    position = { -2000000, 0, 1000000 },
    yaw = 0,
})
jump_home_point = waypoint("Jump home point", {
    group = jump_points,
    position = { -2000000, 0, 860000 },
    yaw = 0,
})

-- Earth, beyond the fort, ahead and below the way the wing comes in, its centre 3,160,000 from the
-- fort. The model of Realistic Planets' Earth (earth.shp) has its origin off its centre, by
-- (752661, -5579, -993745), so the position is the centre less that.

earth = ship("Earth", {
    type = "earth",
    group = planets,
    position = { -1352661, 805579, 6993745 },
})

-- Forte San Marco and its original defenders. The fort stands at (0, 0, 3,000,000); Fort Baxter's
-- model reaches 42,000 astern, 46,000 ahead, 28,000 to the left, 32,000 to the right and 53,000
-- below its origin. The defenders stand about it on the side the wing comes in from. The Kestrel
-- is lost in the arrival cinematic.

san_marco = ship("Forte San Marco", {
    type = 305,
    group = fort_group,
    pilot = "fort_baxter_comms",
    position = { 0, 0, 3000000 },
})
defender_coyote_1 = ship("Coyote 1", {
    type = "coyote",
    group = defenders,
    position = { -25000, -8000, 2945000 },
})
defender_coyote_2 = ship("Coyote 2", {
    type = "coyote",
    group = defenders,
    position = { 25000, -6000, 2950000 },
})
defender_prowler = ship("Prowler", {
    type = "prowler",
    group = defenders,
    pilot = "prowler",
    position = { -55000, 12000, 2935000 },
})
defender_mammoth_1 = ship("Mammoth 1", {
    type = "mammoth",
    group = defenders,
    position = { -75000, 5000, 2985000 },
})
defender_mammoth_2 = ship("Mammoth 2", {
    type = "mammoth",
    group = defenders,
    position = { 75000, 5000, 2985000 },
})
defender_lueneburg_1 = ship("Lueneburg 1", {
    type = "lueneburg",
    group = defenders,
    position = { -60000, 35000, 2960000 },
})
defender_lueneburg_2 = ship("Lueneburg 2", {
    type = "lueneburg",
    group = defenders,
    position = { 60000, 35000, 2960000 },
})
lost_kestrel = ship("Kestrel", {
    type = "kestrel",
    group = fort_kestrel,
    position = { 0, -40000, 2925000 },
})

-- The first engagement: 8 Azans on the defenders, 2 Kurgens on the fort.

azan_1 = ship("Azan 1", { type = "azan", group = first_azans, pilot = "coalition_fighter", position = { -15000, -20000, 2930000 }, yaw = 180 })
azan_2 = ship("Azan 2", { type = "azan", group = first_azans, pilot = "coalition_fighter", position = { -5000, -22000, 2932000 }, yaw = 180 })
azan_3 = ship("Azan 3", { type = "azan", group = first_azans, pilot = "coalition_fighter", position = { 5000, -18000, 2934000 }, yaw = 180 })
azan_4 = ship("Azan 4", { type = "azan", group = first_azans, pilot = "coalition_fighter", position = { 15000, -21000, 2936000 }, yaw = 180 })
azan_5 = ship("Azan 5", { type = "azan", group = first_azans, pilot = "coalition_fighter", position = { -40000, 20000, 2950000 }, yaw = 90 })
azan_6 = ship("Azan 6", { type = "azan", group = first_azans, pilot = "coalition_fighter", position = { -45000, 25000, 2955000 }, yaw = 90 })
azan_7 = ship("Azan 7", { type = "azan", group = first_azans, pilot = "coalition_fighter", position = { 40000, 20000, 2950000 }, yaw = 270 })
azan_8 = ship("Azan 8", { type = "azan", group = first_azans, pilot = "coalition_fighter", position = { 45000, 25000, 2955000 }, yaw = 270 })
kurgen_1 = ship("Kurgen 1", { type = "kurgan", group = first_kurgens, position = { -20000, -35000, 2900000 } })
kurgen_2 = ship("Kurgen 2", { type = "kurgan", group = first_kurgens, position = { 20000, -35000, 2905000 } })

-- The carriers. The Murmansk is there from the start, beyond the fort and to its left; the Kazan
-- jumps in to its right with 8 Azans. Their components (`sltool shp components`): the Kazan's, the
-- Badanov's, 0 its comms, 1 to 3 its engines, 4 its shield generator; the Murmansk's, the
-- Krasnaya's, 0 its comms tower, 1 and 2 its engine blocks, 3 its shield generator. The rest are
-- turrets, free to fire and to be destroyed. Each of the others stays invulnerable until its turn.

murmansk = ship("Murmansk", {
    type = 302,
    group = murmansk_group,
    position = { -160000, -10000, 3140000 },
    yaw = 90,
})
kazan = ship("Kazan", {
    type = 303,
    group = kazan_group,
    position = { 160000, 10000, 3140000 },
    yaw = 270,
})
kazan_in = point("Kazan in", {
    group = zone_points,
    position = { 160000, 10000, 3140000 },
    yaw = 270,
})
escort_in = point("Escort in", {
    group = zone_points,
    position = { 120000, 0, 3060000 },
    yaw = 240,
})
escort_1 = ship("Escort 1", { type = "azan", group = kazan_escort, pilot = "coalition_fighter", position = { 120000, 0, 3060000 }, yaw = 240 })
escort_2 = ship("Escort 2", { type = "azan", group = kazan_escort, pilot = "coalition_fighter", position = { 123000, 0, 3060000 }, yaw = 240 })
escort_3 = ship("Escort 3", { type = "azan", group = kazan_escort, pilot = "coalition_fighter", position = { 117000, 0, 3060000 }, yaw = 240 })
escort_4 = ship("Escort 4", { type = "azan", group = kazan_escort, pilot = "coalition_fighter", position = { 126000, 0, 3060000 }, yaw = 240 })
escort_5 = ship("Escort 5", { type = "azan", group = kazan_escort, pilot = "coalition_fighter", position = { 114000, 0, 3060000 }, yaw = 240 })
escort_6 = ship("Escort 6", { type = "azan", group = kazan_escort, pilot = "coalition_fighter", position = { 129000, 0, 3060000 }, yaw = 240 })
escort_7 = ship("Escort 7", { type = "azan", group = kazan_escort, pilot = "coalition_fighter", position = { 111000, 0, 3060000 }, yaw = 240 })
escort_8 = ship("Escort 8", { type = "azan", group = kazan_escort, pilot = "coalition_fighter", position = { 132000, 0, 3060000 }, yaw = 240 })

kazan_shield = squad("(AI)Kazan shield", { component(kazan, 4) })
kazan_engine_parts = squad("(AI)Kazan engines", { component(kazan, 1), component(kazan, 2), component(kazan, 3) })
murmansk_shield = squad("(AI)Murmansk shield", { component(murmansk, 3) })
murmansk_engine_parts = squad("(AI)Murmansk engines", { component(murmansk, 1), component(murmansk, 2) })

-- The Richelieu's torpedoes, four for each carrier, out of the tubes along either side of its hull
-- rather than its bays: the Victorious' model has no launch point but its four bays, so each
-- torpedo is made by the hull's side, 27,000 out from the Richelieu's middle where it holds,
-- facing its carrier. The Kazan's go from the starboard side, the Murmansk's from the port side.
-- Each carrier explodes once its own four are done with.

torpedo_kazan_1 = ship("Torpedo Kazan 1", { type = "torpedo", group = kazan_torpedoes, position = { -33000, 0, 3170000 }, yaw = 90 })
torpedo_kazan_2 = ship("Torpedo Kazan 2", { type = "torpedo", group = kazan_torpedoes, position = { -33000, 0, 3180000 }, yaw = 90 })
torpedo_kazan_3 = ship("Torpedo Kazan 3", { type = "torpedo", group = kazan_torpedoes, position = { -33000, 0, 3190000 }, yaw = 90 })
torpedo_kazan_4 = ship("Torpedo Kazan 4", { type = "torpedo", group = kazan_torpedoes, position = { -33000, 0, 3200000 }, yaw = 90 })
torpedo_murmansk_1 = ship("Torpedo Murmansk 1", { type = "torpedo", group = murmansk_torpedoes, position = { -87000, 0, 3170000 }, yaw = 270 })
torpedo_murmansk_2 = ship("Torpedo Murmansk 2", { type = "torpedo", group = murmansk_torpedoes, position = { -87000, 0, 3180000 }, yaw = 270 })
torpedo_murmansk_3 = ship("Torpedo Murmansk 3", { type = "torpedo", group = murmansk_torpedoes, position = { -87000, 0, 3190000 }, yaw = 270 })
torpedo_murmansk_4 = ship("Torpedo Murmansk 4", { type = "torpedo", group = murmansk_torpedoes, position = { -87000, 0, 3200000 }, yaw = 270 })

-- The convoy that jumps in with the Richelieu: the 22 evacuation ships and their escorts, each
-- jumping in at a place of its own. The priority transports circle the fort on its ring (below),
-- each jumping in onto it at a slot of its own, Mammoths and Lueneburgs in turn, 20,000 short of
-- the slot's waypoint and facing the way round, and take their turns at the fort's bay from the
-- ring. The others hold their places, on the side of the fort the wing came in from; the Rippers
-- shuttle between theirs, below, and the bay. The fort's bay mouth stands 33,000 astern of its
-- stern end.

bay_mouth = waypoint("Bay mouth", {
    group = convoy_places,
    position = { 0, 10000, 2925000 },
})
mammoth_1_place = waypoint("Mammoth 1 place", { group = convoy_places, position = { -20000, -25000, 2900000 }, yaw = 90 })
mammoth_2_place = waypoint("Mammoth 2 place", { group = convoy_places, position = { 76603, -25000, 2932679 }, yaw = 30 })
mammoth_3_place = waypoint("Mammoth 3 place", { group = convoy_places, position = { 96603, -25000, 3032679 }, yaw = 330 })
mammoth_4_place = waypoint("Mammoth 4 place", { group = convoy_places, position = { 20000, -25000, 3100000 }, yaw = 270 })
mammoth_5_place = waypoint("Mammoth 5 place", { group = convoy_places, position = { -76603, -25000, 3067321 }, yaw = 210 })
mammoth_6_place = waypoint("Mammoth 6 place", { group = convoy_places, position = { -96603, -25000, 2967321 }, yaw = 150 })
lueneburg_1_place = waypoint("Lueneburg 1 place", { group = convoy_places, position = { 32679, -25000, 2903397 }, yaw = 60 })
lueneburg_2_place = waypoint("Lueneburg 2 place", { group = convoy_places, position = { 100000, -25000, 2980000 }, yaw = 0 })
lueneburg_3_place = waypoint("Lueneburg 3 place", { group = convoy_places, position = { 67321, -25000, 3076603 }, yaw = 300 })
lueneburg_4_place = waypoint("Lueneburg 4 place", { group = convoy_places, position = { -32679, -25000, 3096603 }, yaw = 240 })
lueneburg_5_place = waypoint("Lueneburg 5 place", { group = convoy_places, position = { -100000, -25000, 3020000 }, yaw = 180 })
lueneburg_6_place = waypoint("Lueneburg 6 place", { group = convoy_places, position = { -67321, -25000, 2923397 }, yaw = 120 })
lonestar_1_place = waypoint("Lonestar 1 place", { group = convoy_places, position = { -30000, 30000, 2830000 } })
lonestar_2_place = waypoint("Lonestar 2 place", { group = convoy_places, position = { 30000, 30000, 2830000 } })
ripper_1_place = waypoint("Ripper 1 place", { group = convoy_places, position = { -62500, -40000, 2860000 } })
ripper_2_place = waypoint("Ripper 2 place", { group = convoy_places, position = { -37500, -40000, 2860000 } })
ripper_3_place = waypoint("Ripper 3 place", { group = convoy_places, position = { -12500, -40000, 2860000 } })
ripper_4_place = waypoint("Ripper 4 place", { group = convoy_places, position = { 12500, -40000, 2860000 } })
ripper_5_place = waypoint("Ripper 5 place", { group = convoy_places, position = { 37500, -40000, 2860000 } })
ripper_6_place = waypoint("Ripper 6 place", { group = convoy_places, position = { 62500, -40000, 2860000 } })
ripper_1_fort = waypoint("Ripper 1 fort", { group = convoy_places, position = { -20000, -10000, 2910000 } })
ripper_2_fort = waypoint("Ripper 2 fort", { group = convoy_places, position = { -12000, -10000, 2910000 } })
ripper_3_fort = waypoint("Ripper 3 fort", { group = convoy_places, position = { -4000, -10000, 2910000 } })
ripper_4_fort = waypoint("Ripper 4 fort", { group = convoy_places, position = { 4000, -10000, 2910000 } })
ripper_5_fort = waypoint("Ripper 5 fort", { group = convoy_places, position = { 12000, -10000, 2910000 } })
ripper_6_fort = waypoint("Ripper 6 fort", { group = convoy_places, position = { 20000, -10000, 2910000 } })
nanny_1_place = waypoint("Nanny 1 place", { group = convoy_places, position = { -140000, 30000, 2930000 } })
nanny_2_place = waypoint("Nanny 2 place", { group = convoy_places, position = { 140000, 30000, 2930000 } })
kestrel_place = waypoint("Kestrel place", { group = convoy_places, position = { 0, 40000, 2815000 } })
prowler_1_place = waypoint("Prowler 1 place", { group = convoy_places, position = { -40000, 45000, 2830000 } })
prowler_2_place = waypoint("Prowler 2 place", { group = convoy_places, position = { 40000, 45000, 2830000 } })

-- The fort's ring: twelve waypoints 100,000 about the fort, 25,000 below it, which the priority
-- transports fly round, from the side the wing came in from to the right and on round beyond the
-- fort: as a transport comes within 4,000 of one, it flies for the next (the ring's triggers).
-- Below the fort, the ring keeps clear of the Richelieu's torpedoes and of the original defenders.
ring_1 = waypoint("Ring 1", { group = fort_ring, position = { 0, -25000, 2900000 } })
ring_2 = waypoint("Ring 2", { group = fort_ring, position = { 50000, -25000, 2913397 } })
ring_3 = waypoint("Ring 3", { group = fort_ring, position = { 86603, -25000, 2950000 } })
ring_4 = waypoint("Ring 4", { group = fort_ring, position = { 100000, -25000, 3000000 } })
ring_5 = waypoint("Ring 5", { group = fort_ring, position = { 86603, -25000, 3050000 } })
ring_6 = waypoint("Ring 6", { group = fort_ring, position = { 50000, -25000, 3086603 } })
ring_7 = waypoint("Ring 7", { group = fort_ring, position = { 0, -25000, 3100000 } })
ring_8 = waypoint("Ring 8", { group = fort_ring, position = { -50000, -25000, 3086603 } })
ring_9 = waypoint("Ring 9", { group = fort_ring, position = { -86603, -25000, 3050000 } })
ring_10 = waypoint("Ring 10", { group = fort_ring, position = { -100000, -25000, 3000000 } })
ring_11 = waypoint("Ring 11", { group = fort_ring, position = { -86603, -25000, 2950000 } })
ring_12 = waypoint("Ring 12", { group = fort_ring, position = { -50000, -25000, 2913397 } })

mammoth_1 = ship("Mammoth A", { type = "mammoth", group = convoy_mammoths, pilot = "mammoth_1", position = { -20000, -25000, 2900000 }, yaw = 90 })
mammoth_2 = ship("Mammoth B", { type = "mammoth", group = convoy_mammoths, pilot = "mammoth_2", position = { 76603, -25000, 2932679 }, yaw = 30 })
mammoth_3 = ship("Mammoth C", { type = "mammoth", group = convoy_mammoths, pilot = "mammoth_3", position = { 96603, -25000, 3032679 }, yaw = 330 })
mammoth_4 = ship("Mammoth D", { type = "mammoth", group = convoy_mammoths, pilot = "mammoth_1", position = { 20000, -25000, 3100000 }, yaw = 270 })
mammoth_5 = ship("Mammoth E", { type = "mammoth", group = convoy_mammoths, pilot = "mammoth_2", position = { -76603, -25000, 3067321 }, yaw = 210 })
mammoth_6 = ship("Mammoth F", { type = "mammoth", group = convoy_mammoths, pilot = "mammoth_3", position = { -96603, -25000, 2967321 }, yaw = 150 })
lueneburg_1 = ship("Lueneburg A", { type = "lueneburg", group = convoy_lueneburgs, position = { 32679, -25000, 2903397 }, yaw = 60 })
lueneburg_2 = ship("Lueneburg B", { type = "lueneburg", group = convoy_lueneburgs, position = { 100000, -25000, 2980000 }, yaw = 0 })
lueneburg_3 = ship("Lueneburg C", { type = "lueneburg", group = convoy_lueneburgs, position = { 67321, -25000, 3076603 }, yaw = 300 })
lueneburg_4 = ship("Lueneburg D", { type = "lueneburg", group = convoy_lueneburgs, position = { -32679, -25000, 3096603 }, yaw = 240 })
lueneburg_5 = ship("Lueneburg E", { type = "lueneburg", group = convoy_lueneburgs, position = { -100000, -25000, 3020000 }, yaw = 180 })
lueneburg_6 = ship("Lueneburg F", { type = "lueneburg", group = convoy_lueneburgs, position = { -67321, -25000, 2923397 }, yaw = 120 })
lonestar_1 = ship("Lonestar 1", { type = "lonestar", group = convoy_lonestars, position = { -30000, 30000, 2830000 } })
lonestar_2 = ship("Lonestar 2", { type = "lonestar", group = convoy_lonestars, position = { 30000, 30000, 2830000 } })
ripper_1 = ship("Ripper 1", { type = "ripper", group = convoy_rippers, position = { -62500, -40000, 2860000 } })
ripper_2 = ship("Ripper 2", { type = "ripper", group = convoy_rippers, position = { -37500, -40000, 2860000 } })
ripper_3 = ship("Ripper 3", { type = "ripper", group = convoy_rippers, position = { -12500, -40000, 2860000 } })
ripper_4 = ship("Ripper 4", { type = "ripper", group = convoy_rippers, position = { 12500, -40000, 2860000 } })
ripper_5 = ship("Ripper 5", { type = "ripper", group = convoy_rippers, position = { 37500, -40000, 2860000 } })
ripper_6 = ship("Ripper 6", { type = "ripper", group = convoy_rippers, position = { 62500, -40000, 2860000 } })
nanny_1 = ship("Nanny 1", { type = "nanny", group = convoy_nannies, position = { -140000, 30000, 2930000 } })
nanny_2 = ship("Nanny 2", { type = "nanny", group = convoy_nannies, position = { 140000, 30000, 2930000 } })
convoy_kestrel = ship("Convoy Kestrel", { type = "kestrel", group = convoy_escorts, pilot = "kestrel_command", position = { 0, 40000, 2815000 } })
convoy_prowler_1 = ship("Prowler A", { type = "prowler", group = convoy_escorts, pilot = "prowler", position = { -40000, 45000, 2830000 } })
convoy_prowler_2 = ship("Prowler B", { type = "prowler", group = convoy_escorts, pilot = "prowler", position = { 40000, 45000, 2830000 } })

priority_transports = squad("(AI)Priority transports", { convoy_mammoths, convoy_lueneburgs })
convoy = squad("(AI)Convoy", { convoy_mammoths, convoy_lueneburgs, convoy_lonestars, convoy_rippers, convoy_nannies, convoy_escorts, defenders })
-- The convoy's ships that jump in with the Richelieu: all but the original defenders.
convoy_arrivals = squad("(AI)Convoy arrivals", { convoy_mammoths, convoy_lueneburgs, convoy_lonestars, convoy_rippers, convoy_nannies, convoy_escorts })

-- The Sabre waves of the evacuation window, three a minute, each jumping in at a point of its own
-- about the fort: from above and below, from either side, from behind the convoy and from beyond
-- the fort, and from four slants between them. Each wave goes for the transport at the bay.

wave_1_in = point("Wave 1 in", { group = wave_points, position = { 0, -140000, 2900000 }, yaw = 0 })
wave_2_in = point("Wave 2 in", { group = wave_points, position = { 0, 140000, 2900000 }, yaw = 0 })
wave_3_in = point("Wave 3 in", { group = wave_points, position = { -160000, 0, 2925000 }, yaw = 90 })
wave_4_in = point("Wave 4 in", { group = wave_points, position = { 160000, 0, 2925000 }, yaw = 270 })
wave_5_in = point("Wave 5 in", { group = wave_points, position = { 0, 0, 2740000 }, yaw = 0 })
wave_6_in = point("Wave 6 in", { group = wave_points, position = { 0, -20000, 3100000 }, yaw = 180 })
wave_7_in = point("Wave 7 in", { group = wave_points, position = { -120000, -100000, 2820000 }, yaw = 45 })
wave_8_in = point("Wave 8 in", { group = wave_points, position = { 120000, 100000, 2820000 }, yaw = 315 })
wave_9_in = point("Wave 9 in", { group = wave_points, position = { -120000, 100000, 3030000 }, yaw = 135 })
wave_10_in = point("Wave 10 in", { group = wave_points, position = { 120000, -100000, 3030000 }, yaw = 225 })

wave_1_a = ship("Sabre 1A", { type = "sabre", group = wave_1, pilot = "raven", position = { 0, -140000, 2900000 } })
wave_1_b = ship("Sabre 1B", { type = "sabre", group = wave_1, pilot = "raven", position = { 3000, -140000, 2900000 } })
wave_1_c = ship("Sabre 1C", { type = "sabre", group = wave_1, pilot = "raven", position = { -3000, -140000, 2900000 } })
wave_2_a = ship("Sabre 2A", { type = "sabre", group = wave_2, pilot = "raven", position = { 0, 140000, 2900000 } })
wave_2_b = ship("Sabre 2B", { type = "sabre", group = wave_2, pilot = "raven", position = { 3000, 140000, 2900000 } })
wave_2_c = ship("Sabre 2C", { type = "sabre", group = wave_2, pilot = "raven", position = { -3000, 140000, 2900000 } })
wave_3_a = ship("Sabre 3A", { type = "sabre", group = wave_3, pilot = "raven", position = { -160000, 0, 2925000 } })
wave_3_b = ship("Sabre 3B", { type = "sabre", group = wave_3, pilot = "raven", position = { -160000, 0, 2928000 } })
wave_3_c = ship("Sabre 3C", { type = "sabre", group = wave_3, pilot = "raven", position = { -160000, 0, 2922000 } })
wave_4_a = ship("Sabre 4A", { type = "sabre", group = wave_4, pilot = "raven", position = { 160000, 0, 2925000 } })
wave_4_b = ship("Sabre 4B", { type = "sabre", group = wave_4, pilot = "raven", position = { 160000, 0, 2928000 } })
wave_4_c = ship("Sabre 4C", { type = "sabre", group = wave_4, pilot = "raven", position = { 160000, 0, 2922000 } })
wave_5_a = ship("Sabre 5A", { type = "sabre", group = wave_5, pilot = "raven", position = { 0, 0, 2740000 } })
wave_5_b = ship("Sabre 5B", { type = "sabre", group = wave_5, pilot = "raven", position = { 3000, 0, 2740000 } })
wave_5_c = ship("Sabre 5C", { type = "sabre", group = wave_5, pilot = "raven", position = { -3000, 0, 2740000 } })
wave_6_a = ship("Sabre 6A", { type = "sabre", group = wave_6, pilot = "raven", position = { 0, -20000, 3100000 } })
wave_6_b = ship("Sabre 6B", { type = "sabre", group = wave_6, pilot = "raven", position = { 3000, -20000, 3100000 } })
wave_6_c = ship("Sabre 6C", { type = "sabre", group = wave_6, pilot = "raven", position = { -3000, -20000, 3100000 } })
wave_7_a = ship("Sabre 7A", { type = "sabre", group = wave_7, pilot = "raven", position = { -120000, -100000, 2820000 } })
wave_7_b = ship("Sabre 7B", { type = "sabre", group = wave_7, pilot = "raven", position = { -118000, -100000, 2818000 } })
wave_7_c = ship("Sabre 7C", { type = "sabre", group = wave_7, pilot = "raven", position = { -122000, -100000, 2822000 } })
wave_8_a = ship("Sabre 8A", { type = "sabre", group = wave_8, pilot = "raven", position = { 120000, 100000, 2820000 } })
wave_8_b = ship("Sabre 8B", { type = "sabre", group = wave_8, pilot = "raven", position = { 118000, 100000, 2818000 } })
wave_8_c = ship("Sabre 8C", { type = "sabre", group = wave_8, pilot = "raven", position = { 122000, 100000, 2822000 } })
wave_9_a = ship("Sabre 9A", { type = "sabre", group = wave_9, pilot = "raven", position = { -120000, 100000, 3030000 } })
wave_9_b = ship("Sabre 9B", { type = "sabre", group = wave_9, pilot = "raven", position = { -118000, 100000, 3032000 } })
wave_9_c = ship("Sabre 9C", { type = "sabre", group = wave_9, pilot = "raven", position = { -122000, 100000, 3028000 } })
wave_10_a = ship("Sabre 10A", { type = "sabre", group = wave_10, pilot = "raven", position = { 120000, -100000, 3030000 } })
wave_10_b = ship("Sabre 10B", { type = "sabre", group = wave_10, pilot = "raven", position = { 118000, -100000, 3032000 } })
wave_10_c = ship("Sabre 10C", { type = "sabre", group = wave_10, pilot = "raven", position = { 122000, -100000, 3028000 } })

waves_all = squad("(AI)Waves", { wave_1, wave_2, wave_3, wave_4, wave_5, wave_6, wave_7, wave_8, wave_9, wave_10 })

-- The CS Sevastopol, which jumps in about 200,000 from the Richelieu, beyond the fort, facing it.
-- The Kiev's model has two launch points (`sltool shp info Kiev.SHP`), gates 0 and 1: its two
-- salvos and its 12 Sabres launch through them two at a time, each waiting its turn parked far off
-- and disabled, as Alpha 3 to 6 do. The torpedoes explode as they hit, as mission 1's Kamovs' do.

sevastopol = ship("Sevastopol", {
    type = 304,
    group = sevastopol_group,
    position = { -50000, -30000, 3310000 },
    yaw = 194,
})
sevastopol_in = point("Sevastopol in", {
    group = zone_points,
    position = { -50000, -30000, 3310000 },
    yaw = 194,
})
sevastopol_sabre_1 = ship("Sevastopol Sabre 1", { type = "sabre", group = sevastopol_sabres, pilot = "raven", position = { -50000, -30000, 3900000 } })
sevastopol_sabre_2 = ship("Sevastopol Sabre 2", { type = "sabre", group = sevastopol_sabres, pilot = "raven", position = { -46000, -30000, 3900000 } })
sevastopol_sabre_3 = ship("Sevastopol Sabre 3", { type = "sabre", group = sevastopol_sabres, pilot = "raven", position = { -42000, -30000, 3900000 } })
sevastopol_sabre_4 = ship("Sevastopol Sabre 4", { type = "sabre", group = sevastopol_sabres, pilot = "raven", position = { -38000, -30000, 3900000 } })
sevastopol_sabre_5 = ship("Sevastopol Sabre 5", { type = "sabre", group = sevastopol_sabres, pilot = "raven", position = { -34000, -30000, 3900000 } })
sevastopol_sabre_6 = ship("Sevastopol Sabre 6", { type = "sabre", group = sevastopol_sabres, pilot = "raven", position = { -30000, -30000, 3900000 } })
sevastopol_sabre_7 = ship("Sevastopol Sabre 7", { type = "sabre", group = sevastopol_sabres, pilot = "raven", position = { -50000, -26000, 3900000 } })
sevastopol_sabre_8 = ship("Sevastopol Sabre 8", { type = "sabre", group = sevastopol_sabres, pilot = "raven", position = { -46000, -26000, 3900000 } })
sevastopol_sabre_9 = ship("Sevastopol Sabre 9", { type = "sabre", group = sevastopol_sabres, pilot = "raven", position = { -42000, -26000, 3900000 } })
sevastopol_sabre_10 = ship("Sevastopol Sabre 10", { type = "sabre", group = sevastopol_sabres, pilot = "raven", position = { -38000, -26000, 3900000 } })
sevastopol_sabre_11 = ship("Sevastopol Sabre 11", { type = "sabre", group = sevastopol_sabres, pilot = "raven", position = { -34000, -26000, 3900000 } })
sevastopol_sabre_12 = ship("Sevastopol Sabre 12", { type = "sabre", group = sevastopol_sabres, pilot = "raven", position = { -30000, -26000, 3900000 } })
salvo_1_1 = ship("Torpedo 1-1", { type = "russian_torpedo", group = salvo_1, position = { -50000, -40000, 3900000 } })
salvo_1_2 = ship("Torpedo 1-2", { type = "russian_torpedo", group = salvo_1, position = { -46000, -40000, 3900000 } })
salvo_1_3 = ship("Torpedo 1-3", { type = "russian_torpedo", group = salvo_1, position = { -42000, -40000, 3900000 } })
salvo_1_4 = ship("Torpedo 1-4", { type = "russian_torpedo", group = salvo_1, position = { -38000, -40000, 3900000 } })
salvo_1_5 = ship("Torpedo 1-5", { type = "russian_torpedo", group = salvo_1, position = { -34000, -40000, 3900000 } })
salvo_1_6 = ship("Torpedo 1-6", { type = "russian_torpedo", group = salvo_1, position = { -30000, -40000, 3900000 } })
salvo_2_1 = ship("Torpedo 2-1", { type = "russian_torpedo", group = salvo_2, position = { -50000, -44000, 3900000 } })
salvo_2_2 = ship("Torpedo 2-2", { type = "russian_torpedo", group = salvo_2, position = { -46000, -44000, 3900000 } })
salvo_2_3 = ship("Torpedo 2-3", { type = "russian_torpedo", group = salvo_2, position = { -42000, -44000, 3900000 } })
salvo_2_4 = ship("Torpedo 2-4", { type = "russian_torpedo", group = salvo_2, position = { -38000, -44000, 3900000 } })
salvo_2_5 = ship("Torpedo 2-5", { type = "russian_torpedo", group = salvo_2, position = { -34000, -44000, 3900000 } })
salvo_2_6 = ship("Torpedo 2-6", { type = "russian_torpedo", group = salvo_2, position = { -30000, -44000, 3900000 } })

-- Where the camera stands for the shots at the fort: far off for the arrival's first shot, then
-- by the Kestrel, the Murmansk, the Kazan's arrival, the Richelieu's, its torpedo away and the
-- carriers' end from above, and the Sevastopol's arrival. And where the wing waits, clear, while
-- the Richelieu strikes.

camera_far = point("Camera far", { group = zone_points, position = { 100000, -45000, 2830000 } })
camera_kestrel = point("Camera Kestrel", { group = zone_points, position = { -22000, -52000, 2898000 } })
camera_murmansk = point("Camera Murmansk", { group = zone_points, position = { -60000, -25000, 3040000 } })
camera_kazan = point("Camera Kazan", { group = zone_points, position = { 90000, -20000, 3030000 } })
camera_richelieu = point("Camera Richelieu", { group = zone_points, position = { -10000, -30000, 3110000 } })
camera_torpedo = point("Camera torpedo", { group = zone_points, position = { 35000, -20000, 3060000 } })
camera_strike = point("Camera strike", { group = zone_points, position = { 20000, -170000, 3060000 } })
camera_sevastopol = point("Camera Sevastopol", { group = zone_points, position = { -110000, -50000, 3180000 } })
clear_point = waypoint("Clear point", { group = zone_points, position = { 0, -30000, 2860000 } })

-- What the hostiles go for: the first Azans the defenders, the Kurgens the fort, the Kazan's escort
-- the wing and the defenders, the waves the transports, the Sevastopol's Sabres the wing.

fort_targets = squad("(AI)Fort targets", { defenders, fort_kestrel, alpha })
escort_targets = squad("(AI)Escort targets", { alpha, defenders })
engagement_hostiles = squad("(AI)Engagement hostiles", { first_azans, first_kurgens })
second_hostiles = squad("(AI)Second hostiles", { kazan_escort, first_kurgens, first_azans })
defender_fighters = squad("(AI)Defender fighters", { defender_coyote_1, defender_coyote_2 })
sevastopol_targets = squad("(AI)Sevastopol targets", { alpha, carrier_group })

-- The script.

-- The start: the launch, as in mission 1, then the jump drive comes online for the jump to the
-- fort once the radio over the launch has been said.

start = part("(F)Start", function()
    CreateFlightGroup(carrier_group)
    CreateFlightGroup(alpha)
    CreateFlightGroup(jump_points)
    CreateFlightGroup(home_points)
    CreateFlightGroup(planets)
    SetAI(home_points, "object_attach", 1, richelieu)
    SetRescueProbabilities(100, 0, 0)
    SetShipAvoidance(carrier_group, 1)
    -- The Richelieu is never destroyed: torpedoes strike it, and campaign.luau counts the hits.
    SetInvulnerability(richelieu, 2)
    DisableGuns(carrier_group, 1)
    PlayMusic("new_launch.wav", 0)
    DisableObject(a3, 1)
    DisableObject(a4, 1)
    DisableObject(a5, 1)
    DisableObject(a6, 1)
    spawn(launch_chatter)
    StartLaunch(player)
    Wait(2)
    StartDirectorCam(launch_camera, player, 6, nil, nil)
    StartLaunch(a2)
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
    SetObjective(0, 2)
    SetNavPoint(alpha, san_marco_nav)
    ClearAI(escorts)
    Fly(a2, san_marco_nav, 200)
    SetAI(followers, "formation", 1, a2)
    jump_when_ready()
    return 1
end, { start = true })

jump_when_ready = part("(F)Jump when ready", function()
    ready_steps += 1
    if ready_steps >= 2 then
        game.jump_ready = 1
    end
    return 1
end)

-- The radio over the launch, then the bridge's orders before the jump, each line a second after
-- the one before it ends, as in mission 1. The bridge's first line is mission 1's.

launch_chatter = part("(F)Launch chatter", function()
    Wait(2)
    CommsFromPilot("victorious_bridge_officer", "talking", "ctl_m1_l1")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a2, "talking", "cor_m2_l1")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a4, "talking", "wal_m2_l1")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a3, "talking", "fah_m2_l1")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a2, "talking", "cor_m2_l2")
    Wait(1)
    WaitForSpeech()
    Wait(3)
    CommsFromPilot("victorious_bridge_officer", "talking", "ctl_m2_l2")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a2, "talking", "cor_m2_l3")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a4, "talking", "wal_m2_l2")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a2, "talking", "cor_m2_l4")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromPilot("victorious_bridge_officer", "talking", "ctl_m2_l3")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a2, "talking", "cor_m2_l5")
    Wait(1)
    WaitForSpeech()
    jump_when_ready()
    return 1
end)

-- The jump to the fort: the fort, its defenders and its attackers are there before the wing. The
-- fort is never destroyed; the defenders are kept whole through the arrival's cinematic alone.
-- The Murmansk's systems are locked until their turn, its comms tower for good.

jump_to_fort = part("(F)Jump to the fort", function()
    make_fort()
    CreateFlightGroup(first_azans)
    CreateFlightGroup(first_kurgens)
    CreateFlightGroup(murmansk_group)
    SetInvulnerability(defenders, 2)
    SetInvulnerability(fort_kestrel, 2)
    SetInvulnerability(component(murmansk, 0), 2)
    SetInvulnerability(component(murmansk, 1), 2)
    SetInvulnerability(component(murmansk, 2), 2)
    SetInvulnerability(component(murmansk, 3), 2)
    SetAI(first_azans, "find_new_target", 1, fort_targets)
    SetAI(first_kurgens, "find_new_target", 1, san_marco)
    SetAI(defender_fighters, "find_new_target", 1, first_azans)
    ClearAI(alpha)
    SetAI(alpha, "jump_out", 1, san_marco_nav)
    return 1
end)

make_fort = part("(F)Make the fort", function()
    CreateFlightGroup(zone_points)
    CreateFlightGroup(fort_group)
    CreateFlightGroup(defenders)
    CreateFlightGroup(fort_kestrel)
    SetInvulnerability(san_marco, 2)
    return 1
end)

-- Out of the jump: a cinematic of three shots, the wing held still meanwhile: the fort from afar,
-- the Kestrel lost by it, and the Murmansk. San Marco Control calls for help over it, and Corsair
-- answers. Once it is over the defenders can be lost, and the wing engages.

arrive_at_fort = part("(F)Arrive at the fort", function()
    WaitForJumpOrLaunch(alpha)
    DisableObject(carrier_group, 1)
    game.jump_ready = 0
    phase = 1
    SetObjective(0, 1)
    SetObjective(1, 2)
    SetNavPoint(alpha, san_marco)
    PlayMusic("new_mission06.wav", 1)
    ClearAI(escorts)
    Fly(a2, clear_point, 150)
    SetAI(followers, "formation", 1, a2)
    spawn(fort_calls)
    StartDirectorCam(camera_far, san_marco, 6, nil, alpha)
    StackDirectorCam(camera_kestrel, lost_kestrel, 6, nil, alpha)
    StackDirectorCam(camera_murmansk, murmansk, 5, nil, alpha)
    Wait(8)
    SetInvulnerability(fort_kestrel, 0)
    SetAI(lost_kestrel, "explode", 1, nil)
    Wait(9)
    SetInvulnerability(defenders, 0)
    SetAI(escorts, "find_new_target", 1, engagement_hostiles)
    return 1
end)

fort_calls = part("(F)Fort calls", function()
    Wait(2)
    CommsFromShip(san_marco, "talking", "smc_m2_l1")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(san_marco, "talking", "smc_m2_l2")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a2, "talking", "cor_m2_l6")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a2, "talking", "cor_m2_l7")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    return 1
end)

-- The first engagement: the Kazan comes as soon as the first 8 Azans are down; the engagement is
-- over once the Kurgens are down too; and the window of opportunity opens once the Kazan's escort
-- and the Kurgens are down.

on(first_azans, "destroyed", { repeats = "always" }, function(killer, victim)
    azan_kills += 1
    if azan_kills == 8 then
        spawn(kazan_arrives)
    end
    engagement_check()
    return 1
end)

on(first_kurgens, "destroyed", { repeats = "always" }, function(killer, victim)
    kurgen_kills += 1
    engagement_check()
    window_check()
    return 1
end)

on(kazan_escort, "destroyed", { repeats = "always" }, function(killer, victim)
    escort_kills += 1
    window_check()
    return 1
end)

engagement_check = part("(F)Engagement check", function()
    if azan_kills == 8 and kurgen_kills == 2 and engagement_done == 0 then
        engagement_done = 1
        SetObjective(1, 1)
    end
    return 1
end)

window_check = part("(F)Window check", function()
    if escort_kills == 8 and kurgen_kills == 2 and window_open == 0 then
        window_open = 1
        spawn(window_opens)
    end
    return 1
end)

-- The Kazan jumps in to the right of the fort with its escort, in a shot of its own. Its systems
-- are locked until their turn, its comms for good.

kazan_arrives = part("(F)Kazan arrives", function()
    CreateFlightGroup(kazan_group)
    CreateFlightGroup(kazan_escort)
    SetInvulnerability(component(kazan, 0), 2)
    SetInvulnerability(component(kazan, 1), 2)
    SetInvulnerability(component(kazan, 2), 2)
    SetInvulnerability(component(kazan, 3), 2)
    SetInvulnerability(component(kazan, 4), 2)
    SetAI(kazan_group, "fly", 1, nil)
    SetAI(kazan, "jump_in", 1, kazan_in)
    SetAI(kazan_escort, "fly", 1, nil)
    SetAI(kazan_escort, "jump_in", 1, escort_in)
    WaitForSpeech()
    CommsFromShip(a2, "talking", "cor_m2_l8")
    Wait(1)
    StartDirectorCam(camera_kazan, kazan, 7, nil, alpha)
    WaitForJumpOrLaunch(kazan_group)
    SetAI(kazan, "immediately_set_ship_to_zero_velocity_and_rotation", 1, nil)
    WaitForJumpOrLaunch(kazan_escort)
    SetAI(kazan_escort, "find_new_target", 1, escort_targets)
    SetObjective(2, 2)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a2, "talking", "cor_m2_l9")
    ClearAI(escorts)
    SetAI(escorts, "find_new_target", 1, second_hostiles)
    Wait(1)
    WaitForSpeech()
    Wait(1)
    return 1
end)

-- The window of opportunity: the Kazan's shield generator first.

window_opens = part("(F)Window opens", function()
    Wait(2)
    PlayMusic("new_searching mission 09.wav", 0)
    WaitForSpeech()
    CommsFromPilot("victorious_bridge_officer", "talking", "ctl_m2_l4")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a2, "talking", "cor_m2_l10")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    SetObjective(2, 1)
    SetObjective(3, 2)
    systems_step = 1
    SetInvulnerability(component(kazan, 4), 0)
    SetPlayerTarget(player, component(kazan, 4))
    ClearAI(escorts)
    SetAI(escorts, "find_new_target", 1, kazan_shield)
    return 1
end)

-- The Kazan's systems. Each step unlocks the next; the triggers watch the components by their
-- index. The Kazan explodes once the Richelieu's torpedoes for it are done with.

on(kazan, "destroyed", { component = 4 }, function(killer, victim)
    systems_step = 2
    spawn(kazan_shield_down)
    return 1
end)

on(kazan, "destroyed", { component = 1 }, function(killer, victim)
    kazan_engines += 1
    kazan_engine_down()
    return 1
end)

on(kazan, "destroyed", { component = 2 }, function(killer, victim)
    kazan_engines += 1
    kazan_engine_down()
    return 1
end)

on(kazan, "destroyed", { component = 3 }, function(killer, victim)
    kazan_engines += 1
    kazan_engine_down()
    return 1
end)

on(kazan, "destroyed", function(killer, victim)
    carriers_down += 1
    if carriers_down == 2 then
        spawn(carriers_destroyed)
    end
    return 1
end)

kazan_shield_down = part("(F)Kazan shield down", function()
    SetInvulnerability(component(kazan, 1), 0)
    SetInvulnerability(component(kazan, 2), 0)
    SetInvulnerability(component(kazan, 3), 0)
    SetPlayerTarget(player, component(kazan, 1))
    ClearAI(escorts)
    SetAI(escorts, "find_new_target", 1, kazan_engine_parts)
    WaitForSpeech()
    CommsFromShip(a2, "talking", "cor_m2_l11")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    return 1
end)

kazan_engine_down = part("(F)Kazan engine down", function()
    if kazan_engines == 3 then
        systems_step = 3
        spawn(kazan_crippled)
    end
    return 1
end)

kazan_crippled = part("(F)Kazan crippled", function()
    SetInvulnerability(component(murmansk, 3), 0)
    SetPlayerTarget(player, component(murmansk, 3))
    ClearAI(escorts)
    SetAI(escorts, "find_new_target", 1, murmansk_shield)
    WaitForSpeech()
    CommsFromShip(a2, "talking", "cor_m2_l12")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    return 1
end)

-- The Murmansk's systems, the same way.

on(murmansk, "destroyed", { component = 3 }, function(killer, victim)
    systems_step = 4
    spawn(murmansk_shield_down)
    return 1
end)

on(murmansk, "destroyed", { component = 1 }, function(killer, victim)
    murmansk_engines += 1
    murmansk_engine_down()
    return 1
end)

on(murmansk, "destroyed", { component = 2 }, function(killer, victim)
    murmansk_engines += 1
    murmansk_engine_down()
    return 1
end)

on(murmansk, "destroyed", function(killer, victim)
    carriers_down += 1
    if carriers_down == 2 then
        spawn(carriers_destroyed)
    end
    return 1
end)

murmansk_shield_down = part("(F)Murmansk shield down", function()
    SetInvulnerability(component(murmansk, 1), 0)
    SetInvulnerability(component(murmansk, 2), 0)
    SetPlayerTarget(player, component(murmansk, 1))
    ClearAI(escorts)
    SetAI(escorts, "find_new_target", 1, murmansk_engine_parts)
    WaitForSpeech()
    CommsFromShip(a2, "talking", "cor_m2_l11")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    return 1
end)

murmansk_engine_down = part("(F)Murmansk engine down", function()
    if murmansk_engines == 2 and systems_step == 4 then
        systems_step = 5
        spawn(counterattack)
    end
    return 1
end)

explode_kazan = part("(F)Explode Kazan", function()
    if kazan_exploded == 0 then
        kazan_exploded = 1
        SetInvulnerability(component(kazan, 0), 0)
        SetAI(kazan, "explode", 1, nil)
    end
    return 1
end)

explode_murmansk = part("(F)Explode Murmansk", function()
    if murmansk_exploded == 0 then
        murmansk_exploded = 1
        SetInvulnerability(component(murmansk, 0), 0)
        SetAI(murmansk, "explode", 1, nil)
    end
    return 1
end)

-- Each carrier explodes on its own once its four torpedoes are done with, each having hit it or
-- been shot down. A torpedo's strike on a hull counts as a crash, which posts no ShotAt where the
-- part struck is already destroyed, such as an engine the wing shot out: so the torpedoes'
-- destruction tells their end, not the carrier's ShotAt.

on(kazan_torpedoes, "destroyed", { repeats = "always" }, function(killer, victim)
    kazan_torpedoes_done += 1
    if kazan_torpedoes_done == 4 then
        explode_kazan()
    end
    return 1
end)

on(murmansk_torpedoes, "destroyed", { repeats = "always" }, function(killer, victim)
    murmansk_torpedoes_done += 1
    if murmansk_torpedoes_done == 4 then
        explode_murmansk()
    end
    return 1
end)

-- The Richelieu's counterattack: the bridge says it's coming, Corsair calls the wing clear, and
-- the Richelieu jumps in between the carriers, the convoy with it, each ship at its place, and
-- holds there. It fires four torpedoes from each side at the carrier on that side, one from each
-- side a second, which a shot follows away, and a shot from high above shows the carriers go;
-- those still whole go 40 seconds on, should the torpedoes miss. The convoy then settles: the
-- priority transports onto the fort's ring, the others at their places.

counterattack = part("(F)Counterattack", function()
    SetObjective(3, 1)
    WaitForSpeech()
    CommsFromPilot("victorious_bridge_officer", "talking", "ctl_m2_l5")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a2, "talking", "cor_m2_l13")
    ClearAI(escorts)
    Fly(a2, clear_point, 200)
    SetAI(followers, "formation", 1, a2)
    Wait(1)
    WaitForSpeech()
    Wait(1)
    DisableObject(carrier_group, 0)
    CreateFlightGroup(convoy_places)
    CreateFlightGroup(convoy_mammoths)
    CreateFlightGroup(convoy_lueneburgs)
    CreateFlightGroup(convoy_lonestars)
    CreateFlightGroup(convoy_rippers)
    CreateFlightGroup(convoy_nannies)
    CreateFlightGroup(convoy_escorts)
    CreateFlightGroup(fort_ring)
    SetAI(convoy_arrivals, "fly", 1, nil)
    SetAI(richelieu, "jump_in", 1, richelieu_in)
    convoy_jumps_in()
    spawn(convoy_arrives)
    StartDirectorCam(camera_richelieu, richelieu, 9, nil, alpha)
    WaitForJumpOrLaunch(carrier_group)
    SetAI(richelieu, "immediately_set_ship_to_zero_velocity_and_rotation", 1, nil)
    richelieu_holds()
    CreateFlightGroup(kazan_torpedoes)
    CreateFlightGroup(murmansk_torpedoes)
    Wait(1)
    fire_pair(torpedo_kazan_1, torpedo_murmansk_1)
    StartDirectorCam(camera_torpedo, torpedo_kazan_1, 9, nil, alpha)
    StackDirectorCam(camera_strike, richelieu, 20, nil, alpha)
    spawn(strike_fallback)
    Wait(1)
    fire_pair(torpedo_kazan_2, torpedo_murmansk_2)
    Wait(1)
    fire_pair(torpedo_kazan_3, torpedo_murmansk_3)
    Wait(1)
    fire_pair(torpedo_kazan_4, torpedo_murmansk_4)
    return 1
end)

-- The convoy out of its jump: it stops, and settles at once, before a transport can fly on past
-- its slot's waypoint.

convoy_arrives = part("(F)Convoy arrives", function()
    WaitForJumpOrLaunch(convoy_arrivals)
    SetAI(convoy_arrivals, "immediately_set_ship_to_zero_velocity_and_rotation", 1, nil)
    convoy_settles()
    return 1
end)

-- The Richelieu stops where it is and holds, its launch's Fly at 10 done with, so that it never
-- drifts on into the fort.

richelieu_holds = part("(F)Richelieu holds", function()
    ClearAI(richelieu)
    SetAI(richelieu, "do_nothing", 1, nil)
    return 1
end)

-- One torpedo from each side of the Richelieu, each for the carrier on its side. A torpedo whose
-- target is gone, or which can aim at it no more, explodes.

fire_pair = part("(F)Fire pair", function(at_kazan, at_murmansk)
    SetAI(at_kazan, "explode", 1, nil)
    SetAI(at_kazan, "find_new_target", 1, kazan)
    SetAI(at_murmansk, "explode", 1, nil)
    SetAI(at_murmansk, "find_new_target", 1, murmansk)
    return 1
end)

-- The convoy in place: the jump's Fly is done with, so that no ship flies on for ever. Each
-- priority transport flies onto the fort's ring at its slot, and the ring's triggers take it
-- round from there; the Rippers wait between their runs; the other ships hold their places.

convoy_settles = part("(F)Convoy settles", function()
    ClearAI(convoy_arrivals)
    SetAI(convoy_rippers, "do_nothing", 1, nil)
    SetAI(convoy_lonestars, "do_nothing", 1, nil)
    SetAI(convoy_nannies, "do_nothing", 1, nil)
    SetAI(convoy_escorts, "do_nothing", 1, nil)
    Fly(mammoth_1, ring_1, 80)
    Fly(lueneburg_1, ring_2, 80)
    Fly(mammoth_2, ring_3, 80)
    Fly(lueneburg_2, ring_4, 80)
    Fly(mammoth_3, ring_5, 80)
    Fly(lueneburg_3, ring_6, 80)
    Fly(mammoth_4, ring_7, 80)
    Fly(lueneburg_4, ring_8, 80)
    Fly(mammoth_5, ring_9, 80)
    Fly(lueneburg_5, ring_10, 80)
    Fly(mammoth_6, ring_11, 80)
    Fly(lueneburg_6, ring_12, 80)
    return 1
end)

convoy_jumps_in = part("(F)Convoy jumps in", function()
    SetAI(mammoth_1, "jump_in", 1, mammoth_1_place)
    SetAI(mammoth_2, "jump_in", 1, mammoth_2_place)
    SetAI(mammoth_3, "jump_in", 1, mammoth_3_place)
    SetAI(mammoth_4, "jump_in", 1, mammoth_4_place)
    SetAI(mammoth_5, "jump_in", 1, mammoth_5_place)
    SetAI(mammoth_6, "jump_in", 1, mammoth_6_place)
    SetAI(lueneburg_1, "jump_in", 1, lueneburg_1_place)
    SetAI(lueneburg_2, "jump_in", 1, lueneburg_2_place)
    SetAI(lueneburg_3, "jump_in", 1, lueneburg_3_place)
    SetAI(lueneburg_4, "jump_in", 1, lueneburg_4_place)
    SetAI(lueneburg_5, "jump_in", 1, lueneburg_5_place)
    SetAI(lueneburg_6, "jump_in", 1, lueneburg_6_place)
    SetAI(lonestar_1, "jump_in", 1, lonestar_1_place)
    SetAI(lonestar_2, "jump_in", 1, lonestar_2_place)
    SetAI(ripper_1, "jump_in", 1, ripper_1_place)
    SetAI(ripper_2, "jump_in", 1, ripper_2_place)
    SetAI(ripper_3, "jump_in", 1, ripper_3_place)
    SetAI(ripper_4, "jump_in", 1, ripper_4_place)
    SetAI(ripper_5, "jump_in", 1, ripper_5_place)
    SetAI(ripper_6, "jump_in", 1, ripper_6_place)
    SetAI(nanny_1, "jump_in", 1, nanny_1_place)
    SetAI(nanny_2, "jump_in", 1, nanny_2_place)
    SetAI(convoy_kestrel, "jump_in", 1, kestrel_place)
    SetAI(convoy_prowler_1, "jump_in", 1, prowler_1_place)
    SetAI(convoy_prowler_2, "jump_in", 1, prowler_2_place)
    return 1
end)

strike_fallback = part("(F)Strike fallback", function()
    Wait(40)
    explode_kazan()
    explode_murmansk()
    return 1
end)

-- The fort's ring: a priority transport within 4,000 of a waypoint flies for the next, at 80,
-- below the Lueneburgs' top speed, so that the Mammoths keep their slots too. Each trigger answers
-- any ship, once a second while it is that close; the part passes over all but the priority
-- transports. One that passes a waypoint on its way to the bay is sent back to it a second later
-- (`evacuation_tick`).

ring_on = part("(F)Ring on", function(ship, next_point)
    if in_flight_group(ship, convoy_mammoths) or in_flight_group(ship, convoy_lueneburgs) then
        ClearAI(ship)
        Fly(ship, next_point, 80)
    end
    return 1
end)

on(ring_1, "ship_reached", { repeats = "always" }, function(reached_ship)
    ring_on(reached_ship, ring_2)
    return 1
end)
on(ring_2, "ship_reached", { repeats = "always" }, function(reached_ship)
    ring_on(reached_ship, ring_3)
    return 1
end)
on(ring_3, "ship_reached", { repeats = "always" }, function(reached_ship)
    ring_on(reached_ship, ring_4)
    return 1
end)
on(ring_4, "ship_reached", { repeats = "always" }, function(reached_ship)
    ring_on(reached_ship, ring_5)
    return 1
end)
on(ring_5, "ship_reached", { repeats = "always" }, function(reached_ship)
    ring_on(reached_ship, ring_6)
    return 1
end)
on(ring_6, "ship_reached", { repeats = "always" }, function(reached_ship)
    ring_on(reached_ship, ring_7)
    return 1
end)
on(ring_7, "ship_reached", { repeats = "always" }, function(reached_ship)
    ring_on(reached_ship, ring_8)
    return 1
end)
on(ring_8, "ship_reached", { repeats = "always" }, function(reached_ship)
    ring_on(reached_ship, ring_9)
    return 1
end)
on(ring_9, "ship_reached", { repeats = "always" }, function(reached_ship)
    ring_on(reached_ship, ring_10)
    return 1
end)
on(ring_10, "ship_reached", { repeats = "always" }, function(reached_ship)
    ring_on(reached_ship, ring_11)
    return 1
end)
on(ring_11, "ship_reached", { repeats = "always" }, function(reached_ship)
    ring_on(reached_ship, ring_12)
    return 1
end)
on(ring_12, "ship_reached", { repeats = "always" }, function(reached_ship)
    ring_on(reached_ship, ring_1)
    return 1
end)

-- The ring's triggers off, for the departure, so that none takes a transport off its jump.

ring_off = part("(F)Ring off", function()
    SetTriggerState(ring_1, "ship_reached", 0)
    SetTriggerState(ring_2, "ship_reached", 0)
    SetTriggerState(ring_3, "ship_reached", 0)
    SetTriggerState(ring_4, "ship_reached", 0)
    SetTriggerState(ring_5, "ship_reached", 0)
    SetTriggerState(ring_6, "ship_reached", 0)
    SetTriggerState(ring_7, "ship_reached", 0)
    SetTriggerState(ring_8, "ship_reached", 0)
    SetTriggerState(ring_9, "ship_reached", 0)
    SetTriggerState(ring_10, "ship_reached", 0)
    SetTriggerState(ring_11, "ship_reached", 0)
    SetTriggerState(ring_12, "ship_reached", 0)
    SetTriggerState(bay_mouth, "ship_reached", 0)
    return 1
end)

-- Both carriers down: San Marco asks, Corsair answers, and the bridge announces the evacuation,
-- whose ten minutes start once Corsair has answered it.

carriers_destroyed = part("(F)Carriers destroyed", function()
    Wait(4)
    PlayMusic("new_searching mission 09.wav", 0)
    WaitForSpeech()
    CommsFromShip(san_marco, "talking", "smc_m2_l3")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a2, "talking", "cor_m2_l14")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromPilot("victorious_bridge_officer", "talking", "ctl_m2_l6")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a2, "talking", "cor_m2_l15")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    start_evacuation()
    return 1
end)

-- The evacuation window: a timer each second runs it, and the first transport heads for the bay.

start_evacuation = part("(F)Start evacuation", function()
    SetObjective(4, 2)
    SetNavPoint(alpha, bay_mouth)
    ClearAI(escorts)
    Fly(a2, clear_point, 150)
    SetAI(followers, "formation", 1, a2)
    CreateFlightGroup(wave_points)
    CreateTimer(3, evacuation_tick, 1, 0)
    return 1
end)

-- Each second of the window: a Sabre wave on each whole minute, the transports' turns at the bay,
-- and the Rippers' shuttle. At 10:00 the evacuation result is frozen, and the tenth wave and the
-- bridge's departure order come in the same tick.

evacuation_tick = part("(F)Evacuation tick", function()
    if evac_frozen == 0 then
        evac_seconds += 1
        wave_clock += 1
        if wave_clock == 60 then
            wave_clock = 0
            waves += 1
            if waves == 10 then
                window_ends()
            end
            spawn(wave_comes)
        end
    end
    if evac_frozen == 0 then
        turn_clock += 1
        if turn_clock == 1 then
            turn_starts()
        end
        if turn_clock > 1 and turn_clock < 30 and bay_held == 0 then
            to_bay()
        end
        if turn_clock == 36 then
            turn_ends()
        end
        ripper_clock += 1
        if ripper_clock == 20 then
            rippers_to_fort()
        end
        if ripper_clock == 40 then
            ripper_clock = 0
            rippers_to_transports()
        end
    end
    return 1
end)

-- A transport's turn: it leaves the ring for the bay mouth, which takes it at most 30 seconds, and
-- holds there once it reaches it, until it flies back onto the ring at 36 seconds, at its first
-- waypoint, as the next one sets off. Until it holds, it is sent for the bay again each second, so
-- that a ring's waypoint it passes on the way doesn't keep it. A transport that has been lost is
-- passed over, the next one trying a second later.

turn_starts = part("(F)Turn starts", function()
    at_bay = 0
    bay_held = 0
    if evac_turn == 1 and mammoth_1_on == 1 then
        at_bay = 1
    end
    if evac_turn == 2 and lueneburg_1_on == 1 then
        at_bay = 2
    end
    if evac_turn == 3 and mammoth_2_on == 1 then
        at_bay = 3
    end
    if evac_turn == 4 and lueneburg_2_on == 1 then
        at_bay = 4
    end
    if evac_turn == 5 and mammoth_3_on == 1 then
        at_bay = 5
    end
    if evac_turn == 6 and lueneburg_3_on == 1 then
        at_bay = 6
    end
    if evac_turn == 7 and mammoth_4_on == 1 then
        at_bay = 7
    end
    if evac_turn == 8 and lueneburg_4_on == 1 then
        at_bay = 8
    end
    if evac_turn == 9 and mammoth_5_on == 1 then
        at_bay = 9
    end
    if evac_turn == 10 and lueneburg_5_on == 1 then
        at_bay = 10
    end
    if evac_turn == 11 and mammoth_6_on == 1 then
        at_bay = 11
    end
    if evac_turn == 12 and lueneburg_6_on == 1 then
        at_bay = 12
    end
    if at_bay == 0 then
        next_turn()
    else
        to_bay()
    end
    return 1
end)

to_bay = part("(F)To the bay", function()
    if at_bay == 1 and mammoth_1_on == 1 then
        Fly(mammoth_1, bay_mouth, 160)
    end
    if at_bay == 2 and lueneburg_1_on == 1 then
        Fly(lueneburg_1, bay_mouth, 160)
    end
    if at_bay == 3 and mammoth_2_on == 1 then
        Fly(mammoth_2, bay_mouth, 160)
    end
    if at_bay == 4 and lueneburg_2_on == 1 then
        Fly(lueneburg_2, bay_mouth, 160)
    end
    if at_bay == 5 and mammoth_3_on == 1 then
        Fly(mammoth_3, bay_mouth, 160)
    end
    if at_bay == 6 and lueneburg_3_on == 1 then
        Fly(lueneburg_3, bay_mouth, 160)
    end
    if at_bay == 7 and mammoth_4_on == 1 then
        Fly(mammoth_4, bay_mouth, 160)
    end
    if at_bay == 8 and lueneburg_4_on == 1 then
        Fly(lueneburg_4, bay_mouth, 160)
    end
    if at_bay == 9 and mammoth_5_on == 1 then
        Fly(mammoth_5, bay_mouth, 160)
    end
    if at_bay == 10 and lueneburg_5_on == 1 then
        Fly(lueneburg_5, bay_mouth, 160)
    end
    if at_bay == 11 and mammoth_6_on == 1 then
        Fly(mammoth_6, bay_mouth, 160)
    end
    if at_bay == 12 and lueneburg_6_on == 1 then
        Fly(lueneburg_6, bay_mouth, 160)
    end
    return 1
end)

-- The transport whose turn it is reaches the bay mouth, and holds there.

bay_reached = part("(F)Bay reached", function(ship)
    if bay_held == 0 and at_bay > 0 then
        if in_flight_group(ship, convoy_mammoths) or in_flight_group(ship, convoy_lueneburgs) then
            bay_held = 1
            ClearAI(ship)
            SetAI(ship, "do_nothing", 1, nil)
        end
    end
    return 1
end)

on(bay_mouth, "ship_reached", { repeats = "always" }, function(reached_ship)
    bay_reached(reached_ship)
    return 1
end)

turn_ends = part("(F)Turn ends", function()
    if at_bay == 1 and mammoth_1_on == 1 then
        ClearAI(mammoth_1)
        Fly(mammoth_1, ring_1, 80)
    end
    if at_bay == 2 and lueneburg_1_on == 1 then
        ClearAI(lueneburg_1)
        Fly(lueneburg_1, ring_1, 80)
    end
    if at_bay == 3 and mammoth_2_on == 1 then
        ClearAI(mammoth_2)
        Fly(mammoth_2, ring_1, 80)
    end
    if at_bay == 4 and lueneburg_2_on == 1 then
        ClearAI(lueneburg_2)
        Fly(lueneburg_2, ring_1, 80)
    end
    if at_bay == 5 and mammoth_3_on == 1 then
        ClearAI(mammoth_3)
        Fly(mammoth_3, ring_1, 80)
    end
    if at_bay == 6 and lueneburg_3_on == 1 then
        ClearAI(lueneburg_3)
        Fly(lueneburg_3, ring_1, 80)
    end
    if at_bay == 7 and mammoth_4_on == 1 then
        ClearAI(mammoth_4)
        Fly(mammoth_4, ring_1, 80)
    end
    if at_bay == 8 and lueneburg_4_on == 1 then
        ClearAI(lueneburg_4)
        Fly(lueneburg_4, ring_1, 80)
    end
    if at_bay == 9 and mammoth_5_on == 1 then
        ClearAI(mammoth_5)
        Fly(mammoth_5, ring_1, 80)
    end
    if at_bay == 10 and lueneburg_5_on == 1 then
        ClearAI(lueneburg_5)
        Fly(lueneburg_5, ring_1, 80)
    end
    if at_bay == 11 and mammoth_6_on == 1 then
        ClearAI(mammoth_6)
        Fly(mammoth_6, ring_1, 80)
    end
    if at_bay == 12 and lueneburg_6_on == 1 then
        ClearAI(lueneburg_6)
        Fly(lueneburg_6, ring_1, 80)
    end
    bay_held = 0
    next_turn()
    return 1
end)

next_turn = part("(F)Next turn", function()
    turn_clock = 0
    evac_turn += 1
    if evac_turn > 12 then
        evac_turn = 1
    end
    return 1
end)

rippers_to_fort = part("(F)Rippers to the fort", function()
    Fly(ripper_1, ripper_1_fort, 160)
    Fly(ripper_2, ripper_2_fort, 160)
    Fly(ripper_3, ripper_3_fort, 160)
    Fly(ripper_4, ripper_4_fort, 160)
    Fly(ripper_5, ripper_5_fort, 160)
    Fly(ripper_6, ripper_6_fort, 160)
    return 1
end)

rippers_to_transports = part("(F)Rippers to the transports", function()
    Fly(ripper_1, ripper_1_place, 160)
    Fly(ripper_2, ripper_2_place, 160)
    Fly(ripper_3, ripper_3_place, 160)
    Fly(ripper_4, ripper_4_place, 160)
    Fly(ripper_5, ripper_5_place, 160)
    Fly(ripper_6, ripper_6_place, 160)
    return 1
end)

-- A Sabre wave jumps in at its point and goes for the transport at the bay; the wing goes for the
-- waves.

wave_comes = part("(F)Wave comes", function()
    if waves == 1 then
        CreateFlightGroup(wave_1)
        SetAI(wave_1, "fly", 1, nil)
        SetAI(wave_1, "jump_in", 1, wave_1_in)
        WaitForJumpOrLaunch(wave_1)
        target_wave(wave_1)
    end
    if waves == 2 then
        CreateFlightGroup(wave_2)
        SetAI(wave_2, "fly", 1, nil)
        SetAI(wave_2, "jump_in", 1, wave_2_in)
        WaitForJumpOrLaunch(wave_2)
        target_wave(wave_2)
    end
    if waves == 3 then
        CreateFlightGroup(wave_3)
        SetAI(wave_3, "fly", 1, nil)
        SetAI(wave_3, "jump_in", 1, wave_3_in)
        WaitForJumpOrLaunch(wave_3)
        target_wave(wave_3)
    end
    if waves == 4 then
        CreateFlightGroup(wave_4)
        SetAI(wave_4, "fly", 1, nil)
        SetAI(wave_4, "jump_in", 1, wave_4_in)
        WaitForJumpOrLaunch(wave_4)
        target_wave(wave_4)
    end
    if waves == 5 then
        CreateFlightGroup(wave_5)
        SetAI(wave_5, "fly", 1, nil)
        SetAI(wave_5, "jump_in", 1, wave_5_in)
        WaitForJumpOrLaunch(wave_5)
        target_wave(wave_5)
    end
    if waves == 6 then
        CreateFlightGroup(wave_6)
        SetAI(wave_6, "fly", 1, nil)
        SetAI(wave_6, "jump_in", 1, wave_6_in)
        WaitForJumpOrLaunch(wave_6)
        target_wave(wave_6)
    end
    if waves == 7 then
        CreateFlightGroup(wave_7)
        SetAI(wave_7, "fly", 1, nil)
        SetAI(wave_7, "jump_in", 1, wave_7_in)
        WaitForJumpOrLaunch(wave_7)
        target_wave(wave_7)
    end
    if waves == 8 then
        CreateFlightGroup(wave_8)
        SetAI(wave_8, "fly", 1, nil)
        SetAI(wave_8, "jump_in", 1, wave_8_in)
        WaitForJumpOrLaunch(wave_8)
        target_wave(wave_8)
    end
    if waves == 9 then
        CreateFlightGroup(wave_9)
        SetAI(wave_9, "fly", 1, nil)
        SetAI(wave_9, "jump_in", 1, wave_9_in)
        WaitForJumpOrLaunch(wave_9)
        target_wave(wave_9)
    end
    if waves == 10 then
        CreateFlightGroup(wave_10)
        SetAI(wave_10, "fly", 1, nil)
        SetAI(wave_10, "jump_in", 1, wave_10_in)
        WaitForJumpOrLaunch(wave_10)
        target_wave(wave_10)
    end
    SetAI(escorts, "find_new_target", 1, waves_all)
    return 1
end)

-- What a wave goes for: the transport at the bay, or the transports as a whole where none is.

target_wave = part("(F)Target wave", function(wave)
    if at_bay == 0 then
        SetAI(wave, "find_new_target", 1, priority_transports)
    end
    if at_bay == 1 then
        SetAI(wave, "find_new_target", 1, mammoth_1)
    end
    if at_bay == 2 then
        SetAI(wave, "find_new_target", 1, lueneburg_1)
    end
    if at_bay == 3 then
        SetAI(wave, "find_new_target", 1, mammoth_2)
    end
    if at_bay == 4 then
        SetAI(wave, "find_new_target", 1, lueneburg_2)
    end
    if at_bay == 5 then
        SetAI(wave, "find_new_target", 1, mammoth_3)
    end
    if at_bay == 6 then
        SetAI(wave, "find_new_target", 1, lueneburg_3)
    end
    if at_bay == 7 then
        SetAI(wave, "find_new_target", 1, mammoth_4)
    end
    if at_bay == 8 then
        SetAI(wave, "find_new_target", 1, lueneburg_4)
    end
    if at_bay == 9 then
        SetAI(wave, "find_new_target", 1, mammoth_5)
    end
    if at_bay == 10 then
        SetAI(wave, "find_new_target", 1, lueneburg_5)
    end
    if at_bay == 11 then
        SetAI(wave, "find_new_target", 1, mammoth_6)
    end
    if at_bay == 12 then
        SetAI(wave, "find_new_target", 1, lueneburg_6)
    end
    return 1
end)

-- 10:00: every priority transport still flying counts as saved, whatever its turn; the result goes
-- to campaign.luau, and the bridge orders the departure as the tenth wave comes.

window_ends = part("(F)Window ends", function()
    evac_frozen = 1
    DestroyTimer(3)
    transports_saved = mammoth_1_on + mammoth_2_on + mammoth_3_on + mammoth_4_on + mammoth_5_on + mammoth_6_on + lueneburg_1_on + lueneburg_2_on + lueneburg_3_on + lueneburg_4_on + lueneburg_5_on + lueneburg_6_on
    PrintShipName(san_marco, 100 + transports_saved)
    SetObjective(4, 1)
    SetObjective(5, 2)
    ring_off()
    spawn(departure_order)
    spawn(departure)
    return 1
end)

departure_order = part("(F)Departure order", function()
    CommsFromPilot("victorious_bridge_officer", "talking", "ctl_m2_l7")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(san_marco, "talking", "smc_m2_l5")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    return 1
end)

-- The departure: one ship at a time, three seconds apart, in the fixed order, each that still
-- flies. The convoy has gone once none of it is still jumping; the original defenders still flying
-- then have jumped out with it.

departure = part("(F)Departure", function()
    Wait(2)
    if mammoth_1_on == 1 then
        SetAI(mammoth_1, "jump_out", 1, nil)
        Wait(3)
    end
    if mammoth_2_on == 1 then
        SetAI(mammoth_2, "jump_out", 1, nil)
        Wait(3)
    end
    if mammoth_3_on == 1 then
        SetAI(mammoth_3, "jump_out", 1, nil)
        Wait(3)
    end
    if mammoth_4_on == 1 then
        SetAI(mammoth_4, "jump_out", 1, nil)
        Wait(3)
    end
    if mammoth_5_on == 1 then
        SetAI(mammoth_5, "jump_out", 1, nil)
        Wait(3)
    end
    if mammoth_6_on == 1 then
        SetAI(mammoth_6, "jump_out", 1, nil)
        Wait(3)
    end
    if lueneburg_1_on == 1 then
        SetAI(lueneburg_1, "jump_out", 1, nil)
        Wait(3)
    end
    if lueneburg_2_on == 1 then
        SetAI(lueneburg_2, "jump_out", 1, nil)
        Wait(3)
    end
    if lueneburg_3_on == 1 then
        SetAI(lueneburg_3, "jump_out", 1, nil)
        Wait(3)
    end
    if lueneburg_4_on == 1 then
        SetAI(lueneburg_4, "jump_out", 1, nil)
        Wait(3)
    end
    if lueneburg_5_on == 1 then
        SetAI(lueneburg_5, "jump_out", 1, nil)
        Wait(3)
    end
    if lueneburg_6_on == 1 then
        SetAI(lueneburg_6, "jump_out", 1, nil)
        Wait(3)
    end
    if lonestar_1_on == 1 then
        SetAI(lonestar_1, "jump_out", 1, nil)
        Wait(3)
    end
    if lonestar_2_on == 1 then
        SetAI(lonestar_2, "jump_out", 1, nil)
        Wait(3)
    end
    if ripper_1_on == 1 then
        SetAI(ripper_1, "jump_out", 1, nil)
        Wait(3)
    end
    if ripper_2_on == 1 then
        SetAI(ripper_2, "jump_out", 1, nil)
        Wait(3)
    end
    if ripper_3_on == 1 then
        SetAI(ripper_3, "jump_out", 1, nil)
        Wait(3)
    end
    if ripper_4_on == 1 then
        SetAI(ripper_4, "jump_out", 1, nil)
        Wait(3)
    end
    if ripper_5_on == 1 then
        SetAI(ripper_5, "jump_out", 1, nil)
        Wait(3)
    end
    if ripper_6_on == 1 then
        SetAI(ripper_6, "jump_out", 1, nil)
        Wait(3)
    end
    if nanny_1_on == 1 then
        SetAI(nanny_1, "jump_out", 1, nil)
        Wait(3)
    end
    if nanny_2_on == 1 then
        SetAI(nanny_2, "jump_out", 1, nil)
        Wait(3)
    end
    if defender_1_on == 1 then
        SetAI(defender_coyote_1, "jump_out", 1, nil)
        Wait(3)
    end
    if defender_2_on == 1 then
        SetAI(defender_coyote_2, "jump_out", 1, nil)
        Wait(3)
    end
    if defender_3_on == 1 then
        SetAI(defender_prowler, "jump_out", 1, nil)
        Wait(3)
    end
    if defender_4_on == 1 then
        SetAI(defender_mammoth_1, "jump_out", 1, nil)
        Wait(3)
    end
    if defender_5_on == 1 then
        SetAI(defender_mammoth_2, "jump_out", 1, nil)
        Wait(3)
    end
    if defender_6_on == 1 then
        SetAI(defender_lueneburg_1, "jump_out", 1, nil)
        Wait(3)
    end
    if defender_7_on == 1 then
        SetAI(defender_lueneburg_2, "jump_out", 1, nil)
        Wait(3)
    end
    if kestrel_on == 1 then
        SetAI(convoy_kestrel, "jump_out", 1, nil)
        Wait(3)
    end
    if prowler_1_on == 1 then
        SetAI(convoy_prowler_1, "jump_out", 1, nil)
        Wait(3)
    end
    if prowler_2_on == 1 then
        SetAI(convoy_prowler_2, "jump_out", 1, nil)
        Wait(3)
    end
    WaitForJumpOrLaunch(convoy)
    if defender_1_on + defender_2_on + defender_3_on + defender_4_on + defender_5_on + defender_6_on + defender_7_on > 0 then
        defenders_survived = 1
    end
    rate_mission()
    SetObjective(5, 1)
    SetAI(waves_all, "find_new_target", 1, sevastopol_targets)
    spawn(sevastopol_arrives)
    return 1
end)

-- The debriefing's score, from the evacuation result and the defenders: 4 and 3 a Grand success
-- (12 saved), 2 and 1 a Success (6 to 11), with and without the defenders, and 0 a Failure.

rate_mission = part("(F)Rate the mission", function()
    score = 0
    if transports_saved == 12 then
        score = 3 + defenders_survived
    end
    if transports_saved >= 6 and transports_saved <= 11 then
        score = 1 + defenders_survived
    end
    game.mission_success = score
    return 1
end)

-- A priority transport lost before the window ends: San Marco Control announces it, and the
-- mission is lost once all twelve are. After the window, a loss changes nothing.

-- The twelfth loss stops the window at once, so that 10:00 can't come while the line plays, and
-- the mission ends once San Marco has announced it.

transport_lost = part("(F)Transport lost", function()
    if evac_frozen == 0 then
        transports_lost += 1
        if transports_lost == 12 then
            evacuation_failed = 1
            evac_frozen = 1
            DestroyTimer(3)
            game.mission_success = -1
        end
        spawn(transport_loss_line)
    end
    return 1
end)

transport_loss_line = part("(F)Transport loss line", function()
    WaitForSpeech()
    CommsFromShip(san_marco, "talking", "smc_m2_l4")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    if evacuation_failed == 1 then
        game.mission_over = 1
    end
    return 1
end)

on(mammoth_1, "destroyed", function(killer, victim)
    mammoth_1_on = 0
    transport_lost()
    return 1
end)
on(mammoth_2, "destroyed", function(killer, victim)
    mammoth_2_on = 0
    transport_lost()
    return 1
end)
on(mammoth_3, "destroyed", function(killer, victim)
    mammoth_3_on = 0
    transport_lost()
    return 1
end)
on(mammoth_4, "destroyed", function(killer, victim)
    mammoth_4_on = 0
    transport_lost()
    return 1
end)
on(mammoth_5, "destroyed", function(killer, victim)
    mammoth_5_on = 0
    transport_lost()
    return 1
end)
on(mammoth_6, "destroyed", function(killer, victim)
    mammoth_6_on = 0
    transport_lost()
    return 1
end)
on(lueneburg_1, "destroyed", function(killer, victim)
    lueneburg_1_on = 0
    transport_lost()
    return 1
end)
on(lueneburg_2, "destroyed", function(killer, victim)
    lueneburg_2_on = 0
    transport_lost()
    return 1
end)
on(lueneburg_3, "destroyed", function(killer, victim)
    lueneburg_3_on = 0
    transport_lost()
    return 1
end)
on(lueneburg_4, "destroyed", function(killer, victim)
    lueneburg_4_on = 0
    transport_lost()
    return 1
end)
on(lueneburg_5, "destroyed", function(killer, victim)
    lueneburg_5_on = 0
    transport_lost()
    return 1
end)
on(lueneburg_6, "destroyed", function(killer, victim)
    lueneburg_6_on = 0
    transport_lost()
    return 1
end)

-- The convoy's other ships and the original defenders, lost unannounced and uncounted.

on(lonestar_1, "destroyed", function(killer, victim)
    lonestar_1_on = 0
    return 1
end)
on(lonestar_2, "destroyed", function(killer, victim)
    lonestar_2_on = 0
    return 1
end)
on(ripper_1, "destroyed", function(killer, victim)
    ripper_1_on = 0
    return 1
end)
on(ripper_2, "destroyed", function(killer, victim)
    ripper_2_on = 0
    return 1
end)
on(ripper_3, "destroyed", function(killer, victim)
    ripper_3_on = 0
    return 1
end)
on(ripper_4, "destroyed", function(killer, victim)
    ripper_4_on = 0
    return 1
end)
on(ripper_5, "destroyed", function(killer, victim)
    ripper_5_on = 0
    return 1
end)
on(ripper_6, "destroyed", function(killer, victim)
    ripper_6_on = 0
    return 1
end)
on(nanny_1, "destroyed", function(killer, victim)
    nanny_1_on = 0
    return 1
end)
on(nanny_2, "destroyed", function(killer, victim)
    nanny_2_on = 0
    return 1
end)
on(convoy_kestrel, "destroyed", function(killer, victim)
    kestrel_on = 0
    return 1
end)
on(convoy_prowler_1, "destroyed", function(killer, victim)
    prowler_1_on = 0
    return 1
end)
on(convoy_prowler_2, "destroyed", function(killer, victim)
    prowler_2_on = 0
    return 1
end)
on(defender_coyote_1, "destroyed", function(killer, victim)
    defender_1_on = 0
    return 1
end)
on(defender_coyote_2, "destroyed", function(killer, victim)
    defender_2_on = 0
    return 1
end)
on(defender_prowler, "destroyed", function(killer, victim)
    defender_3_on = 0
    return 1
end)
on(defender_mammoth_1, "destroyed", function(killer, victim)
    defender_4_on = 0
    return 1
end)
on(defender_mammoth_2, "destroyed", function(killer, victim)
    defender_5_on = 0
    return 1
end)
on(defender_lueneburg_1, "destroyed", function(killer, victim)
    defender_6_on = 0
    return 1
end)
on(defender_lueneburg_2, "destroyed", function(killer, victim)
    defender_7_on = 0
    return 1
end)

-- The CS Sevastopol: the bridge calls a heavy cruiser, Corsair can't believe it, and it jumps in
-- alone in a shot of its own. Fighters can't destroy it. Its first salvo goes for the Richelieu,
-- then its Sabres launch, two at a time, as fast as its two gates allow.

sevastopol_arrives = part("(F)Sevastopol arrives", function()
    Wait(3)
    WaitForSpeech()
    CommsFromPilot("victorious_bridge_officer", "talking", "ctl_m2_l8")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a2, "talking", "cor_m2_l16")
    ClearAI(escorts)
    Fly(a2, clear_point, 200)
    SetAI(followers, "formation", 1, a2)
    Wait(1)
    WaitForSpeech()
    PlayMusic("new_mission06.wav", 1)
    CreateFlightGroup(sevastopol_group)
    SetInvulnerability(sevastopol, 2)
    SetAI(sevastopol_group, "fly", 1, nil)
    SetAI(sevastopol, "jump_in", 1, sevastopol_in)
    StartDirectorCam(camera_sevastopol, sevastopol, 10, nil, alpha)
    WaitForJumpOrLaunch(sevastopol_group)
    SetAI(sevastopol, "immediately_set_ship_to_zero_velocity_and_rotation", 1, nil)
    CreateFlightGroup(salvo_1)
    CreateFlightGroup(sevastopol_sabres)
    DisableObject(salvo_1, 1)
    DisableObject(sevastopol_sabres, 1)
    SetAI(salvo_1, "explode", 1, nil)
    SetAI(salvo_1, "find_new_target", 1, richelieu)
    spawn(sevastopol_launches)
    Wait(2)
    CommsFromPilot("victorious_bridge_officer", "talking", "ctl_m2_l9")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a2, "talking", "cor_m2_l17")
    SetObjective(6, 2)
    SetNavPoint(alpha, richelieu)
    ClearAI(escorts)
    SetAI(escorts, "find_new_target", 1, salvo_1)
    Wait(1)
    WaitForSpeech()
    Wait(1)
    return 1
end)

sevastopol_launches = part("(F)Sevastopol launches", function()
    launch_pair(salvo_1_1, salvo_1_2)
    launch_pair(salvo_1_3, salvo_1_4)
    launch_pair(salvo_1_5, salvo_1_6)
    launch_pair(sevastopol_sabre_1, sevastopol_sabre_2)
    SetAI(sevastopol_sabres, "find_new_target", 1, sevastopol_targets)
    launch_pair(sevastopol_sabre_3, sevastopol_sabre_4)
    SetAI(sevastopol_sabres, "find_new_target", 1, sevastopol_targets)
    launch_pair(sevastopol_sabre_5, sevastopol_sabre_6)
    SetAI(sevastopol_sabres, "find_new_target", 1, sevastopol_targets)
    launch_pair(sevastopol_sabre_7, sevastopol_sabre_8)
    SetAI(sevastopol_sabres, "find_new_target", 1, sevastopol_targets)
    launch_pair(sevastopol_sabre_9, sevastopol_sabre_10)
    SetAI(sevastopol_sabres, "find_new_target", 1, sevastopol_targets)
    launch_pair(sevastopol_sabre_11, sevastopol_sabre_12)
    SetAI(sevastopol_sabres, "find_new_target", 1, sevastopol_targets)
    sabres_deployed = 1
    return 1
end)

-- Two ships out of the Sevastopol's gates at once, each from the far spot it waits at.

launch_pair = part("(F)Launch pair", function(first, second)
    DisableObject(first, 0)
    DisableObject(second, 0)
    SetupLaunch(first, sevastopol, 0)
    SetupLaunch(second, sevastopol, 1)
    StartLaunch(first)
    StartLaunch(second)
    WaitForJumpOrLaunch(first)
    WaitForJumpOrLaunch(second)
    return 1
end)

-- The salvos: each torpedo counts as flying from its launch until it is shot down or hits; a salvo
-- is over once all six are done with. The first's end turns the wing on the Sabres, and the second
-- comes 45 seconds later; the second's end sends the Richelieu away.

on(salvo_1, "launched", { repeats = "always" }, function(launched_ship)
    salvo_1_flying += 1
    return 1
end)

on(salvo_1, "destroyed", { repeats = "always" }, function(killer, victim)
    if salvo_1_flying > 0 then
        salvo_1_flying -= 1
    end
    salvo_1_done += 1
    if salvo_1_done == 6 then
        spawn(salvo_1_over)
    end
    return 1
end)

on(salvo_2, "launched", { repeats = "always" }, function(launched_ship)
    salvo_2_flying += 1
    return 1
end)

on(salvo_2, "destroyed", { repeats = "always" }, function(killer, victim)
    if salvo_2_flying > 0 then
        salvo_2_flying -= 1
    end
    salvo_2_done += 1
    if salvo_2_done == 6 then
        spawn(salvo_2_over)
    end
    return 1
end)

-- The Richelieu hits so far, from campaign.luau, for the debugger's view of the globals.

count_hits = part("(F)Count hits", function()
    PrintShipName(richelieu, 1)
    richelieu_hits = result()
    return 1
end)

salvo_1_over = part("(F)Salvo 1 over", function()
    count_hits()
    SetObjective(6, 1)
    SetObjective(7, 2)
    ClearAI(escorts)
    SetAI(escorts, "find_new_target", 1, sevastopol_sabres)
    CreateTimer(4, salvo_2_comes, 45, 1)
    WaitForSpeech()
    CommsFromShip(a2, "talking", "cor_m2_l18")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    return 1
end)

salvo_2_comes = part("(F)Salvo 2 comes", function()
    CreateFlightGroup(salvo_2)
    DisableObject(salvo_2, 1)
    SetAI(salvo_2, "explode", 1, nil)
    SetAI(salvo_2, "find_new_target", 1, richelieu)
    spawn(salvo_2_launches)
    SetObjective(7, 1)
    SetObjective(6, 2)
    ClearAI(escorts)
    SetAI(escorts, "find_new_target", 1, salvo_2)
    WaitForSpeech()
    CommsFromPilot("victorious_bridge_officer", "talking", "ctl_m2_l10")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromShip(a2, "talking", "cor_m2_l19")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    return 1
end)

salvo_2_launches = part("(F)Salvo 2 launches", function()
    launch_pair(salvo_2_1, salvo_2_2)
    launch_pair(salvo_2_3, salvo_2_4)
    launch_pair(salvo_2_5, salvo_2_6)
    return 1
end)

-- The second salvo over: the Richelieu jumps away at once, to its new place, a target of its own
-- so that it doesn't join the player's jump, and stops there.

salvo_2_over = part("(F)Salvo 2 over", function()
    count_hits()
    SetObjective(6, 1)
    SetObjective(7, 2)
    ClearAI(escorts)
    SetAI(escorts, "find_new_target", 1, sevastopol_sabres)
    SetAI(richelieu, "jump_out", 1, richelieu_away)
    WaitForSpeech()
    CommsFromPilot("victorious_bridge_officer", "talking", "ctl_m2_l11")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    WaitForJumpOrLaunch(carrier_group)
    SetAI(richelieu, "immediately_set_ship_to_zero_velocity_and_rotation", 1, nil)
    richelieu_gone = 1
    home_check()
    return 1
end)

on(sevastopol_sabres, "destroyed", { repeats = "always" }, function(killer, victim)
    sevastopol_kills += 1
    home_check()
    return 1
end)

home_check = part("(F)Home check", function()
    if sevastopol_kills == 12 and richelieu_gone == 1 and home_called == 0 then
        home_called = 1
        spawn(called_home)
    end
    return 1
end)

-- The Sabres down and the Richelieu gone: Corsair calls the wing home, the bridge clears it, and
-- the jump drive comes online for the jump to the Richelieu.

called_home = part("(F)Called home", function()
    Wait(2)
    PlayMusic("new_searching mission 09.wav", 0)
    WaitForSpeech()
    CommsFromShip(a2, "talking", "cor_m2_l20")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    CommsFromPilot("victorious_bridge_officer", "talking", "ctl_m2_l12")
    Wait(1)
    WaitForSpeech()
    Wait(1)
    SetObjective(7, 1)
    SetObjective(8, 2)
    ClearAI(escorts)
    Fly(a2, clear_point, 150)
    SetAI(followers, "formation", 1, a2)
    SetNavPoint(alpha, jump_home_point)
    phase = 2
    game.jump_ready = 1
    return 1
end)

-- The jumps, on each leg: the player engages the jump drive, and the wing jumps where the phase
-- says; the arrival follows.

on(player, "player_ready_to_jump", { repeats = "always" }, function()
    if phase == 0 then
        spawn(jump_to_fort)
    end
    if phase == 2 then
        spawn(jump_home)
    end
    return 1
end)

on(player, "jumped_in", { repeats = "always" }, function(jumped_in_ship)
    if phase == 0 then
        spawn(arrive_at_fort)
    end
    if phase == 2 then
        spawn(arrive_home)
    end
    return 1
end)

jump_home = part("(F)Jump home", function()
    ClearAI(alpha)
    Wait(1)
    SetAI(alpha, "jump_out", 1, jump_home_point)
    return 1
end)

-- Home: the landing, as in mission 1. The player asks PERMISSION TO LAND, flies to the recovery
-- point astern of the Richelieu, and lands in bay 0, which ends the mission.

arrive_home = part("(F)Arrive home", function()
    WaitForJumpOrLaunch(alpha)
    game.jump_ready = 0
    phase = 3
    SetActionCentre(richelieu, 0)
    ResetFlybackMarker()
    SetNavPoint(alpha, recovery_point)
    ClearAI(escorts)
    Fly(a2, wingman_hold, 150)
    SetAI(followers, "formation", 1, a2)
    PlayMusic("new_victory.wav", 0)
    game.landing_cleared = 1
    spawn(await_landing_request)
    return 1
end)

-- Waits for the player to ask PERMISSION TO LAND (landing.luau holds the debug message command
-- until then), then shows the way to the recovery point.

await_landing_request = part("(F)Await landing request", function()
    PrintDebugMessage("spear: landing request")
    cleared_to_land = 1
    SetEscortPoint(player, recovery_point)
    SetFlybackMarker(recovery_point, 4000)
    return 1
end)

on(recovery_point, "ship_reached", { repeats = "always", reached_ship = player }, function(reached_ship)
    if phase == 3 and cleared_to_land == 1 then
        cleared_to_land = 2
        SetObjective(8, 1)
        SetEscortPoint(player, nil)
        ResetFlybackMarker()
        game.landing_cleared = 0
        SetAI(player, "land", 1, component(richelieu, 0))
        Wait(90)
        game.mission_over = 1
    end
    return 1
end)

-- For checking the mission from the command line or the debugger (`--part`, or `run`), once the
-- wing has launched. Each jumps the wing to the fort and plays from a later moment: the first
-- Azans exploded, which brings the Kazan ("test kazan"); the Kazan's escort and the Kurgens
-- exploded too, which opens the window of opportunity ("test window"); the carriers' systems
-- counted as down, for the Richelieu's strike ("test strike"); the evacuation from its start
-- ("test evacuation") or from 9:30 ("test departure"), the carriers gone; the Sevastopol's
-- arrival, the convoy gone ("test sevastopol"); and the wing called home, the Richelieu gone
-- ("test ending").

test_jump = part("(F)Test jump", function()
    -- After the wing's launch, which goes on after the player's.
    Wait(25)
    phase = 0
    jump_to_fort()
    return 1
end)

test_kazan = part("(F)Test kazan", function()
    test_jump()
    Wait(35)
    SetAI(first_azans, "explode", 1, nil)
    return 1
end)

test_window = part("(F)Test window", function()
    test_jump()
    Wait(35)
    SetAI(first_azans, "explode", 1, nil)
    SetAI(first_kurgens, "explode", 1, nil)
    Wait(30)
    SetAI(kazan_escort, "explode", 1, nil)
    return 1
end)

test_strike = part("(F)Test strike", function()
    test_jump()
    Wait(35)
    azan_kills = 8
    kurgen_kills = 2
    engagement_done = 1
    escort_kills = 8
    window_open = 1
    DestroyFlightGroup(first_azans)
    DestroyFlightGroup(first_kurgens)
    CreateFlightGroup(kazan_group)
    SetInvulnerability(component(kazan, 0), 2)
    systems_step = 5
    spawn(counterattack)
    return 1
end)

-- The fort, the Richelieu and the convoy as they stand once the carriers are gone, for the later
-- tests.

test_fort = part("(F)Test fort", function()
    Wait(25)
    phase = 1
    make_fort()
    ClearAI(alpha)
    SetAI(alpha, "jump_out", 1, san_marco_nav)
    WaitForJumpOrLaunch(alpha)
    game.jump_ready = 0
    SetObjective(0, 1)
    SnapToPoint(richelieu, richelieu_in)
    richelieu_holds()
    CreateFlightGroup(convoy_places)
    CreateFlightGroup(fort_ring)
    CreateFlightGroup(convoy_mammoths)
    CreateFlightGroup(convoy_lueneburgs)
    CreateFlightGroup(convoy_lonestars)
    CreateFlightGroup(convoy_rippers)
    CreateFlightGroup(convoy_nannies)
    CreateFlightGroup(convoy_escorts)
    convoy_settles()
    return 1
end)

test_evacuation = part("(F)Test evacuation", function()
    test_fort()
    start_evacuation()
    return 1
end)

test_departure = part("(F)Test departure", function()
    test_fort()
    waves = 9
    wave_clock = 30
    evac_seconds = 570
    start_evacuation()
    return 1
end)

-- `"test landing"` plays the end of the mission, as mission 1's `"test recovery"` does: a Grand
-- success with the defenders reported, and the player's ship put at the recovery point, which
-- lands it and ends the mission.

test_landing = part("(F)Test landing", function()
    Wait(25)
    transports_saved = 12
    defenders_survived = 1
    PrintShipName(san_marco, 100 + transports_saved)
    rate_mission()
    phase = 3
    cleared_to_land = 1
    SetObjective(8, 2)
    SetNavPoint(alpha, recovery_point)
    SnapToPoint(player, recovery_point)
    return 1
end)

-- `"test total loss"` blows up every priority transport a few seconds into the evacuation, which
-- loses the mission; `"test late loss"` blows up one just after 10:00, which changes nothing.

test_total_loss = part("(F)Test total loss", function()
    test_evacuation()
    Wait(5)
    SetAI(priority_transports, "explode", 1, nil)
    return 1
end)

test_late_loss = part("(F)Test late loss", function()
    test_departure()
    Wait(33)
    SetAI(mammoth_6, "explode", 1, nil)
    return 1
end)

-- `"test wing losses"` blows up Rook and Mako once the wing has launched, each lost with his or
-- her line. (An Explode order goes round wing2.luau's protection, which keeps the others from
-- their hits' end.)

test_wing_losses = part("(F)Test wing losses", function()
    Wait(25)
    SetAI(a5, "explode", 1, nil)
    Wait(6)
    SetAI(a6, "explode", 1, nil)
    return 1
end)

test_sevastopol = part("(F)Test sevastopol", function()
    test_fort()
    transports_saved = 12
    evac_frozen = 1
    DestroyFlightGroup(convoy_mammoths)
    DestroyFlightGroup(convoy_lueneburgs)
    DestroyFlightGroup(convoy_lonestars)
    DestroyFlightGroup(convoy_rippers)
    DestroyFlightGroup(convoy_nannies)
    DestroyFlightGroup(convoy_escorts)
    rate_mission()
    spawn(sevastopol_arrives)
    return 1
end)

test_ending = part("(F)Test ending", function()
    test_fort()
    transports_saved = 12
    rate_mission()
    SetAI(richelieu, "jump_out", 1, richelieu_away)
    WaitForJumpOrLaunch(carrier_group)
    SetAI(richelieu, "immediately_set_ship_to_zero_velocity_and_rotation", 1, nil)
    richelieu_gone = 1
    sevastopol_kills = 12
    home_check()
    return 1
end)

-- `"test home"` does the same, then jumps the wing to the Richelieu once it is called home, as the
-- player's jump would.

test_home = part("(F)Test home", function()
    test_ending()
    Wait(25)
    jump_home()
    return 1
end)
