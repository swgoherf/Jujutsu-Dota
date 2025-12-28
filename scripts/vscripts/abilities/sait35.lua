LinkLuaModifier( "modifier_sait35", "abilities/sait35", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_sait35_kill", "abilities/sait35", LUA_MODIFIER_MOTION_NONE)

sait35 = class({})

function sait35:GetIntrinsicModifierName()
    return "modifier_sait35"
end

modifier_sait35 = class({})

function modifier_sait35:IsHidden()
    return true
end

function modifier_sait35:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_HERO_KILLED
    }
end

modifier_sait35_kill = class({})

function modifier_sait35_kill:IsHidden()
    return false
end

function modifier_sait35_kill:IsPurgable()
    return false
end

function modifier_sait35_kill:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
    }
end

function modifier_sait35_kill:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor("damage") * self:GetStackCount()
end

function modifier_sait35:OnHeroKilled(keys)
    if IsServer() then
        local parent = self:GetParent()
        local attacker = keys.attacker

        if attacker == parent then
            parent:AddNewModifier(parent, self:GetAbility(), "modifier_sait35_kill", { duration = -1 })
            parent:AddNewModifier(parent, self:GetAbility(), "modifier_sait35_kill", { duration = -1 }):IncrementStackCount()
        end
    end
end 

