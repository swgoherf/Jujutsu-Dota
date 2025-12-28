item_ref_boss = {}

function item_ref_boss:OnSpellStart()
	local point1 = Entities:FindByName( nil, "boss_point"):GetAbsOrigin()
	local point2 = Entities:FindByName( nil, "boss_point2"):GetAbsOrigin()
	local point3 = Entities:FindByName( nil, "boss_point3"):GetAbsOrigin()
	
	CreateUnitByName("npc_dota_neutral_kobold_boss", point1, true, nil, nil, DOTA_TEAM_NEUTRALS)
	CreateUnitByName("npc_dota_neutral_bimbam_boss", point2, true, nil, nil, DOTA_TEAM_NEUTRALS)
	CreateUnitByName("npc_dota_neutral_bimbum_boss", point3, true, nil, nil, DOTA_TEAM_NEUTRALS)

	UTIL_Remove(self)
end