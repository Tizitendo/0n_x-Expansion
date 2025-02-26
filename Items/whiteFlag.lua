--[[
give_item OnyxExpansion-whiteFlag
]] local whiteFlag = Item.new(NAMESPACE, "whiteFlag")
whiteFlag:set_tier(Item.TIER.uncommon)
whiteFlag:set_loot_tags(Item.LOOT_TAG.category_utility)
whiteFlag:set_sprite(Resources.sprite_load(NAMESPACE, "whiteFlag", PATH .. "/Assets/Items/whiteFlag.png", 1, 15, 15))

-- local whiteFlagObject = Object.new(NAMESPACE, "whiteFlagObject", Object.PARENT.interactable)
local whiteFlagObject = Object.new(NAMESPACE, "whiteFlagObject", Object.PARENT.mapObjects)
whiteFlagObject.obj_sprite = Resources.sprite_load(NAMESPACE, "whiteFlagObject",
    PATH .. "/Assets/Items/whiteFlagObject.png", 7, 15, 20)
whiteFlagObject.obj_depth = 1

local flagDebuff = Buff.new(NAMESPACE, "flagDebuff")
flagDebuff.icon_sprite = Resources.sprite_load(NAMESPACE, "flagDebuff", PATH .. "/Assets/Buffs/whiteFlag.png", 1, 7, 8)

whiteFlag:onKillProc(function(actor, victim, stack)
    local flagList = Instance.find_all(whiteFlagObject)
    for _, flag in ipairs(flagList) do
        local flagData = flag:get_data("whiteFlag")
        flagData.lifetime = 300 + 300 * stack
        if flagData.radius < 500 then
            flagData.radius = flagData.radius + 25
        end
    end

    if math.random(1, 20 * (1 + #flagList)) <= 1 then
        local flag = whiteFlagObject:create(victim.x, victim.y - 50)
        flag:move_contact_solid(270, -5)
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
    GM.draw_circle_colour(inst.x, inst.y, inst:get_data("whiteFlag").radius, 166, 16777215, 16777215, true)
end)

flagDebuff:onPostStatRecalc(function(actor, stack)
    actor.pHmax = actor.pHmax * 0.5
    actor.attack_speed = actor.attack_speed * 0.5
end)

whiteFlagObject:onStep(function(inst)
    local flagData = inst:get_data("whiteFlag")
    flagData.lifetime = flagData.lifetime - 1
    if flagData.lifetime == 0 then
        inst:destroy()
    end
end)

Callback.add(Callback.TYPE.onSecond, NAMESPACE .. "whiteFlag-onSecond", function(minute, second)
    for _, flag in ipairs(Instance.find_all(whiteFlagObject)) do
        local flagData = flag:get_data("whiteFlag")
        local victims = List.new()
        flag:collision_circle_list(flag.x, flag.y, flag:get_data("whiteFlag").radius, gm.constants.pActor, false, true,
            victims, false)

        for _, victim in ipairs(victims) do
            if victim.team ~= flag.team then
                if victim:buff_stack_count(flagDebuff) == 0 then
                    victim:buff_apply(flagDebuff, 90)
                else
                    GM.set_buff_time_nosync(victim, flagDebuff, 90)
                end
            end
        end
    end
end)
