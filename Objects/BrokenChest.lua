local sparkParticle = Particle.find("ror", "Spark")
local brokenChests = {}

local function SparkChest(chest)
    if chest:exists() and chest.active == 0 then
        sparkParticle:create(chest.x, chest.y - 20, math.random(1, 6))
        Alarm.create(SparkChest, math.random(30, 180), chest)
    end
end

Callback.add(Callback.TYPE.onStageStart, NAMESPACE .. "BrokenChest-onStageStart", function()
    brokenChests = {}
    local function WaitForInit()
        -- local chests = Instance.find_all(Instance.chests)
        local chests = Instance.find_all({gm.constants.oChest1, gm.constants.oChest2})
        --local numChests = math.random(0, #chests)
        -- local numChests = #chests
        for i = 1, #chests do
            if math.random(1, 20) <= 2 + DISTORTION then
                local randomChest = math.random(1, #chests)
                chests[randomChest]:get_data().broken = true
                -- chests[randomChest]:get_data().sparkTimer = math.random(30, 180)
                Alarm.create(SparkChest, math.random(30, 180), chests[randomChest])
                chests[randomChest].skip_loot = true
                chests[randomChest].open_delay = 0
                table.insert(brokenChests, chests[randomChest])
                table.remove(chests, randomChest)
            end
        end
    end
    Alarm.create(WaitForInit, 1)
end)

Callback.add(Callback.TYPE.onStep, NAMESPACE .. "BrokenChest-onStep", function()
    for _, chest in ipairs(brokenChests) do
        -- local chestData = chest:get_data()
        -- chestData.sparkTimer = chestData.sparkTimer - 1
        -- if chest:get_data().sparkTimer == 0 then
        --     chestData.sparkTimer = math.random(30, 180)
        --     sparkParticle:create(chest.x, chest.y - 20, math.random(1, 6))
        -- end

        if chest.active == 2 then
            chest.active = 3

            local dropItem = nil
            if chest.object_index == gm.constants.oChest1 then
                local randomnum = math.random(1, 100)
                if randomnum <= 2 then
                    -- dropItem = GetRandomItem(TIER_BROKEN_RARE)
                    dropItem = Item.get_random(TIER_BROKEN_RARE)
                elseif randomnum <= 16 then
                    -- dropItem = GetRandomItem(TIER_BROKEN_UNCOMMON)
                    dropItem = Item.get_random(TIER_BROKEN_UNCOMMON)
                else
                    -- dropItem = GetRandomItem(TIER_BROKEN_COMMON)
                    dropItem = Item.get_random(TIER_BROKEN_COMMON)
                end
            end
            if chest.object_index == gm.constants.oChest2 then
                local randomnum = math.random(1, 100)
                if randomnum <= 20 then
                    -- dropItem = GetRandomItem(TIER_BROKEN_RARE)
                    dropItem = Item.get_random(TIER_BROKEN_RARE)
                else
                    -- dropItem = GetRandomItem(TIER_BROKEN_UNCOMMON)
                    dropItem = Item.get_random(TIER_BROKEN_UNCOMMON)
                end
            end
            Object.find(dropItem.namespace, dropItem.identifier):create(chest.x, chest.y - 30)
        end
    end
end)
