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
        <h3 class="tsH3">Totals</h3>
        <bar-chart  :TSData="myTeamBarData"
                    :showGoal="false"
                    :forceUpdate="chartUpdate"
                    id="resultBar"
                    class="statleteChart">
        </bar-chart>
      </div>
      <!-- <div id="doughnutCharts">
        <doughnut-chart class="fg2"
                        :label="'FG2'"
                        :inputDatasets="fg2Datasets"
                        :updateChart="updatefg2">
        </doughnut-chart>
        <doughnut-chart class="fg3"
                        :label="'FG2'"
                        :inputDatasets="fg2Datasets"
                        :updateChart="updatefg2">
        </doughnut-chart>
        <doughnut-chart class="ft"
                        :label="'FG2'"
                        :inputDatasets="fg2Datasets"
                        :updateChart="updatefg2">
        </doughnut-chart>
      </div> -->
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
        totals: {},
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
        chartUpdate: 1,
        fg2Datasets: [{ backgroundColor: ['#2B2A29','#e00010'],
                        borderColor: '#e00010',
                        data: [70, 30]
                      }],
        updatefg2: 0
      }
    },
    computed: {
       ...mapGetters({
        activeGameId: 'mainStore/activeGameId',
        players: 'mainStore/players',
        selectedTeamId: 'mainStore/selectedTeamId',
        selectedTeamSport: 'mainStore/selectedTeamSport',
        myColor: 'mainStore/myColor'
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
      },
      hexToRgbA(hex){
        var c;
        if(/^#([A-Fa-f0-9]{3}){1,2}$/.test(hex)){
            c= hex.substring(1).split('');
            if(c.length== 3){
                c= [c[0], c[0], c[1], c[1], c[2], c[2]];
            }
            c= '0x'+c.join('');
            return 'rgba('+[(c>>16)&255, (c>>8)&255, c&255].join(',')+',0.8)';
        }
        throw new Error('Bad Hex');
      },
      createBarGraph(){
        this.updatefg2 = this.updatefg2 + 1;
        var self = this;
        var color = self.myColor;
        if(color.startsWith('#')){
          color = self.hexToRgbA(color)
        }
        
        //Update Chart Data
        if(self.isSoccer){
          var dataArr = []
          if(self.totals['Goals'] !== 'undefined'){
            dataArr.push(self.totals['Goals'])
          }
          else{
            dataArr.push(0)
          }
          if(self.totals['Assists'] !== 'undefined'){
            dataArr.push(self.totals['Assists'])
          }
          else{
            dataArr.push(0)
          }
          if(self.totals['Shots'] !== 'undefined'){
            dataArr.push(self.totals['Shots'])
          }
          else{
            dataArr.push(0)
          }
          if(self.totals['Shots on Goal'] !== 'undefined'){
            dataArr.push(self.totals['Shots on Goal'])
          }
          else{
            dataArr.push(0)
          }
          if(self.totals['Fouls'] !== 'undefined'){
            dataArr.push(self.totals['Fouls'])
          }
          else{
            dataArr.push(0)
          }
          

          self.myTeamBarLabels = ['Goals', 'Assists', 'Shots', 'Shots on Goal', 'Fouls']
          // Vue.set(self.myTeamBarData, 'labels', ['Goals', 'Assists', 'Shots', 'Shots on Goal', 'Fouls']);
          // Vue.set(self.myTeamBarData, 'datasets', [{'backgroundColor': color,'data': dataArr}]);
          self.myTeamBarData = {
            labels: ['Goals', 'Assists', 'Shots', 'Shots on Goal', 'Fouls'],
            datasets: [{'backgroundColor': color,'data': dataArr}, {'backgroundColor': 'rgba(0,0,255, 0.8)','data': dataArr}]
          };
        }
        else{
          var dataArr = []
          if(totals['AST'] !== 'undefined'){
            dataArr.push(totals['AST'])
          }
          else{
            dataArr.push(0)
          }
          if(totals['BLK'] !== 'undefined'){
            dataArr.push(totals['BLK'])
          }
          else{
            dataArr.push(0)
          }
          if(totals['STL'] !== 'undefined'){
            dataArr.push(totals['STL'])
          }
          else{
            dataArr.push(0)
          }
          if(totals['DREB'] !== 'undefined'){
            dataArr.push(totals['DREB'])
          }
          else{
            dataArr.push(0)
          }
          if(totals['OREB'] !== 'undefined'){
            dataArr.push(totals['OREB'])
          }
          else{
            dataArr.push(0)
          }
          

          self.myTeamBarLabels = ['AST', 'BLK', 'STL', 'DREB', 'OREB']
          self.myTeamBarData = {
            labels: ['AST', 'BLK', 'STL', 'DREB', 'OREB'],
            datasets: [
              {
                'backgroundColor': color,
                'data': dataArr
              }
            ]
          };
        }
      }
    },
    created() {
      this.loggedInUser = firebase.auth().currentUser;
      this.currentUserEmail = this.loggedInUser.email;

      var self = this;
      var gameDataRef = null;
      var totalsRef = null;

      if(this.isSoccer){
        gameDataRef = firebase.database().ref('/SoccerGames/' + self.selectedTeamId).child(self.activeGameId).child('Players');
        totalsRef = firebase.database().ref('/SoccerGames/' + self.selectedTeamId).child(self.activeGameId).child('MyTotals');
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
        totalsRef = firebase.database().ref('/BasketballGames/' + self.selectedTeamId).child(self.activeGameId).child('MyTotals');
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
      totalsRef.on('value', function(snapshot) {
        Object.keys(snapshot.val()['Period1']).forEach(key => {
          self.totals[key] = 0
        })
        Object.keys(snapshot.val()['Period1']).forEach(key => {
          self.totals[key] += snapshot.val()['Period1'][key]['Total']
          self.totals[key] += snapshot.val()['Period2'][key]['Total']
        })
      })
      this.createBarGraph()
    },
    mounted() {
      this.createBarGraph()
    },
    watch: {
      playerData: {
        handler(val){
          this.chartUpdate++;
        },
        deep: true
      }
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
    flex-basis: 90%;
    margin-left: 5%;
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
