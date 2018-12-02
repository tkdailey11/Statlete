const state = {
  selectedPlayer: '',
  statString: '',
  shotType: 'gcf',
  shotsArr: [],
  periodStartTime: -1,
  currGameTime: '0:00',
  periodLength: 45,
  numberOfPeriods: 2,
  timeRemainingInPeriod: 0,
  plays: {}
};

const getters = {
  plays: state => {
    return state.plays;
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
  },
  numberOfPeriods: state => {
    return state.numberOfPeriods;
  },
  timeRemainingInPeriod: state => {
    return state.timeRemainingInPeriod;
  }
};

const mutations = {
  GV_APPEND_PLAY: (state, payload) => {
    state.plays[payload.key] = payload.val
  },
  GV_SET_PLAYS: (state, payload) => {
    state.plays = payload
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
  },
  GV_CLEAR_STATE: (state, payload) => {
    state.selectedPlayer = '';
    state.statString = '';
    state.shotType = 'gcf';
    state.shotsArr = [];
    state.periodStartTime = -1;
    state.currGameTime = '0:00';
    state.periodLength = 45;
    state.numberOfPeriods = 2;
    state.timeRemainingInPeriod = 0;
  },
  GV_SET_NUM_PERIODS: (state, payload) => {
    state.numberOfPeriods = payload;
  },
  GV_SET_TIME_REMAINING: (state, payload) => {
    state.timeRemainingInPeriod = payload;
  }
};

export default {
  namespaced: true,
  state,
  getters,
  mutations
}
