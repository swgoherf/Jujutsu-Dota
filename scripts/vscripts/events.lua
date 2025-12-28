--[[ events.lua ]]

---------------------------------------------------------------------------
-- Event: Game state change handler
---------------------------------------------------------------------------
countBossKilled = 0

function COverthrowGameMode:OnGameRulesStateChange()
	local nNewState = GameRules:State_Get()
	--print( "OnGameRulesStateChange: " .. nNewState )

	if nNewState == DOTA_GAMERULES_STATE_HERO_SELECTION then
		self:AssignTeams()

	elseif nNewState == DOTA_GAMERULES_STATE_PRE_GAME then
		local numberOfPlayers = PlayerResource:GetPlayerCount()
		if numberOfPlayers > 7 then
			--self.TEAM_KILLS_TO_WIN = 25
			nCOUNTDOWNTIMER = 1801
			EmitGlobalSound("pizdec")

		elseif numberOfPlayers > 4 and numberOfPlayers <= 7 then
			--self.TEAM_KILLS_TO_WIN = 20
			nCOUNTDOWNTIMER = 1801
			EmitGlobalSound("pizdec")
		else
			--self.TEAM_KILLS_TO_WIN = 15
			nCOUNTDOWNTIMER = 1801
			EmitGlobalSound("pizdec")
		end
		
		if GetMapName() == "forest_solo" then
			self.TEAM_KILLS_TO_WIN = self.KILLS_TO_WIN_SINGLES
		elseif GetMapName() == "desert_duo" then
			self.TEAM_KILLS_TO_WIN = self.KILLS_TO_WIN_DUOS
		elseif GetMapName() == "temple_quartet" then
			self.TEAM_KILLS_TO_WIN = self.KILLS_TO_WIN_QUADS
		elseif GetMapName() == "desert_quintet" then
			self.TEAM_KILLS_TO_WIN = self.KILLS_TO_WIN_QUINTS
		else
			self.TEAM_KILLS_TO_WIN = self.KILLS_TO_WIN_TRIOS
		end
		--print( "Kills to win = " .. tostring(self.TEAM_KILLS_TO_WIN) )

		CustomNetTables:SetTableValue( "game_state", "victory_condition", { kills_to_win = self.TEAM_KILLS_TO_WIN } );

		self._fPreGameStartTime = GameRules:GetGameTime()

	elseif nNewState == DOTA_GAMERULES_STATE_STRATEGY_TIME then
		-- random for all players that haven't chosen yet
		for nPlayerID = 0, ( DOTA_MAX_TEAM_PLAYERS - 1 ) do
			local hPlayer = PlayerResource:GetPlayer( nPlayerID )
			if hPlayer and not PlayerResource:HasSelectedHero( nPlayerID ) then
				hPlayer:MakeRandomHeroSelection()
			end	
		end

	elseif nNewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--print( "OnGameRulesStateChange: Game In Progress" )
		self.countdownEnabled = true
		CustomGameEventManager:Send_ServerToAllClients( "show_timer", {} )
		DoEntFire( "center_experience_ring_particles", "Start", "0", 0, self, self  )

		GameRules:GetGameModeEntity():SetAnnouncerDisabled( true ) -- Disable the normal announcer at game start
	end
end

--------------------------------------------------------------------------------
-- Event: OnNPCSpawned
--------------------------------------------------------------------------------
function COverthrowGameMode:OnNPCSpawned( event )
	local spawnedUnit = EntIndexToHScript( event.entindex )
	if spawnedUnit:IsRealHero() then
		-- Destroys the last hit effects
		local deathEffects = spawnedUnit:Attribute_GetIntValue( "effectsID", -1 )
		if deathEffects ~= -1 then
			ParticleManager:DestroyParticle( deathEffects, true )
			spawnedUnit:DeleteAttribute( "effectsID" )
		end
		if self.allSpawned == false then
			if GetMapName() == "mines_trio" then
				--print("mines_trio is the map")
				--print("self.allSpawned is " .. tostring(self.allSpawned) )
				local unitTeam = spawnedUnit:GetTeam()
				local particleSpawn = ParticleManager:CreateParticleForTeam( "particles/addons_gameplay/player_deferred_light.vpcf", PATTACH_ABSORIGIN, spawnedUnit, unitTeam )
				ParticleManager:SetParticleControlEnt( particleSpawn, PATTACH_ABSORIGIN, spawnedUnit, PATTACH_ABSORIGIN, "attach_origin", spawnedUnit:GetAbsOrigin(), true )
			end
		end
	end
