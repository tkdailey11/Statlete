import Vue from 'vue';
import Vuex from 'vuex';
//import VuexPersist from 'vuex-persist';
import createPersistedState from 'vuex-persistedstate';
import mainStore from './modules/mainStore'
import gameViewStore from './modules/gameViewStore'
import playerStore from './modules/playerStore'
import statStore from './modules/statStore'
import footballStore from './modules/footballStore'

Vue.use(Vuex);

// const vuexLocalStorage = new VuexPersist({
//   key: 'vuex', // The key to store the state on in the storage provider.
//   storage: window.localStorage // or window.sessionStorage or localForage
//   // Function that passes the state and returns the state with only the objects you want to store.
//   // reducer: state => state,
//   // Function that passes a mutation and lets you decide if it should update the state in localStorage.
//   // filter: mutation => (true)
// })

export const store = new Vuex.Store({
    state: {

    },
    getters: {

    },
    mutations: {

    },
    modules: {
      mainStore,
      gameViewStore,
      playerStore,
      statStore,
      footballStore
    },
    //plugins: [vuexLocalStorage.plugin]
    plugins: [createPersistedState()]
});
