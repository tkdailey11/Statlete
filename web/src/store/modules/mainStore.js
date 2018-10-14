const state = {
  loggedInUser: '',
  currentUserEmail: '',
  activeGameId: '',
  selectedSport: 'basketball',
  selectedTeam: {
    id: '',
    name: '',
    token: '',
    sport: ''
  },
  players: [],
  gamesList: []
};

const getters = {
  gamesList: state => {
    return state.gamesList;
  },
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
  selectedTeamSport: state => {
    return state.selectedTeam.sport
  },
  activeGameId: state => {
    return state.activeGameId
  },
  players: state => {
    return state.players
  }
};

const mutations = {
  SET_GAMES_LIST: (state, payload) => {
    state.gamesList = payload;
  },
  APPEND_GAME: (state, payload) => {
    state.games.push(payload);
  },
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
  SET_SELECTED_TEAM_TOKEN: (state, payload) => {
    state.selectedTeam.token = payload
  },
  SET_SELECTED_TEAM_SPORT: (state, payload) => {
    state.selectedTeam.sport = payload
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
