--[[
Overthrow Game Mode
]]

_G.nNEUTRAL_TEAM = 4
_G.nCOUNTDOWNTIMER = 901


---------------------------------------------------------------------------
-- COverthrowGameMode class
---------------------------------------------------------------------------
if COverthrowGameMode == nil then
	_G.COverthrowGameMode = class({}) -- put COverthrowGameMode in the global scope
	--refer to: http://stackoverflow.com/questions/6586145/lua-require-with-global-local
end

-- global
HeroExpTable = {0,240,640,1160,1760,2440,3200,4000,4900,5900,7000,8200,9500,10900,12400,14000,15700,17500,19400,21400,23600,26000,28600,31400,34400,38400,43400,49400,56400,63900,70000,73000,77000,81000,85000}
DESIRED_PLAYER_ID = 1

---------------------------------------------------------------------------
-- Required .lua files
---------------------------------------------------------------------------
require( "events" )
require( "items" )
require( "utility_functions" )
require("utils/timers")

---------------------------------------------------------------------------
-- Precache
---------------------------------------------------------------------------
function Precache( context )
	--Cache the gold bags
		PrecacheItemByNameSync( "item_bag_of_gold", context )
		PrecacheResource( "particle", "particles/items2_fx/veil_of_discord.vpcf", context )	

		PrecacheItemByNameSync( "item_treasure_chest", context )

	--Cache the creature models
		PrecacheUnitByNameSync( "npc_dota_creature_basic_zombie", context )
        PrecacheUnitByNameSync( "npc_dota_creature_berserk_zombie", context )
        PrecacheUnitByNameSync( "npc_dota_treasure_courier", context )

    --Cache new particles
       	PrecacheResource( "particle", "particles/econ/events/nexon_hero_compendium_2014/teleport_end_nexon_hero_cp_2014.vpcf", context )
       	PrecacheResource( "particle", "particles/leader/leader_overhead.vpcf", context )
       	PrecacheResource( "particle", "particles/last_hit/last_hit.vpcf", context )
       	PrecacheResource( "particle", "particles/units/heroes/hero_zuus/zeus_taunt_coin.vpcf", context )
       	PrecacheResource( "particle", "particles/addons_gameplay/player_deferred_light.vpcf", context )
       	PrecacheResource( "particle", "particles/items_fx/black_king_bar_avatar.vpcf", context )
       	PrecacheResource( "particle", "particles/treasure_courier_death.vpcf", context )
       	PrecacheResource( "particle", "particles/econ/wards/f2p/f2p_ward/f2p_ward_true_sight_ambient.vpcf", context )
       	PrecacheResource( "particle", "particles/econ/items/lone_druid/lone_druid_cauldron/lone_druid_bear_entangle_dust_cauldron.vpcf", context )
       	PrecacheResource( "particle", "particles/newplayer_fx/npx_landslide_debris.vpcf", context )
       	PrecacheResource( "particle", "particles/econ/items/underlord/underlord_ti8_immortal_weapon/underlord_ti8_immortal_pitofmalice_burst.vpcf", context )
       	PrecacheResource( "particle", "particles/units/heroes/hero_lion/lion_spell_voodoo.vpcf", context )
       	PrecacheResource( "particle", "particles/units/heroes/hero_phoenix/phoenix_sunray_tgt_ring.vpcf", context )
       	PrecacheResource( "particle", "particles/units/heroes/hero_pudge/pudge_meathook.vpcf", context )
       	PrecacheResource( "particle", "particles/items4_fx/nullifier_mute_debuff.vpcf", context )
       	
	--Cache particles for traps
		PrecacheResource( "particle_folder", "particles/units/heroes/hero_dragon_knight", context )
		PrecacheResource( "particle_folder", "particles/units/heroes/hero_venomancer", context )
		PrecacheResource( "particle_folder", "particles/units/heroes/hero_axe", context )
		PrecacheResource( "particle_folder", "particles/units/heroes/hero_life_stealer", context )

	--Cache sounds for traps
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_dragon_knight.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/soundevents_conquest.vsndevts", context )

	-- Cache overthrow-specific sounds
		PrecacheResource( "soundfile", "soundevents/game_sounds_overthrow.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/soundscast.vsndevts", context )

		--precache hero(time)
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_doombringer.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_antimage.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_enigma.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_wisp.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_alchemist.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_medusa.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_phoenix.vsndevts", context )
end

