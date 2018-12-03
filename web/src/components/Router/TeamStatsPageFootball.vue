<template>
  <div class="TeamStatsPage">
        <nav-component />
        <h1 class="teamStatsH1">Team Totals</h1>
        <div id="teamstatspage_main">
            <vue-scrolling-table
                        :scroll-horizontal="scrollHorizontal" v-if="loaded"
                        :scroll-vertical="scrollVertical"
                        :sync-header-scroll="syncHeaderScroll"
                        :sync-footer-scroll="false"
                        :include-footer="false"
                        :dead-area-color="deadAreaColor"
                        :class="{ freezeFirstColumn:freezeFirstColumn }"
                        style="border: 5px solid rgb(224, 0, 16);
                            border-radius: 5px;
                            background-color: rgb(85, 85, 85);
                            height: 25vh;">
                <template slot="thead">
                <tr>
                    <th style="border-right: medium solid black; border-bottom: medium solid black;">OFFENSE</th>
                    <th v-for="stat in footballOffenseArr" 
                        :key="stat + '-hd'"
                        style="border-bottom: medium solid black;">
                        {{ stat }}
                    </th>
                </tr>
                </template>
                <template slot="tbody">
                <tr v-for="game in gamesList" :key="game + '-key'">
                    <th style="border-right: medium solid black;">{{game}}</th>
                    <td v-for="stat in footballOffenseArr" :key="stat + '-' + 'statType'">
                      <input v-model="dataPointsArr[game]['Offense'][stat].Total">
                    </td>
                </tr>
                </template>
            </vue-scrolling-table>
            <vue-scrolling-table
                        :scroll-horizontal="scrollHorizontal" v-if="loaded"
                        :scroll-vertical="scrollVertical"
                        :sync-header-scroll="syncHeaderScroll"
                        :sync-footer-scroll="false"
                        :include-footer="false"
                        :dead-area-color="deadAreaColor"
                        :class="{ freezeFirstColumn:freezeFirstColumn }"
                        style="border: 5px solid rgb(224, 0, 16);
                            border-radius: 5px;
                            background-color: rgb(85, 85, 85);
                            height: 25vh;
                            margin-top: 1vh;">
                <template slot="thead">
                <tr>
                    <th style="border-right: medium solid black; border-bottom: medium solid black;">DEFENSE</th>
                    <th v-for="stat in footballDefenseArr" 
                        :key="stat + '-hd'"
                        style="border-bottom: medium solid black;">
                        {{ stat }}
                    </th>
                </tr>
                </template>
                <template slot="tbody">
                <tr v-for="game in gamesList" :key="game + '-key'">
                    <th style="border-right: medium solid black;">{{game}}</th>
                    <td v-for="stat in footballDefenseArr" :key="stat + '-' + 'statType'">
                      {{dataPointsArr[game]['Defense'][stat].Total}}
                    </td>
                </tr>
                </template>
            </vue-scrolling-table>
                        <vue-scrolling-table
                        :scroll-horizontal="scrollHorizontal" v-if="loaded"
                        :scroll-vertical="scrollVertical"
                        :sync-header-scroll="syncHeaderScroll"
                        :sync-footer-scroll="false"
                        :include-footer="false"
                        :dead-area-color="deadAreaColor"
                        :class="{ freezeFirstColumn:freezeFirstColumn }"
                        style="border: 5px solid rgb(224, 0, 16);
                            border-radius: 5px;
                            background-color: rgb(85, 85, 85);
                            height: 25vh;
                            margin-top: 1vh;
                            margin-bottom: 5vh;">
                <template slot="thead">
                <tr>
                    <th style="border-right: medium solid black; border-bottom: medium solid black;">SPECIAL TEAMS</th>
                    <th v-for="stat in footballTeamStatsSpecialArr" 
                        :key="stat + '-hd'"
                        style="border-bottom: medium solid black;">
                        {{ stat }}
                    </th>
                </tr>
                </template>
                <template slot="tbody">
                <tr v-for="game in gamesList" :key="game + '-key'">
                    <th style="border-right: medium solid black;">{{game}}</th>
                    <td v-for="stat in footballTeamStatsSpecialArr" :key="stat + '-' + 'statType'">
                      {{dataPointsArr[game]['Special'][stat].Total}}
                    </td>
                </tr>
                </template>
            </vue-scrolling-table>
        </div>
  </div>
</template>

