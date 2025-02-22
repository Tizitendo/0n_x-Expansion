--[[
give_item OnyxExpansion-dubiousInjector
]] local dubiousInjector = Item.new(NAMESPACE, "dubiousInjector")
dubiousInjector:set_tier(TIER_BROKEN_COMMON)
dubiousInjector:set_loot_tags(Item.LOOT_TAG.category_healing)
dubiousInjector:set_sprite(Resources.sprite_load(NAMESPACE, "dubiousInjector", PATH.."/Assets/Items/dubiousInjector.png", 1, 16, 16))

Callback.add(Callback.TYPE.onPlayerInit, NAMESPACE.."dubiousInjector-onPlayerInit", function(player)
    player:get_data("dubiousInjector").injectionCount = 0
end)

dubiousInjector:onStatRecalc(function(actor, stack)
    actor.maxhp = math.floor(actor.maxhp / (1 + actor:get_data("dubiousInjector").injectionCount * 0.1))
end)

dubiousInjector:onDamagedProc(function(actor, attacker, stack, hit_info)
    if actor.hp <= actor.maxhp * 0.25 then
        actor:get_data("dubiousInjector").injectionCount = actor:get_data("dubiousInjector").injectionCount + 1
        actor:heal(actor.maxhp * 0.5)

        local dubiousInjectorUsed = Item.find(NAMESPACE, "dubiousInjectorUsed")
        local normalItemCount = actor:item_stack_count(dubiousInjector, Item.STACK_KIND.normal)
        local tempItemCount = actor:item_stack_count(dubiousInjector, Item.STACK_KIND.temporary_blue)
        if normalItemCount > 0 then
            actor:item_remove(dubiousInjector, normalItemCount)
            actor:item_give(dubiousInjectorUsed, normalItemCount)
        end
        if tempItemCount > 0 then
            actor:item_remove(dubiousInjector, tempItemCount, Item.STACK_KIND.temporary_blue)
            actor:item_give(dubiousInjectorUsed, tempItemCount, Item.STACK_KIND.temporary_blue)
        end
    end
end)

