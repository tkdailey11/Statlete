<template>
  <div class="TeamStatsPage">
        <nav-component />
        <h1 class="teamStatsH1">Team Totals</h1>
        <div id="teamstatspage_main">
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
                            background-color: rgb(85, 85, 85);">
                <template slot="thead">
                <tr>
                    <th style="border-right: medium solid black; border-bottom: medium solid black;"></th>
                    <th v-for="stat in statTypes" 
                        :key="stat + '-hd'"
                        style="border-bottom: medium solid black;">
                        {{ stat }}
                    </th>
                </tr>
                </template>
                <template slot="tbody">
                <tr v-for="p in playerNumbers" :key="p + '-key'">
                    <th style="border-right: medium solid black;">{{ p.replace('p', '#')}}</th>
                    <td v-for="statType in statTypes" :key="p + '-' + statType">
                      <statlete-num-input :align="'center'" v-model="playerData[p][statType]" :controls="false" @change="statChanged({'STAT': statType, 'PLAYER': p})"></statlete-num-input>
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
        gameDataRef: null
      }
    },
    computed: {
       ...mapGetters({
        activeGameId: 'mainStore/activeGameId',
        players: 'mainStore/players',
        selectedTeamId: 'mainStore/selectedTeamId',
        selectedTeamSport: 'mainStore/selectedTeamSport',
        basketballPlayerStats: 'statStore/basketballPlayerStats',
        soccerPlayerStats: 'statStore/soccerPlayerStats'
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
      cellClick: function(x) {
      },
      getGameData: function() {

      },
      statChanged: function(data) {
        // alert(data.PLAYER + ': ' + data.STAT)
      },
      refreshStats: function() {
        var self = this;
        self.gameDataRef.on('value', function(snap){
          Object.keys(self.playerData).forEach(pl => {
            Object.keys(self.playerData[pl]).forEach(stat => {
              self.playerData[pl][stat] = 0
            })
          })
          Object.keys(snap.val()).forEach(id => {
            var playersObj = snap.val()[id].Players;
            var playersArr = Object.keys(playersObj);
            playersArr.forEach(p => {
              var data = playersObj[p];
              Object.keys(data).forEach(playerStat => {
                self.playerData[p][playerStat] += parseInt(data[playerStat])
              })
            })
          })
          console.log('PLAYER DATA')
          console.log(self.playerData)
          self.$forceUpdate();
        })
      }
    },
    created() {
      this.loggedInUser = firebase.auth().currentUser;
      this.currentUserEmail = this.loggedInUser.email;

      if(this.isSoccer){
        this.gameDataRef = firebase.database().ref('/SoccerGames/' + this.selectedTeamId);
      }
      else {
        this.statTypes = [
          "AST",
          "BLK",
          "DREB",
          "FG3A",
          "FG3M",
          "FG2A",
          "FG2M",
          "FTA",
          "FTM",
          "OREB",
          "PF",
          "STL",
          "TOV"
        ]
        this.gameDataRef = firebase.database().ref('/BasketballGames/' + this.selectedTeamId);
      }
      Object.keys(this.players).forEach(player => {
        if(!this.playerData[player]){
          this.playerData[player] = {}
        }
      })
      Object.keys(this.players).forEach(player => {
        this.statTypes.forEach(stat => {
          if(!this.playerData[player][stat]){
            this.playerData[player][stat] = 0
          }
        })
      })
      this.refreshStats();
      
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