function Activate()
	-- Create our game mode and initialize it
	COverthrowGameMode:InitGameMode()
	-- Custom Spawn
	COverthrowGameMode:CustomSpawnCamps()
end

function COverthrowGameMode:CustomSpawnCamps()
	for name,_ in pairs(spawncamps) do
	spawnunits(name)
	end
end

---------------------------------------------------------------------------
-- Initializer
---------------------------------------------------------------------------
function COverthrowGameMode:InitGameMode()
	print( "Overthrow is loaded." )

	local numberOfPlayers = PlayerResource:GetPlayerCount()
	
--	CustomNetTables:SetTableValue( "test", "value 1", {} );
--	CustomNetTables:SetTableValue( "test", "value 2", { a = 1, b = 2 } );

	self.m_bFillWithBots = GlobalSys:CommandLineCheck( "-addon_bots" )
	self.m_bFastPlay = GlobalSys:CommandLineCheck( "-addon_fastplay" )

	self.m_TeamColors = {}
	self.m_TeamColors[DOTA_TEAM_GOODGUYS] = { 61, 210, 150 }	--		Teal
	self.m_TeamColors[DOTA_TEAM_BADGUYS]  = { 243, 201, 9 }		--		Yellow
	self.m_TeamColors[DOTA_TEAM_CUSTOM_1] = { 197, 77, 168 }	--      Pink
	self.m_TeamColors[DOTA_TEAM_CUSTOM_2] = { 255, 108, 0 }		--		Orange
	self.m_TeamColors[DOTA_TEAM_CUSTOM_3] = { 52, 85, 255 }		--		Blue
	self.m_TeamColors[DOTA_TEAM_CUSTOM_4] = { 101, 212, 19 }	--		Green
	self.m_TeamColors[DOTA_TEAM_CUSTOM_5] = { 129, 83, 54 }		--		Brown
	self.m_TeamColors[DOTA_TEAM_CUSTOM_6] = { 27, 192, 216 }	--		Cyan
	self.m_TeamColors[DOTA_TEAM_CUSTOM_7] = { 199, 228, 13 }	--		Olive
	self.m_TeamColors[DOTA_TEAM_CUSTOM_8] = { 140, 42, 244 }	--		Purple

	for team = 0, (DOTA_TEAM_COUNT-1) do
		color = self.m_TeamColors[ team ]
		if color then
			SetTeamCustomHealthbarColor( team, color[1], color[2], color[3] )
		end
	end

	self.m_VictoryMessages = {}
	self.m_VictoryMessages[DOTA_TEAM_GOODGUYS] = "#VictoryMessage_GoodGuys"
	self.m_VictoryMessages[DOTA_TEAM_BADGUYS]  = "#VictoryMessage_BadGuys"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_1] = "#VictoryMessage_Custom1"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_2] = "#VictoryMessage_Custom2"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_3] = "#VictoryMessage_Custom3"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_4] = "#VictoryMessage_Custom4"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_5] = "#VictoryMessage_Custom5"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_6] = "#VictoryMessage_Custom6"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_7] = "#VictoryMessage_Custom7"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_8] = "#VictoryMessage_Custom8"

	self.m_GatheredShuffledTeams = {}
	self.numSpawnCamps = 5
	self.specialItem = ""
	self.spawnTime = 60
	self.warnTime = 7
	self.nNextSpawnItemNumber = 1
	self.nMaxItemSpawns = 30
	self.hasWarnedSpawn = false
	self.allSpawned = false
	self.leadingTeam = -1
	self.runnerupTeam = -1
	self.leadingTeamScore = 0
	self.runnerupTeamScore = 0
	self.isGameTied = true
	self.countdownEnabled = false
	self.itemSpawnIndex = 1
	self.itemSpawnLocation = Entities:FindByName( nil, "greevil" )
	self.tier1ItemBucket = {}
	self.tier2ItemBucket = {}
	self.tier3ItemBucket = {}
	self.tier4ItemBucket = {}
	self.tier5ItemBucket = {}

	self.itemSpawnLocations = nil
	self.KILLS_TO_WIN_SINGLES = 25
	self.KILLS_TO_WIN_DUOS = 30
	self.KILLS_TO_WIN_TRIOS = 35
	self.KILLS_TO_WIN_QUADS = 50
	self.KILLS_TO_WIN_QUINTS = 50

	self.TEAM_KILLS_TO_WIN = self.KILLS_TO_WIN_SINGLES
	self.CLOSE_TO_VICTORY_THRESHOLD = 5

	---------------------------------------------------------------------------

	self:GatherAndRegisterValidTeams()

	GameRules:GetGameModeEntity().COverthrowGameMode = self

	-- Adding Many Players
	if GetMapName() == "desert_quintet" then
		GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 5 )
		GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 5 )
		GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_1, 5 )
		self.m_GoldRadiusMin = 300
		self.m_GoldRadiusMax = 1400
		self.m_GoldDropPercent = 8
	elseif GetMapName() == "temple_duo" then
	    print('load')
		self.m_GoldRadiusMin = 300
		self.m_GoldRadiusMax = 1400
		self.m_GoldDropPercent = 5
	else
		self.m_GoldRadiusMin = 250
		self.m_GoldRadiusMax = 550
		self.m_GoldDropPercent = 4
	end

	-- Show the ending scoreboard immediately
	GameRules:SetCustomGameEndDelay( 0 )
	GameRules:SetCustomVictoryMessageDuration( 10 )
	GameRules:SetCustomGameSetupTimeout( 0.0 )
	GameRules:SetPreGameTime( 10.0 )
	GameRules:SetStrategyTime( 10.0 )
	if self.m_bFastPlay then
		GameRules:SetStrategyTime( 1.0 )
	end
	GameRules:SetHeroSelectPenaltyTime( 0.0 )
	GameRules:SetShowcaseTime( 0.0 )
	GameRules:SetIgnoreLobbyTeamsInCustomGame( false )
	--GameRules:SetHideKillMessageHeaders( true )
	GameRules:GetGameModeEntity():SetTopBarTeamValuesOverride( true )
	GameRules:GetGameModeEntity():SetTopBarTeamValuesVisible( false )
	GameRules:SetHideKillMessageHeaders( true )
	GameRules:SetUseUniversalShopMode( true )
	GameRules:SetSuggestAbilitiesEnabled( true )
	GameRules:SetSuggestItemsEnabled( true )
	GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_DOUBLEDAMAGE , true ) --Double Damage
	GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_HASTE, true ) --Haste
	GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_ILLUSION, true ) --Illusion
	GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_INVISIBILITY, true ) --Invis
	GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_REGENERATION, false ) --Regen
	GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_ARCANE, true ) --Arcane
	GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_BOUNTY, false ) --Bounty
	GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_XP, true )
	GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_SHIELD , true )
	GameRules:GetGameModeEntity():SetLoseGoldOnDeath( false )
	GameRules:GetGameModeEntity():SetFountainPercentageHealthRegen( 200 )
	GameRules:GetGameModeEntity():SetFountainPercentageManaRegen( 200 )
	GameRules:GetGameModeEntity():SetFountainConstantManaRegen( 0 )
	GameRules:GetGameModeEntity():SetGiveFreeTPOnDeath( false )
	GameRules:GetGameModeEntity():SetDefaultStickyItem( "item_boots" )
	GameRules:GetGameModeEntity():SetBountyRunePickupFilter( Dynamic_Wrap( COverthrowGameMode, "BountyRunePickupFilter" ), self )
	GameRules:GetGameModeEntity():SetExecuteOrderFilter( Dynamic_Wrap( COverthrowGameMode, "ExecuteOrderFilter" ), self )

	GameRules:GetGameModeEntity():SetFreeCourierModeEnabled( true )
	GameRules:GetGameModeEntity():SetUseTurboCouriers( true )
	GameRules:GetGameModeEntity():SetCanSellAnywhere( true )

	GameRules:GetGameModeEntity():SetUseCustomHeroLevels( true ) 
	GameRules:GetGameModeEntity():SetCustomXPRequiredToReachNextLevel( HeroExpTable )

	local nTeamSize = GameRules:GetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS )
	--print( '^^^Setting BANS PER TEAM to Team Size = ' .. nTeamSize )
	GameRules:SetCustomGameBansPerTeam( nTeamSize )
	GameRules:GetGameModeEntity():SetDraftingBanningTimeOverride( 8.0 )
	if self.m_bFastPlay then
		GameRules:GetGameModeEntity():SetDraftingBanningTimeOverride( 1.0 )
	end
	GameRules:GetGameModeEntity():SetDraftingHeroPickSelectTimeOverride( 30.0 )

	ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap( COverthrowGameMode, 'OnGameRulesStateChange' ), self )
	ListenToGameEvent( "npc_spawned", Dynamic_Wrap( COverthrowGameMode, "OnNPCSpawned" ), self )
	ListenToGameEvent( "dota_on_hero_finish_spawn", Dynamic_Wrap( COverthrowGameMode, "OnHeroFinishSpawn" ), self )
	ListenToGameEvent( "dota_team_kill_credit", Dynamic_Wrap( COverthrowGameMode, 'OnTeamKillCredit' ), self )
	ListenToGameEvent( "entity_killed", Dynamic_Wrap( COverthrowGameMode, 'OnEntityKilled' ), self )
	ListenToGameEvent( "dota_item_picked_up", Dynamic_Wrap( COverthrowGameMode, "OnItemPickUp"), self )
	ListenToGameEvent( "dota_npc_goal_reached", Dynamic_Wrap( COverthrowGameMode, "OnNpcGoalReached" ), self )
	ListenToGameEvent( "dota_player_used_ability", Dynamic_Wrap( COverthrowGameMode, 'MusicLala' ), self )

	Convars:RegisterCommand( "overthrow_force_item_drop", function(...) self:ForceSpawnItem() end, "Force an item drop.", FCVAR_CHEAT )
	Convars:RegisterCommand( "overthrow_force_gold_drop", function(...) self:ForceSpawnGold() end, "Force gold drop.", FCVAR_CHEAT )
	Convars:RegisterCommand( "overthrow_set_timer", function(...) return SetTimer( ... ) end, "Set the timer.", FCVAR_CHEAT )
	Convars:RegisterCommand( "overthrow_force_end_game", function(...) return self:EndGame( DOTA_TEAM_GOODGUYS ) end, "Force the game to end.", FCVAR_CHEAT )
	Convars:SetInt( "dota_server_side_animation_heroesonly", 0 )

	COverthrowGameMode:SetUpFountains()
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, 1 ) 

	-- Spawning monsters
	spawncamps = {}
	for i = 1, self.numSpawnCamps do
		local campname = "camp"..i.."_path_customspawn"
		spawncamps[campname] =
		{
			NumberToSpawn = RandomInt(3,5),
			WaypointName = "camp"..i.."_path_wp1" --8 7 6 3 2
		}
	end

	GameRules:SetPostGameLayout( DOTA_POST_GAME_LAYOUT_SINGLE_COLUMN )
	GameRules:SetPostGameColumns( {
		DOTA_POST_GAME_COLUMN_LEVEL,
		DOTA_POST_GAME_COLUMN_ITEMS,
		DOTA_POST_GAME_COLUMN_KILLS,
		DOTA_POST_GAME_COLUMN_DEATHS,
		DOTA_POST_GAME_COLUMN_ASSISTS,
		DOTA_POST_GAME_COLUMN_NET_WORTH,
		DOTA_POST_GAME_COLUMN_DAMAGE,
		DOTA_POST_GAME_COLUMN_HEALING,
	} )
