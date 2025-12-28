LinkLuaModifier( "modifier_item_mag_shard_true", "items/item_mag_shard_true", LUA_MODIFIER_MOTION_NONE )

item_mag_shard_true = {}

modifier_item_mag_shard_true = {}

function modifier_item_mag_shard_true:IsHidden()
	return false
end

function modifier_item_mag_shard_true:IsPurgable()
	return false
end

function modifier_item_mag_shard_true:RemoveOnDeath()
	return false
end

function modifier_item_mag_shard_true:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
end

function modifier_item_mag_shard_true:GetModifierSpellAmplify_Percentage()
	return 40
end

function modifier_item_mag_shard_true:GetModifierPreAttack_BonusDamage()
	return 100
end

function modifier_item_mag_shard_true:GetModifierIncomingDamage_Percentage()
	return -30
end

function item_mag_shard_true:OnSpellStart()
	local caster = self:GetCaster()

	local modif = caster:AddNewModifier(caster, self, "modifier_item_mag_shard_true", {})
	modif:IncrementStackCount()
	UTIL_Remove(self)
end

