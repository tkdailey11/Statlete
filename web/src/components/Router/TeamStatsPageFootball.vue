<template>
  <div class="TeamStatsPage">
        <nav-component />
        <h1 class="teamStatsH1">Team Totals</h1>
        <div id="teamstatspage_main">
            <!-- <vue-scrolling-table
                        :scroll-horizontal="scrollHorizontal"
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
                        :scroll-horizontal="scrollHorizontal"
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
                        :scroll-horizontal="scrollHorizontal"
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
            </vue-scrolling-table> -->
            <template>
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
            </template>

                        <template>
              <v-data-table
                :headers="defHeaders"
                :items="defenseArr"
                class="elevation-1"
                style="margin-top: 5vh;"
              >
                <template slot="items" slot-scope="props">
                  <td>{{ props.item.gameID }}</td>
                  <td class="text-xs-right" v-for="type in footballOffenseArr" :key="'offense-' + type">{{ props.item[type] }}</td>
                </template>
              </v-data-table>
            </template>
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
        headers: [
          {
            text: 'Dessert (100g serving)',
            align: 'left',
            sortable: false,
            value: 'name'
          },
          { text: 'Calories', value: 'calories' },
          { text: 'Fat (g)', value: 'fat' },
          { text: 'Carbs (g)', value: 'carbs' },
          { text: 'Protein (g)', value: 'protein' },
          { text: 'Iron (%)', value: 'iron' }
        ],
        defHeaders: [
          {
            text: 'Dessert (100g serving)',
            align: 'left',
            sortable: false,
            value: 'name'
          },
          { text: 'Calories', value: 'calories' },
          { text: 'Fat (g)', value: 'fat' },
          { text: 'Carbs (g)', value: 'carbs' },
          { text: 'Protein (g)', value: 'protein' },
          { text: 'Iron (%)', value: 'iron' }
        ],
        desserts: [
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
          },
          {
            value: false,
            name: 'Eclair',
            calories: 262,
            fat: 16.0,
            carbs: 23,
            protein: 6.0,
            iron: '7%'
          },
          {
            value: false,
            name: 'Cupcake',
            calories: 305,
            fat: 3.7,
            carbs: 67,
            protein: 4.3,
            iron: '8%'
          },
          {
            value: false,
            name: 'Gingerbread',
            calories: 356,
            fat: 16.0,
            carbs: 49,
            protein: 3.9,
            iron: '16%'
          },
          {
            value: false,
            name: 'Jelly bean',
            calories: 375,
            fat: 0.0,
            carbs: 94,
            protein: 0.0,
            iron: '0%'
          },
          {
            value: false,
            name: 'Lollipop',
            calories: 392,
            fat: 0.2,
            carbs: 98,
            protein: 0,
            iron: '2%'
          },
          {
            value: false,
            name: 'Honeycomb',
            calories: 408,
            fat: 3.2,
            carbs: 87,
            protein: 6.5,
            iron: '45%'
          },
          {
            value: false,
            name: 'Donut',
            calories: 452,
            fat: 25.0,
            carbs: 51,
            protein: 4.9,
            iron: '22%'
          },
          {
            value: false,
            name: 'KitKat',
            calories: 518,
            fat: 26.0,
            carbs: 65,
            protein: 7,
            iron: '6%'
          }
        ],
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
        testArr: []
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
      this.footballDefenseArr.forEach(stat => {
        this.defHeaders.push({
          'text': stat,
          'value': 'gameID'
        })
      })

      this.offenseArr = []
      this.defenseArr = []

      this.testArr.forEach(obj => {
        if(typeof obj.Defense !== 'undefined' && typeof obj.Offense !== 'undefined'){
          var offObj = obj.Offense
          var defObj = obj.Defense
          var tmp = {'value': false, 'gameID': obj.id}

          Object.keys(offObj).forEach(key => {
            tmp[key] = offObj[key].Total
          })
          this.offenseArr.push(tmp)

          tmp = {'value': false, 'gameID': obj.id}
          console.log('Def obj')
          console.log(defObj)
          console.log('----------')
          
          console.log('==========')
          Object.keys(defObj).forEach(key => {
            tmp[key] = defObj[key].Total
          })
          this.defenseArr.push(tmp)
        }
      })

      this.defHeaders.forEach(header => {
        console.log(header.text)
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
