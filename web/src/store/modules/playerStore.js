const state = {
    isAddGameEnabled: true
};

const getters = {
    isAddGameEnabled: state => {
        return state.isAddGameEnabled;
    }
};

const mutations = {
    PL_SET_ADD_GAME_ENABLED: (state, payload) => {
        state.isAddGameEnabled = payload;
    }
};

export default {
    namespaced: true,
    state,
    getters,
    mutations
}
  