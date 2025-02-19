--[[
give_item OnyxExpansion-tinkerKit
]] 

local tinkerKit = Item.new(NAMESPACE, "tinkerKit")
tinkerKit:set_tier(TIER_BROKEN_RARE)
tinkerKit:set_loot_tags(Item.LOOT_TAG.category_utility)
tinkerKit:set_sprite(Resources.sprite_load(NAMESPACE, "tinkerKit", PATH.."/Assets/Items/tinkerKit.png", 1, 15, 15))

tinkerKit:onStageStart(function(actor, stack)
    local item_order_copy = {}
    for k, v in ipairs(actor.inventory_item_order) do
        table.insert(item_order_copy, v)
    end
    
    local randomInvItem = nil
    --log.warning(#item_order_copy > 1 and randomInvItem.tier > 2)
    while (randomInvItem == nil or randomInvItem.tier > 2) and #item_order_copy > 1 do
        local randomInvSlot = math.random(1, #item_order_copy)
        randomInvItem = Item.wrap(item_order_copy[randomInvSlot])
        table.remove(item_order_copy, randomInvSlot)
    end
    if randomInvItem ~= nil then
        for i = 1, stack + 1 do
            actor:item_give(GetRandomItem(TIER_BROKEN_COMMON + randomInvItem.tier))
        end
        actor:item_remove(randomInvItem)
    end
end)