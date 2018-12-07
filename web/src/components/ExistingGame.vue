<template>
    <div class="ExistingPage">
        <v-navigation-drawer
          v-model="sidebar"
          :mini-variant="mini"
          absolute
          :dark="darkMode"
          temporary>
          <v-list class="pa-1">
            <v-list-tile v-if="mini" @click.stop="mini = false">
              <v-list-tile-action>
                <v-icon>chevron_right</v-icon>
              </v-list-tile-action>
            </v-list-tile>
            <v-list-tile v-else @click.stop="mini = true">
              <v-list-tile-action>
                <v-icon right>chevron_left</v-icon>
              </v-list-tile-action>
            </v-list-tile>
            <v-list-tile  v-for="item in menuItems"
                          :key="item.title"
                          @click.stop="goTo(item.path)">
              <v-list-tile >
                <v-list-tile-action>
                  <v-icon>{{item.icon}}</v-icon>
                </v-list-tile-action>
                <v-list-tile-title>{{item.title}}</v-list-tile-title>
              </v-list-tile>
            </v-list-tile>
            <v-list-tile
                @click="TOGGLE_DARK_MODE()">
                  <v-list-tile-action>
                    <v-icon>color_lens</v-icon>
                  </v-list-tile-action>
                  <v-list-tile-title v-text="'Toggle DarkMode'"></v-list-tile-title>
              </v-list-tile>
          </v-list>
        </v-navigation-drawer>
        <v-toolbar app :dark="darkMode">
            <v-toolbar-side-icon @click="sidebar = !sidebar">
            </v-toolbar-side-icon>
            <v-toolbar-title>
                {{appTitle}}
            </v-toolbar-title>
            <v-spacer></v-spacer>
            <v-toolbar-items class="hidden-xs-only">
                <v-btn
                flat
                v-for="item in menuItems"
                :key="item.title"
                :to="item.path">
                <v-icon left :dark="darkMode">{{ item.icon }}</v-icon>
                {{ item.title }}
                </v-btn>
            </v-toolbar-items>
        </v-toolbar>

        <v-content style="margin: 5vh;" id="ex_container">
            <div id="ex_top">
                <v-card :dark="darkMode" id="credsCard">
                    <v-card-title>Credentials</v-card-title>
                    <v-text-field
                        v-model="teamID"
                        label="Team ID"
                        id="ex_idtxt">
                    </v-text-field>
                    <v-text-field
                        v-model="teamToken"
                        label="Team Token"
                        id="ex_tokentxt">
                    </v-text-field>
                    <v-card-actions>
                        <v-btn @click="viewGame" :dark="darkMode">View Live Game</v-btn>
                    </v-card-actions>
                </v-card>
            </div>
            <div id="ex_body">
                <v-card :dark="darkMode" id="eg_statTable">
                    <!-- TOTALS -->
                    <v-card-title>Totals</v-card-title>
                    <table style="width: 100%;">
                        <thead><th>Stat Type</th><th>Team Total</th></thead>
                        <tbody>
                            <tr v-for="stat in totals" :key="stat.type">
                                <td>{{stat.type}}</td>
                                <td>{{stat.total}}</td>
                            </tr>
                        </tbody>
                    </table>
                </v-card>
                <v-card :dark="darkMode" id="eg_playsTable">
                    <!-- PLAYS -->
                    <v-card-title>Plays</v-card-title>
                    <table style="width: 100%;">
                        <thead><th>Team</th><th>Play</th></thead>
                        <tbody v-for="period in periods" :key="period">
                            <tr><td colspan="2" class="eg_periodHeader">{{period}}</td></tr>
                            <tr v-for="play in plays[period]" :key="play">
                                <td class="eg_myTeamPlay dataRow" v-if="play.split(' | ')[0] == 0 && /\S/.test(play)">MY TEAM</td>
                                <td class="eg_oppPlay dataRow" v-else-if="play.split(' | ')[0] == 1">OPPONENT</td>
                                <td class="dataRow" v-if="/\S/.test(play)">{{play.split(' | ')[1]}}</td>
                            </tr>
                        </tbody>
                    </table>
                </v-card>
            </div>
         </v-content>
    </div>
</template>

