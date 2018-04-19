// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import App from './App'
import router from './router'
import firebase from 'firebase'
import { config } from './helpers/firebaseConfig'
import VueFormWizard from 'vue-form-wizard'
import VueGoodWizard from 'vue-good-wizard';

import SelectSport from '@/components/SelectSport';
Vue.component('select-sport', SelectSport);

import PlayerSelectionBox from '@/components/PlayerSelectionBox';
Vue.component('player-selection-box', PlayerSelectionBox);

import PlayerEntryBox from '@/components/PlayerEntryBox';
Vue.component('player-entry-box', PlayerEntryBox);

import GamesList from '@/components/GamesList';
Vue.component('games-list', GamesList);

import PlayersList from '@/components/PlayersList';
Vue.component('players-list', PlayersList);

import Navbar from '@/components/Navbar';
Vue.component('statlete-navbar', Navbar);

import GameView from '@/components/GameView';
Vue.component('game-view', GameView);

import TeamSettings from '@/components/TeamSettings';
Vue.component('team-settings', TeamSettings);

import TeamStats from '@/components/TeamStats';
Vue.component('team-stats', TeamStats);

import PlayerDetailView from '@/components/PlayerDetailView';
Vue.component('player-detail-view', PlayerDetailView);

import SideNav from '@/components/SideNav';
Vue.component('side-nav', SideNav);

import NewPlayer from '@/components/NewPlayer';
Vue.component('new-player', NewPlayer);

import SBdataEntry from '@/components/SBdataEntry';
Vue.component('sb-data-entry', SBdataEntry);

import SBfield from '@/components/SBfield';
Vue.component('sb-field', SBfield);

import SBshotType from '@/components/SBshotType';
Vue.component('sb-shot-type', SBshotType);

import FLP from '@/components/FirstLandingPage';
Vue.component('landing-page', FLP);

import VModal from 'vue-js-modal'
Vue.use(VModal)
import Vue2TouchEvents from 'vue2-touch-events'
Vue.use(Vue2TouchEvents)

import jQuery from 'jquery'
global.jQuery = jQuery
import popper from 'popper.js'
global.Popper = popper
let Bootstrap = require('bootstrap')

import 'bootstrap/dist/css/bootstrap.css'
import './assets/stylesheets/bootstrap-social.css'
import 'vue-form-wizard/dist/vue-form-wizard.min.css'

Vue.config.productionTip = false
Vue.use(VueFormWizard)
Vue.use(VueGoodWizard)

import VueSticky from 'vue-sticky-js';
Vue.use(VueSticky.install);

import VueScrollingTable from "vue-scrolling-table";
Vue.use(VueScrollingTable);
//import { TableComponent, TableColumn } from 'vue-table-component';

//Vue.use(TableComponent);
//Vue.use(TableColumn);

let app;
firebase.initializeApp(config);

firebase.auth().onAuthStateChanged(function(user) {
  if(!app) {
    app = new Vue({
      el: '#app',
      router,
      components: { App },
      template: '<App/>'
    })
  }
});
