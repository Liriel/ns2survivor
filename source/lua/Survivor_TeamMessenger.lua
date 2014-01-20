//
// lua\Survivor_TeamMessenger.lua
//
//    Created by:   Lassi lassi@heisl.org
//

kSurvivorTeamMessageTypes = enum({ 'SurvivalStarted' })

kTeamMessages[kSurvivorTeamMessageTypes.SurvivalStarted] = { text = { [kMarineTeamType] = "MARINE_TEAM_SURVIVAL_STARTED", [kAlienTeamType] = "ALIEN_TEAM_SURVIVAL_STARTED" } }