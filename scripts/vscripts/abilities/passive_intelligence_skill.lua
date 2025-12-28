-- Создаем новый скилл
passive_intelligence_skill = class({})

-- Устанавливаем тип скилла (пассивный)
LinkLuaModifier("modifier_passive_intelligence_skill", "abilities/passive_intelligence_skill", LUA_MODIFIER_MOTION_NONE)

-- Определяем функцию, которая выполняется при создании скилла
function passive_intelligence_skill:GetIntrinsicModifierName()
    return "modifier_passive_intelligence_skill"
end

-- Создаем новый модификатор
modifier_passive_intelligence_skill = class({})

-- Определяем тип модификатора
function modifier_passive_intelligence_skill:IsHidden()
    return true  -- Модификатор не отображается в интерфейсе
end

-- Определяем тип модификатора
function modifier_passive_intelligence_skill:IsPurgable()
    return false  -- Модификатор не может быть снят с помощью чистки
end

-- Определяем функцию, которая выполняется при создании модификатора
function modifier_passive_intelligence_skill:OnCreated(event)
    if IsServer() then
        local ability = self:GetAbility()
        local bonus_intelligence = ability:GetSpecialValueFor("bonus_intelligence") or 0

        -- Добавляем бонус интеллекта герою
        self:GetParent():ModifyIntellect(bonus_intelligence)
    end
end

-- Определяем функцию, которая выполняется при обновлении модификатора
function modifier_passive_intelligence_skill:OnRefresh(event)
    if IsServer() then
        local ability = self:GetAbility()
        local bonus_intelligence = ability:GetSpecialValueFor("bonus_intelligence") or 0

        -- Обновляем значение бонуса интеллекта
        self:GetParent():ModifyIntellect(bonus_intelligence)
    end
end

-- Определяем таблицу с особыми значениями скилла
function passive_intelligence_skill:GetAbilitySpecialValue()
    return {
        bonus_intelligence = self:GetSpecialValueFor("bonus_intelligence"),
    }
end
