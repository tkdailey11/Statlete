import Vue from 'vue'
import Router from 'vue-router'
import firebase from 'firebase'



import Login from '@/components/Router/Login'
import SignUp from '@/components/Router/SignUp'
import Main from '@/components/Router/Main'
import FLP from '@/components/Router/FirstLandingPage'
import GameView from '@/components/Game/GameView'
import PlayerGameView from '@/components/Game/PlayerGameView'
import TeamSettings from '@/components/Router/TeamSettings'
import TeamStatsPage from '@/components/Router/TeamStatsPage'
import GoalsPage from '@/components/Router/GoalsPage'
import PlayerDetailView from '@/components/Router/PlayerDetailView'
import PlayerHome from '@/components/Router/PlayerHome'
import PlayerSettings from '@/components/Router/PlayerSettings'
import WizardPlayer from '@/components/Wizards/WizardPlayer'
import WizardT from '@/components/Wizards/WizardT'
import AnalysisPage from '@/components/Router/AnalysisPage'
import AboutPage from '@/components/Router/AboutPage'
import FAQPage from '@/components/Router/FAQPage'
import ExportStats from '@/components/Router/ExportStats'
import FootballGame from '@/components/FootballGame'

Vue.use(Router)

let router = new Router({
  routes: [
    {
      path: '*',
      redirect: '/login'
    },
    {
      path: '/',
      redirect: '/login'
    },
    {
      path: '/login',
      name: 'Login',
      component: Login
    },
    {
      path: '/sign-up',
      name: 'SignUp',
      component: SignUp
    },
    {
      path: '/about',
      name: 'AboutPage',
      component: AboutPage
    },
    {
      path: '/faq',
      name: 'FAQPage',
      component: FAQPage
    },
    {
      path: '/main',
      name: 'Main',
      component: Main,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '/flp',
      name: 'FLP',
      component: FLP,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '/gameview',
      name: 'GameView',
      component: GameView,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '/playergameview',
      name: 'PlayerGameView',
      component: PlayerGameView,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '/teamsettings',
      name: 'TeamSettings',
      component: TeamSettings,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '/teamstats',
      name: 'TeamStatsPage',
      component: TeamStatsPage,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '/playerdetail',
      name: 'PlayerDetailView',
      component: PlayerDetailView,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '/playerhome',
      name: 'PlayerHome',
      component: PlayerHome,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '/playersettings',
      name: 'PlayerSettings',
      component: PlayerSettings,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '/createplayer',
      name: 'WizardPlayer',
      component: WizardPlayer,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '/createteam',
      name: 'WizardT',
      component: WizardT,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '/analysis',
      name: 'AnalysisPage',
      component: AnalysisPage,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '/exportstats',
      name: 'ExportStats',
      component: ExportStats,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '/football',
      name: 'FootballGame',
      component: FootballGame,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '/goals',
      name: 'GoalsPage',
      component: GoalsPage,
      meta: {
        requiresAuth: true
      }
    }
  ]
})

router.beforeEach((to, from, next) => {
  let currentUser = firebase.auth().currentUser;
  let requiresAuth = to.matched.some(record => record.meta.requiresAuth);

  if (requiresAuth && !currentUser) {
    next('login')
  }
  else if (!requiresAuth && currentUser){
    next('main')
  }
  else {
    next()
  }
})

export default router