end

---------------------------------------------------------------------------
-- Set up fountain regen
---------------------------------------------------------------------------
function COverthrowGameMode:SetUpFountains()

	LinkLuaModifier( "modifier_fountain_aura_lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_fountain_aura_effect_lua", LUA_MODIFIER_MOTION_NONE )

	local fountainEntities = Entities:FindAllByClassname( "ent_dota_fountain")
	for _,fountainEnt in pairs( fountainEntities ) do
		--print("fountain unit " .. tostring( fountainEnt ) )
		fountainEnt:AddNewModifier( fountainEnt, fountainEnt, "modifier_fountain_aura_lua", {} )
	end
end

---------------------------------------------------------------------------
-- Get the color associated with a given teamID
---------------------------------------------------------------------------
function COverthrowGameMode:ColorForTeam( teamID )
	local color = self.m_TeamColors[ teamID ]
	if color == nil then
		color = { 255, 255, 255 } -- default to white
	end
	return color
end

---------------------------------------------------------------------------
---------------------------------------------------------------------------
function COverthrowGameMode:EndGame( victoryTeam )
	local overBoss = Entities:FindByName( nil, "@overboss" )
	if overBoss then
		local celebrate = overBoss:FindAbilityByName( 'dota_ability_celebrate' )
		if celebrate then
			overBoss:CastAbilityNoTarget( celebrate, -1 )
		end
	end
	
	local tTeamScores = {}
	for team = DOTA_TEAM_FIRST, (DOTA_TEAM_COUNT-1) do
		tTeamScores[team] = GetTeamHeroKills(team)
	end
	GameRules:SetPostGameTeamScores( tTeamScores )

	GameRules:SetGameWinner( victoryTeam )
