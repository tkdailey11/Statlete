// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import App from './App'
import { store } from './store/store';
import router from './router'
import firebase from 'firebase'
import { config } from './helpers/firebaseConfig'
require("firebase/functions");



//Main (Team and Player)
import GamesList from '@/components/MainPageTP/GamesList';
Vue.component('games-list', GamesList);
import PlayersList from '@/components/MainPageTP/PlayersList';
Vue.component('players-list', PlayersList);
import NewPlayer from '@/components/MainPageTP/NewPlayer';
Vue.component('new-player', NewPlayer);
import NewGame from '@/components/MainPageTP/NewGame';
Vue.component('new-game', NewGame);

import NewAdmin from '@/components/NewAdmin';
Vue.component('new-admin', NewAdmin);


import NumericInput from '@/components/NumericInput';
Vue.component('statlete-num-input', NumericInput)


//Navigation
import NavComponent from '@/components/Navigation/NavComponent';
Vue.component('nav-component', NavComponent);
import UploadPhoto from '@/components/UploadPhoto';
Vue.component('upload-photo', UploadPhoto)



//Game.vue
import GameView from '@/components/Game/GameView';
Vue.component('game-view', GameView);
import PeriodMarker from '@/components/Game/PeriodMarker';
Vue.component('period-marker', PeriodMarker);
import SBdataEntry from '@/components/Game/SBdataEntry';
Vue.component('sb-data-entry', SBdataEntry);
import SBfield from '@/components/Game/SBfield';
Vue.component('sb-field', SBfield);
import SBshotType from '@/components/Game/SBshotType';
Vue.component('sb-shot-type', SBshotType);
import PlayerStatSelector from '@/components/Game/PlayerStatSelector';
Vue.component('player-stat-selector', PlayerStatSelector);
import TeamStats from '@/components/Game/TeamStats';
Vue.component('team-stats', TeamStats);
import TimeClock from '@/components/Game/TimeClock';
Vue.component('time-clock', TimeClock);




//Not in use
import PlayerHome from '@/components/Router/PlayerHome';
Vue.component('player-home', PlayerHome);
import PlayerSettings from '@/components/Router/PlayerSettings';
Vue.component('player-settings', PlayerSettings);
import PlayerDetailView from '@/components/Router/PlayerDetailView';
Vue.component('player-detail-view', PlayerDetailView);
import TeamSettings from '@/components/Router/TeamSettings';
Vue.component('team-settings', TeamSettings);
import FLP from '@/components/Router/FirstLandingPage';
Vue.component('landing-page', FLP);
import AnalysisPage from '@/components/Router/AnalysisPage';
Vue.component('analysis-page', AnalysisPage)



//Wizards
import WizardP from '@/components/Wizards/WizardP';
Vue.component('tkd-wizardP', WizardP);
import WizardT from '@/components/Wizards/WizardT';
Vue.component('team-wizard', WizardT);
import WizardPlayer from '@/components/Wizards/WizardPlayer';
Vue.component('wizard-player', WizardPlayer);
import PlayerSelectionBox from '@/components/Wizards/PlayerSelectionBox';
Vue.component('player-selection-box', PlayerSelectionBox);
import PlayerEntryBox from '@/components/Wizards/PlayerEntryBox';
Vue.component('player-entry-box', PlayerEntryBox);
import SelectSport from '@/components/Wizards/SelectSport';
Vue.component('select-sport', SelectSport);



//Charts
import BarChartContainer from '@/components/Charts/BarChartContainer';
Vue.component('bar-container', BarChartContainer);
import MyBarChart from '@/components/Charts/MyBarChart';
Vue.component('bar-chart', MyBarChart);
import OtherBarChart from '@/components/Charts/OtherBarChart';
Vue.component('other-bar-chart', OtherBarChart);
import MyLineChart from '@/components/Charts/MyLineChart';
Vue.component('line-chart', MyLineChart);
import MyDoughnutChart from '@/components/Charts/MyDoughnutChart';
Vue.component('doughnut-chart', MyDoughnutChart);

import FootballGame from '@/components/FootballGame';
Vue.component('football-game', FootballGame);

import FootballOffense from '@/components/FootballOffense';
Vue.component('football-offense', FootballOffense);

import FootballDefense from '@/components/FootballDefense';
Vue.component('football-defense', FootballDefense);

import FootballSpecial from '@/components/FootballSpecial';
Vue.component('football-special', FootballSpecial);


//External
import VModal from 'vue-js-modal'
Vue.use(VModal)
import Vue2TouchEvents from 'vue2-touch-events'
Vue.use(Vue2TouchEvents)
import VuejsDialog from "vuejs-dialog"
Vue.use(VuejsDialog)
import GroupButton from 'vue-libs-radio-group';
Vue.component('group-button', GroupButton);
import dropdown from 'vue-dropdowns'
Vue.component('dropdown', dropdown);
import jQuery from 'jquery'
global.jQuery = jQuery
import popper from 'popper.js'
global.Popper = popper
let Bootstrap = require('bootstrap')
import 'vue-awesome/icons'
import Icon from 'vue-awesome/components/Icon'
Vue.component('icon', Icon)
import ToggleButton from 'vue-js-toggle-button'
Vue.use(ToggleButton)
import vSelect from 'vue-select'
Vue.component('v-select', vSelect)
import VueScrollPicker from 'vue-scroll-picker'
Vue.use(VueScrollPicker)
import WheelNumber from 'vue-wheel-number'
Vue.use(WheelNumber)
import Multiselect from 'vue-multiselect'
Vue.component('multiselect', Multiselect)
import VueScrollingTable from 'vue-scrolling-table';
Vue.component('vue-scrolling-table', VueScrollingTable);
import VueNumericInput from 'vue-numeric-input';
Vue.use(VueNumericInput)

import VueExpandPanel from 'vue-expand-panel'
import 'vue-expand-panel/dist/vue-expand-panel.css'
Vue.use(VueExpandPanel)

import Vuetify from 'vuetify'
import 'vuetify/dist/vuetify.min.css'
import 'material-design-icons-iconfont/dist/material-design-icons.css'
Vue.use(Vuetify)

import { library } from '@fortawesome/fontawesome-svg-core';
import { faBasketballBall, faFutbol, faFootballBall } from '@fortawesome/free-solid-svg-icons';
import { faJs, faVuejs } from '@fortawesome/free-brands-svg-icons';
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome';
library.add(faBasketballBall, faFutbol, faFootballBall, faJs, faVuejs);
Vue.component('font-awesome-icon', FontAwesomeIcon)

// import Simplert from 'vue2-simplert'
// import 'vue2-simplert/dist/simplert.css'
// Vue.component('simplert', Simplert)
import VueFlashMessage from 'vue-flash-message';
import 'vue-flash-message/dist/vue-flash-message.min.css';
Vue.use(VueFlashMessage);



//Stylesheets
import './assets/stylesheets/vuejs-dialog.min.css'
import './assets/stylesheets/bootstrap.min.css'
import './assets/stylesheets/bootstrap-social.css'
import './assets/stylesheets/vue-multiselect.min.css'
//import './assets/stylesheets/master_colors_light.scss'
import './assets/stylesheets/master_colors_dark.scss'

Vue.config.productionTip = false

function reload(){
  location.reload();
}

let app;
firebase.initializeApp(config);

firebase.auth().onAuthStateChanged(function(user) {
  if(!app) {
    app = new Vue({
      el: '#app',
      router,
      store,
      components: { App },
      template: '<App/>'
    })
  }
});
