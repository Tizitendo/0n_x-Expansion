
function GetRandomItem(tier, loot_tag)
    local itemList = Item.find_all(NAMESPACE)
    if loot_tag ~= nil then
        for i = #itemList, 1, -1 do
            if (itemList[i].loot_tags & loot_tag) == 0 then
                table.remove(itemList, i)
            end
        end
    end
    if tier ~= nil then
        for i = #itemList, 1, -1 do
            if itemList[i].tier ~= tier then
                table.remove(itemList, i)
            end
        end
    end
    return itemList[gm.irandom_range(1, #itemList)]
end