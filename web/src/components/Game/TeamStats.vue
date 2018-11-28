<template>
  <div class="TeamStats">
    <div id="teamstats_main">
      <vue-scrolling-table
                :scroll-horizontal="scrollHorizontal"
                :scroll-vertical="scrollVertical"
                :sync-header-scroll="syncHeaderScroll"
                :sync-footer-scroll="false"
                :include-footer="true"
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
              <statlete-num-input :align="'center'" v-model="playerData[p][statType]" :controls="false" @change="statChanged({'STAT': statType, 'PLAYER': p})" readonly></statlete-num-input>
            </td>
          </tr>
        </template>
        <template slot="tfoot">
          <tr><th :colspan="statTypes.length + 1" @click="editClicked" :class="'editStatsBtn'">Edit</th></tr>
        </template>
      </vue-scrolling-table>
    </div>
  </div>
</template>

<script>
  import firebase from 'firebase'
  import { mapGetters, mapMutations } from 'vuex';

  export default {
    name: 'TeamStats',
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
        freezeFirstColumn: true

      }
    },
    computed: {
       ...mapGetters({
        activeGameId: 'mainStore/activeGameId',
        players: 'mainStore/players',
        selectedTeamId: 'mainStore/selectedTeamId',
        selectedTeamSport: 'mainStore/selectedTeamSport'
      }),
      playerNumbers() {
        return Object.keys(this.players);
      },
      isSoccer() {
        return this.selectedTeamSport == 1;
      }
    },
    methods: {
      goBack: function() {
        this.$emit('TeamStatsClose');
        console.log('CLOSE');
      },
      cellClick: function(x) {
        console.log(x);
      },
      getGameData: function() {

      },
      statChanged: function(data) {
        var self = this;
        if(self.isSoccer){
          var ref = firebase.database().ref('/SoccerGames').child(self.selectedTeamId).child(self.activeGameId);
          ref.child('Players').child(data.PLAYER).update({
            [data.STAT]: self.playerData[data.PLAYER][data.STAT]
          })
        }
        else{
          var ref = firebase.database().ref('/BasketballGames').child(self.selectedTeamId).child(self.activeGameId);
          ref.child('Players').child(data.PLAYER).update({
            [data.STAT]: self.playerData[data.PLAYER][data.STAT]
          })
        }
      },
      editClicked: function() {
        this.$emit('EditStats')
      }
    },
    created() {
      this.loggedInUser = firebase.auth().currentUser;
      this.currentUserEmail = this.loggedInUser.email;

      var self = this;
      // var ref = firebase.database().ref('/SoccerGames/' + self.selectedTeamId).child(self.activeGameId).child('MyTotals').child('Period1');
      // ref.once('value', function(snap) {
      //   self.statTypes = Object.keys(snap.val())
      // })
      var gameDataRef = null;

      if(this.isSoccer){
        gameDataRef = firebase.database().ref('/SoccerGames/' + self.selectedTeamId).child(self.activeGameId).child('Players');
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
        gameDataRef = firebase.database().ref('/BasketballGames/' + self.selectedTeamId).child(self.activeGameId).child('Players');
      }
      gameDataRef.on('value', function(snapshot) {
        self.playerData = snapshot.val();
        Object.keys(self.players).forEach(player => {
          if(!self.playerData[player]){
            self.playerData[player] = {}
          }
          self.statTypes.forEach(statType => {
            if(!self.playerData[player][statType]){
              self.playerData[player][statType] = 0
            }
          })
        });
      });

    },
    mounted() {

    }
  }
</script>

<style scoped>
  #teamstats_main {
    height: 400px;
    width: 1090px;
  }
  .TeamStats {
    
  }
  th, td {
    color: black;
  }

  table.scrolling .w2 {
    width: 20em;
    min-width: 20em;
    max-width: 20em;
  }
  table.scrolling tfoot tr th {
    width: 100%;
    min-width: 1090px;
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

  .editStatsBtn:hover {
    cursor: pointer;
  }
</style>
