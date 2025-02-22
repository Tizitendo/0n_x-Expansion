--[[
give_item OnyxExpansion-visionsOfHeresy
]] local visionsOfHeresy = Item.new(NAMESPACE, "visionsOfHeresy")
visionsOfHeresy:set_tier(TIER_BROKEN_COMMON)
visionsOfHeresy:set_loot_tags(Item.LOOT_TAG.category_damage)
visionsOfHeresy:set_sprite(Resources.sprite_load(NAMESPACE, "visionsOfHeresy", PATH.."/Assets/Items/visionsOfHeresy.png", 1, 16, 16))

local bulletSprite = Resources.sprite_load(NAMESPACE, "visionsBullet", PATH.."/Assets/Items/visionsBullet.png", 1, 16, 16)

local hungeringGaze = Skill.new(NAMESPACE, "hungeringGaze")
hungeringGaze.is_primary = true

local visionsBullet = Object.new(NAMESPACE, "visionsBullet")
visionsBullet:set_sprite(bulletSprite)
visionsBullet:set_depth(-1)

local attackSlow = false
visionsOfHeresy:onAcquire(function(actor, stack)
    hungeringGaze.max_stock = 12 * stack
    hungeringGaze.cooldown = 15 + 15 * stack
    actor:add_skill_override(0, hungeringGaze)
end)

visionsOfHeresy:onStatRecalc(function(actor, stack)
    attackSlow = false
end)

visionsOfHeresy:onPostStep(function(actor, stack)
    if hungeringGaze.required_stock ~= 1 then
        actor:freeze_active_skill(0)
        if not attackSlow and actor:is_grounded() then
            attackSlow = true
            actor.pHmax = actor.pHmax / 4.25
        end
    else
        if attackSlow then
            attackSlow = false
            actor.pHmax = actor.pHmax * 4.25
        end
    end
end)

hungeringGaze:onActivate(function(actor)
    local bulletInst = visionsBullet:create(actor.x, actor.y)
    local bulletData = bulletInst:get_data()
    bulletData.parent = actor
    bulletData.pH = actor.hold_facing_direction_xscale * 8
    bulletData.pV = 0
    hungeringGaze.required_stock = hungeringGaze.max_stock + 1

    local function myFunc()
        hungeringGaze.required_stock = 1
    end
    Alarm.create(myFunc, 15 / actor.attack_speed)
end)

visionsBullet:onStep(function(bullet)
    local bulletData = bullet:get_data()
    bullet.x = bullet.x + bulletData.pH
    bullet.y = bullet.y + bulletData.pV

    if bulletData.target == nil or bulletData.target == -4 or not bulletData.target:exists() then
        bulletData.target = bulletData.parent:find_target_nearest(bullet.x, bullet.y)
        return
    end

    local trajectoryX = bulletData.target.x - bullet.x
    local trajectoryY = bulletData.target.y - bullet.y
    local trajectoryLength = math.sqrt(trajectoryX^2 + trajectoryY^2)
    local normalisedX = trajectoryX / trajectoryLength
    local normalisedY = trajectoryY / trajectoryLength
    local trueLength = math.sqrt((normalisedX + bulletData.pH * 3)^2 + (normalisedY + bulletData.pV * 3)^2)
    bulletData.pH = (bulletData.pH * 3 + normalisedX) / trueLength * 8
    bulletData.pV = (bulletData.pV * 3 + normalisedY) / trueLength * 8

    -- Actor collision
    local actors = bullet:get_collisions(gm.constants.pActorCollisionBase)
    for _, actor in ipairs(actors) do
        if (actor.team and actor.team ~= bulletData.parent.team)
        or (actor.parent and actor.parent.team and actor.parent.team ~= bulletData.parent.team) then
            actor:apply_dot(1, bulletData.parent, 1, 1)
            bullet:destroy()
            -- self:sound_play_at(soundHit, 1.0, 1.0, self.x, self.y, nil)
            return
        end
    end

    if bullet:is_colliding(gm.constants.pSolidBulletCollision) then
        bullet:destroy()
        -- self:sound_play_at(soundHit, 1.0, 1.0 + gm.random_range(-0.1, 0.1), self.x, self.y, nil)
    end
end)

Callback.add(Callback.TYPE.onPlayerStep, "idjhdk", function(player)
    -- log.warning(player.pAccel)
end)