end

---------------------------------------------------------------------------
-- Put a label over a player's hero so people know who is on what team
---------------------------------------------------------------------------
function COverthrowGameMode:UpdatePlayerColor( nPlayerID )
	if not PlayerResource:HasSelectedHero( nPlayerID ) then
		return
	end

	local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
	if hero == nil then
		return
	end

	local teamID = PlayerResource:GetTeam( nPlayerID )
	local color = self:ColorForTeam( teamID )
	PlayerResource:SetCustomPlayerColor( nPlayerID, color[1], color[2], color[3] )
end


---------------------------------------------------------------------------
-- Simple scoreboard using debug text
---------------------------------------------------------------------------
function COverthrowGameMode:UpdateScoreboard()
	local sortedTeams = {}
	for _, team in pairs( self.m_GatheredShuffledTeams ) do
		table.insert( sortedTeams, { teamID = team, teamScore = GetTeamHeroKills( team ) } )
	end

	-- reverse-sort by score
	table.sort( sortedTeams, function(a,b) return ( a.teamScore > b.teamScore ) end )

	for _, t in pairs( sortedTeams ) do
		local clr = self:ColorForTeam( t.teamID )

		-- Scaleform UI Scoreboard
		local score = 
		{
			team_id = t.teamID,
			team_score = t.teamScore
		}
		FireGameEvent( "score_board", score )
	end
	-- Leader effects (moved from OnTeamKillCredit)
	local leader = sortedTeams[1].teamID
	--print("Leader = " .. leader)
	self.leadingTeam = leader
	self.runnerupTeam = sortedTeams[2].teamID
	self.leadingTeamScore = sortedTeams[1].teamScore
	self.runnerupTeamScore = sortedTeams[2].teamScore
	if sortedTeams[1].teamScore == sortedTeams[2].teamScore then
		self.isGameTied = true
	else
		self.isGameTied = false
	end
	local allHeroes = HeroList:GetAllHeroes()
	for _,entity in pairs( allHeroes) do
		if entity:GetTeamNumber() == leader and sortedTeams[1].teamScore ~= sortedTeams[2].teamScore then
			if entity:IsAlive() == true then
				-- Attaching a particle to the leading team heroes
				local existingParticle = entity:Attribute_GetIntValue( "particleID", -1 )
       			if existingParticle == -1 then
       				local particleLeader = ParticleManager:CreateParticle( "particles/leader/leader_overhead.vpcf", PATTACH_OVERHEAD_FOLLOW, entity )
					ParticleManager:SetParticleControlEnt( particleLeader, PATTACH_OVERHEAD_FOLLOW, entity, PATTACH_OVERHEAD_FOLLOW, "follow_overhead", entity:GetAbsOrigin(), true )
					entity:Attribute_SetIntValue( "particleID", particleLeader )
				end
			else
				local particleLeader = entity:Attribute_GetIntValue( "particleID", -1 )
				if particleLeader ~= -1 then
					ParticleManager:DestroyParticle( particleLeader, true )
					entity:DeleteAttribute( "particleID" )
				end
			end
		else
			local particleLeader = entity:Attribute_GetIntValue( "particleID", -1 )
			if particleLeader ~= -1 then
				ParticleManager:DestroyParticle( particleLeader, true )
				entity:DeleteAttribute( "particleID" )
			end
		end
	end
