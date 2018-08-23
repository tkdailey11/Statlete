const state = {
  loggedInUser: '',
  currentUserEmail: '',
  currTeam: {
    id: '',
    name: '',
    token: ''
  },
  activeGameId: '',
  selectedSport: 'basketball',
  selectedTeam: {
    id: '',
    name: '',
    token: ''
  },
  players: []
};

const getters = {
  loggedInUser: state => {
    return state.loggedInUser
  },
  currentUserEmail: state => {
    return state.currentUserEmail
  },
  selectedTeamId: state => {
    return state.selectedTeam.id
  },
  selectedTeamName: state => {
    return state.selectedTeam.name
  },
  selectedTeamToken: state => {
    return state.selectedTeam.token
  },
  teamID: state => {
    return state.currTeam.id
  },
  teamName: state => {
    return state.currTeam.name
  },
  teamToken: state => {
    return state.currTeam.token
  },
  selectedSport: state => {
    return state.selectedSport
  },
  activeGameId: state => {
    return state.activeGameId
  },
  players: state => {
    return state.players
  }
};

const mutations = {
  SET_LOGGED_IN_USER: (state, payload) => {
    state.loggedInUser = payload;
    state.currentUserEmail = state.loggedInUser.email
  },
  SET_SELECTED_TEAM: (state, payload) => {
    state.selectedTeam = payload
  },
  SET_SELECTED_TEAM_ID: (state, payload) => {
    state.selectedTeam.id = payload
  },
  SET_CURR_TEAM: (state, payload) => {
    state.currTeam = payload
  },
  SET_SELECTED_SPORT: (state, payload) => {
    state.selectedSport = payload
  },
  SET_ACTIVE_GAME_ID: (state, payload) => {
    state.activeGameId = payload
  },
  SET_PLAYERS: (state, payload) => {
    state.players = payload
  },
  APPEND_PLAYER: (state, payload) => {
    state.players.push(payload)
  }
};

export default {
  namespaced: true,
  state,
  getters,
  mutations
}
