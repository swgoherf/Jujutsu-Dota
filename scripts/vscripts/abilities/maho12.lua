LinkLuaModifier( "modifier_maho12", "abilities/maho12", LUA_MODIFIER_MOTION_NONE)

maho12 = class({})

function maho12:GetIntrinsicModifierName()
    return "modifier_maho12"
end

modifier_maho12 = class({})

function modifier_maho12:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
	}
end

function modifier_maho12:GetModifierConstantHealthRegen()
	return self:GetAbility():GetSpecialValueFor("regen")
end

function modifier_maho12:GetEffectName()
	return "particles/units/heroes/hero_sven/sven_spell_gods_strength.vpcf"
end