local SPRITE_PATH = path.combine(PATH, "Assets/Elites/Illusion")

local sprite_icon = Resources.sprite_load(NAMESPACE, "EliteIconIllusion", path.combine(SPRITE_PATH, "icon.png"), 1, 14, 10)
local sprite_palette = Resources.sprite_load(NAMESPACE, "ElitePaletteIllusion", path.combine(SPRITE_PATH, "palette.png"))

local eliteElusive = Elite.new(NAMESPACE, "illusion")
eliteElusive.healthbar_icon = sprite_icon
eliteElusive.palette = sprite_palette
eliteElusive.blend_col = Color.AQUA

local itemEliteOrbIllusion = Item.new(NAMESPACE, "eliteOrbIllusion", true)
itemEliteOrbIllusion.is_hidden = true

eliteElusive:onApply(function(actor)
    actor:item_give(itemEliteOrbIllusion)
    actor:get_data().lifeTimer = 1200
    actor.activity = 0
    actor.is_update_enabled = true
end)

local destroyList = {}
itemEliteOrbIllusion:onPostStep(function(actor, stack)
    if gm._mod_net_isClient() then
        return
    end
    actor.intangible = 1
    actor.damage_base = 0
    actor.damage = 0

    local actordata = actor:get_data()
    actordata.lifeTimer = actordata.lifeTimer - 1
    if actordata.lifeTimer == 0 then
        table.insert(destroyList, actor)
        --actor:destroy()
    end
end)

itemEliteOrbIllusion:onAttackHit(function(actor, victim, stack, hit_info)
    hit_info.damage = 0
end)


Callback.add("postStep", NAMESPACE.."Illusion-postStep", function()
    for i = #destroyList, 1, -1 do
        destroyList[i]:destroy()
        table.remove(destroyList, i)
    end
end)

itemEliteOrbIllusion:onPostStatRecalc(function(actor, stack)
    actor.intangible = 1
    actor.damage_base = 0
    actor.damage = 0
    if math.random(1, 2) == 2 then
        actor.pHmax_raw = actor.pHmax_raw * 1.3
        actor.pHmax = actor.pHmax * 1.3
    else
        actor.pHmax_raw = actor.pHmax_raw / 1.3
        actor.pHmax = actor.pHmax / 1.3
    end
end)