<script>
  import firebase from 'firebase'
  import { mapGetters, mapMutations } from 'vuex';

  export default {
    name: 'TeamStatsPage',
    data() {
      return {
        gameData : {},
        statTypes: ["Assists",
                    "Corners",
                    "Crosses",
                    "Fouls",
                    "Goals",
                    "Minutes",
                    "Offsides",
                    "Red Cards",
                    "Saves",
                    "Shots",
                    "Shots on Goal",
                    "Yellow Cards"],
        playerData: {},
        loggedInUser: '',
        currentUserEmail: '',
        scrollVertical: true,
        scrollHorizontal: true,
        syncHeaderScroll: true,
        deadAreaColor: "#DDDDDD",
        maxRows: 100,
        freezeFirstColumn: true,
        gameDataRef: null,
        dataPointsArr: null,
        loaded: false
      }
    },
    computed: {
       ...mapGetters({
        activeGameId: 'mainStore/activeGameId',
        players: 'mainStore/players',
        selectedTeamId: 'mainStore/selectedTeamId',
        selectedTeamSport: 'mainStore/selectedTeamSport',
        basketballPlayerStats: 'statStore/basketballPlayerStats',
        soccerPlayerStats: 'statStore/soccerPlayerStats',
        gamesList: 'mainStore/gamesList',
        footballOffenseArr: 'statStore/footballOffenseArr',
        footballOffenseStats: 'statStore/footballOffenseStats',
        footballDefenseArr: 'statStore/footballDefenseArr',
        footballDefenseStats: 'statStore/footballDefenseStats',
        footballSpecialArr: 'statStore/footballSpecialArr',
        footballTeamStatsSpecial: 'statStore/footballTeamStatsSpecial',
        footballTeamStatsSpecialArr: 'statStore/footballTeamStatsSpecialArr'
      }),
      playerNumbers() {
        return Object.keys(this.players);
      },
      isSoccer: function() {
        return this.selectedTeamSport == 1;
      }
    },
    methods: {
      goBack: function() {
        this.$emit('TeamStatsPageClose');
      },
      refreshStats: async function() {
        console.log(this.dataPointsArr)
        this.loaded = false
        var self = this;
        var dbRef = firebase.database().ref('/FootballGames/' + this.selectedTeamId);
        var promiseList = []
        var localDataPoints = {}
        promiseList.push(this.gamesList.forEach(function(el){
            dbRef.child(el).once('value', function(snap){
                var obj = snap.val()
                var opposingTeamName = obj['OpponentTeamName']
                var date = obj['Date']
                var offStats = obj.Totals.Offense;
                var defStats = obj.Totals.Defense;
                var specialStats = obj.Totals.Special;

                var specialTeamStats = {}

                self.footballTeamStatsSpecialArr.forEach(val => {
                  switch(val){
                    case 'FGAttempted':
                      specialTeamStats[val] = {
                        "Total": specialStats['FG'].TotalAtt
                      }
                      break;
                    case 'FGMade':
                      specialTeamStats[val] = {
                        "Total": specialStats['FG'].TotalMade
                      }
                      break;
                    case 'KickoffReturns':
                      specialTeamStats[val] = {
                        "Total": specialStats['KickRet'].TotalRets
                      }
                      break;
                    case 'KickoffYds':
                      specialTeamStats[val] = {
                        "Total": specialStats['KickRet'].TotalYds
                      }
                      break;
                    case 'PuntRet':
                      specialTeamStats[val] = {
                        "Total": specialStats['PuntRet'].TotalRets
                      }
                      break;
                    case 'PuntRetTD':
                      specialTeamStats[val] = {
                        "Total": specialStats['PuntRet'].TotalTD
                      }
                      break;
                    case 'PuntRetYds':
                      specialTeamStats[val] = {
                        "Total": specialStats['PuntRet'].TotalYds
                      }
                      break;
                    case 'XPAtt':
                      specialTeamStats[val] = {
                        "Total": specialStats['XP'].TotalAtt
                      }
                      break;
                    case 'XPMade':
                      specialTeamStats[val] = {
                        "Total": specialStats['XP'].TotalMade
                      }
                      break;
                    case 'TotalFGAllowed':
                      specialTeamStats[val] = {
                        "Total": specialStats['TotalFGAllowed']
                      }
                      break;
                    case 'TotalTDAllowed':
                      specialTeamStats[val] = {
                        "Total": specialStats['TotalTDAllowed']
                      }
                      break;
                    default:
                      specialTeamStats[val] = {
                        "Total": specialStats['TotalXPAllowed']
                      }
                      break;
                  }
                })

                localDataPoints[el] = {
                    'Date' : date,
                    'OpposingTeam': opposingTeamName,
                    'Offense': offStats,
                    'Defense': defStats,
                    'Special': specialTeamStats
                }
            })
        }))
        
        await Promise.all(promiseList).then(() => {
          
          //self.dataPointsArr = localDataPoints
          return localDataPoints
        })
      }
    }, 
    watch: {
      dataPointsArr: {
        handler: function(){
        this.vm.$forceUpdate()
        },
        deep: true
      }
    },
    async created() {
      this.loggedInUser = firebase.auth().currentUser;
      this.currentUserEmail = this.loggedInUser.email;
      var self = this
      // this.gamesList.forEach(function(el){
      //   self.dataPointsArr[el] = {
      //     'Date': 'date',
      //     'OpposingTeam': 'opponent',
      //     'Offense': self.footballOffenseStats,
      //     'Defense': self.footballDefenseStats,
      //     'Special': self.footballTeamStatsSpecial
      //   }
      // })
      this.dataPointsArr = await this.refreshStats();
      this.loaded = true;
    },
    mounted() {
      
    }
  }
</script>

<style scoped>
  #teamstatspage_main {
    width: 80vw;
    height: 60vh;
    margin-top: 5vh;
    margin-left: 10vw;
    margin-right: 10vw;
  }
  .TeamStatsPage {
    overflow-x: scroll;
    height: 100vh;
  }
  th, td {
    color: black;
  }

  table.scrolling td {
    border: none;
  }

  table.scrolling .w2 {
    width: 20em;
    min-width: 20em;
    max-width: 20em;
  }
  table.scrolling tfoot tr th {
    width: 130em;
    min-width: 130em;
    max-width: 130em;
  }
  table.freezeFirstColumn thead tr,
  table.freezeFirstColumn tbody tr {
    display: block;
    width: min-content;
  }
  table.freezeFirstColumn thead td:first-child,
  table.freezeFirstColumn tbody td:first-child,
  table.freezeFirstColumn thead th:first-child,
  table.freezeFirstColumn tbody th:first-child {
    position: sticky;
    position: -webkit-sticky;
    left: 0;
  }
  
  .box {
    clear: both;
    padding: 0;
    min-height: 300px;
    height: 40vh;
    margin-left: auto;
    margin-right: auto;
    overflow: hidden;
  }

  .vue-numeric-input input{
    border: none;
  }

  .teamStatsH1 {
    margin-top: 5vh;
  }
</style>
