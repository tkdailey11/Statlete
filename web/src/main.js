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
