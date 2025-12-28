LinkLuaModifier( "modifier_meg1_kill", "abilities/meg1", LUA_MODIFIER_MOTION_NONE)

meg1 = class({})

function meg1:OnSpellStart() 
    local caster = self:GetCaster()
    local point = self:GetCursorPosition()
    local level = self:GetLevel()

    EmitGlobalSound("meg1")
    
    if level == 1 then
        local unit = CreateUnitByName("npc_dota_neutral_volf11", point, true, caster, caster, caster:GetTeamNumber())
        unit:SetControllableByPlayer(caster:GetPlayerID(), true)
        unit:AddNewModifier(caster, self, "modifier_meg1_kill", {duration = self:GetSpecialValueFor("duration")})
    elseif level == 2 then 
    	local unit = CreateUnitByName("npc_dota_neutral_volf12", point, true, caster, caster, caster:GetTeamNumber())
        unit:SetControllableByPlayer(caster:GetPlayerID(), true)
        unit:AddNewModifier(caster, self, "modifier_meg1_kill", {duration = self:GetSpecialValueFor("duration")})
    elseif level == 3 then 
    	local unit = CreateUnitByName("npc_dota_neutral_volf13", point, true, caster, caster, caster:GetTeamNumber())
        unit:SetControllableByPlayer(caster:GetPlayerID(), true)
        unit:AddNewModifier(caster, self, "modifier_meg1_kill", {duration = self:GetSpecialValueFor("duration")})
    else
    	local unit = CreateUnitByName("npc_dota_neutral_volf14", point, true, caster, caster, caster:GetTeamNumber())
        unit:SetControllableByPlayer(caster:GetPlayerID(), true)
        unit:AddNewModifier(caster, self, "modifier_meg1_kill", {duration = self:GetSpecialValueFor("duration")})
    end

    if level == 1 then 
    	local unit = CreateUnitByName("npc_dota_neutral_volf21", point, true, caster, caster, caster:GetTeamNumber())
        unit:SetControllableByPlayer(caster:GetPlayerID(), true)
        unit:AddNewModifier(caster, self, "modifier_meg1_kill", {duration = self:GetSpecialValueFor("duration")})
    elseif level == 2 then 
    	local unit = CreateUnitByName("npc_dota_neutral_volf22", point, true, caster, caster, caster:GetTeamNumber())
        unit:SetControllableByPlayer(caster:GetPlayerID(), true)
        unit:AddNewModifier(caster, self, "modifier_meg1_kill", {duration = self:GetSpecialValueFor("duration")})
    elseif level == 3 then 
    	local unit = CreateUnitByName("npc_dota_neutral_volf23", point, true, caster, caster, caster:GetTeamNumber())
        unit:SetControllableByPlayer(caster:GetPlayerID(), true)
        unit:AddNewModifier(caster, self, "modifier_meg1_kill", {duration = self:GetSpecialValueFor("duration")})
    else
    	local unit = CreateUnitByName("npc_dota_neutral_volf24", point, true, caster, caster, caster:GetTeamNumber())
        unit:SetControllableByPlayer(caster:GetPlayerID(), true)
        unit:AddNewModifier(caster, self, "modifier_meg1_kill", {duration = self:GetSpecialValueFor("duration")})
    end
end

modifier_meg1_kill = class({})

function modifier_meg1_kill:IsHidden()
	return false
end

function modifier_meg1_kill:IsPurgable()
	return false
end

function modifier_meg1_kill:IsServer()
	return true
end

function modifier_meg1_kill:OnDestroy()
	local parent = self:GetParent()
	local damage = {
					victim = parent,
					attacker = parent,
					damage = 100000,
					damage_type = DAMAGE_TYPE_PURE,
					ability = self:GetAbility()
				}

	ApplyDamage(damage)
end
