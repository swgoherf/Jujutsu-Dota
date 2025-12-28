function Spawn()
	if not thisEntity then return nil end

	thisEntity:SetContextThink("BossEvent", BossEvent, 1)
end

function BossEvent()
    local ability = thisEntity:FindAbilityByName("")

    if GameRules:State_Get() == DOTA_GAMERULES_STATE_POST_GAME or not thisEntity:IsAlive() then 
        return nil
    end

    if ability:IsFullyCastable() then
        local radius = ability:GetCastRange()
        local enemies = FindUnitsInRadius(thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)

        if #enemies > 0 then
            local target = enemies[1] 
            if target:GetHealth() <= 500 then
                ExecuteOrderFromTable({
                    UnitIndex = thisEntity:entindex(),
                    OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
                    TargetIndex = target:entindex(),
                    AbilityIndex = ability:entindex()
                })
            end
        end
    end

    return 0.2
end

