--[[
give_item OnyxExpansion-stridesOfHeresy
]] local stridesOfHeresy = Item.new(NAMESPACE, "stridesOfHeresy")
stridesOfHeresy:set_tier(TIER_BROKEN_COMMON)
stridesOfHeresy:set_loot_tags(Item.LOOT_TAG.category_damage)
stridesOfHeresy:set_sprite(Resources.sprite_load(NAMESPACE, "stridesOfHeresy", PATH.."/Assets/Items/stridesOfHeresy.png", 1, 16, 16))

local shadowFade = Skill.new(NAMESPACE, "shadowFade")
shadowFade.sprite = Resources.sprite_load(NAMESPACE, "shadowFadeSkill", PATH.."/Assets/Skills/shadowFade.png", 1, 0, 0)
-- shadowFade:set_skill_animation(gm.constants.sGiantJellyBulletPurple)
shadowFade:set_skill_animation(Resources.sprite_load(NAMESPACE, "shadowFadeState", PATH.."/Assets/States/shadowFade.png", 1, 14, 14))
local fadeState = State.new(NAMESPACE, "fadeState")

stridesOfHeresy:onAcquire(function(actor, stack)
    shadowFade.cooldown = 360 + 180 * stack
    actor:add_skill_override(2, shadowFade)
    actor:get_data("stridesOfHeresy").fadeTime = 180 * stack
end)

stridesOfHeresy:onRemove(function(actor, stack)
    if stack <= 1 then
        actor:remove_skill_override(2, shadowFade)
    end
end)

shadowFade:onActivate(function(actor)
    GM.actor_set_state(actor, fadeState)
    actor.hp_regen = actor.hp_regen + 0.1
end)

local function EndShadowFade(actor)
    actor:skill_util_reset_activity_state()
end
fadeState:onEnter(function(actor, data)
    actor.image_index = 0
    actor.pGravity2 = actor.pGravity2 * 0.5
    actor.pGravity1 = actor.pGravity1 * 0.5
    actor.intangible = true
    Alarm.create(EndShadowFade, actor:get_data("stridesOfHeresy").fadeTime, actor)
end)
fadeState:onStep(function(actor, data)
    actor:actor_animation_set(actor:actor_get_skill_animation(shadowFade), 0.1, false)--Change animation to skill 1

    if actor.pVspeed > 0 then
        actor.pVspeed = 0
    end
    actor.pHspeed = actor.pHspeed * 0.95
    if gm.bool(actor.moveLeft) then
        actor.pHspeed = actor.pHspeed - actor.pHmax * 0.06
    end
    if gm.bool(actor.moveRight) then
        actor.pHspeed = actor.pHspeed + actor.pHmax * 0.06
    end
    -- log.warning(actor:actor_get_current_actor_state())
end)
fadeState:onExit(function(actor, data)
    actor.intangible = false
    actor:recalculate_stats()
end)