end

---------------------------------------------------------------------------
-- Update player labels and the scoreboard
---------------------------------------------------------------------------
function COverthrowGameMode:OnThink()
	for nPlayerID = 0, (DOTA_MAX_TEAM_PLAYERS-1) do
		self:UpdatePlayerColor( nPlayerID )
	end
	
	self:UpdateScoreboard()
	-- Stop thinking if game is paused
	if GameRules:IsGamePaused() == true then
        return 1
    end

	if self.countdownEnabled == true then
		CountdownTimer()
		if nCOUNTDOWNTIMER == 30 then
			CustomGameEventManager:Send_ServerToAllClients( "timer_alert", {} )
		end
		if nCOUNTDOWNTIMER <= 0 then
			--Check to see if there's a tie
			if self.isGameTied == false then
				GameRules:SetCustomVictoryMessage( self.m_VictoryMessages[self.leadingTeam] )
				COverthrowGameMode:EndGame( self.leadingTeam )
				self.countdownEnabled = false
				EmitGlobalSound("end")
			else
				self.TEAM_KILLS_TO_WIN = self.leadingTeamScore + 1
				local broadcast_killcount = 
				{
					killcount = self.TEAM_KILLS_TO_WIN
				}
				CustomGameEventManager:Send_ServerToAllClients( "overtime_alert", broadcast_killcount )
				EmitGlobalSound("end")
			end
       	end
	end
	
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--Spawn Gold Bags
		if not self.gameStarted then
            self:GameDotaStart()
            self.gameStarted = true
        end
		COverthrowGameMode:ThinkGoldDrop()
		COverthrowGameMode:ThinkSpecialItemDrop()
	end

	return 1
