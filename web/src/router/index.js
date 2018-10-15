import Vue from 'vue'
import Router from 'vue-router'

import Login from '@/components/Login'
import SignUp from '@/components/SignUp'
import firebase from 'firebase'
import Main from '@/components/Main'
import FLP from '@/components/FirstLandingPage'
import GameView from '@/components/GameView'
import TeamSettings from '@/components/TeamSettings'
import TeamStats from '@/components/TeamStats'
import PlayerDetailView from '@/components/PlayerDetailView'
import PlayerHome from '@/components/PlayerHome'
import PlayerSettings from '@/components/PlayerSettings'
import WizardPlayer from '@/components/WizardPlayer'
import WizardT from '@/components/WizardT'
import AnalysisPage from '@/components/AnalysisPage'


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
      path: '/teamsettings',
      name: 'TeamSettings',
      component: TeamSettings,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '/teamstats',
      name: 'TeamStats',
      component: TeamStats,
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