end

---------------------------------------------------------
-- dota_on_hero_finish_spawn
-- * heroindex
-- * hero  		(string)
---------------------------------------------------------

function COverthrowGameMode:OnHeroFinishSpawn( event )
	local hPlayerHero = EntIndexToHScript( event.heroindex )
	if hPlayerHero ~= nil and hPlayerHero:IsRealHero() then
		local hTP = hPlayerHero:FindItemInInventory( "item_tpscroll" )
		if hTP ~= nil then
			UTIL_Remove( hTP )
		end
	end
end

--------------------------------------------------------------------------------
-- Event: BountyRunePickupFilter
--------------------------------------------------------------------------------
function COverthrowGameMode:BountyRunePickupFilter( filterTable )
      filterTable["xp_bounty"] = 2*filterTable["xp_bounty"]
      filterTable["gold_bounty"] = 2*filterTable["gold_bounty"]
      return true
end

---------------------------------------------------------------------------
-- Event: OnTeamKillCredit, see if anyone won
---------------------------------------------------------------------------
function COverthrowGameMode:OnTeamKillCredit( event )
--	print( "OnKillCredit" )
--	DeepPrint( event )

	local nKillerID = event.killer_userid
	local nTeamID = event.teamnumber
	local nTeamKills = event.herokills
	local nKillsRemaining = self.TEAM_KILLS_TO_WIN - nTeamKills
	
	local broadcast_kill_event =
	{
		killer_id = event.killer_userid,
		team_id = event.teamnumber,
		team_kills = nTeamKills,
		kills_remaining = nKillsRemaining,
		victory = 0,
		close_to_victory = 0,
		very_close_to_victory = 0,
	}

	if nKillsRemaining <= 0 then
		local tTeamScores = {}
		for team = DOTA_TEAM_FIRST, (DOTA_TEAM_COUNT-1) do
			tTeamScores[team] = GetTeamHeroKills(team)
		end
		GameRules:SetPostGameTeamScores( tTeamScores )

		GameRules:SetCustomVictoryMessage( self.m_VictoryMessages[nTeamID] )
		GameRules:SetGameWinner( nTeamID )
		broadcast_kill_event.victory = 1
	elseif nKillsRemaining == 1 then
		EmitGlobalSound( "ui.npe_objective_complete" )
		broadcast_kill_event.very_close_to_victory = 1
	elseif nKillsRemaining <= self.CLOSE_TO_VICTORY_THRESHOLD then
		EmitGlobalSound( "ui.npe_objective_given" )
		broadcast_kill_event.close_to_victory = 1
	end

	CustomGameEventManager:Send_ServerToAllClients( "kill_event", broadcast_kill_event )
end

