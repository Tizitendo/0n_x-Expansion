--[[
give_item OnyxExpansion-tungstenCube
]] 
local tungstenCube = Item.new(NAMESPACE, "tungstenCube")
tungstenCube:set_tier(TIER_BROKEN_COMMON)
tungstenCube:set_loot_tags(Item.LOOT_TAG.category_damage)
tungstenCube:set_sprite(Resources.sprite_load(NAMESPACE, "tungstenCube", PATH.."/Assets/Items/tungstenCube.png", 1, 15, 15))

tungstenCube:onAttackHit(function(actor, victim, stack, hit_info)
    if actor:is_grounded() then
        hit_info.damage = hit_info.damage * (0.30 * stack + 1)
    else
        hit_info.damage = hit_info.damage / (0.1 * stack + 1)
    end
end)