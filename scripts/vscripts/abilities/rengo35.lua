LinkLuaModifier( "modifier_rengo35", "abilities/rengo35", LUA_MODIFIER_MOTION_NONE)

rengo35 = class({})

function rengo35:GetIntrinsicModifierName()
    return "modifier_rengo35"
end

modifier_rengo35 = class({})

function modifier_rengo35:IsHidden()
	return true
end

function modifier_rengo35:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	}
end

function modifier_rengo35:GetModifierMoveSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("ms")
end

function modifier_rengo35:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("damage")
end

function modifier_rengo35:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("stats")
end

function modifier_rengo35:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("stats")
end

function modifier_rengo35:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("stats")
end

function modifier_rengo35:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("as")
end

