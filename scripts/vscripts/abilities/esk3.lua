LinkLuaModifier( "modifier_esk3_debuff", "abilities/esk3", LUA_MODIFIER_MOTION_NONE)

esk3 = class{}

function esk3:OnSpellStart()
	local target = self:GetCursorTarget()

	target:AddNewModifier(self:GetCaster(), self, "modifier_esk3_debuff", { duration = self:GetSpecialValueFor("duration") })
end

modifier_esk3_debuff = class{}

function modifier_esk3_debuff:IsHidden()
	return false
end

function modifier_esk3_debuff:IsPurgable()
	return false
end

function modifier_esk3_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
end

function modifier_esk3_debuff:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("armor")
end

function modifier_esk3_debuff:GetModifierMoveSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("move")
end

function modifier_esk3_debuff:OnCreated()
	self:StartIntervalThink(1)
	EmitGlobalSound("esk3")
end

function modifier_esk3_debuff:GetEffectName()
    return "particles/units/heroes/hero_ogre_magi/ogre_magi_ignite_debuff.vpcf"
end

function modifier_esk3_debuff:OnIntervalThink()
    local damage = {
        victim = self:GetParent(),
        attacker = self:GetCaster(),
        damage = self:GetAbility():GetSpecialValueFor("damage_bonus"),
        damage_type = DAMAGE_TYPE_MAGICAL,
        ability = self:GetAbility()
        }
    ApplyDamage(damage)
end