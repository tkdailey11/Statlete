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
    <div id="teamstats_graphs">
      <div id="bargraphs">
        <h3 class="tsH3">My Team Totals</h3>
        <bar-chart  :TSData="myTeamBarData"
                    :showGoal="false"
                    :forceUpdate="chartUpdate"
                    id="resultBar"
                    class="statleteChart">
        </bar-chart>
      </div>
      <div id="doughnutCharts">
        <doughnut-chart class="fg2"></doughnut-chart>
        <doughnut-chart class="fg3"></doughnut-chart>
        <doughnut-chart class="ft"></doughnut-chart>
      </div>
    </div>
  </div>
</template>

<script>
  import firebase from 'firebase'
  import { mapGetters, mapMutations } from 'vuex';
import { setTimeout } from 'timers';

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
        freezeFirstColumn: true,
        myTeamBarLabels: [],
        myTeamBarData: {},
        chartUpdate: 0
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
      },
      cellClick: function(x) {
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
      gameDataRef.on('value', function(snapshot) {
        self.playerData = snapshot.val();
        var totals = {}
        Object.keys(self.players).forEach(player => {
          if(!self.playerData[player]){
            self.playerData[player] = {}
          }
          self.statTypes.forEach(statType => {
            if(!totals[statType]){
              totals[statType] = 0;
            }
            if(!self.playerData[player][statType]){
              self.playerData[player][statType] = 0
            }
            totals[statType] += self.playerData[player][statType]
          })
        });
        
        //Update Chart Data
        if(self.isSoccer){
          var dataArr = []
          if(totals['Goals'] !== 'undefined'){
            dataArr.push(totals['Goals'])
          }
          else{
            dataArr.push(0)
          }
          if(totals['Assists'] !== 'undefined'){
            dataArr.push(totals['Assists'])
          }
          else{
            dataArr.push(0)
          }
          if(totals['Shots'] !== 'undefined'){
            dataArr.push(totals['Shots'])
          }
          else{
            dataArr.push(0)
          }
          if(totals['Shots on Goal'] !== 'undefined'){
            dataArr.push(totals['Shots on Goal'])
          }
          else{
            dataArr.push(0)
          }
          if(totals['Fouls'] !== 'undefined'){
            dataArr.push(totals['Fouls'])
          }
          else{
            dataArr.push(0)
          }
          self.myTeamBarLabels = ['Goals', 'Assists', 'Shots', 'Shots on Goal', 'Fouls']
          self.myTeamBarData = {
            labels: ['Goals', 'Assists', 'Shots', 'Shots on Goal', 'Fouls'],
            datasets: [
              {
                'backgroundColor': 'rgba(224, 0, 16, 0.75)',
                'data': dataArr
              }
            ]
          };
          console.log('--------------------')
          console.log(self.myTeamBarData)
          console.log('--------------------')
          
        }
      });

    },
    mounted() {
      var self = this
      setTimeout(function(){
        self.chartUpdate = self.chartUpdate + 1
      }, 1500)
      
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

  #teamstats_graphs {
    width: 100%;
    height: 50vh;
    margin-top: 25px;
    display: flex;
    margin-bottom: 50px;
  }
  #bargraphs {
    flex-basis: 40%;
    margin-right: 5px;
  }
  #doughnutCharts {
    flex-basis: 60%;
    margin-left: 5px;
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

  .fg2{
    width: 45%;
    height: 45%;
    float: left;
    margin-left: 5%;
  }

  .fg3{
    width: 45%;
    height: 45%;
    float: left;
    margin-left: 5%;
  }

  .ft{
    width: 45%;
    height: 45%;
    float: left;
    margin: 5%;
    margin-left: 27.5%;
  }
</style>
