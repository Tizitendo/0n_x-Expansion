--[[
give_item OnyxExpansion-hamsterWheel
]] 
local hamsterWheel = Item.new(NAMESPACE, "hamsterWheel")
hamsterWheel:set_tier(Item.TIER.common)
hamsterWheel:set_loot_tags(Item.LOOT_TAG.category_utility)
hamsterWheel:set_sprite(Resources.sprite_load(NAMESPACE, "hamsterWheel", PATH.."/Assets/Items/hamsterWheel.png", 1, 14, 14))

hamsterWheel:onPostStatRecalc(function(actor, stack)
    local actorData = actor:get_data("hamsterWheel")
    actorData.buffed = false
end)

hamsterWheel:onAcquire(function(actor, stack)
    local actorData = actor:get_data("hamsterWheel")
    actorData.moveLeft = 0
    actorData.moveRight = 0
end)

hamsterWheel:onPostStep(function(actor, stack)
    local actorData = actor:get_data("hamsterWheel")
    
    if gm.bool(actor.moveLeft) and not gm.bool(actor.moveRight) then
        if actorData.moveLeft < 100 then
            actorData.moveLeft = actorData.moveLeft + 1
        end
    else
        if actorData.moveLeft > 0 then
            actorData.moveLeft = actorData.moveLeft - 2
        end
    end
    if gm.bool(actor.moveRight) and not gm.bool(actor.moveLeft) then
        if actorData.moveRight < 100 then
            actorData.moveRight = actorData.moveRight + 1
        end
    else
        if actorData.moveRight > 0 then
            actorData.moveRight = actorData.moveRight - 2
        end
    end

    if (actorData.moveRight > 90 or actorData.moveLeft > 90) and not actorData.buffed then
        actorData.buffed = true
        actor.pHmax = actor.pHmax + 0.7 * stack
    end
    if actorData.moveRight <= 90 and actorData.moveLeft <= 90 and actorData.buffed then
        actorData.buffed = false
        actor.pHmax = actor.pHmax - 0.7 * stack
    end
end)