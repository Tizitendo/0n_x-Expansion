RunArtifact = mods["0n_x-MidrunArtifacts"].setup()

local artifactReliquary = Object.new(NAMESPACE, "artifactReliquary", Object.PARENT.interactable)
artifactReliquary.obj_sprite  = gm.constants.sTeleporterEpicChargeFX
artifactReliquary.obj_depth   = 1

artifactReliquary:onCreate(function(inst)
    inst:get_data().frameNum = -1
    inst.image_speed = 0.1
end)

artifactReliquary:onStep(function(inst)
    local ReliquaryData = inst:get_data()

    ReliquaryData.frameNum = ReliquaryData.frameNum + inst.image_speed
    if inst.image_speed < 0 then
        inst.image_speed = 0.1
    end
    if ReliquaryData.frameNum >= 14.9 then
        inst.image_speed = -14.9
    end

    if inst.active == 2 then
        inst.active = 0
        local playerData = inst.activator:get_data()
        if #playerData.ActiveArtifacts > 0 then
            local RemoveArtifactSlot = math.random(1, #playerData.ActiveArtifacts)
            RunArtifact.remove(playerData.ActiveArtifacts[RemoveArtifactSlot])
            Item.get_random(Item.TIER.rare):create(inst.x, inst.y)
            DISTORTION = DISTORTION + 1
            local difficulty = Difficulty.wrap(GM._mod_game_getDifficulty())
            difficulty:set_scaling(difficulty.diff_scale, difficulty.general_scale, difficulty.point_scale + 0.5)
        end
    end
end)

Callback.add(Callback.TYPE.onGameEnd, NAMESPACE.."artifactReliquary-onGameEnd", function()
    local difficulty = Difficulty.wrap(GM._mod_game_getDifficulty())
    difficulty:set_scaling(difficulty.diff_scale, difficulty.general_scale, difficulty.point_scale - DISTORTION * 0.5)
    DISTORTION = 0
end)