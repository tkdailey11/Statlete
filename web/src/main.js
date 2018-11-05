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



//Navigation
import Navbar from '@/components/Navigation/Navbar';
Vue.component('statlete-navbar', Navbar);
import SideNav from '@/components/Navigation/SideNav';
Vue.component('side-nav', SideNav);
import NavComponent from '@/components/Navigation/NavComponent';
Vue.component('nav-component', NavComponent);



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
import VueScrollingTable from 'vue-scrolling-table';
Vue.component('vue-scrolling-table', VueScrollingTable);



//Not in use
import PlayerHome from '@/components/PlayerHome';
Vue.component('player-home', PlayerHome);
import PlayerSettings from '@/components/PlayerSettings';
Vue.component('player-settings', PlayerSettings);
import PlayerDetailView from '@/components/PlayerDetailView';
Vue.component('player-detail-view', PlayerDetailView);
import TeamSettings from '@/components/TeamSettings';
Vue.component('team-settings', TeamSettings);
import FLP from '@/components/FirstLandingPage';
Vue.component('landing-page', FLP);
import AnalysisPage from '@/components/AnalysisPage';
Vue.component('analysis-page', AnalysisPage)



//Wizards
import VueFormWizard from 'vue-form-wizard'
Vue.use(VueFormWizard)
import VueGoodWizard from 'vue-good-wizard';
Vue.use(VueGoodWizard)
import Wizard from '@/components/Wizards/Wizard';
Vue.component('tkd-wizard', Wizard);
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
import SelectSport from '@/components/SelectSport';
Vue.component('select-sport', SelectSport);



//Charts
import MyBarChart from '@/components/Charts/MyBarChart';
Vue.component('bar-chart', MyBarChart);
import MyLineChart from '@/components/Charts/MyLineChart';
Vue.component('line-chart', MyLineChart);



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



//Stylesheets
import 'vuejs-dialog/dist/vuejs-dialog.min.css'
import 'bootstrap/dist/css/bootstrap.css'
import './assets/stylesheets/bootstrap-social.css'
import 'vue-form-wizard/dist/vue-form-wizard.min.css'



Vue.config.productionTip = false

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
