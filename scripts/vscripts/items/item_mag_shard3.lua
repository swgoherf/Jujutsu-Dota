LinkLuaModifier( "modifier_item_mag_shard_res", "items/item_mag_shard3", LUA_MODIFIER_MOTION_NONE)

item_mag_shard3 = class({})

function item_mag_shard3:GetIntrinsicModifierName()
  return "modifier_item_mag_shard_res"
end

modifier_item_mag_shard_res = class({})

function modifier_item_mag_shard_res:IsHidden()
  return false
end

function modifier_item_mag_shard_res:DeclareFunctions()
  return {
    MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE 
  }
end

function modifier_item_mag_shard_res:GetModifierIncomingDamage_Percentage()
  return self:GetAbility():GetSpecialValueFor("res")
end
