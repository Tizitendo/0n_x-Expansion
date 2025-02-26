--[[
give_item OnyxExpansion-visionsOfHeresy
]] local visionsOfHeresy = Item.new(NAMESPACE, "visionsOfHeresy")
visionsOfHeresy:set_tier(TIER_BROKEN_COMMON)
visionsOfHeresy:set_loot_tags(Item.LOOT_TAG.category_damage)
visionsOfHeresy:set_sprite(Resources.sprite_load(NAMESPACE, "visionsOfHeresy",
    PATH .. "/Assets/Items/visionsOfHeresy.png", 1, 16, 16))

local bulletSprite = Resources.sprite_load(NAMESPACE, "visionsBullet", PATH .. "/Assets/Items/visionsBullet.png", 1, 16,
    16)

local hungeringGaze = Skill.new(NAMESPACE, "hungeringGaze")
hungeringGaze.sprite = Resources.sprite_load(NAMESPACE, "hungeringGazeSkill", PATH.."/Assets/Skills/hungeringGaze.png", 1, 0, 0)
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

visionsOfHeresy:onRemove(function(actor, stack)
    if stack <= 1 then
        actor:remove_skill_override(0, hungeringGaze)
    end
end)

visionsOfHeresy:onStatRecalc(function(actor, stack)
    attackSlow = false
end)

visionsOfHeresy:onPostStep(function(actor, stack)
    if hungeringGaze.required_stock ~= 1 then
        actor:freeze_active_skill(0)
        if not attackSlow and actor:is_grounded() then
            attackSlow = true
            -- actor.pHmax = actor.pHmax / 4.25 / actor.walk_speed_coeff + actor.pHmax
            -- actor.walk_speed_coeff = 1/((1/actor.walk_speed_coeff) + 4.25)

            actor.pHmax = actor.pHmax - actor.pHmax_base * 0.75
        end
    else
        if attackSlow then
            attackSlow = false
            -- actor.walk_speed_coeff = 1/((1/actor.walk_speed_coeff) - 4.25)
            -- actor.pHmax = actor.pHmax * 4.25 * actor.walk_speed_coeff + actor.pHmax
            actor.pHmax = actor.pHmax + actor.pHmax_base * 0.75
        end
    end
end)

local function ResetSlow()
    hungeringGaze.required_stock = 1
end
hungeringGaze:onActivate(function(actor)
    if actor:is_authority() then
        -- this needs to be done, otherwise actor.hold_facing_direction_xscale sometimes gets read as a bool
        actor.hold_facing_direction_xscale = gm.int64(actor.hold_facing_direction_xscale)
        if not GM.skill_util_update_heaven_cracker(actor, damage, actor.image_xscale) then
            local buff_shadow_clone = Buff.find("ror", "shadowClone")
            for i = 0, actor:buff_stack_count(buff_shadow_clone) do
                local bulletInst = visionsBullet:create(actor.x + 12 - i * actor.hold_facing_direction_xscale * 3 + actor.hold_facing_direction_xscale * 10, actor.y + 10)
                local bulletData = bulletInst:get_data()
                bulletData.parent = actor
                bulletData.pH = actor.hold_facing_direction_xscale * 8
                bulletData.pV = 0
            end
        end
    end
    hungeringGaze.required_stock = hungeringGaze.max_stock + 1
    Alarm.create(ResetSlow, math.max(15 / actor.attack_speed, 1))
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
    local trajectoryLength = math.sqrt(trajectoryX ^ 2 + trajectoryY ^ 2)
    local normalisedX = trajectoryX / trajectoryLength
    local normalisedY = trajectoryY / trajectoryLength
    local trueLength = math.sqrt((normalisedX + bulletData.pH * 3) ^ 2 + (normalisedY + bulletData.pV * 3) ^ 2)
    bulletData.pH = (bulletData.pH * 3 + normalisedX) / trueLength * 8
    bulletData.pV = (bulletData.pV * 3 + normalisedY) / trueLength * 8

    -- Actor collision
    local actors = bullet:get_collisions(gm.constants.pBulletActorCollisionBase)
    for _, actor in ipairs(actors) do
        if (actor.team and actor.team ~= bulletData.parent.team) or (actor.parent and actor.parent.team and actor.parent.team ~= bulletData.parent.team) then
            bulletData.parent:fire_explosion(bullet.x - 10, bullet.y - 10, 10, 10, 1.2)
            bullet:destroy()
            return
        end
    end

    if bullet:is_colliding(gm.constants.pSolidBulletCollision) then
        bullet:destroy()
        -- self:sound_play_at(soundHit, 1.0, 1.0 + gm.random_range(-0.1, 0.1), self.x, self.y, nil)
    end
end)
