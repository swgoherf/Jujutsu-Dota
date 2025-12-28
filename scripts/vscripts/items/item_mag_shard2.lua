LinkLuaModifier( "modifier_item_mag_shard_att", "items/item_mag_shard2", LUA_MODIFIER_MOTION_NONE)

item_mag_shard2 = class({})

function item_mag_shard2:GetIntrinsicModifierName()
  return "modifier_item_mag_shard_att"
end

modifier_item_mag_shard_att = class({})

function modifier_item_mag_shard_att:IsHidden()
  return false
end

function modifier_item_mag_shard_att:DeclareFunctions()
  return {
    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
  }
end

function modifier_item_mag_shard_att:GetModifierPreAttack_BonusDamage()
  return self:GetAbility():GetSpecialValueFor("damage")
end