end

---------------------------------------------------------------------------
-- Scan the map to see which teams have spawn points
---------------------------------------------------------------------------
function COverthrowGameMode:GatherAndRegisterValidTeams()
--	print( "GatherValidTeams:" )

	local foundTeams = {}
	for _, playerStart in pairs( Entities:FindAllByClassname( "info_player_start_dota" ) ) do
		foundTeams[  playerStart:GetTeam() ] = true
	end

	local numTeams = TableCount(foundTeams)
	print( "GatherValidTeams - Found spawns for a total of " .. numTeams .. " teams" )
	
	local foundTeamsList = {}
	for t, _ in pairs( foundTeams ) do
		table.insert( foundTeamsList, t )
	end

	if numTeams == 0 then
		print( "GatherValidTeams - NO team spawns detected, defaulting to GOOD/BAD" )
		table.insert( foundTeamsList, DOTA_TEAM_GOODGUYS )
		table.insert( foundTeamsList, DOTA_TEAM_BADGUYS )
		numTeams = 2
	end

	local maxPlayersPerValidTeam = math.floor( 10 / numTeams )

	self.m_GatheredShuffledTeams = ShuffledList( foundTeamsList )

	print( "Final shuffled team list:" )
	for _, team in pairs( self.m_GatheredShuffledTeams ) do
		print( " - " .. team .. " ( " .. GetTeamName( team ) .. " )" )
	end

	print( "Setting up teams:" )
	for team = 0, (DOTA_TEAM_COUNT-1) do
		local maxPlayers = 0
		if ( nil ~= TableFindKey( foundTeamsList, team ) ) then
			maxPlayers = maxPlayersPerValidTeam
		end
		print( " - " .. team .. " ( " .. GetTeamName( team ) .. " ) -> max players = " .. tostring(maxPlayers) )
		GameRules:SetCustomGameTeamMaxPlayers( team, maxPlayers )
	end
end

-- Spawning individual camps
function COverthrowGameMode:spawncamp(campname)
	spawnunits(campname)
end

