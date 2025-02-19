
local preventAiInput = Object.new(NAMESPACE, "preventAiInput", Object.PARENT.actor)
preventAiInput.obj_sprite = Resources.sprite_load(NAMESPACE, "Empty", path.combine(PATH.."/Assets/Objects", "empty.png"), 1, 0, 0)
--preventAiInput.obj_depth = 11 -- depth of vanilla pEnemyClassic objects

-- Object.find("ror-lizard"):onStep(function(inst)
--     inst.moveLeft = 0
-- end)

preventAiInput:onStep(function(inst)
    local idk, bool = inst:get_collisions(Object.find("ror-P"))
    --Helper.log_struct(inst)
    inst.intangible = true
    
    local lems, bool = inst:get_collisions(Object.find("ror-lizard"))
    for i, collider in ipairs(lems) do
        if inst.blockMoveLeft then
            collider.moveLeft = 0
        end
        if inst.blockMoveRight then
            collider.moveRight = 0
        end
        if inst.blockRopeUp then
            collider.ropeUp = 0
        end
        if inst.blockRopeDown then
            collider.ropeDown = 0
        end
        if inst.forceMoveLeft then
            collider.moveLeft = 1
        end
        if inst.forceMoveRight then
            collider.moveRight = 1
        end
        if inst.forceRopeUp then
            collider.ropeUp = 1
        end
        if inst.forceRopeDown then
            collider.ropeDown = 1
        end
        log.warning(collider)
        Helper.log_struct(collider)
    end

    -- if inst:is_colliding(Object.find("ror-lizard")) then
    --     Helper.log_struct()
    -- end
end)
