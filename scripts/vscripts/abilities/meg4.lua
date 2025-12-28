LinkLuaModifier( "modifier_meg4", "abilities/meg4", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_meg4_kill", "abilities/meg4", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_meg4_damage", "abilities/meg4", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_meg4_stun", "abilities/meg4", LUA_MODIFIER_MOTION_NONE)

meg4 = class({})

function meg4:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function meg4:OnSpellStart()
	local point = self:GetCursorPosition()
	local caster = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius")
	local level = self:GetLevel()

	EmitGlobalSound("meg4")

	if level == 1 then 
		local unit = CreateUnitByName("npc_dota_neutral_mahorag1", point, true, caster, caster, caster:GetTeamNumber())
	    unit:SetControllableByPlayer(caster:GetPlayerID(), true)

	    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_lion/lion_spell_voodoo.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
	    ParticleManager:SetParticleControl(particle, 0, unit:GetAbsOrigin())

	    unit:AddNewModifier(caster, self, "modifier_meg4_kill", {duration = self:GetSpecialValueFor("duration")})
	elseif level == 2 then
		local unit = CreateUnitByName("npc_dota_neutral_mahorag2", point, true, caster, caster, caster:GetTeamNumber())
	    unit:SetControllableByPlayer(caster:GetPlayerID(), true)

	    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_lion/lion_spell_voodoo.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
	    ParticleManager:SetParticleControl(particle, 0, unit:GetAbsOrigin())

	    unit:AddNewModifier(caster, self, "modifier_meg4_kill", {duration = self:GetSpecialValueFor("duration")})
	else
		local unit = CreateUnitByName("npc_dota_neutral_mahorag3", point, true, caster, caster, caster:GetTeamNumber())
	    unit:SetControllableByPlayer(caster:GetPlayerID(), true)

	    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_lion/lion_spell_voodoo.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
	    ParticleManager:SetParticleControl(particle, 0, unit:GetAbsOrigin())

	    unit:AddNewModifier(caster, self, "modifier_meg4_kill", {duration = self:GetSpecialValueFor("duration")})
	end

	CreateModifierThinker(caster, self, "modifier_meg4", { duration = 0.1 }, point, caster:GetTeamNumber(), false)
end


modifier_meg4 = class({})

function modifier_meg4:IsHidden()
	return false
end

modifier_meg4_stun = class({})

function modifier_meg4_stun:IsHidden()
	return false
end

function modifier_meg4_stun:IsPurgable()
	return true
end

function modifier_meg4_stun:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf"
end

function modifier_meg4_stun:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_meg4_stun:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
	}
	return state
end

function modifier_meg4_stun:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}
	return funcs
end

function modifier_meg4_stun:GetOverrideAnimation(params)
	return ACT_DOTA_DISABLED
end

function modifier_meg4:OnCreated()
	self:StartIntervalThink(0.1)
end

function modifier_meg4:OnIntervalThink()
	local caster = self:GetCaster()
	local parent = self:GetParent()
	local radius = self:GetAbility():GetSpecialValueFor("radius")
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), parent:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false)

	for _, enemy in pairs(enemies) do
		enemy:AddNewModifier(caster, self:GetAbility(), "modifier_meg4_damage", { duration = self:GetAbility():GetSpecialValueFor("stun") } )
		enemy:AddNewModifier(caster, self:GetAbility(), "modifier_meg4_stun", { duration = self:GetAbility():GetSpecialValueFor("stun") } )
	end
end

modifier_meg4_damage = class({})

function modifier_meg4_damage:IsHidden()
	return false
end

function modifier_meg4_damage:OnDestroy()
	local parent = self:GetParent()
	local damage = {
					victim = parent,
					attacker = parent,
					damage = self:GetAbility():GetSpecialValueFor("damage"),
					damage_type = DAMAGE_TYPE_PURE,
					ability = self:GetAbility()
				}

	ApplyDamage(damage)
end

modifier_meg4_kill = class({})

function modifier_meg4_kill:IsHidden()
	return false
end

function modifier_meg4_kill:IsPurgable()
	return false
end

function modifier_meg4_kill:IsServer()
	return true
end

function modifier_meg4_kill:OnDestroy()
	local parent = self:GetParent()
	local damage = {
					victim = parent,
					attacker = parent,
					damage = 100000,
					damage_type = DAMAGE_TYPE_PURE,
					ability = self:GetAbility()
				}

	ApplyDamage(damage)
end
