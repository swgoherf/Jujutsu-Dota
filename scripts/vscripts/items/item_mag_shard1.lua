LinkLuaModifier( "modifier_item_mag_shard1", "items/item_mag_shard1", LUA_MODIFIER_MOTION_NONE)

item_mag_shard1 = class({})

function item_mag_shard1:GetIntrinsicModifierName()
  return "modifier_item_mag_shard1"
end

modifier_item_mag_shard1 = class({})

function modifier_item_mag_shard1:IsHidden()
  return true
end

function modifier_item_mag_shard1:DeclareFunctions()
  return {
    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
  }
end

function modifier_item_mag_shard1:GetModifierSpellAmplify_Percentage()
  return self:GetAbility():GetSpecialValueFor("damage_prc")
end
