LinkLuaModifier( "modifier_invo2", "abilities/invo2", LUA_MODIFIER_MOTION_NONE)

invo2 = class{}

modifier_invo2 = class{}

function modifier_invo2:IsHidden()
	return false
end

function modifier_invo2:IsPurgable()
	return false
end

function modifier_invo2:DeclareFunctions()
	return {
	 MODIFIER_PROPERTY_STATS_AGILITY_BONUS
	}
end

function modifier_invo2:GetEffectName()
	return "particles/units/heroes/hero_dragon_knight/dragon_knight_transform_green.vpcf"
end

function modifier_invo2:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("agl")
end

function invo2:OnSpellStart()
    local caster = self:GetCaster()  
    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_dragon_knight/dragon_knight_transform_green.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
    
    ParticleManager:SetParticleControl(particle, 1, caster:GetAbsOrigin())
    ParticleManager:SetParticleControl(particle, 2, caster:GetAbsOrigin())

    if caster:HasModifier("modifier_invo1") then
        caster:RemoveModifierByName("modifier_invo1")
    end
    if caster:HasModifier("modifier_invo3") then
        caster:RemoveModifierByName("modifier_invo3")
    end
    if caster:HasModifier("modifier_invo4") then
        caster:RemoveModifierByName("modifier_invo4")
    end
   
    caster:AddNewModifier(caster, self, "modifier_invo2", { duration = -1 })
end