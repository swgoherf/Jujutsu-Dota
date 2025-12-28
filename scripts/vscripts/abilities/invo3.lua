LinkLuaModifier( "modifier_invo3", "abilities/invo3", LUA_MODIFIER_MOTION_NONE)

invo3 = class{}

modifier_invo3 = class{}

function modifier_invo3:IsHidden()
	return false
end

function modifier_invo3:IsPurgable()
	return false
end

function modifier_invo3:DeclareFunctions()
	return {
	 MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	}
end

function modifier_invo3:GetEffectName()
	return "particles/econ/items/faceless_void/faceless_void_bracers_of_aeons/fv_bracers_of_aeons_dialatedebuf_hex.vpcf"
end

function modifier_invo3:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("int")
end

function invo3:OnSpellStart()
    local caster = self:GetCaster()  
    local particle = ParticleManager:CreateParticle("particles/econ/items/faceless_void/faceless_void_bracers_of_aeons/fv_bracers_of_aeons_dialatedebuf_hex.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
    
    ParticleManager:SetParticleControl(particle, 1, caster:GetAbsOrigin())
    ParticleManager:SetParticleControl(particle, 2, caster:GetAbsOrigin())

    if caster:HasModifier("modifier_invo1") then
        caster:RemoveModifierByName("modifier_invo1")
    end
    if caster:HasModifier("modifier_invo2") then
        caster:RemoveModifierByName("modifier_invo2")
    end
    if caster:HasModifier("modifier_invo4") then
        caster:RemoveModifierByName("modifier_invo4")
    end
   
    caster:AddNewModifier(caster, self, "modifier_invo3", { duration = -1 })
end