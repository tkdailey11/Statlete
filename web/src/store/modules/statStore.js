const state = {
    soccerStats: {
      "Assists" : {
        "Total" : 0
      },
      "Corners" : {
        "Total" : 0
      },
      "Crosses" : {
        "Total" : 0
      },
      "Fouls" : {
        "Total" : 0
      },
      "Goals" : {
        "Total" : 0
      },
      "Offsides" : {
        "Total" : 0
      },
      "Red Cards" : {
        "Total" : 0
      },
      "Saves" : {
        "Total" : 0
      },
      "Shots" : {
        "Total" : 0
      },
      "Shots on Goal" : {
        "Total" : 0
      },
      "Yellow Cards" : {
        "Total" : 0
      }
    },
    basketballStats: {
      "AST" : {
        "Total" : 0
      },
      "BLK" : {
        "Total" : 0
      },
      "DREB" : {
        "Total" : 0
      },
      "OREB" : {
        "Total" : 0
      },
      "FG2A" : {
        "Total" : 0
      },
      "FG2M" : {
        "Total" : 0
      },
      "FG3A" : {
        "Total" : 0
      },
      "FG3M" : {
        "Total" : 0
      },
      "FTA" : {
        "Total" : 0
      },
      "FTM" : {
        "Total" : 0
      },
      "PF" : {
        "Total" : 0
      },
      "STL" : {
        "Total" : 0
      },
      "TOV" : {
        "Total" : 0
      }
    },
    basketballPlayerStats: {
      "AST"  : 0,
      "BLK"  : 0,
      "DREB" : 0,
      "OREB" : 0,
      "FG2A" : 0,
      "FG2M" : 0,
      "FG3A" : 0,
      "FG3M" : 0,
      "FTA"  : 0,
      "FTM"  : 0,
      "PF"   : 0,
      "STL"  : 0,
      "TOV"  : 0
    },
    soccerPlayerStats: {
      "Assists"       : 0,
      "Corners"       : 0,
      "Crosses"       : 0,
      "Goals"         : 0,
      "Offsides"      : 0,
      "Red Cards"     : 0,
      "Saves"         : 0,
      "Shots"         : 0,
      "Shots on Goal" : 0,
      "Yellow Cards"  : 0,
      "Minutes"       : 0
    },
    footballOffenseStats: {
      "Fumble" : {
        "Total": 0
      },
      "INT" : {
        "Total" : 0
      },
      "PassAtt" : {
        "Total" : 0
      },
      "PassComp" : {
        "Total" : 0
      },
      "PassTD" : {
        "Total" : 0
      },
      "PassYds" : {
        "Total" : 0,
        "Side": {
          "Right": 0,
          "Left": 0,
          "Middle": 0
        }
      },
      "RecTD" : {
        "Total" : 0
      },
      "RecYds" : {
        "Total" : 0
      },
      "Receptions" : {
        "Total" : 0
      },
      "RushCarries" : {
        "Total" : 0
      },
      "RushTD" : {
        "Total" : 0
      },
      "RushYds" : {
        "Total" : 0,
        "Side": {
          "Right": 0,
          "Left": 0,
          "Middle": 0
        }
      }
    },
    footballDefenseStats: {
      "FumbleForced" : {
        "Total" : 0
      },
      "DefTD": {
        "Total": 0
      },
      "FumbleRec" : {
        "Total" : 0,
      },
      "INT" : {
        "Total" : 0
      },
      "Sacks" : {
        "Total" : 0
      },
      "TackleForLoss" : {
        "Total" : 0
      },
      "Tackles" : {
        "Total" : 0
      },
      "TotalPassTD" : 0,
      "TotalPassYds" : {
        "Total" : 0,
        "Side" : {
          "Right" : 0,
          "Left" : 0,
          "Middle" : 0
        }
      },
      "TotalRushTD" : 0,
      "TotalRushYds" : {
        "Total" : 0,
        "Side" : {
          "Right" : 0,
          "Left" : 0,
          "Middle" : 0
        }
      }
    },
    footballTeamStatsSpecial: {
      "FGAttempted" : {
        "Total": 0
      },
      "FGMade" : {
        "Total": 0
      },
      "KickoffReturns" : {
        "Total": 0
      },
      "KickoffYds": {
        "Total": 0
      },
      "PuntRet" : {
        "Total": 0
      },
      "PuntRetTD": {
        "Total": 0
      },
      "PuntRetYds": {
        "Total": 0
      },
      "XPAtt" : {
        "Total": 0
      },
      "XPMade": {
        "Total": 0
      },
      "TotalFGAllowed": {
        "Total": 0
      },
      "TotalTDAllowed": {
        "Total": 0
      },
      "TotalXPAllowed": {
        "Total": 0
      }
    },
    footballAskStatlete: {
      "1Down": {
        "PassLeft": 0,
        "PassMiddle": 0,
        "PassRight": 0,
        "RunLeft": 0,
        "RunMiddle": 0,
        "RunRight": 0,
      },
      "2DownAndMedium": {
        "PassLeft": 0,
        "PassMiddle": 0,
        "PassRight": 0,
        "RunLeft": 0,
        "RunMiddle": 0,
        "RunRight": 0,
      },
      "2DownAndLong": {
        "PassLeft": 0,
        "PassMiddle": 0,
        "PassRight": 0,
        "RunLeft": 0,
        "RunMiddle": 0,
        "RunRight": 0,
      },
      "2DownAndShort": {
        "PassLeft": 0,
        "PassMiddle": 0,
        "PassRight": 0,
        "RunLeft": 0,
        "RunMiddle": 0,
        "RunRight": 0,
      },
      "3DownAndLong": {
        "PassLeft": 0,
        "PassMiddle": 0,
        "PassRight": 0,
        "RunLeft": 0,
        "RunMiddle": 0,
        "RunRight": 0,
      },
      "3DownAndMedium": {
        "PassLeft": 0,
        "PassMiddle": 0,
        "PassRight": 0,
        "RunLeft": 0,
        "RunMiddle": 0,
        "RunRight": 0,
      },
      "3DownAndShort": {
        "PassLeft": 0,
        "PassMiddle": 0,
        "PassRight": 0,
        "RunLeft": 0,
        "RunMiddle": 0,
        "RunRight": 0,
      },
      "4DownAndLong": {
        "PassLeft": 0,
        "PassMiddle": 0,
        "PassRight": 0,
        "RunLeft": 0,
        "RunMiddle": 0,
        "RunRight": 0,
      },
      "3DownAndMedium": {
        "PassLeft": 0,
        "PassMiddle": 0,
        "PassRight": 0,
        "RunLeft": 0,
        "RunMiddle": 0,
        "RunRight": 0,
      },
      "4DownAndLong": {
        "PassLeft": 0,
        "PassMiddle": 0,
        "PassRight": 0,
        "RunLeft": 0,
        "RunMiddle": 0,
        "RunRight": 0,
      },
    },
    footballSpecialStats: {
      "FG" : {
        "TotalAtt" : 0,
        "TotalMade" : 0
      },
      "FGDef" : {
        "FGMade": 0,
        "XPMade": 0
      },
      "Kick":{
        "KickTD": 0
      },
      "KickRet" : {
        "TotalRets" : 0,
        "TotalYds" : 0
      },
      "Punt" : {
        "RetYds" : 0,
        "Total" : 0
      },
      "PuntRet" : {
        "TotalRets" : 0,
        "TotalTD" : 0,
        "TotalYds" : 0
      },
      "XP" : {
        "TotalAtt" : 0,
        "TotalMade" : 0
      },
      "TotalFGAllowed": 0,
      "TotalTDAllowed": 0,
      "TotalXPAllowed": 0
    },
    goals: {}
  };
  
  const getters = {
    soccerStats: state => {
      return state.soccerStats;
    },
    basketballStats: state => {
      return state.basketballStats;
    },
    soccerStatsArr: state => {
      return Object.keys(state.soccerStats);
    },
    basketballStatsArr: state => {
      return Object.keys(state.basketballStats);
    },
    basketballPlayerStats: state => {
      return state.basketballPlayerStats;
    },
    soccerPlayerStats: state => {
      return state.soccerPlayerStats;
    },
    goals: state => {
      return state.goals;
    }, 
    footballOffenseStats: state => {
      return state.footballOffenseStats;
    },
    footballDefenseStats: state => {
      return state.footballDefenseStats;
    },
    footballSpecialStats: state => {
      return state.footballSpecialStats;
    },
    footballAskStatlete: state => {
      return state.footballAskStatlete;
    },
    footballOffenseArr: state => {
      return Object.keys(state.footballOffenseStats)
    },
    footballDefenseArr: state => {
      return Object.keys(state.footballDefenseStats)
    },
    footballSpecialArr: state => {
      return Object.keys(state.footballSpecialStats)
    },
    footballTeamStatsSpecial: state => {
      return state.footballTeamStatsSpecial
    },
    footballTeamStatsSpecialArr: state => {
      return Object.keys(state.footballTeamStatsSpecial)
    }
  };
  
  const mutations = {
    SS_ADD_SOCCER_STAT: (state, payload) => {
      state.soccerStats.push(payload);
    },
    SS_REMOVE_SOCCER_STAT: (state, payload) => {
      delete state.soccerStats.payload;
    },
    SS_ADD_BASKETBALL_STAT: (state, payload) => {
      state.basketballStats.push(payload);
    },
    SS_REMOVE_BASKETBALL_STAT: (state, payload) => {
      delete state.basketballStats.payload;
    },
    SS_SET_GOALS: (state, payload) => {
      state.goals = payload;
    },
    SS_UPDATE_GOAL: (state, payload) => {
      state.goals[payload.stat] = payload.val;
    }
  };
  
  export default {
    namespaced: true,
    state,
    getters,
    mutations
  }
  