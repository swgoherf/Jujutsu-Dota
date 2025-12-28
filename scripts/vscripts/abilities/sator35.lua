LinkLuaModifier( "modifier_sator35", "abilities/sator35", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_sator35_stun", "abilities/sator35", LUA_MODIFIER_MOTION_NONE)

sator35 = class({})

function sator35:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function sator35:OnSpellStart()
	local point = self:GetCursorPosition()

	CreateModifierThinker(self:GetCaster(), self, "modifier_sator35", { duration = self:GetSpecialValueFor("duration") }, point, self:GetCaster():GetTeamNumber(), false)
end

modifier_sator35 = class({})

function modifier_sator35:IsHidden()
	return false
end

function modifier_sator35:OnCreated()
	EmitGlobalSound("sator35")
	local radius = self:GetAbility():GetSpecialValueFor("radius")

	self.effect_cast = ParticleManager:CreateParticle( "particles/econ/items/underlord/underlord_ti8_immortal_weapon/underlord_ti8_immortal_pitofmalice_burst.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( radius, 0, 0 ) )

	self:StartIntervalThink(1)
end

function modifier_sator35:OnIntervalThink()
	local caster = self:GetCaster()
	local parent = self:GetParent()
	local radius = self:GetAbility():GetSpecialValueFor("radius")
	local allies = FindUnitsInRadius(caster:GetTeamNumber(), parent:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false)
    
    self.effect_cast = ParticleManager:CreateParticle( "particles/econ/items/underlord/underlord_ti8_immortal_weapon/underlord_ti8_immortal_pitofmalice_burst.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( radius, 0, 0 ) )

	for _, ally in pairs(allies) do
		ApplyDamage({
			victim = ally,
			attacker = caster,
			damage = self:GetAbility():GetSpecialValueFor("damage"),
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility()
		})

		ally:AddNewModifier(caster, self:GetAbility(), "modifier_sator35_stun", { duration = 1 } )
	end
end

modifier_sator35_stun = class({})

function modifier_sator35_stun:IsHidden()
	return false
end

function modifier_sator35_stun:IsPurgable()
	return true
end

function modifier_sator35_stun:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf"
end

function modifier_sator35_stun:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_sator35_stun:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
	}
	return state
end

function modifier_sator35_stun:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}
	return funcs
end

function modifier_sator35_stun:GetOverrideAnimation(params)
	return ACT_DOTA_DISABLED
end
