LinkLuaModifier( "modifier_invo4", "abilities/invo4", LUA_MODIFIER_MOTION_NONE)

invo4 = class{}

modifier_invo4 = class{}

function modifier_invo4:IsHidden()
	return false
end

function modifier_invo4:IsPurgable()
	return false
end

function modifier_invo4:DeclareFunctions()
	return {
	 MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
     MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
     MODIFIER_PROPERTY_STATS_AGILITY_BONUS
	}
end

function modifier_invo4:GetEffectName()
	return "particles/econ/items/queen_of_pain/qop_2022_immortal/queen_2022_scream_of_pain_owner_blue_wave_scream.vpcf"
end

function modifier_invo4:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor("str")
end

function modifier_invo4:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor("agl")
end

function modifier_invo4:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("int")
end

function invo4:OnSpellStart()
    local caster = self:GetCaster()  
    local particle = ParticleManager:CreateParticle("particles/econ/items/queen_of_pain/qop_2022_immortal/queen_2022_scream_of_pain_owner_blue_wave_scream.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
    
    ParticleManager:SetParticleControl(particle, 1, caster:GetAbsOrigin())
    ParticleManager:SetParticleControl(particle, 2, caster:GetAbsOrigin())

    if caster:HasModifier("modifier_invo1") then
        caster:RemoveModifierByName("modifier_invo1")
    end
    if caster:HasModifier("modifier_invo2") then
        caster:RemoveModifierByName("modifier_invo2")
    end
    if caster:HasModifier("modifier_invo3") then
        caster:RemoveModifierByName("modifier_invo3")
    end
   
    caster:AddNewModifier(caster, self, "modifier_invo4", { duration = -1 })
end