---------------------------------------------------------------------------
-- Event: OnEntityKilled
---------------------------------------------------------------------------
function COverthrowGameMode:OnEntityKilled( event )
	print("entity killed")
	local unit = EntIndexToHScript(event.entindex_killed)
      local attackerUnit = EntIndexToHScript(event.entindex_attacker)

      if unit:GetUnitName() == "npc_dota_neutral_kobold_boss" then
            EmitGlobalSound("pizda")
            Say(nil, "<font color='#ffe600'>The boss was killed!!!</font>", false)

            local shard = CreateItem("item_mag_shard3", nil, nil)
            CreateItemOnPositionForLaunch(unit:GetAbsOrigin(), shard)
            local aegis = CreateItem("item_aegis", nil, nil)
            CreateItemOnPositionForLaunch(unit:GetAbsOrigin(), aegis)
      end

      if unit:GetUnitName() == "npc_dota_neutral_bimbam_boss" then
            EmitGlobalSound("pizda")
            Say(nil, "<font color='#00c8ff'>The boss was killed!!!</font>", false)

            local shard = CreateItem("item_mag_shard1", nil, nil)
            CreateItemOnPositionForLaunch(unit:GetAbsOrigin(), shard)
            local aegis = CreateItem("item_aegis", nil, nil)
            CreateItemOnPositionForLaunch(unit:GetAbsOrigin(), aegis)
      end

      if unit:GetUnitName() == "npc_dota_neutral_bimbum_boss" then
            EmitGlobalSound("pizda")
            Say(nil, "<font color='#ff0000'>The boss was killed!!!</font>", false)

            local shard = CreateItem("item_mag_shard2", nil, nil)
            CreateItemOnPositionForLaunch(unit:GetAbsOrigin(), shard)
            local aegis = CreateItem("item_aegis", nil, nil)
            CreateItemOnPositionForLaunch(unit:GetAbsOrigin(), aegis)
      end

      if unit:GetUnitName() == "npc_dota_neutral_kobold_boss" or unit:GetUnitName() == "npc_dota_neutral_bimbum_boss" or unit:GetUnitName() == "npc_dota_neutral_bimbam_boss" then
            countBossKilled = countBossKilled + 1
            print(countBossKilled)
            if countBossKilled == 3 then
                  countBossKilled = 0
                  EventBoss()
                  Say(nil, "<font color='#fb00ff'>The event boss was spawning!!!</font>", false)
                  EmitGlobalSound("eventboss")
            end
      end
 
      if unit:GetUnitName() == "npc_dota_neutral_event_boss" then

            Say(nil, "<font color='#fb00ff'>The event boss was killed!!!</font>", false)

            local shard1 = CreateItem("item_mag_shard1", nil, nil)
            CreateItemOnPositionForLaunch(unit:GetAbsOrigin(), shard1)

            local shard2 = CreateItem("item_mag_shard2", nil, nil)
            CreateItemOnPositionForLaunch(unit:GetAbsOrigin(), shard2)

            local shard3 = CreateItem("item_mag_shard3", nil, nil)
            CreateItemOnPositionForLaunch(unit:GetAbsOrigin(), shard3)

            StopGlobalSound("eventboss")
      end

	local killedUnit = EntIndexToHScript( event.entindex_killed )
	local killedTeam = killedUnit:GetTeam()
	local hero = EntIndexToHScript( event.entindex_attacker )
	local heroTeam = hero:GetTeam()
	local extraTime = 0
	if killedUnit:IsRealHero() then
		self.allSpawned = true
		--print("Hero has been killed")
		--Add extra time if killed by Necro Ult
		if hero:IsRealHero() == true then
			if event.entindex_inflictor ~= nil then
				local inflictor_index = event.entindex_inflictor
				if inflictor_index ~= nil then
					local ability = EntIndexToHScript( event.entindex_inflictor )
					if ability ~= nil then
						if ability:GetAbilityName() ~= nil then
							if ability:GetAbilityName() == "necrolyte_reapers_scythe" then
								print("Killed by Necro Ult")
								extraTime = 20
							end
						end
					end
				end
			end
		end
		if hero:IsRealHero() and heroTeam ~= killedTeam then
			--print("Granting killer xp")
			if killedUnit:GetTeam() == self.leadingTeam and self.isGameTied == false then
				local memberID = hero:GetPlayerID()
				PlayerResource:ModifyGold( memberID, 500, true, 0 )
				hero:AddExperience( 100, 0, false, false )
				local name = hero:GetClassname()
				local victim = killedUnit:GetClassname()
				local kill_alert =
					{
						hero_id = hero:GetClassname()
					}
				CustomGameEventManager:Send_ServerToAllClients( "kill_alert", kill_alert )
			else
				hero:AddExperience( 50, 0, false, false )
			end
		end
		--Granting XP to all heroes who assisted
		local allHeroes = HeroList:GetAllHeroes()
		for _,attacker in pairs( allHeroes ) do
			--print(killedUnit:GetNumAttackers())
			for i = 0, killedUnit:GetNumAttackers() - 1 do
				if attacker == killedUnit:GetAttacker( i ) then
					--print("Granting assist xp")
					attacker:AddExperience( 25, 0, false, false )
				end
			end
		end
		if killedUnit:GetRespawnTime() > 10 then
			--print("Hero has long respawn time")
			if killedUnit:IsReincarnating() == true then
				--print("Set time for Wraith King respawn disabled")
				return nil
			else
				COverthrowGameMode:SetRespawnTime( killedTeam, killedUnit, extraTime )
			end
		else
			COverthrowGameMode:SetRespawnTime( killedTeam, killedUnit, extraTime )
		end
	end
