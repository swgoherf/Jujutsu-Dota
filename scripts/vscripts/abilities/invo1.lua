LinkLuaModifier( "modifier_invo1", "abilities/invo1", LUA_MODIFIER_MOTION_NONE)

invo1 = class{}

modifier_invo1 = class{}

function modifier_invo1:IsHidden()
	return false
end

function modifier_invo1:IsPurgable()
	return false
end

function modifier_invo1:DeclareFunctions()
	return {
	 MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
	}
end

function modifier_invo1:GetEffectName()
	return "particles/econ/items/faceless_void/faceless_void_bracers_of_aeons/fv_bracers_of_aeons_dialatedebuf_red_hex.vpcf"
end

function modifier_invo1:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("str")
end

function invo1:OnSpellStart()
    local caster = self:GetCaster()  
    local particle = ParticleManager:CreateParticle("particles/econ/items/faceless_void/faceless_void_bracers_of_aeons/fv_bracers_of_aeons_dialatedebuf_red_hex.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
    
    ParticleManager:SetParticleControl(particle, 1, caster:GetAbsOrigin())
    ParticleManager:SetParticleControl(particle, 2, caster:GetAbsOrigin())

    if caster:HasModifier("modifier_invo2") then
        caster:RemoveModifierByName("modifier_invo2")
    end
    if caster:HasModifier("modifier_invo3") then
        caster:RemoveModifierByName("modifier_invo3")
    end
    if caster:HasModifier("modifier_invo4") then
        caster:RemoveModifierByName("modifier_invo4")
    end
   
    caster:AddNewModifier(caster, self, "modifier_invo1", { duration = -1 })
end