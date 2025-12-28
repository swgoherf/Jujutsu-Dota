LinkLuaModifier( "modifier_heal_spell", "abilities/heal_spell", LUA_MODIFIER_MOTION_NONE)

heal_spell = class{}

modifier_heal_spell = class{}

function modifier_heal_spell:IsHidden()
	return false
end

function modifier_heal_spell:IsPurgable()
	return false
end

function modifier_heal_spell:GetEffectName()
	return "particles/units/heroes/hero_mars/mars_arena_of_blood_heal_flame.vpcf"
end

function modifier_heal_spell:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
	}
end

function modifier_heal_spell:GetModifierConstantHealthRegen()
	return self:GetAbility():GetSpecialValueFor("hp_regen")
end

function modifier_heal_spell:GetModifierConstantManaRegen()
	return self:GetAbility():GetSpecialValueFor("mana_regen")
end

function heal_spell:OnSpellStart()
    local caster = self:GetCaster()
    local modif = caster:AddNewModifier(caster, self, "modifier_heal_spell", { duration = self:GetSpecialValueFor("duration")})
end