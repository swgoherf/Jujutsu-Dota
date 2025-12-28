LinkLuaModifier( "modifier_yarik", "abilities/yarik", LUA_MODIFIER_MOTION_NONE)

yarik = class{}

function yarik:GetIntrinsicModifierName()
	return "modifier_yarik"
end

modifier_yarik = class{}

function modifier_yarik:IsHidden()
	return true
end

function modifier_yarik:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

function modifier_yarik:OnAttackLanded(props)
	if self:GetParent() == props.attacker then
		Say(nil, "Yarik LOX!!!!", false)
	end
end
