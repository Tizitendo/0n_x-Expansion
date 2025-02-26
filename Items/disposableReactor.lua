--[[
give_item OnyxExpansion-disposableReactor
]] local disposableReactor = Item.new(NAMESPACE, "disposableReactor")
disposableReactor:set_tier(TIER_BROKEN_UNCOMMON)
disposableReactor:set_loot_tags(Item.LOOT_TAG.category_damage)
disposableReactor:set_sprite(Resources.sprite_load(NAMESPACE, "disposableReactor", PATH.."/Assets/Items/disposableReactor.png", 1, 16, 16))

local reactorObject = Object.new(NAMESPACE, "reactor", Object.PARENT.mapObjects)
reactorObject.obj_sprite = Resources.sprite_load(NAMESPACE, "reactor", PATH.."/Assets/Items/reactor.png", 8, 15, 15)
reactorObject.obj_depth = 1

local reactorCard = Monster_Card.new(NAMESPACE, "reactor")
reactorCard.object_id = reactorObject

local reactorDebuff = Buff.new(NAMESPACE, "reactorDebuff")
reactorDebuff.icon_sprite = Resources.sprite_load(NAMESPACE, "reactorDebuff", PATH .. "/Assets/Buffs/disposableReactor.png", 1, 12, 12)

reactorDebuff:onDamagedProc(function(actor, attacker, stack, hit_info)
    if hit_info.attack_info ~= nil then
        actor:apply_dot(hit_info.damage * 0.5, attacker, 1, 1, 5569968, true)
    end
end)

local function KillReactor(inst)
    inst:destroy()
end

disposableReactor:onInteractableActivate(function(actor, stack, interactable)
    local reactorInst = Instance.wrap(GM.director_spawn_monster_card(actor.x, actor.y, reactorCard, 1))
    reactorInst.image_speed = 0.15
    reactorInst:get_data("disposableReactor").parent = actor
    Alarm.create(KillReactor, 60 * 60, reactorInst)
end)

disposableReactor:onStatRecalc(function(actor, stack)
    actor:get_data("disposableReactor").radius = 150 * stack
end)

-- reactor:onStep(function(inst)
--     local victims = List.new()
--     inst:collision_circle_list(inst.x, inst.y, 100, gm.constants.pActor, false, true, victims, false)

--     for _, victim in ipairs(victims) do
--         if victim:buff_stack_count(reactorDebuff) == 0 then
--             victim:buff_apply(reactorDebuff, 60)
--         else
--             GM.set_buff_time_nosync(victim, reactorDebuff, 60)
--         end
--     end
-- end)

local function Apply_Buff()
    for _, reactor in ipairs(Instance.find_all(reactorObject)) do
        local radius = reactor:get_data("disposableReactor").parent:get_data("disposableReactor").radius
        local victims = List.new()
        reactor:collision_circle_list(reactor.x, reactor.y, radius, gm.constants.pActor, false, true, victims, false)
    
        for _, victim in ipairs(victims) do
            if victim:buff_stack_count(reactorDebuff) == 0 then
                victim:buff_apply(reactorDebuff, 60)
            else
                GM.set_buff_time_nosync(victim, reactorDebuff, 60)
            end
        end
    end
end

Callback.add(Callback.TYPE.onSecond, NAMESPACE .. "disposableReactor-onSecond", function(minute, second)
    Apply_Buff()
    Alarm.create(Apply_Buff, 30)
end)

reactorObject:onDraw(function(inst)
    GM.draw_circle_colour(inst.x, inst.y,
        inst:get_data("disposableReactor").parent:get_data("disposableReactor").radius, 166, 5569968, 5569968, true)
end)
