--[[
give_item OnyxExpansion-tungstenCube
]] local tungstenCube = Item.new(NAMESPACE, "tungstenCube")
tungstenCube:set_tier(TIER_BROKEN_COMMON)
tungstenCube:set_loot_tags(Item.LOOT_TAG.category_damage)
tungstenCube:set_sprite(Resources.sprite_load(NAMESPACE, "tungstenCube", PATH .. "/Assets/Items/tungstenCube.png", 1,
    15, 15))
local groundedColor = Color.from_rgb(217, 174, 129)
local airborneColor = Color.from_rgb(200, 12, 12)

tungstenCube:onAttackHit(function(actor, victim, stack, hit_info)
    local attack_info = hit_info.attack_info
    if actor:is_grounded() then
        hit_info.damage = hit_info.damage * (0.30 * stack + 1)
        gm.draw_damage_networked(victim.x, victim.bbox_top + 2,
            math.ceil(attack_info.damage * (0.30 * stack + 1) - attack_info.damage), attack_info.critical,
            groundedColor, attack_info.team, attack_info.climb)
    else
        hit_info.damage = hit_info.damage / (0.15 * stack + 1)
        gm.draw_damage_networked(victim.x, victim.bbox_top + 2,
            math.ceil(attack_info.damage * (0.15 * stack + 1) - attack_info.damage), attack_info.critical,
            airborneColor, attack_info.team, attack_info.climb)
    end
end)
