const state = {
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
          "Side": {
            "Right": 0,
            "Left": 0,
            "Middle": 0
          }
        },
        "TotalRushTD" : 0,
        "TotalRushYds" : {
          "Total" : 0,
          "Side": {
            "Right": 0,
            "Left": 0,
            "Middle": 0
          }
        }
    }
}

const getters = {
    footballDefenseStats: state => {
        return state.footballDefenseStats;
    }
}

export default {
    namespaced: true,
    state,
    getters
  }