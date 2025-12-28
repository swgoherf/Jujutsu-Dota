LinkLuaModifier( "modifier_esk2", "abilities/esk2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_esk2_buff", "abilities/esk2", LUA_MODIFIER_MOTION_NONE)

esk2 = class{}

function esk2:GetIntrinsicModifierName()
    return "modifier_esk2"
end

modifier_esk2 = class{}

function modifier_esk2:IsHidden()
	return true
end

function modifier_esk2:IsPurgable()
	return false
end

function modifier_esk2:OnIntervalThink()
    if IsServer() then
        if GameRules:IsDaytime() then
            if not self:GetParent():HasModifier("modifier_esk2_buff") then
                self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_esk2_buff", {})
                print("modif add!")
            end
        else
            if self:GetParent():HasModifier("modifier_esk2_buff") then
                self:GetParent():RemoveModifierByName("modifier_esk2_buff")
                print("modif remove!")
            end
        end
    end
end

function modifier_esk2:OnCreated()
    self:StartIntervalThink(1) -- Проверка времени суток каждую секунду
end

modifier_esk2_buff = class{}

function modifier_esk2_buff:IsHidden()
	return false
end

function modifier_esk2_buff:IsPurgable()
	return false
end

function modifier_esk2_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_esk2_buff:GetModifierMoveSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("ms")
end

function modifier_esk2_buff:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("atk")
end

function modifier_esk2_buff:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("armor")
end

function modifier_esk2_buff:GetModifierMagicalResistanceBonus()
	return self:GetAbility():GetSpecialValueFor("mag_res")
end

function modifier_esk2_buff:GetModifierHealthRegenPercentage()
	return self:GetAbility():GetSpecialValueFor("hp_regen")
end

function modifier_esk2_buff:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("as")
end

function modifier_esk2_buff:GetModifierModelScale()
    return 50
end

--function modifier_esk2_buff:GetEffectName()
--	return "particles/econ/items/bloodseeker/bloodseeker_eztzhok_weapon/bloodseeker_bloodrage_ground_eztzhok_arc.vpcf"
--end
