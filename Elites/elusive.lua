local SPRITE_PATH = path.combine(PATH, "Assets/Elites/Elusive")

local sprite_icon = Resources.sprite_load(NAMESPACE, "EliteIconElusive", path.combine(SPRITE_PATH, "icon.png"), 1, 14,
    10)
local sprite_palette = Resources.sprite_load(NAMESPACE, "ElitePaletteElusive", path.combine(SPRITE_PATH, "palette.png"))
local eliteElusive = Elite.new(NAMESPACE, "elusive")
eliteElusive.healthbar_icon = sprite_icon
eliteElusive.palette = sprite_palette
eliteElusive.blend_col = Color.AQUA

GM.elite_generate_palettes()

local itemEliteOrbElusive = Item.new(NAMESPACE, "eliteOrbElusive", true)
itemEliteOrbElusive.is_hidden = true

eliteElusive:onApply(function(actor)
    actor:item_give(itemEliteOrbElusive)
    actor:get_data().IllusionTimer = 300
    actor.damage_base = actor.damage_base * 1.5
end)

itemEliteOrbElusive:onPreStep(function(actor, stack)
    local actordata = actor:get_data()
    actordata.IllusionTimer = actordata.IllusionTimer - 1
    if actordata.IllusionTimer == 0 then
        actordata.IllusionTimer = 600
        local Illusion
        if actor:get_object_index_self() ~= gm.constants.oP then
            Illusion = Object.wrap(actor:get_object_index_self()):create(actor.x, actor.y)
            -- local target = Object.wrap(gm.constants.oActorTargetEnemy):create(actor.x, actor.y)
            -- target.parent = Illusion
        else
            local umbras = {gm.constants.oUmbraA, gm.constants.oUmbraB, gm.constants.oUmbraC, gm.constants.oUmbraD}
            Illusion = Object.wrap(umbras[math.random(1, 4)]):create(actor.x, actor.y)
            Illusion.team = 1.0
            -- local target = Object.wrap(gm.constants.oActorTargetPlayer):create(actor.x, actor.y)
            -- target.parent = Illusion
        end
        GM.elite_set(Illusion, Elite.find(NAMESPACE, "illusion"))
    end
end)

-- gm.post_script_hook(gm.constants.enemy_stats_init, function(self, other, result, args)
--     local function myFunc(self)
--         self.hp = 10
--     end
--     local function myFunc2(self)
--         if self.elite_type == -1 then
--             GM.elite_set(self, eliteElusive)
--             Alarm.create(myFunc, 10, self)
--         end
--     end
--     Alarm.create(myFunc2, 10, self)
-- end)

--gimme ChildG

local BeatProvidence = false
gm.post_script_hook(gm.constants.enemy_stats_init, function(self, other, result, args)
    if (self.object_index == gm.constants.oBoss1 or self.object_index == gm.constants.oBoss3 or self.object_index ==
        gm.constants.oBoss4) and BeatProvidence then
        local function SetElite(self)
            if self.elite_type == -1 then
                GM.elite_set(self, eliteElusive)
            end
        end
        Alarm.create(SetElite, 10, self)
    end
    if self.object_index == gm.constants.oBoss4 then
        BeatProvidence = true
        self.dropPortal = true
    end

    if self.object_index == gm.constants.oBoss4 then
        local provi = Instance.find_all(gm.constants.oBoss4)
        for i = 2, #provi do
            GM.elite_set(provi[i], Elite.find(NAMESPACE, "illusion"))
        end
    end
end)

Callback.add(Callback.TYPE.onGameStart, NAMESPACE .. "elusive-onGameStart", function()
    BeatProvidence = false
end)

local all_monster_cards = Monster_Card.find_all()
for i, card in ipairs(all_monster_cards) do
    local elite_list = List.wrap(card.elite_list)
    if not elite_list:contains(eliteElusive) then
        elite_list:add(eliteElusive)
    end
end
