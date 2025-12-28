LinkLuaModifier( "modifier_gold_hole_thinker", "abilities/gold_hole", LUA_MODIFIER_MOTION_NONE )


gold_hole = {}

function gold_hole:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function gold_hole:OnSpellStart()
	local point = self:GetCursorPosition()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")

	CreateModifierThinker(caster, self, "modifier_gold_hole_thinker", {duration = duration}, point, caster:GetTeamNumber(), false)
end

modifier_gold_hole_thinker = {}

function modifier_gold_hole_thinker:IsHidden()
	return true
end

function modifier_gold_hole_thinker:OnCreated()
	local radius = self:GetAbility():GetSpecialValueFor("radius")

	self.effect_cast = ParticleManager:CreateParticle( "particles/econ/items/riki/riki_head_ti8_gold/riki_smokebomb_ti8_gold.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( radius, 0, 0 ) )
 
	self:StartIntervalThink(1)
end


function modifier_gold_hole_thinker:OnDestroy()
	ParticleManager:DestroyParticle(self.effect_cast, false)
end

function modifier_gold_hole_thinker:OnIntervalThink()
 	local caster = self:GetCaster()
 	local parent = self:GetParent()
	local radius = self:GetAbility():GetSpecialValueFor("radius")
	local gold_per_unit = self:GetAbility():GetSpecialValueFor("gold_per_unit")

	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), parent:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false)
	local gold = gold_per_unit * #enemies


 	caster:ModifyGold(gold, true, 13) 
 	EmitSoundOnClient("General.Coins", caster)
 	SendOverheadEventMessage(caster:GetPlayerOwner(), OVERHEAD_ALERT_GOLD, caster, gold, caster)
end