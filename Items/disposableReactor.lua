--[[
give_item OnyxExpansion-disposableReactor
]] local disposableReactor = Item.new(NAMESPACE, "disposableReactor")
disposableReactor:set_tier(TIER_BROKEN_UNCOMMON)
disposableReactor:set_loot_tags(Item.LOOT_TAG.category_damage)
disposableReactor:set_sprite(Resources.sprite_load(NAMESPACE, "disposableReactor", PATH.."/Assets/Items/disposableReactor.png", 1, 16, 16))

local reactor = Object.new(NAMESPACE, "reactor", Object.PARENT.mapObjects)
-- reactor.obj_sprite = gm.constants.sEfWarbanner
reactor.obj_sprite = Resources.sprite_load(NAMESPACE, "reactor", PATH.."/Assets/Items/reactor.png", 8, 15, 15)
reactor.obj_depth = 1

local reactorCard = Monster_Card.new(NAMESPACE, "reactor")
reactorCard.object_id = reactor

local reactorDebuff = Buff.new(NAMESPACE, "reactorDebuff")

reactorDebuff:onDamagedProc(function(actor, attacker, stack, hit_info)
    if hit_info.attack_info ~= nil then
        actor:apply_dot(0.5, attacker, 1, 1, 5569968)
    end
end)

local function KillReactor(inst)
    inst:destroy()
end

disposableReactor:onInteractableActivate(function(actor, stack, interactable)
    local reactorInst = Instance.wrap(GM.director_spawn_monster_card(actor.x, actor.y, reactorCard, 1))
    reactorInst.image_speed = 0.15
    reactorInst:get_data("disposableReactor").parent = actor
    Alarm.create(KillReactor, 1800, reactorInst)
end)

disposableReactor:onStatRecalc(function(actor, stack)
    actor:get_data("disposableReactor").radius = 150 * stack
end)

reactor:onStep(function(inst)
    local victims = List.new()
    inst:collision_circle_list(inst.x, inst.y, 100, gm.constants.pActor, false, true, victims, false)

    for _, victim in ipairs(victims) do
        if victim:buff_stack_count(reactorDebuff) == 0 then
            victim:buff_apply(reactorDebuff, 60)
        else
            GM.set_buff_time_nosync(victim, reactorDebuff, 60)
        end
    end
end)

reactor:onDraw(function(inst)
    GM.draw_circle_colour(inst.x, inst.y,
        inst:get_data("disposableReactor").parent:get_data("disposableReactor").radius, 166, 5569968, 5569968, true)
end)
