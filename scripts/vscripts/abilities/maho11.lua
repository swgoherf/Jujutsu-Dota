LinkLuaModifier( "modifier_maho11", "abilities/maho11", LUA_MODIFIER_MOTION_NONE)

maho11 = class({})

function maho11:GetIntrinsicModifierName()
    return "modifier_maho11"
end

modifier_maho11 = class({})

function modifier_maho11:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
	}
end

function modifier_maho11:GetModifierConstantHealthRegen()
	return self:GetAbility():GetSpecialValueFor("regen")
end

function modifier_maho11:GetEffectName()
	return "particles/units/heroes/hero_sven/sven_spell_gods_strength.vpcf"
end