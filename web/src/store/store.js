import Vue from 'vue';
import Vuex from 'vuex';
import VuexPersist from 'vuex-persist';
import mainStore from './modules/mainStore'
import gameViewStore from './modules/gameViewStore'
import playerStore from './modules/playerStore'

Vue.use(Vuex);

const vuexLocalStorage = new VuexPersist({
  key: 'vuex', // The key to store the state on in the storage provider.
  storage: window.sessionStorage // or window.localStorage or localForage
  // Function that passes the state and returns the state with only the objects you want to store.
  // reducer: state => state,
  // Function that passes a mutation and lets you decide if it should update the state in localStorage.
  // filter: mutation => (true)
})

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
      playerStore
    },
    plugins: [vuexLocalStorage.plugin]
});
