--[[
give_item OnyxExpansion-whiteFlag
]] local whiteFlag = Item.new(NAMESPACE, "whiteFlag")
whiteFlag:set_tier(Item.TIER.uncommon)
whiteFlag:set_loot_tags(Item.LOOT_TAG.category_utility)
whiteFlag:set_sprite(Resources.sprite_load(NAMESPACE, "whiteFlag", PATH.."/Assets/Items/whiteFlag.png", 1, 15, 15))
local whiteFlagObject = Object.new(NAMESPACE, "whiteFlagObject", Object.PARENT.interactable)
--whiteFlagObject.obj_sprite = gm.constants.sEfWarbanner
whiteFlagObject.obj_sprite = Resources.sprite_load(NAMESPACE, "whiteFlagObject", PATH.."/Assets/Items/whiteFlagObject.png", 7, 15, 20)
whiteFlagObject.obj_depth = 1

whiteFlag:onKillProc(function(actor, victim, stack)
    local flagList = Instance.find_all(whiteFlagObject)
    for _, flag in ipairs(flagList) do
        flag:get_data("whiteFlag").lifetime = 600
        flag:get_data("whiteFlag").radius = flag:get_data("whiteFlag").radius + 25
    end
    if math.random(1, 20) <= 1 then
        local flag = whiteFlagObject:create(victim.x, victim.y)
        flag.team = actor.team
        flag:get_data("whiteFlag").lifetime = 300 + 300 * stack
    end
end)

whiteFlagObject:onCreate(function(inst)
    inst.active = -1
    inst.image_speed = 0.1
    inst:get_data("whiteFlag").radius = 50
end)

whiteFlagObject:onDraw(function(inst)
    if inst.image_index >= 6 then
        inst.image_index = 0
    end
    GM.draw_circle_colour(inst.x, inst.y, inst:get_data("whiteFlag").radius, 166, 5569968, 5569968, true)
end)

local flagDebuff = Buff.new(NAMESPACE, "flagDebuff")

flagDebuff:onPostStatRecalc(function(actor, stack)
    actor.pHmax = actor.pHmax * 0.5
    actor.attack_speed = actor.attack_speed * 0.5
end)

whiteFlagObject:onStep(function(inst)
    local flagData = inst:get_data("whiteFlag")
    local victims = List.new()
    inst:collision_circle_list(inst.x, inst.y, inst:get_data("whiteFlag").radius, gm.constants.pActor, false, true, victims, false)

    for _, victim in ipairs(victims) do
        if victim.team ~= inst.team then
            -- log.warning(victim)
            if victim:buff_stack_count(flagDebuff) == 0 then
                victim:buff_apply(flagDebuff, 60)
            else
                GM.set_buff_time_nosync(victim, flagDebuff, 60)
            end
        end
    end

    flagData.lifetime = flagData.lifetime - 1
    if flagData.lifetime == 0 then
        inst:destroy()
    end
end)
