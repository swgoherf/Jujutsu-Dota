LinkLuaModifier( "modifier_invo5S", "abilities/invo5", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_invo5A", "abilities/invo5", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_invo5I", "abilities/invo5", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_invo5All", "abilities/invo5", LUA_MODIFIER_MOTION_NONE)

invo5 = class{}

modifier_invo5S = class{}

modifier_invo5A = class{}

modifier_invo5I = class{}

modifier_invo5All = class{}

function modifier_invo5S:IsHidden()
	return false
end

function modifier_invo5S:IsPurgable()
	return false
end

function modifier_invo5A:IsHidden()
	return false
end

function modifier_invo5A:IsPurgable()
	return false
end

function modifier_invo5I:IsHidden()
	return false
end

function modifier_invo5I:IsPurgable()
	return false
end

function modifier_invo5All:IsHidden()
	return false
end

function modifier_invo5All:IsPurgable()
	return false
end

function modifier_invo5S:DeclareFunctions()
	return {
    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
    MODIFIER_PROPERTY_MODEL_SCALE
	}
end

function modifier_invo5A:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_EVASION_CONSTANT,
		MODIFIER_PROPERTY_MODEL_SCALE
	}
end

function modifier_invo5I:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_MODEL_SCALE
	}
end

function modifier_invo5All:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_MODEL_SCALE
	}
end

function modifier_invo5S:GetModifierModelScale()
    return 50
end

function modifier_invo5A:GetModifierModelScale()
    return 50
end

function modifier_invo5I:GetModifierModelScale()
    return 50
end

function modifier_invo5All:GetModifierModelScale()
    return 50
end

function modifier_invo5All:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor("str_all")
end

function modifier_invo5All:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor("agl_all")
end

function modifier_invo5All:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("int_all")
end

function modifier_invo5I:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("int")
end

function modifier_invo5I:GetModifierConstantManaRegen()
	return self:GetAbility():GetSpecialValueFor("mp_regen")
end

function modifier_invo5I:GetModifierConstantHealthRegen()
	return self:GetAbility():GetSpecialValueFor("hp_regen")
end

function modifier_invo5A:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor("agl")
end

function modifier_invo5A:GetModifierAttackSpeedBonus_Constant()
    return self:GetAbility():GetSpecialValueFor("as_bonus")
end

function modifier_invo5A:GetModifierEvasion_Constant()
    return self:GetAbility():GetSpecialValueFor("evasion_bonus")
end

function modifier_invo5S:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("str")
end

function modifier_invo5S:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("armor_bonus")
end

function modifier_invo5S:GetModifierMagicalResistanceBonus()
	return self:GetAbility():GetSpecialValueFor("res_bonus")
end

function invo5:OnSpellStart()
    local caster = self:GetCaster()
    local particle = ParticleManager:CreateParticle("particles/econ/items/antimage/antimage_ti7/antimage_blink_start_ti7_ribbon_bright.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
    
    ParticleManager:SetParticleControl(particle, 1, caster:GetAbsOrigin())
    ParticleManager:SetParticleControl(particle, 2, caster:GetAbsOrigin())

    if caster:HasModifier("modifier_invo1") then
        caster:AddNewModifier( caster, self, "modifier_invo5S", { duration = self:GetSpecialValueFor("duration")} )
    end

    if caster:HasModifier("modifier_invo2") then
        caster:AddNewModifier( caster, self, "modifier_invo5A", { duration = self:GetSpecialValueFor("duration")} )
    end

    if caster:HasModifier("modifier_invo3") then
        caster:AddNewModifier( caster, self, "modifier_invo5I", { duration = self:GetSpecialValueFor("duration")} )
    end

    if caster:HasModifier("modifier_invo4") then
        caster:AddNewModifier( caster, self, "modifier_invo5All", { duration = self:GetSpecialValueFor("duration")} )
    end

    EmitGlobalSound("invo5")
end