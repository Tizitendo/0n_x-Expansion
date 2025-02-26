local toxicSymbiote = Item.new(NAMESPACE, "toxicSymbiote")
toxicSymbiote:set_tier(TIER_BROKEN_COMMON)
toxicSymbiote:set_loot_tags(Item.LOOT_TAG.category_healing)
toxicSymbiote:set_sprite(Resources.sprite_load(NAMESPACE, "toxicSymbiote", PATH.."/Assets/Items/toxicSymbiote.png", 1, 15, 15))

toxicSymbiote:onStatRecalc(function(actor, stack)
    actor.attack_speed = actor.attack_speed + 0.3
    actor.hp_regen = actor.hp_regen - 0.015 * stack
end)