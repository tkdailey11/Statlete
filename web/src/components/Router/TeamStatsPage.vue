<template>
  <div class="TeamStatsPage">
        <nav-component />
        <h1 class="teamStatsH1">Team Totals</h1>
        <div id="teamstatspage_main">
            <v-card :dark="darkMode">
            <v-card-title>
              My Team
              <v-spacer></v-spacer>
            </v-card-title>
            <v-data-table
              :headers="headers"
              :items="testArr"
              class="elevation-1"
            >
              <template slot="items" slot-scope="props">
                <td>{{ props.item.name }}</td>
                <td class="text-xs-right" v-for="type in statTypes" :key="'offense-' + type" >{{ props.item[type] }}</td>
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
        headers: [{
            text: 'Player Name',
            align: 'left',
            sortable: false,
            value: 'name'
        }],
        playerDataArray: [],
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
        darkMode: 'mainStore/darkMode'
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
      getPlayerArray: function(){
        var tmpArr = []
        Object.keys(this.playerData).forEach(player => {
          tmpArr.push({
            'name': player,
            'data': this.playerData[player]
          })
        })
        this.playerDataArray = tmpArr
      },
      refreshStats: async function() {
        var self = this;
        await self.gameDataRef.on('value', function(snap){
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
        })
        self.getPlayerArray()
      }
    },
    async created() {
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

      this.statTypes.forEach(type => {
        this.headers.push({
          'text': type,
          'value': type
        })
      })
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
      await this.refreshStats();
      this.testArr = []
      this.playerDataArray.forEach(player => {
        var tmp = {'value': false, 'name': player.name}
        var obj = player.data;
        Object.keys(obj).forEach(key => {
          tmp[key] = obj[key]
        })
        this.testArr.push(tmp)
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
