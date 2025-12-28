LinkLuaModifier("modifier_item_nullif_up", "items/item_nullif_up", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_nullif_up_state", "items/item_nullif_up", LUA_MODIFIER_MOTION_NONE)

positive_count = 0

item_nullif_up = class({})

function item_nullif_up:GetIntrinsicModifierName()
    return "modifier_item_nullif_up_state"
end

modifier_item_nullif_up_state = {}

function modifier_item_nullif_up_state:IsHidden()
    return false
end

function modifier_item_nullif_up_state:IsPurgable()
    return false
end

function modifier_item_nullif_up_state:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
    }
end

function modifier_item_nullif_up_state:GetModifierConstantHealthRegen()
    return self:GetAbility():GetSpecialValueFor("hp_regen")
end

function modifier_item_nullif_up_state:GetModifierPhysicalArmorBonus()
    return self:GetAbility():GetSpecialValueFor("armor")
end

function modifier_item_nullif_up_state:GetModifierBaseAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor("damage_bonus")
end

function item_nullif_up:OnSpellStart()
    local target = self:GetCursorTarget()
    local caster = self:GetCaster()

    caster:EmitSound("DOTA_Item.Nullifier.Cast")

    target:AddNewModifier(caster, self, "modifier_item_nullif_up", {duration = self:GetSpecialValueFor("duration")})
end

modifier_item_nullif_up = class({})

function modifier_item_nullif_up:IsHidden()
    return false
end

function modifier_item_nullif_up:IsPurgable()
    return false
end

function modifier_item_nullif_up:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    }
end

function modifier_item_nullif_up:GetModifierMoveSpeedBonus_Constant()
    return self:GetAbility():GetSpecialValueFor("ms") * positive_count
end

function modifier_item_nullif_up:GetModifierAttackSpeedBonus_Constant()
    return self:GetAbility():GetSpecialValueFor("as") * positive_count
end

function modifier_item_nullif_up:GetEffectName()
    return "particles/items4_fx/nullifier_mute_debuff.vpcf"
end

function modifier_item_nullif_up:OnCreated()
    if not IsServer() then return end
    self:StartIntervalThink(0.5)
end

function modifier_item_nullif_up:OnIntervalThink()
    if not IsServer() then return end
    local target = self:GetParent()
    local caster = self:GetCaster()
    local ability = self:GetAbility()

    local positive_effects = {}

    for i = 0, target:GetModifierCount() - 1 do
        local modifier = target:GetModifierNameByIndex(i)
        local modifier_instance = target:FindModifierByName(modifier)
        if modifier_instance and not modifier_instance:IsDebuff() then
            table.insert(positive_effects, modifier)
        end
    end

    positive_count = #positive_effects

    for _, effect in pairs(positive_effects) do
        target:RemoveModifierByName(effect)
    end

    if positive_count > 0 then
        local damage = positive_count * self:GetAbility():GetSpecialValueFor("damage")
        local damageTable = {
            victim = target,
            attacker = caster,
            damage = damage,
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = ability
        }
        ApplyDamage(damageTable)
    end
end
