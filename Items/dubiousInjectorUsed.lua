--[[
give_item OnyxExpansion-dubiousInjectorUsed
]] local dubiousInjectorUsed = Item.new(NAMESPACE, "dubiousInjectorUsed")
-- local spriteCooldown = Resources.sprite_load(NAMESPACE, "dubiousInjectorCooldown", PATH.."Assets/Items/dubiousInjectorCooldown.png", 1, 4, 4)
local spriteCooldown = Resources.sprite_load(NAMESPACE, "dubiousInjectorCooldown", path.combine(PATH, "Assets/Items/dubiousInjectorCooldown.png"), 1, 4, 4)
dubiousInjectorUsed:set_sprite(Resources.sprite_load(NAMESPACE, "dubiousInjectorUsed", PATH.."/Assets/Items/dubiousInjectorUsed.png", 1, 16, 16))

local function RestoreInjector(actor)
    if actor:exists() then
        local dubiousInjector = Item.find(NAMESPACE, "dubiousInjector")
        local normalItemCount = actor:item_stack_count(item, Item.STACK_KIND.normal)
        local tempItemCount = actor:item_stack_count(item, Item.STACK_KIND.temporary_blue)
        
        if normalItemCount > 0 then
            actor:item_remove(dubiousInjectorUsed, normalItemCount)
            actor:item_give(dubiousInjector, normalItemCount)
        end
        if tempItemCount > 0 then
            actor:item_remove(dubiousInjectorUsed, tempItemCount, Item.STACK_KIND.temporary_blue)
            actor:item_give(dubiousInjector, tempItemCount, Item.STACK_KIND.temporary_blue)
        end
    end
end

dubiousInjectorUsed:onAcquire(function(actor, stack)
    local cd = 120*60 / (stack * 0.2)

    -- Apply cooldown
    Alarm.create(RestoreInjector, cd, actor)
    Cooldown.set(actor, NAMESPACE.."dubiousInjector", cd, spriteCooldown, Color(0xf0e07d))
end)

dubiousInjectorUsed:onStatRecalc(function(actor, stack)
    actor.maxhp = math.floor(actor.maxhp / (1 + actor:get_data("dubiousInjector").injectionCount * 0.1))
end)