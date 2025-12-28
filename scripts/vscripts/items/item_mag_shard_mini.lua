LinkLuaModifier( "modifier_item_mag_shard_mini", "items/item_mag_shard_mini", LUA_MODIFIER_MOTION_NONE)

item_mag_shard_mini = class({})

function item_mag_shard_mini:GetIntrinsicModifierName()
	return "modifier_item_mag_shard_mini"
end

modifier_item_mag_shard_mini = class({})

function modifier_item_mag_shard_mini:IsHidden()
  return true
end

function modifier_item_mag_shard_mini:DeclareFunctions()
  return {
    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
  }
end

function modifier_item_mag_shard_mini:GetModifierSpellAmplify_Percentage()
	return self:GetAbility():GetSpecialValueFor("damage_prc")
end