--[[
gimme StrangePrism
]]

local portalSpawn = Item.new(NAMESPACE, "portalSpawn", true)
portalSpawn:toggle_loot(false)

local portal = Object.new(NAMESPACE, "portal", Object.PARENT.interactable)
portal.obj_sprite  = gm.constants.sImpPortal
portal.obj_depth   = 1

Callback.add(Callback.TYPE.onKillProc, NAMESPACE.."Portal-onKillProc", function(victim, killer)
    --oBoarMS: "Iron Boarlit"
    --oAcrid: "Acrid"
    --oLizardGS: "Direseeker"
    if victim.object_index == gm.constants.oAcrid or victim.object_index == gm.constants.oLizardGS then
        victim.dropPortal = true
    end

    --victim.dropPortal = true
    if victim.dropPortal and GM._mod_game_getDirector().teleporter_active == 0 then
        portalSpawn:create(victim.x, victim.y)
    end
end)

Object.find(NAMESPACE, "portalSpawn"):onStep(function(inst)
    if inst.spawned then
        -- Create Portal
        local portalInst = portal:create(inst.x, inst.y - 30)
        portalInst:get_data().frameNum = -1
        portalInst.image_speed = 0.15
        inst:destroy()
    end
end)

portal:onStep(function(inst)
    local portalData = inst:get_data()

    portalData.frameNum = portalData.frameNum + inst.image_speed
    if portalData.frameNum >= 30 or (portalData.frameNum <= 3 and inst.image_speed < 0) then
        inst.image_speed = -inst.image_speed
    end

    if inst.active == 2 then
        inst.image_speed = 0.2
    end
    if portalData.frameNum > 35 then
        GM.stage_goto(Stage.find(NAMESPACE, "bulwarksAmbry"))
        local Director = gm._mod_game_getDirector()
        Director.stages_passed = Director.stages_passed - 1
        inst:destroy()
    end
end)

local PortalBoss = Monster_Card.new(NAMESPACE, "GildedWurm")
PortalBoss.object_id = Object.find("ror", "WurmHead").value
PortalBoss.spawn_type = Monster_Card.SPAWN_TYPE.offscreen

Callback.add(Callback.TYPE.onPlayerStep, NAMESPACE.."Portal-onPlayerStep", function(player)
    if player:is_colliding(Object.find("ror-StrangePrism")) then
        local boss = Instance.wrap(GM.director_spawn_monster_card(player.x, player.y, PortalBoss, 1))
        boss.dropPortal = true
    end
end)