--[[
give_item OnyxExpansion-essenceOfHeresy
remove_item OnyxExpansion-essenceOfHeresy
give_item ancientScepter
remove_item ancientScepter
]] local essenceOfHeresy = Item.new(NAMESPACE, "essenceOfHeresy")
essenceOfHeresy:set_tier(TIER_BROKEN_RARE)
essenceOfHeresy:set_loot_tags(Item.LOOT_TAG.category_damage)
essenceOfHeresy:set_sprite(Resources.sprite_load(NAMESPACE, "essenceOfHeresy", PATH.."/Assets/Items/essenceOfHeresy.png", 1, 16, 16))

local ruin = Skill.new(NAMESPACE, "ruin")
ruin.sprite = Resources.sprite_load(NAMESPACE, "ruinSkill", PATH.."/Assets/Skills/ruin.png", 1, 0, 0)
ruin.cooldown = 60 * 12

local ruinBoosted = Skill.new(NAMESPACE, "ruinBoosted")
ruin:set_skill_upgrade(ruinBoosted)
ruinBoosted.sprite = Resources.sprite_load(NAMESPACE, "ruinSkill", PATH.."/Assets/Skills/ruin.png", 1, 0, 0)
ruinBoosted.cooldown = 60 * 12

local ruinDebuff = Buff.new(NAMESPACE, "ruinDebuff")
ruinDebuff.icon_sprite = Resources.sprite_load(NAMESPACE, "ruinDebuff", PATH .. "/Assets/Buffs/essenceOfHeresy.png", 1, 7, 8)
ruinDebuff.max_stack = 999

local scepter = Item.find("ror", "ancientScepter")

essenceOfHeresy:onAcquire(function(actor, stack)
    ruin.cooldown = 60 * 15 + 5 * 60 * stack
    ruinBoosted.cooldown = 60 * 15 + 5 * 60 * stack
    actor:add_skill_override(3, ruin)
    actor:get_data("essenceOfHeresy").stack = stack
    
    if actor:item_stack_count(scepter) > 0 then
        actor:add_skill_override(3, ruinBoosted)
    end
end)

essenceOfHeresy:onRemove(function(actor, stack)
    if stack <= 1 then
        actor:remove_skill_override(3, ruin)
        actor:remove_skill_override(3, ruinBoosted)
    end
end)

scepter:onAcquire(function(actor, stack)
    if actor:item_stack_count(essenceOfHeresy) > 0 then
        actor:add_skill_override(3, ruinBoosted)
    end
end)

scepter:onRemove(function(actor, stack)
    if stack <= 1 then
        actor:remove_skill_override(3, ruinBoosted)
    end
end)

ruin:onActivate(function(actor)
    local actorData = actor:get_data("essenceOfHeresy")
    for _, victim in ipairs(Instance.find_all(gm.constants.pActor)) do    
        if victim:buff_stack_count(ruinDebuff) > 0 then
            victim:apply_dot(3, actor, 1, 1)
        end
        for i = 1, victim:buff_stack_count(ruinDebuff) do
            victim:apply_dot(1, actor, 1, 1)
        end
        victim:buff_remove(ruinDebuff, victim:buff_stack_count(ruinDebuff))
        victim:buff_apply(fear, actorData.stack * 120)
    end
end)

ruinBoosted:onActivate(function(actor)
    local actorData = actor:get_data("essenceOfHeresy")
    for _, victim in ipairs(Instance.find_all(gm.constants.pActor)) do    
        if victim:buff_stack_count(ruinDebuff) > 0 then
            victim:apply_dot(3, actor, 1, 1)
        end
        for i = 1, victim:buff_stack_count(ruinDebuff) do
            victim:apply_dot(1.3, actor, 1, 1)
        end
        victim:buff_remove(ruinDebuff, victim:buff_stack_count(ruinDebuff))
    end
end)

Callback.add(Callback.TYPE.onHitProc, NAMESPACE.."essenceOfHeresy-onHitProc", function(actor, victim, hit_info)
    if actor:item_stack_count(essenceOfHeresy) > 0 then
        victim:buff_apply(ruinDebuff, 600 * actor:get_data().stack)
    end
end)

