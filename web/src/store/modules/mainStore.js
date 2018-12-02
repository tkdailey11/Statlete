const state = {
  loggedInUser: '',
  currentUserEmail: '',
  currentUserName: '',
  activeGameId: '',
  selectedTeam: {
    id: '',
    name: '',
    token: '',
    sport: 0
  },
  players: [],
  playerList: {},
  gamesList: [],
  myColor: 'rgba(224, 0, 16, 0.75)',
  mySecondaryColor: 'rgba(247,204,78, 0.9)',
  oppColor: 'rgba(247,204,78, 0.9)',
  sportfolioType: 'team'
};

const getters = {
  sportfolioType: state => {
    return state.sportfolioType;
  },
  mySecondaryColor: state => {
    return state.mySecondaryColor;
  },
  myColor: state => {
    return state.myColor;
  },
  oppColor: state=> {
    return state.oppColor;
  },
  currentUserName: state => {
    return state.currentUserName;
  },
  playerList: state => {
    return state.playerList;
  },
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
  SET_SECONDARY_COLOR: (state, payload) => {
    state.mySecondaryColor = payload;
  },
  SET_MY_COLOR: (state, payload) => {
    state.myColor = payload;
  },
  SET_OPP_COLOR: (state, payload) => {
    state.oppColor = payload;
  },
  SET_CURRENT_USER_NAME: (state, payload) => {
    state.currentUserName = payload;
  },
  SET_PLAYER_LIST: (state, payload) => {
    state.playerList = payload;
  },
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
  },
  CLEAR_STATE: (state, payload) => {
    state.loggedInUser = '';
    state.currentUserEmail = '';
    state.currentUserName = '';
    state.activeGameId = '';
    state.selectedTeam = {
      id: '',
      name: '',
      token: '',
      sport: 0
    };
    state.players = [];
    state.playerList = {};
    state.gamesList = [];
  }
};

export default {
  namespaced: true,
  state,
  getters,
  mutations
}
