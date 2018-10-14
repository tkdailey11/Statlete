const state = {
  selectedPlayer: '',
  statString: '',
  shotType: 'gcf',
  shotsArr: [],
  periodStartTime: -1,
  currGameTime: '0:00',
  inProgress: false,
  gameLive: false,
  currentPeriod: -1,
  periodLength: 40
};

const getters = {
  inProgress: state => {
    return state.inProgress;
  },
  gameLive: state => {
    return state.gameLive;
  },
  periodLength: state => {
    return state.periodLength;
  },
  selectedPlayer: state => {
    return state.selectedPlayer;
  },
  statString: state => {
    return state.statString;
  },
  currentPeriod: state => {
    return state.currentPeriod;
  },
  shotType: state => {
    return state.shotType;
  },
  shotsArr: state => {
    return state.shotsArr;
  },
  shotsArrLength: state => {
    return state.shotsArr.length;
  },
  periodStartTime: state => {
    return state.periodStartTime;
  },
  currGameTime: state => {
    return state.currGameTime;
  }
};

const mutations = {
  GV_SET_IN_PROGRESS: (state, payload) => {
    state.inProgress = payload;
  },
  GV_SET_GAME_LIVE: (state, payload) => {
    state.gameLive = payload;
  },
  GV_SET_PERIOD_LENGTH: (state, payload) => {
    state.periodLength = payload;
  },
  GV_SET_PLAYER: (state, payload) => {
    state.selectedPlayer = payload;
  },
  GV_SET_STAT_STRING: (state, payload) => {
    state.statString = payload;
  },
  GV_SET_PERIOD: (state, payload) => {
    state.currentPeriod = payload;
  },
  GV_SET_SHOT_TYPE: (state, payload) => {
    state.shotType = payload;
  },
  GV_SET_SHOTS_ARR: (state, payload) => {
    state.shotsArr = payload;
  },
  GV_APPEND_SHOT: (state, payload) => {
    state.shotsArr.push(payload);
  },
  GV_REMOVE_SHOT: (state, payload) => {
    state.shotsArr.pop();
  },
  GV_SET_PERIOD_START_TIME: (state, payload) => {
    state.periodStartTime = payload;
  },
  GV_SET_CURR_GAME_TIME: (state, payload) => {
    state.currGameTime = payload;
  }
};

export default {
  namespaced: true,
  state,
  getters,
  mutations
}
