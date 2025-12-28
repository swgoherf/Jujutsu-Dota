LinkLuaModifier( "modifier_sykyna35", "abilities/sykyna35", LUA_MODIFIER_MOTION_NONE)

sykyna35 = class({})

function sykyna35:GetIntrinsicModifierName()
    return "modifier_sykyna35"
end

modifier_sykyna35 = class({})

function modifier_sykyna35:IsHidenn()
	return true
end

function modifier_sykyna35:IsPurgable()
	return false
end

function modifier_sykyna35:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
	}
end

function modifier_sykyna35:GetModifierHealthBonus()
	return self:GetAbility():GetSpecialValueFor("hp")
end

function modifier_sykyna35:GetModifierMoveSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("ms")
end

function modifier_sykyna35:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("armor")
end

function modifier_sykyna35:GetModifierMagicalResistanceBonus()
	return self:GetAbility():GetSpecialValueFor("mag_res")
end

function modifier_sykyna35:GetModifierSpellAmplify_Percentage()
	return self:GetAbility():GetSpecialValueFor("mag_dmg")
end