-- Simple Custom Spawn
function spawnunits(campname)
	local spawndata = spawncamps[campname]
	local NumberToSpawn = spawndata.NumberToSpawn --How many to spawn
    local SpawnLocation = Entities:FindByName( nil, campname )
    local waypointlocation = Entities:FindByName ( nil, spawndata.WaypointName )
	if SpawnLocation == nil then
		return
	end

    local randomCreature = 
    	{
			"basic_zombie",
			"berserk_zombie"
	    }
	local r = randomCreature[RandomInt(1,#randomCreature)]
	--print(r)
    for i = 1, NumberToSpawn do
        local creature = CreateUnitByName( "npc_dota_creature_" ..r , SpawnLocation:GetAbsOrigin() + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_NEUTRALS )
        --print ("Spawning Camps")
        creature:SetInitialGoalEntity( waypointlocation )
    end
end

--------------------------------------------------------------------------------
-- Event: Filter for inventory full
--------------------------------------------------------------------------------
function COverthrowGameMode:ExecuteOrderFilter( filterTable )
	--[[
	for k, v in pairs( filterTable ) do
		print("EO: " .. k .. " " .. tostring(v) )
	end
	]]

	local orderType = filterTable["order_type"]
	if ( orderType ~= DOTA_UNIT_ORDER_PICKUP_ITEM or filterTable["issuer_player_id_const"] == -1 ) then
		return true
	else
		local item = EntIndexToHScript( filterTable["entindex_target"] )
		if item == nil then
			return true
		end
		local pickedItem = item:GetContainedItem()

		--print(pickedItem:GetAbilityName())
		if pickedItem == nil then
			return true
		end
		if pickedItem:GetAbilityName() == "item_treasure_chest" then
			local player = PlayerResource:GetPlayer(filterTable["issuer_player_id_const"])
			local hero = player:GetAssignedHero()

			-- determine if we can scoop the neutral or not
			-- we need either a free backpack slot or a free neutral item slot
			local bAllowPickup = false
			local hNeutralItem = hero:GetItemInSlot( DOTA_ITEM_NEUTRAL_SLOT )
			if hNeutralItem == nil then
				bAllowPickup = true
				--print( '^^^Empty neutral slot!' )
			else
				local numBackpackItems = 0
				for nItemSlot = 0,DOTA_ITEM_INVENTORY_SIZE - 1 do 
					local hItem = hero:GetItemInSlot( nItemSlot )
					if hItem and hItem:IsInBackpack() then
						numBackpackItems = numBackpackItems + 1
					end
				end
				--print( '^^^Backpack slots = ' .. numBackpackItems )
				if numBackpackItems < 3 then
					bAllowPickup = true
				end
			end		

			if bAllowPickup then
				--print("inventory has space")
				return true
			else
				--print("Moving to target instead")
				local position = item:GetAbsOrigin()
				filterTable["position_x"] = position.x
				filterTable["position_y"] = position.y
				filterTable["position_z"] = position.z
				filterTable["order_type"] = DOTA_UNIT_ORDER_MOVE_TO_POSITION
				return true
			end
		end
	end
	return true
end

--------------------------------------------------------------------------------
function COverthrowGameMode:AssignTeams()
	--print( "Assigning teams" )
	local vecTeamValid = {}
	local vecTeamNeededPlayers = {}
	for nTeam = 0, (DOTA_TEAM_COUNT-1) do
		local nMax = GameRules:GetCustomGameTeamMaxPlayers( nTeam )
		if nMax > 0 then
			--print( "Found team " .. nTeam .. " with max players " .. nMax )
			vecTeamNeededPlayers[ nTeam ] = nMax
			vecTeamValid[ nTeam ] = true
		else
			vecTeamValid[ nTeam ] = false
		end
	end

	-- loop 1: count up players on each team
	local hPlayers = {}
	for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		if PlayerResource:IsValidPlayerID( nPlayerID ) then
			local nTeam = PlayerResource:GetTeam( nPlayerID )
			if vecTeamValid[ nTeam ] == false then
				nTeam = PlayerResource:GetCustomTeamAssignment( nPlayerID )
			end
			--print( "Found player " .. nPlayerID .. " on team " .. nTeam )
			if vecTeamValid[ nTeam ] then
				vecTeamNeededPlayers[ nTeam ] = vecTeamNeededPlayers[ nTeam ] - 1
			else
				table.insert( hPlayers, nPlayerID )
			end
		end
	end

	-- loop 2: assign players. For each player who is on an invalid team,
	-- find the team that has the highest number of needed players
	-- and assign the player to that team
	for _,nPlayerID in pairs( hPlayers ) do
		--print( "Finding team for player " .. nPlayerID )
		local nTeamNumber = -1
		local nHighest = 0
		for nTeam = 0, (DOTA_TEAM_COUNT-1) do
			if vecTeamValid[ nTeam ] then
				local nVal = vecTeamNeededPlayers[ nTeam ]
				if nVal > nHighest then
					--print( "found team " .. nTeam .. " with needed " .. nVal .. " but highest was only " .. nHighest )
					nHighest = nVal
					nTeamNumber = nTeam
				end
			end
		end
		if nTeamNumber > 0 then
			PlayerResource:SetCustomTeamAssignment( nPlayerID, nTeamNumber )
			vecTeamNeededPlayers[ nTeamNumber ] = vecTeamNeededPlayers[ nTeamNumber ] - 1
		end
	end
		
	if self.m_bFillWithBots == true then
		GameRules:BotPopulate()
	end
end

function COverthrowGameMode:MusicLala(event)
    local player = PlayerResource:GetPlayer(event.PlayerID)
    
    if player then
        local hero = player:GetAssignedHero()

        if hero and event.abilityname then
            local abilityName = event.abilityname
            print("Игрок использовал способность:", abilityName)

            if abilityName == "saske_ult" or abilityName == "kakashi3" then
                EmitGlobalSound("chidori_k")
            elseif abilityName == "redanim" then
                EmitGlobalSound("redanim")
            elseif abilityName == "blueanim" then 
            	EmitGlobalSound("blueanim")
            elseif abilityName == "fiolanim" then 
            	EmitGlobalSound("fiolanim")
            elseif abilityName == "counteranim" then 
            	EmitGlobalSound("counteranim")
            elseif abilityName == "yagami3" then
            	EmitGlobalSound("ahahaha")
            elseif abilityName == "yagami2" then
            	EmitGlobalSound("doomya")
            elseif abilityName == "kakashi1" then
            	EmitGlobalSound("kakashi_hole") 
            elseif abilityName == "morphling_replicate" then 
            	EmitGlobalSound("copy_cr")
            elseif abilityName == "dio2" then
            	EmitGlobalSound("muda")
            elseif abilityName == "dio3" then
            	EmitGlobalSound("theworld")
            elseif abilityName == "saske_rinne" then
            	EmitGlobalSound("rinne") -- -createhero npc_dota_hero_antimage enemy
            elseif abilityName == "dio4" then
            	EmitGlobalSound("shine")
            elseif abilityName == "ubauba1" then
            	EmitGlobalSound("uba1")
            elseif abilityName == "ubauba4" then
            	EmitGlobalSound("uba4")
            elseif abilityName == "rema1" then
            	EmitGlobalSound("rema1")
            elseif abilityName == "rema2" then
            	EmitGlobalSound("rema2")
            elseif abilityName == "rema3" then
            	EmitGlobalSound("rema3")
            elseif abilityName == "rema4" then
            	EmitGlobalSound("rema4")
            elseif abilityName == "guts1" then
            	EmitGlobalSound("guts1")
            elseif abilityName == "guts4" then 
            	EmitGlobalSound("guts4")
            elseif abilityName == "narut1" then
            	EmitGlobalSound("narut1")
            elseif abilityName == "rengo1" then
            	EmitGlobalSound("rengo1")
            elseif abilityName == "rengo2" then
            	EmitGlobalSound("rengo2")
            elseif abilityName == "rengo3" then
            	EmitGlobalSound("rengo3")
            elseif abilityName == "rengo4" then
            	EmitGlobalSound("rengo4")
            elseif abilityName == "todgi1" then
            	EmitGlobalSound("todgi1")
            elseif abilityName == "todgi3" then
            	EmitGlobalSound("todgi2")
            elseif abilityName == "todgi4" then
            	EmitGlobalSound("todgi4")
            elseif abilityName == "garou1" then
            	EmitGlobalSound("garou1")
            elseif abilityName == "garou2" then
            	EmitGlobalSound("garou2")
            elseif abilityName == "garou4" then
            	EmitGlobalSound("garou4")
            elseif abilityName == "sait2" then
            	EmitGlobalSound("sait2")
            elseif abilityName == "sait3" then
            	EmitGlobalSound("sait3")
            elseif abilityName == "heal_spell" then
            	EmitGlobalSound("oroch3")
            elseif abilityName == "undying_tombstone" then
            	EmitGlobalSound("oroch4")
            elseif abilityName == "esk1" then
            	EmitGlobalSound("esk1")
            elseif abilityName == "esk4" then
            	EmitGlobalSound("esk4")
            elseif abilityName == "meg3" then
            	EmitGlobalSound("meg3")
            elseif abilityName == "item_treasure_chest" then
            	local gold = 200
 			   	hero:ModifyGold(gold, true, 13)
            end
        end
    end
end

function COverthrowGameMode:GameDotaStart()
	if GetMapName() == "arena_solo" then
	local point1 = Entities:FindByName( nil, "boss_point"):GetAbsOrigin()
	local point2 = Entities:FindByName( nil, "boss_point2"):GetAbsOrigin()
	local point3 = Entities:FindByName( nil, "boss_point3"):GetAbsOrigin()

	CreateUnitByName("npc_dota_neutral_kobold_boss", point1, true, nil, nil, DOTA_TEAM_NEUTRALS)
	CreateUnitByName("npc_dota_neutral_bimbam_boss", point2, true, nil, nil, DOTA_TEAM_NEUTRALS)
	CreateUnitByName("npc_dota_neutral_bimbum_boss", point3, true, nil, nil, DOTA_TEAM_NEUTRALS)
    end
end

