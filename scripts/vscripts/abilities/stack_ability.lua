LinkLuaModifier( "modifier_stack_ability", "abilities/stack_ability", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_stack_ability_value", "abilities/stack_ability", LUA_MODIFIER_MOTION_NONE)

stack_ability = class{}

function stack_ability:GetIntrinsicModifierName()
    return "modifier_stack_ability"
end

modifier_stack_ability = class{}

function modifier_stack_ability:IsHidden()
	return true
end

function modifier_stack_ability:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

function modifier_stack_ability:OnAttackLanded(props)
	if self:GetParent() == props.attacker then
		local stack = props.attacker:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stack_ability_value", { duration = self:GetAbility():GetSpecialValueFor("duration") })
		stack:IncrementStackCount()
		local count = stack:GetStackCount()
		print("Stack count:", count)
		if count == self:GetAbility():GetSpecialValueFor("count") then
			stack:SetStackCount(0)
			print("Return to 0")
			local boom_modifier = props.attacker:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stack_ability_boom", { duration = 30 })
			if boom_modifier then
				local damage = {
					victim = props.target,
					attacker = props.attacker,
					damage = self:GetAbility():GetSpecialValueFor("bonus_damage"),
					damage_type = DAMAGE_TYPE_PURE,
					ability = self:GetAbility()
				}
				ApplyDamage(damage)
				boom_modifier:Destroy()
				print("Destroyed boom_modifier!")
			end
		end 
	end
end

modifier_stack_ability_value = class{}

function modifier_stack_ability_value:IsHidden()
	return false
end

function modifier_stack_ability_value:IsDebuff()
	return false
end

function modifier_stack_ability_value:IsPurgable()
	return false
end

modifier_stack_ability_boom = class{}

function modifier_stack_ability_boom:IsHidden()
	return false
end

function modifier_stack_ability_boom:IsDebuff()
	return false
end

function modifier_stack_ability_boom:IsPurgable()
	return false
end
