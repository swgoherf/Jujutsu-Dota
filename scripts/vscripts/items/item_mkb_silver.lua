LinkLuaModifier( "modifier_item_mkb_silver", "items/item_mkb_silver", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_item_mkb_silver_true", "items/item_mkb_silver", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_item_mkb_silver_debuff", "items/item_mkb_silver", LUA_MODIFIER_MOTION_NONE)

item_mkb_silver = class({})

function item_mkb_silver:GetIntrinsicModifierName()
    return "modifier_item_mkb_silver_true"
end

modifier_item_mkb_silver_true = class({})

function modifier_item_mkb_silver_true:IsHidden()
    return true
end

function modifier_item_mkb_silver_true:IsPurgable()
    return false
end

function modifier_item_mkb_silver_true:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_FAIL,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
    }
end

function modifier_item_mkb_silver_true:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("as")
end

function modifier_item_mkb_silver_true:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function item_mkb_silver:OnSpellStart()
    local caster = self:GetCaster()

    caster:AddNewModifier(caster, self, "modifier_item_mkb_silver", { duration = self:GetSpecialValueFor("duration") } )
end

modifier_item_mkb_silver = class({})

function modifier_item_mkb_silver:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }
end

function modifier_item_mkb_silver:CheckState()
    local state = {
        [MODIFIER_STATE_INVISIBLE] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_UNSLOWABLE] = true,
    }
    return state
end

function modifier_item_mkb_silver:GetModifierMoveSpeedBonus_Percentage()
	return 35
end

function modifier_item_mkb_silver_true:OnAttackLanded(props)
    if self:GetParent() == props.attacker then
        ApplyDamage({
            victim = props.target,
            attacker = props.attacker,
            damage = self:GetAbility():GetSpecialValueFor("damage_magic"),
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self:GetAbility()
        })
    end
end

function modifier_item_mkb_silver_true:OnAttackFail(props)
    if self:GetParent() == props.attacker then
        ApplyDamage({
            victim = props.target,
            attacker = props.attacker,
            damage = self:GetAbility():GetSpecialValueFor("damage_magic") + self:GetParent():GetAttackDamage(),
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self:GetAbility()
        })
    end
end

function modifier_item_mkb_silver:GetModifierInvisibilityLevel()
    return 2
end

function modifier_item_mkb_silver:OnAttackLanded(props)
    if self:GetParent() == props.attacker then
        ApplyDamage({
            victim = props.target,
            attacker = props.attacker,
            damage = self:GetAbility():GetSpecialValueFor("damage") + props.target:GetHealth() * 0.07,
            damage_type = DAMAGE_TYPE_PHYSICAL,
            ability = self:GetAbility()
        })

        self:Destroy()

        props.target:AddNewModifier(props.attacker, self:GetAbility(), "modifier_item_mkb_silver_debuff", { duration = 10 })
    end
end

modifier_item_mkb_silver_debuff = class({})

function modifier_item_mkb_silver_debuff:IsHidden()
    return false
end

function modifier_item_mkb_silver_debuff:IsDebuff()
    return true
end

function modifier_item_mkb_silver_debuff:IsPurgable()
    return true
end

function modifier_item_mkb_silver_debuff:CheckState()
    return {
        [MODIFIER_STATE_PASSIVES_DISABLED] = true
    }
end