LinkLuaModifier( "modifier_maho13", "abilities/maho13", LUA_MODIFIER_MOTION_NONE)

maho13 = class({})

function maho13:GetIntrinsicModifierName()
    return "modifier_maho13"
end

modifier_maho13 = class({})

function modifier_maho13:DeclareFunctions()
     return {
          MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
     }
end

function modifier_maho13:GetModifierConstantHealthRegen()
     return self:GetAbility():GetSpecialValueFor("regen")
end

function modifier_maho13:GetEffectName()
     return "particles/units/heroes/hero_sven/sven_spell_gods_strength.vpcf"
end