end

function COverthrowGameMode:SetRespawnTime( killedTeam, killedUnit, extraTime )
	--print("Setting time for respawn")
	if killedTeam == self.leadingTeam and self.isGameTied == false then
		killedUnit:SetTimeUntilRespawn( 20 + extraTime )
	else
		killedUnit:SetTimeUntilRespawn( 10 + extraTime )
	end
end


--------------------------------------------------------------------------------
-- Event: OnItemPickUp
--------------------------------------------------------------------------------
function COverthrowGameMode:OnItemPickUp( event )
	local item = EntIndexToHScript( event.ItemEntityIndex )
	local owner = EntIndexToHScript( event.HeroEntityIndex )
	r = 300
	--r = RandomInt(200, 400)
	if event.itemname == "item_bag_of_gold" then
		--print("Bag of gold picked up")
		PlayerResource:ModifyGold( owner:GetPlayerID(), r, true, 0 )
		SendOverheadEventMessage( owner, OVERHEAD_ALERT_GOLD, owner, r, nil )
		UTIL_Remove( item ) -- otherwise it pollutes the player inventory
	elseif event.itemname == "item_treasure_chest" then
		print( "Special Item Picked Up" )

		if item.GetAbilityName ~= nil then
			--print( "Item is named: - " .. item:GetAbilityName() )
		end

		local hContainer = item:GetContainer()

		for k,v in pairs ( self.itemSpawnLocationsInUse ) do
			if v.hDrop == hContainer then
				--print( '^^^DROP CONTAINER!' )
				if v.hItemDestinationRevealer then
					v.hItemDestinationRevealer:RemoveSelf()
					ParticleManager:DestroyParticle( v.nItemDestinationParticles, false )
					DoEntFire( v.world_effects_name, "Stop", "0", 0, self, self )
				end
				
				table.insert( self.itemSpawnLocations, v )
				table.remove( self.itemSpawnLocationsInUse, k )
				break
			end
		end
		
		COverthrowGameMode:SpecialItemAdd( event )
		UTIL_Remove( item ) -- otherwise it pollutes the player inventory
	end
end


--------------------------------------------------------------------------------
-- Event: OnNpcGoalReached
--------------------------------------------------------------------------------
function COverthrowGameMode:OnNpcGoalReached( event )
	local npc = EntIndexToHScript( event.npc_entindex )
	if npc:GetUnitName() == "npc_dota_treasure_courier" then
		COverthrowGameMode:TreasureDrop( npc )
	end
end

function EventBoss()
	local point = Entities:FindByName( nil, "boss_point_event"):GetAbsOrigin()

	CreateUnitByName("npc_dota_neutral_event_boss", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
