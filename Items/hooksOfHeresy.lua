--[[
give_item OnyxExpansion-hooksOfHeresy
]] local hooksOfHeresy = Item.new(NAMESPACE, "hooksOfHeresy")
hooksOfHeresy:set_tier(TIER_BROKEN_UNCOMMON)
hooksOfHeresy:set_loot_tags(Item.LOOT_TAG.category_damage)
hooksOfHeresy:set_sprite(Resources.sprite_load(NAMESPACE, "hooksOfHeresy", PATH.."/Assets/Items/hooksOfHeresy.png", 1, 16, 16))

local slicingMaelstrom = Skill.new(NAMESPACE, "slicingMaelstrom")

local maelstrom = Object.new(NAMESPACE, "maelstrom")
-- Maelstrom:set_sprite(bulletSprite)
maelstrom:set_sprite(gm.constants.sGiantJellyBulletPurple)
maelstrom:set_depth(-1)

hooksOfHeresy:onAcquire(function(actor, stack)
    -- slicingMaelstrom.max_stock = 12 * stack
    slicingMaelstrom.cooldown = 180 * stack
    actor:add_skill_override(1, slicingMaelstrom)
end)

slicingMaelstrom:onActivate(function(actor)
    actor:get_data().hooksCharge = 1
end)

hooksOfHeresy:onPostStep(function(actor, stack)
    local actorData = actor:get_data()
    if gm.bool(actor.x_skill) and gm.bool(actorData.hooksCharge) and actorData.hooksCharge < 120 then
        actorData.hooksCharge = actorData.hooksCharge + 1
        actor:freeze_active_skill(1)
        return
    end
    if not gm.bool(actorData.hooksCharge) then
        return
    end

    local bulletData = maelstrom:create(actor.x, actor.y):get_data()
    bulletData.pH = actor.hold_facing_direction_xscale * actorData.hooksCharge * 0.05
    bulletData.parent = actor
    bulletData.cooldown = 0
    bulletData.lifetime = 300 * stack
    actorData.hooksCharge = 0
end)

maelstrom:onStep(function(bullet)
    local bulletData = bullet:get_data()
    bullet.x = bullet.x + bulletData.pH
    bulletData.pH = bulletData.pH * 0.98
    bulletData.lifetime = bulletData.lifetime - 1

    -- Actor collision
    if bulletData.cooldown == 0 then
        local actors = bullet:get_collisions(gm.constants.pActorCollisionBase)
        for _, actor in ipairs(actors) do
            if (actor.team and actor.team ~= bulletData.parent.team) or
                (actor.parent and actor.parent.team and actor.parent.team ~= bulletData.parent.team) then
                actor:apply_dot(1, bulletData.parent, 1, 1)
                -- self:sound_play_at(soundHit, 1.0, 1.0, self.x, self.y, nil)
            end
            bulletData.cooldown = 10
        end
    else
        bulletData.cooldown = bulletData.cooldown - 1
    end

    if bulletData.lifetime == 0 then
        bullet:destroy()
    end
end)
