local item_tiers = Global.item_tiers
local treasure_loot_pools = Global.treasure_loot_pools

-- Common
local brokenTier = gm.new_struct()
brokenTier.pickup_head_shape = nil
brokenTier.ignore_fair = false
brokenTier.equipment_pool_for_reroll = 0
brokenTier.item_pool_for_reroll = 0
brokenTier.pickup_color = 8721588
brokenTier.text_color = 'r'
brokenTier.index = #item_tiers
TIER_BROKEN_COMMON = #item_tiers
brokenTier.fair_item_value = 1
brokenTier.pickup_particle_type = -1
brokenTier.spawn_sound = 57
brokenTier.pickup_color_bright = 16777215
table.insert(item_tiers, brokenTier)

local broken_pool = gm.new_struct()
broken_pool.is_equipment_pool = false
-- broken_pool.available_drop_pool = 118 + 2 * #treasure_loot_pools
broken_pool.available_drop_pool = gm.ds_list_create()
broken_pool.index = TIER_BROKEN_COMMON
-- broken_pool.drop_pool = 117 + 2 * #treasure_loot_pools
broken_pool.drop_pool = gm.ds_list_create()
broken_pool.item_tier = TIER_BROKEN_COMMON
-- broken_pool.command_crate_object_id = 800 + #treasure_loot_pools
broken_pool.command_crate_object_id = gm.ds_list_create()
table.insert(treasure_loot_pools, broken_pool)

-- Uncommon
local brokenTier = gm.new_struct()
brokenTier.pickup_head_shape = nil
brokenTier.ignore_fair = false
brokenTier.equipment_pool_for_reroll = 0
brokenTier.item_pool_for_reroll = 0
brokenTier.pickup_color = 8721588
brokenTier.text_color = 'r'
brokenTier.index = #item_tiers
TIER_BROKEN_UNCOMMON = #item_tiers
brokenTier.fair_item_value = 1
brokenTier.pickup_particle_type = -1
brokenTier.spawn_sound = 57
brokenTier.pickup_color_bright = 16777215
table.insert(item_tiers, brokenTier)

local broken_pool = gm.new_struct()
broken_pool.is_equipment_pool = false
-- broken_pool.available_drop_pool = 118 + 2 * #treasure_loot_pools
broken_pool.available_drop_pool = gm.ds_list_create()
broken_pool.index = TIER_BROKEN_UNCOMMON
-- broken_pool.drop_pool = 117 + 2 * #treasure_loot_pools
broken_pool.drop_pool = gm.ds_list_create()
broken_pool.item_tier = TIER_BROKEN_UNCOMMON
-- broken_pool.command_crate_object_id = 800 + #treasure_loot_pools
broken_pool.command_crate_object_id = gm.ds_list_create()
table.insert(treasure_loot_pools, broken_pool)

-- Rare
local brokenTier = gm.new_struct()
brokenTier.pickup_head_shape = nil
brokenTier.ignore_fair = false
brokenTier.equipment_pool_for_reroll = 0
brokenTier.item_pool_for_reroll = 0
brokenTier.pickup_color = 8721588
brokenTier.text_color = 'r'
brokenTier.index = #item_tiers
TIER_BROKEN_RARE = #item_tiers
brokenTier.fair_item_value = 1
brokenTier.pickup_particle_type = -1
brokenTier.spawn_sound = 57
brokenTier.pickup_color_bright = 16777215
table.insert(item_tiers, brokenTier)

local broken_pool = gm.new_struct()
broken_pool.is_equipment_pool = false
-- broken_pool.available_drop_pool = 118 + 2 * #treasure_loot_pools
broken_pool.available_drop_pool = gm.ds_list_create()
broken_pool.index = TIER_BROKEN_RARE
-- broken_pool.drop_pool = 117 + 2 * #treasure_loot_pools
broken_pool.drop_pool = gm.ds_list_create()
broken_pool.item_tier = TIER_BROKEN_RARE
-- broken_pool.command_crate_object_id = 800 + #treasure_loot_pools
broken_pool.command_crate_object_id = gm.ds_list_create()
table.insert(treasure_loot_pools, broken_pool)