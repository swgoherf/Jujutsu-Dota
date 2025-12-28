LinkLuaModifier( "modifier_meg2", "abilities/meg2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_meg2_stun", "abilities/meg2", LUA_MODIFIER_MOTION_NONE)

meg2 = class({})

modifier_meg2 = class({})

function modifier_meg2:IsHidden()
	return false
end

function modifier_meg2:IsPurgable()
	return false
end

function modifier_meg2:IsDebuff()
	return true
end

function modifier_meg2:OnDestroy()
	local parent = self:GetParent()
	local caster = self:GetAbility():GetCaster()

	ApplyDamage( {
		victim = parent,
		attacker = caster,
		damage = self:GetAbility():GetSpecialValueFor("damage"),
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility()
	} )
end

modifier_meg2_stun = class({})

function modifier_meg2_stun:IsHidden()
	return false
end

function modifier_meg2_stun:IsPurgable()
	return false
end

function modifier_meg2_stun:IsDebuff()
	return true
end

function modifier_meg2_stun:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf"
end

function modifier_meg2_stun:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_meg2_stun:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
	}
	return state
end

function modifier_meg2_stun:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}
	return funcs
end

function modifier_meg2_stun:GetOverrideAnimation(params)
	return ACT_DOTA_DISABLED
end

function meg2:OnSpellStart()
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()

    EmitGlobalSound("kva")

    target:AddNewModifier(caster, self, "modifier_meg2_stun", { duration = 1.5 } )
    target:AddNewModifier(caster, self, "modifier_meg2", { duration = 0.01 } )
    
    if target and not target:IsMagicImmune() then
        local casterPosition = caster:GetAbsOrigin()
        local targetPosition = target:GetAbsOrigin()
        local direction = (casterPosition - targetPosition):Normalized()
        local pullDistance = -50
        local pullSpeed = 1000
        
        local endPosition = casterPosition + direction * pullDistance
        
        target:SetContextThink("PullToCaster", function()
            if target and not target:IsNull() and not target:IsAlive() then
                return nil
            end
            
            local currentTargetPosition = target:GetAbsOrigin()
            local distance = (endPosition - currentTargetPosition):Length2D()
            
            if distance <= pullSpeed * FrameTime() then
                target:SetAbsOrigin(endPosition)
                return nil
            else
                local newPosition = currentTargetPosition + direction * pullSpeed * FrameTime()
                target:SetAbsOrigin(newPosition)
                return FrameTime()
            end
        end, 0)

        local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_pudge/pudge_meathook.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
        ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)

        Timers:CreateTimer(1.5, function()
            ParticleManager:DestroyParticle(particle, false)
            ParticleManager:ReleaseParticleIndex(particle)
        end)
    end
end
