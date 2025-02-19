local SpriteNamespace = "OnyxStage"

--Stage Resources
Resources.sprite_load(SpriteNamespace, "bulwarksAmbry1", path.combine(PATH.."/Assets/Stages/Bulwark's Ambry", "bulwarksAmbry1.png"), 1, 0, 0)
-- Resources.sprite_load(NAMESPACE, "BackTilesModded2", path.combine(PATH.."/Sprites/Stages/WhistlingBasin", "BackTilesModded2.png"), 1, 0, 0)
-- Resources.sprite_load(NAMESPACE, "LandCloudWhistlingBasin", path.combine(PATH.."/Sprites/Stages/WhistlingBasin", "LandCloudWhistlingBasin.png"), 1, 0, 0)
-- Resources.sprite_load(NAMESPACE, "SkyBasin", path.combine(PATH.."/Sprites/Stages/WhistlingBasin", "SkyBasin.png"), 1, 0, 0)
-- Resources.sprite_load(NAMESPACE, "MoonBasin", path.combine(PATH.."/Sprites/Stages/WhistlingBasin", "MoonBasin.png"), 1, 0, 0)
-- Resources.sprite_load(NAMESPACE, "MountainsBasinNew", path.combine(PATH.."/Sprites/Stages/WhistlingBasin", "MountainsBasinNew.png"), 1, 0, 0)
-- Resources.sprite_load(NAMESPACE, "MountainsBasinNew2", path.combine(PATH.."/Sprites/Stages/WhistlingBasin", "MountainsBasinNew2.png"), 1, 0, 0)
-- Resources.sprite_load(NAMESPACE, "LandCloud4WhistlingBasin", path.combine(PATH.."/Sprites/Stages/WhistlingBasin", "LandCloud4WhistlingBasin.png"), 1, 0, 0)
-- Resources.sprite_load(NAMESPACE, "LandCloud5WhistlingBasin", path.combine(PATH.."/Sprites/Stages/WhistlingBasin", "LandCloud5WhistlingBasin.png"), 1, 0, 0)

--Menu Resources
-- local EnvironmentWhistlingBasin = Resources.sprite_load(NAMESPACE, "EnvironmentWhistlingBasin", path.combine(PATH.."/Sprites/Stages/WhistlingBasin", "EnvironmentWhistlingBasin.png"))
-- local GroundStripWhistlingBasin = Resources.sprite_load(NAMESPACE, "GroundStripWhistlingBasin", path.combine(PATH.."/Sprites/Stages/WhistlingBasin", "GroundStripWhistlingBasin.png"))

--Stage
local bulwarksAmbry = Stage.new(NAMESPACE, "bulwarksAmbry")
--bulwarksAmbry.music_id = gm.sound_add_w(NAMESPACE, "musicWhistlingBasin", path.combine(PATH.."/Sounds/Music", "musicWhistlingBasin.ogg"))
bulwarksAmbry.music_id = gm.constants.musicStage4
bulwarksAmbry.token_name = "Bulwark's Ambry"
bulwarksAmbry.token_subname = "idk yet" 
--bulwarksAmbry:set_index(2)

--Rooms
bulwarksAmbry:add_room(path.combine(PATH.."/Assets/Stages/Bulwark's Ambry", "Bulwark's Ambry1.rorlvl"))

--Spawn list
bulwarksAmbry:add_monster({
    "lemurian",
    "wisp",
    "imp",
    "crab",
    "greaterWisp",
    "ancientWisp",
    "archaicWisp",
    "bramble",
    "scavenger"
})
bulwarksAmbry:add_monster_loop({
    "impOverlord",
    "lemrider"
})

bulwarksAmbry:add_interactable({
    "barrel1",
    "barrelEquipment",
    "chest1",
    "chest2",
    "chest3",
    "drone3",
    "drone4",
    "shrine2",
    "chestHealing1",
    "equipmentActivator",
    "droneRecycler"
})
bulwarksAmbry:add_interactable_loop({
    "chestHealing2",
    "chest4",
    "shrine3S",
    "barrel2",
    "chest5"
})

--Environment Log
-- bulwarksAmbry:set_log_icon(EnvironmentWhistlingBasin)

--Main Menu
-- bulwarksAmbry:set_title_screen_properties(GroundStripWhistlingBasin)
