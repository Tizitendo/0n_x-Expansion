log.info("Successfully loaded " .. _ENV["!guid"] .. ".")
mods["RoRRModdingToolkit-RoRR_Modding_Toolkit"].auto(true)
PATH = _ENV["!plugins_mod_folder_path"]
NAMESPACE = "OnyxExpansion"
TIER_BROKEN_COMMON = 0
TIER_BROKEN_UNCOMMON = 0
TIER_BROKEN_RARE = 0
DISTORTION = 0

Initialize(function()
	local item_tiers = Global.item_tiers
	if #item_tiers == 7 then
		table.insert(item_tiers, gm.new_struct())
	end

	local treasure_loot_pools = Global.treasure_loot_pools
	if #treasure_loot_pools == 7 then
		local notier_pool = gm.new_struct()
		notier_pool.available_drop_pool = 118 + 2 * #treasure_loot_pools
		notier_pool.drop_pool = 117 + 2 * #treasure_loot_pools
		notier_pool.command_crate_object_id = 800 + #treasure_loot_pools
		table.insert(treasure_loot_pools, notier_pool)
	end

	--require("stageLoader")
    local folders = {
		"Misc",
		"Item_Tiers",
		"Elites",
        "Actors",
		"Objects",
		"Gameplay",
		"Items"
	}

    for _, folder in ipairs(folders) do
		-- NOTE: this includes filepaths within subdirectories of the above folders
		local filepaths = path.get_files(path.combine(PATH, folder))
		for _, filepath in ipairs(filepaths) do
			-- filter for files with the .lua extension, incase there's non-lua files
			if string.sub(filepath, -4, -1) == ".lua" then
				require(filepath)
			end
		end
	end
end)