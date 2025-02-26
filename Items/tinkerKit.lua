--[[
give_item OnyxExpansion-tinkerKit
]] local tinkerKit = Item.new(NAMESPACE, "tinkerKit")
tinkerKit:set_tier(TIER_BROKEN_RARE)
tinkerKit:set_loot_tags(Item.LOOT_TAG.category_utility)
tinkerKit:set_sprite(Resources.sprite_load(NAMESPACE, "tinkerKit", PATH .. "/Assets/Items/tinkerKit.png", 1, 15, 15))

tinkerKit:onStageStart(function(actor, stack)
    local item_order_copy = {}
    for k, v in ipairs(actor.inventory_item_order) do
        table.insert(item_order_copy, v)
    end

    local randomInvItem = nil
    for i = 1, stack do
        local randomInvSlot = nil
        randomInvItem = nil
        while (randomInvItem == nil or randomInvItem.tier > 2) and #item_order_copy > 0 do
            randomInvSlot = math.random(1, #item_order_copy)
            randomInvItem = Item.wrap(item_order_copy[randomInvSlot])
            table.remove(item_order_copy, randomInvSlot)
        end
        table.remove(item_order_copy, randomInvSlot)
        if randomInvItem ~= nil and randomInvItem.tier <= 2 then
            -- (player, name, description, sprite_id, ?, border color, ?, temporary, box thing?)
            GM._mod_game_getHUD():add_item_pickup_display_for_player_gml_Object_oHUD_Create_0(actor, "<r>" ..
                Language.translate_token(randomInvItem.token_name), Language.translate_token(randomInvItem.token_text),
                randomInvItem.sprite_id, 0, 10, 0, 0, false)
            actor:item_remove(randomInvItem)
            Object.wrap(Item.get_random(TIER_BROKEN_COMMON + randomInvItem.tier).object_id):create(actor.x, actor.y)
        end
    end
end)