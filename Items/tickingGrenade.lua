--[[
give_item OnyxExpansion-tickingGrenade
]] 

local tickingGrenade = Item.new(NAMESPACE, "tickingGrenade")
tickingGrenade:set_tier(TIER_BROKEN_UNCOMMON)
tickingGrenade:set_loot_tags(Item.LOOT_TAG.category_damage)
tickingGrenade:set_sprite(Resources.sprite_load(NAMESPACE, "tickingGrenade", PATH.."/Assets/Items/tickingGrenade.png", 1, 15, 15))

local grenade = Object.new("ror", "EfGrenadeEnemy")

tickingGrenade:onHitProc(function(actor, victim, stack, hit_info)
    if math.random(1, 20) <= 1 then
        local spawnedGrenade = grenade:create(actor.x, actor.y)
        spawnedGrenade.team = 0
        spawnedGrenade.damage = actor.damage * stack * 5
        spawnedGrenade.parent = actor
        spawnedGrenade.bounces = -1
    end
end)

tickingGrenade:onAttackHit(function(actor, victim, stack, hit_info)
    if actor.team == victim.team then
        hit_info.damage = hit_info.damage / 2
    end
end)