<template>
  <div class="TeamStatsPage">
        <nav-component />
        <h1 class="teamStatsH1">Team Totals</h1>
        <div id="teamstatspage_main">
          <v-card>
            <v-card-title>
              Offense
              <v-spacer></v-spacer>
            </v-card-title>
            <v-data-table
              :headers="headers"
              :items="offenseArr"
              class="elevation-1"
            >
              <template slot="items" slot-scope="props">
                <td>{{ props.item.gameID }}</td>
                <td class="text-xs-right" v-for="type in footballOffenseArr" :key="'offense-' + type">{{ props.item[type] }}</td>
              </template>
            </v-data-table>
          </v-card>

          <v-card style="margin-top: 5vh;">
            <v-card-title>
              Defense
              <v-spacer></v-spacer>
            </v-card-title>
            <v-data-table
              :headers="defHeaders"
              :items="defenseArr"
              class="elevation-1"
            >
              <template slot="items" slot-scope="props">
                <td>{{ props.item.gameID }}</td>
                <td class="text-xs-right" v-for="type in defKeys" :key="'defense-' + type">{{ props.item[type] }}</td>
              </template>
            </v-data-table>
          </v-card>

          <v-card style="margin-top: 5vh; margin-bottom: 5vh;">
            <v-card-title>
              Special Teams
              <v-spacer></v-spacer>
            </v-card-title>
            <v-data-table
              :headers="specialHeaders"
              :items="specialArr"
              class="elevation-1"
            >
              <template slot="items" slot-scope="props">
                <td>{{ props.item.gameID }}</td>
                <td class="text-xs-right" v-for="type in specialKeys" :key="'special-' + type">{{ props.item[type] }}</td>
              </template>
            </v-data-table>
          </v-card>
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
        dataPointsArr: {},
        loaded: false,
        headers: [],
        defHeaders: [],
        specialHeaders: [],
        offenseArr: [
          {
            value: false,
            name: 'Frozen Yogurt',
            calories: 159,
            fat: 6.0,
            carbs: 24,
            protein: 4.0,
            iron: '1%'
          },
          {
            value: false,
            name: 'Ice cream sandwich',
            calories: 237,
            fat: 9.0,
            carbs: 37,
            protein: 4.3,
            iron: '1%'
          }
        ],
        defenseArr: [
          {
            value: false,
            name: 'Frozen Yogurt',
            calories: 159,
            fat: 6.0,
            carbs: 24,
            protein: 4.0,
            iron: '1%'
          },
          {
            value: false,
            name: 'Ice cream sandwich',
            calories: 237,
            fat: 9.0,
            carbs: 37,
            protein: 4.3,
            iron: '1%'
          }
        ],
        specialArr: [],
        testArr: [],
        defKeys: [
        "DefTD",
        "FumbleForced",
        "FumbleRec",
        "INT",
        "Sacks",
        "TackleForLoss",
        "Tackles",
        "TotalPassYds",
        "TotalRushYds"
        ],
        specialKeys: [
        ]
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
        this.loaded = false
        var self = this;
        var dbRef = firebase.database().ref('/FootballGames/' + this.selectedTeamId);
        var promiseList = []
        var localDataPoints = []
        this.gamesList.forEach(function(el){
            promiseList.push(dbRef.child(el).once('value', function(snap){
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

                self.testArr.push(
                {
                  'id': el,
                    'Date' : date,
                    'OpposingTeam': opposingTeamName,
                    'Offense': offStats,
                    'Defense': defStats,
                    'Special': specialTeamStats
                })

                
            })
        )})
        await Promise.all(promiseList).then(() => {
          console.log('DONE')
        })
      }
    },
    async created() {
      this.loggedInUser = firebase.auth().currentUser;
      this.currentUserEmail = this.loggedInUser.email;
      var self = this
      await this.refreshStats();

      this.headers = [{
            text: 'Game',
            align: 'left',
            sortable: false,
            value: 'name'
      }]
      this.footballOffenseArr.forEach(stat => {
        this.headers.push({
          'text': stat,
          'value': 'gameID'
        })
      })
      this.defHeaders = [{
            text: 'Game',
            align: 'left',
            sortable: false,
            value: 'name'
      }]
      this.defKeys.forEach(stat => {
        this.defHeaders.push({
          'text': stat,
          'value': 'gameID'
        })
      })

      this.specialHeaders = [{
            text: 'Game',
            align: 'left',
            sortable: false,
            value: 'name'
      }]
      this.specialKeys = []
      Object.keys(this.testArr[0]['Special']).forEach(stat => {
        this.specialKeys.push(stat)
        this.specialHeaders.push({
          'text': stat,
          'value': 'gameID'
        })
      })

      this.offenseArr = []
      this.defenseArr = []
      this.specialArr = []
      
      this.testArr.forEach(obj => {
        if(typeof obj.Defense !== 'undefined' && typeof obj.Offense !== 'undefined'){
          var offObj = obj.Offense
          var defObj = obj.Defense
          var specialObj = obj.Special

          var tmp = {'value': false, 'gameID': obj.id}

          Object.keys(offObj).forEach(key => {
            tmp[key] = offObj[key].Total
          })
          this.offenseArr.push(tmp)

          tmp = {'value': false, 'gameID': obj.id}
          this.defKeys.forEach(key => {
            if(typeof defObj[key] === 'undefined'){
              tmp[key] = 0
            }
            else {
              tmp[key] = typeof defObj[key].Total === 'undefined' ? 0 : defObj[key].Total
            }
            
          })
          this.defenseArr.push(tmp)

          //Special Teams stats
          tmp = {'value': false, 'gameID': obj.id}
          Object.keys(specialObj).forEach(key => {
            if(typeof specialObj[key] === 'undefined'){
              tmp[key] = 0
            }
            else {
              tmp[key] = typeof specialObj[key].Total === 'undefined' ? 0 : specialObj[key].Total
            }
          })
          this.specialArr.push(tmp)
        }
      })

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