<script>
import { mapGetters, mapMutations } from 'vuex';
import firebase from 'firebase'
export default {
    data() {
        return {
            appTitle: 'Statlete',
            sidebar: false,
            menuItems: [
            { title: 'Login', path: '/login', icon: 'input' },
            { title: 'Sign Up', path: '/sign-up', icon: 'person_add' },
            { title: 'About', path: '/about', icon: 'info' },
            { title: 'FAQ', path: '/faq', icon: 'question_answer' },
            { title: 'Live Game', path: '/liveview', icon: 'videogame_asset' }
            ],
            mini: true,
            teamID: '',
            teamToken: '',
            totals: [],
            plays: [],
            periods: []
        }
    },
    computed: {
        ...mapGetters({
            darkMode: 'mainStore/darkMode',
            myColor: 'mainStore/myColor',
            oppColor: 'mainStore/oppColor'
        })
    },
    methods: {
        ...mapMutations({
            TOGGLE_DARK_MODE: 'mainStore/TOGGLE_DARK_MODE'
        }),
        goTo: function(path) {
            this.$router.push(path)
        },
        viewGame: async function(){
            var self = this;
            var ref = firebase.database().ref('TeamSportfolios').child(this.teamID);
            var sport = -1
            var lastID = ''
            await ref.once('value', function(snapshot){
                if(snapshot.val()['Token'] !== self.teamToken){
                    alert('Team ID and token do not match, please try again.')
                }
                else {
                    sport = snapshot.val()['Sport']
                    var idArr = Object.keys(snapshot.val()['Games'])
                    lastID = idArr.pop()
                }

            })
            if(sport == 0){
                //bball
                await firebase.database().ref('BasketballGames').child(self.teamID).child(lastID).on('value', function(snap){
                    if(!snap.val().Live){
                        alert('The most recent game for this team is no longer active. Please check back later.')
                    }
                    else {
                        var totalsDB = snap.val()['MyTotals'];
                        var totalsObj = {}
                        Object.keys(totalsDB).forEach(element => {
                            var period = totalsDB[element]
                            Object.keys(period).forEach(dataPt => {
                                var myObj = totalsObj[dataPt]
                                if(myObj == null || typeof myObj === 'undefined'){
                                    totalsObj[dataPt] = period[dataPt].Total
                                }
                                else {
                                    totalsObj[dataPt] += period[dataPt].Total
                                }
                            })
                        })
                        self.totals = []
                        Object.keys(totalsObj).forEach(statType => {
                            self.totals.push({'type': statType, 'total': totalsObj[statType]})
                        })
                        var playsObj = snap.val()['Plays'];
                        self.plays = []
                        self.periods = []
                        var tmpArr = []
                        if(playsObj != null && typeof playsObj !== 'undefined'){
                            Object.keys(playsObj).forEach(key => {
                                self.periods.push(key)
                                tmpArr = []
                                Object.values(playsObj[key]).forEach(po =>{
                                    tmpArr.push(po)
                                })
                                self.plays.push({
                                    [key] : tmpArr
                                })
                            })
                        }
                        console.log('Plays')
                        console.log(self.plays)
                    }
                })
            }
            else if(sport == 1){
                //soccer
                await firebase.database().ref('SoccerGames').child(self.teamID).child(lastID).on('value', function(snap){
                    if(!snap.val().Live){
                        alert('The most recent game for this team is no longer active. Please check back later.')
                    }
                    else {
                        var totalsDB = snap.val()['MyTotals'];
                        var totalsObj = {}
                        Object.keys(totalsDB).forEach(element => {
                            var period = totalsDB[element]
                            Object.keys(period).forEach(dataPt => {
                                var myObj = totalsObj[dataPt]
                                if(myObj == null || typeof myObj === 'undefined'){
                                    totalsObj[dataPt] = period[dataPt].Total
                                }
                                else {
                                    totalsObj[dataPt] += period[dataPt].Total
                                }
                            })
                        })
                        self.totals = []
                        Object.keys(totalsObj).forEach(statType => {
                            self.totals.push({'type': statType, 'total': totalsObj[statType]})
                        })
                        var playsObj = snap.val()['Plays'];
                        self.plays = []
                        self.periods = []
                        var tmpArr = []
                        if(playsObj != null && typeof playsObj !== 'undefined'){
                            Object.keys(playsObj).forEach(key => {
                                self.periods.push(key)
                                tmpArr = []
                                Object.values(playsObj[key]).forEach(po =>{
                                    tmpArr.push(po)
                                })
                                self.plays[key] = tmpArr
                            })
                        }
                        console.log('Plays')
                        console.log(self.plays['Period2'])
                    }
                })
            }
            this.setMyTeamColor()
            this.setOppColor()
        },
        setMyTeamColor(){
            var self = this;
            jQuery('.eg_myTeamPlay').each(function(){
                jQuery(this).css('background-color', self.myColor)
            })
        },
        setOppColor(){
            var self = this;
            jQuery('.eg_oppPlay').each(function(){
            jQuery(this).css('background-color', self.oppColor)
            })
        },
    },
    watch: {
        plays: {
            handler(){
                this.setMyTeamColor()
                this.setOppColor()
            },
            deep: true
        }
    }
}
</script>

<style scoped>
    .ExistingPage {
        min-height: 100vh;
        height: 100%;
    }

    #ex_container {
        display: flex;
        flex-direction: column;
    }

    #ex_top {
        flex-basis: 25%;
    }

    #ex_body {
        flex-basis: 70%;
        margin-top: 5vh;
        display: flex;
    }

    #eg_statTable {
        flex-basis: 45%;
        margin-right: 5%;
    }

    #eg_playsTable {
        flex-basis: 45%;
        margin-left: 5%;
    }

    #ex_idtxt {
        
    }
    #credsCard {
        padding: 0vh 5vw 1vh 5vw;
    }
    .eg_periodHeader {
        border-bottom-width: 3px; 
        border-bottom-style: solid;
        border-top-width: 3px; 
        border-top-style: solid;
    }

    td {
        padding: 7px;
    }

    .dataRow {
        border-bottom-width: 0.5px; 
        border-bottom-style: solid;
    }

    .eg_myTeamPlay, .eg_oppPlay {
        width: 15%;
        padding: 2px;
        font-size: 75%;
    }

      a, i {
    text-decoration: none;
  }
</style>

