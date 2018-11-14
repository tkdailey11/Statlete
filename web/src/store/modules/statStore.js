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
      "FGA" : {
        "Total" : 0
      },
      "FGM" : {
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
    footballOffenseStats: {
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
        "Total" : 0
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
        "Total" : 0
      }
    },
    footballDefenseStats: {
      "FumbleForced" : {
        "Total" : 0
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
      "TotalPassYds" : 0,
      "TotalRushTD" : 0,
      "TotalRushYds" : 0
    },
    footballSpecialStats: {
      "FG" : {
        "TotalAtt" : 0,
        "TotalMade" : 0
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
      }
    }
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
    }
  };
  
  export default {
    namespaced: true,
    state,
    getters,
    mutations
  }
  