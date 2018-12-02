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
      <canvas id="myCanvas" width="1000" height="300"></canvas>
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
        oppTotals: {},
        myTotalsArr: [0,0,0,0],
        oppTotalsArr: [0,0,0,0],
        loggedInUser: '',
        currentUserEmail: '',
        scrollVertical: true,
        scrollHorizontal: true,
        syncHeaderScroll: true,
        deadAreaColor: "#DDDDDD",
        freezeFirstColumn: true,
        loadChart: false,
        dataLoaded: false
      }
    },
    computed: {
       ...mapGetters({
        activeGameId: 'mainStore/activeGameId',
        players: 'mainStore/players',
        selectedTeamId: 'mainStore/selectedTeamId',
        selectedTeamSport: 'mainStore/selectedTeamSport',
        myColor: 'mainStore/myColor',
        oppColor: 'mainStore/oppColor',
        numberOfPeriods: 'gameViewStore/numberOfPeriods'
      }),
      playerNumbers() {
        return Object.keys(this.players);
      },
      isSoccer() {
        return this.selectedTeamSport == 1;
      },
      isBasketball() {
        return this.selectedTeamSport == 0;
      }
    },
    methods: {
      drawTotalsGraph: function(){
        var myTotals = this.myTotalsArr;
        var oTotals = this.oppTotalsArr;

        var color = this.myColor;
        var colorOpp = this.oppColor;

        var labelX = 10
        var labelY = 90
        var numX = 100
        var canvas = document.getElementById("myCanvas");
        var ctx = canvas.getContext("2d");
        ctx.clearRect(0,0,canvas.width, canvas.height)
        ctx.lineWidth = 15;

        if(typeof myTotals[0] === 'undefined' || typeof myTotals[1] === 'undefined' || typeof myTotals[2] === 'undefined' || typeof myTotals[3] === 'undefined'){

          return
        }
        if(typeof oTotals[0] === 'undefined' || typeof oTotals[1] === 'undefined' || typeof oTotals[2] === 'undefined' || typeof oTotals[3] === 'undefined'){

          return
        }

        //Legend
        ctx.beginPath();
        ctx.strokeStyle = color;
        ctx.moveTo(85,15);
        ctx.lineTo(105,15);
        ctx.stroke();

        ctx.beginPath();
        ctx.strokeStyle = colorOpp;
        ctx.moveTo(85,35);
        ctx.lineTo(105,35);
        ctx.stroke();
        ctx.font = "15px Arial";
        ctx.fillStyle = "#000000";
        ctx.fillText("- My Team",110, 20);
        ctx.fillText("- Opponent",110, 40);

        ctx.font = "20px Arial";
        ctx.fillStyle = "#000000";
        ctx.strokeStyle = "#FF0000";

        if(this.isSoccer){
          ctx.fillText("Goals",labelX, labelY + 0);
          ctx.fillText("Assists",labelX,labelY + 60);
          ctx.fillText("Shots",labelX,labelY + 120);
          ctx.fillText("S.O.G.",labelX,labelY + 180);
        }
        else if(this.isBasketball){
          labelX += 20;
          ctx.fillText("AST",labelX, labelY + 0);
          ctx.fillText("REB",labelX,labelY + 60);
          ctx.fillText("BLK",labelX,labelY + 120);
          ctx.fillText("STL",labelX,labelY + 180);
        }
        else{
          ctx.font = "18px Arial";
          ctx.fillText("PassYds",labelX, labelY + 0);
          ctx.fillText("RushYds",labelX,labelY + 60);
          ctx.font = "20px Arial";
          ctx.fillText("TDs",labelX,labelY + 120);
          ctx.fillText("FGs",labelX,labelY + 180);
        }

        
        if(this.isSoccer){
          for(var i = 0; i < myTotals.length; i++){
            if(i < 2){
              ctx.beginPath();
              ctx.strokeStyle = color;
              ctx.moveTo(85,75 + (i * 60));
              ctx.lineTo(85+myTotals[i]*50,75 + (i * 60));
              ctx.stroke();

              ctx.beginPath();
              ctx.strokeStyle = colorOpp;
              ctx.moveTo(85,95 + (i * 60));
              ctx.lineTo(85+oTotals[i]*50,95 + (i * 60));
              ctx.stroke();
            }
            else{
              ctx.beginPath();
              ctx.strokeStyle = color;
              ctx.moveTo(85,195+((i-2)*60));
              ctx.lineTo(85+myTotals[i]*25,195+((i-2)*60));
              ctx.stroke();

              ctx.beginPath();
              ctx.strokeStyle = colorOpp;
              ctx.moveTo(85,215+((i-2)*60));
              ctx.lineTo(85+oTotals[i]*25,215+((i-2)*60));
              ctx.stroke();
            }
          }
        }
        else if(this.isBasketball){
          for(var i = 0; i < myTotals.length; i++){
            if(i < 2){
              ctx.beginPath();
              ctx.strokeStyle = color;
              ctx.moveTo(85,75 + (i * 60));
              ctx.lineTo(85+myTotals[i]*25,75 + (i * 60));
              ctx.stroke();

              ctx.beginPath();
              ctx.strokeStyle = colorOpp;
              ctx.moveTo(85,95 + (i * 60));
              ctx.lineTo(85+oTotals[i]*25,95 + (i * 60));
              ctx.stroke();
            }
            else{
              ctx.beginPath();
              ctx.strokeStyle = color;
              ctx.moveTo(85,195+((i-2)*60));
              ctx.lineTo(85+myTotals[i]*50,195+((i-2)*60));
              ctx.stroke();

              ctx.beginPath();
              ctx.strokeStyle = colorOpp;
              ctx.moveTo(85,215+((i-2)*60));
              ctx.lineTo(85+oTotals[i]*50,215+((i-2)*60));
              ctx.stroke();
            }
          }
        }
        else {
          for(var i = 0; i < myTotals.length; i++){
            if(i < 2){
              ctx.beginPath();
              ctx.strokeStyle = color;
              ctx.moveTo(85,75 + (i * 60));
              ctx.lineTo(85+myTotals[i],75 + (i * 60));
              ctx.stroke();

              ctx.beginPath();
              ctx.strokeStyle = colorOpp;
              ctx.moveTo(85,95 + (i * 60));
              ctx.lineTo(85+oTotals[i],95 + (i * 60));
              ctx.stroke();
            }
            else{
              ctx.beginPath();
              ctx.strokeStyle = color;
              ctx.moveTo(85,195+((i-2)*60));
              ctx.lineTo(85+myTotals[i]*50,195+((i-2)*60));
              ctx.stroke();

              ctx.beginPath();
              ctx.strokeStyle = colorOpp;
              ctx.moveTo(85,215+((i-2)*60));
              ctx.lineTo(85+oTotals[i]*50,215+((i-2)*60));
              ctx.stroke();
            }
          }
        }

        ctx.font = "15px Arial";
        ctx.fillStyle = "#ffffff";

        for(var i = 0; i < myTotals.length; i++){
          ctx.fillText(myTotals[i],numX,80 + i*60);
          ctx.fillText(oTotals[i],numX,100 + i*60);
        }
      },
      goBack: function() {
        this.$emit('TeamStatsClose');
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
      getTeamTotals(){
        var self = this;
        //Update Chart Data
        if(self.isSoccer){
          var dataArr = [0,0,0,0]
          var oppDataArr = [0,0,0,0]
          dataArr[0] = (typeof self.totals['Goals'] === 'undefined') ? 0 : self.totals['Goals']
          dataArr[1] = (typeof self.totals['Assists'] === 'undefined') ? 0 : self.totals['Assists']
          dataArr[2] = (typeof self.totals['Shots'] === 'undefined') ? 0 : self.totals['Shots']
          dataArr[3] = (typeof self.totals['Shots on Goal'] === 'undefined') ? 0 : self.totals['Shots on Goal']

          oppDataArr[0] = (typeof self.oppTotals['Goals'] === 'undefined') ? 0 : self.oppTotals['Goals']
          oppDataArr[1] = (typeof self.oppTotals['Assists'] === 'undefined') ? 0 : self.oppTotals['Assists']
          oppDataArr[2] = (typeof self.oppTotals['Shots'] === 'undefined') ? 0 : self.oppTotals['Shots']
          oppDataArr[3] = (typeof self.oppTotals['Shots on Goal'] === 'undefined') ? 0 : self.oppTotals['Shots on Goal']

          self.myTotalsArr = dataArr
          self.oppTotalsArr = oppDataArr          
        }
        else if(self.isBasketball){
          var dataArr = [0,0,0,0]
          var oppDataArr = [0,0,0,0]
          var dreb = 0;
          var oreb = 0;
          dataArr[0] = (typeof self.totals['AST'] === 'undefined') ? 0 : self.totals['AST']
          dataArr[2] = (typeof self.totals['BLK'] === 'undefined') ? 0 : self.totals['BLK']
          dataArr[3] = (typeof self.totals['STL'] === 'undefined') ? 0 : self.totals['STL']
          dreb = (typeof self.totals['DREB'] === 'undefined') ? 0 : self.totals['DREB']
          oreb = (typeof self.totals['OREB'] === 'undefined') ? 0 : self.totals['OREB']
          dataArr[1] = dreb + oreb

          oppDataArr[0] = (typeof self.oppTotals['AST'] === 'undefined') ? 0 : self.oppTotals['AST']
          oppDataArr[2] = (typeof self.oppTotals['BLK'] === 'undefined') ? 0 : self.oppTotals['BLK']
          oppDataArr[3] = (typeof self.oppTotals['STL'] === 'undefined') ? 0 : self.oppTotals['STL']
          dreb = (typeof self.oppTotals['DREB'] === 'undefined') ? 0 : self.oppTotals['DREB']
          oreb = (typeof self.oppTotals['OREB'] === 'undefined') ? 0 : self.oppTotals['OREB']
          oppDataArr[1] = dreb + oreb

          self.myTotalsArr = dataArr
          self.oppTotalsArr = oppDataArr
        }
        else{
          //Football
          var dataArr = {}
          var oppDataArr = {}
          dataArr['PassYds'] = (typeof self.totals['PassYds'] === 'undefined') ? 0 : self.totals['PassYds']
          dataArr['RushYds'] = (typeof self.totals['RushYds'] === 'undefined') ? 0 : self.totals['RushYds']
          dataArr['Tackles'] = (typeof self.totals['Tackles'] === 'undefined') ? 0 : self.totals['Tackles']
          dataArr['MadeFG'] = (typeof self.totals['MadeFG'] === 'undefined') ? 0 : self.totals['MadeFG']
          dataArr['Punts'] = (typeof self.totals['Punts'] === 'undefined') ? 0 : self.totals['Punts']

          oppDataArr['PassYds'] = (typeof self.oppTotals['PassYds'] === 'undefined') ? 0 : self.oppTotals['PassYds']
          oppDataArr['RushYds'] = (typeof self.oppTotals['RushYds'] === 'undefined') ? 0 : self.oppTotals['RushYds']
          oppDataArr['Tackles'] = (typeof self.oppTotals['Tackles'] === 'undefined') ? 0 : self.oppTotals['Tackles']
          oppDataArr['MadeFG'] = (typeof self.oppTotals['MadeFG'] === 'undefined') ? 0 : self.oppTotals['MadeFG']
          oppDataArr['Punts'] = (typeof self.oppTotals['Punts'] === 'undefined') ? 0 : self.oppTotals['Punts']
        
          self.myTotals = dataArr
          self.oppTotals = oppDataArr
          self.dataLoaded = true;
        }
      }
    },
    async created() {
      this.loggedInUser = firebase.auth().currentUser;
      this.currentUserEmail = this.loggedInUser.email;

      var self = this;
      var gameDataRef = null;
      var totalsRef = null;
      var oppTotalsRef = null;

      if(this.isSoccer){
        gameDataRef = firebase.database().ref('/SoccerGames/' + self.selectedTeamId).child(self.activeGameId).child('Players');
        totalsRef = firebase.database().ref('/SoccerGames/' + self.selectedTeamId).child(self.activeGameId).child('MyTotals');
        oppTotalsRef = firebase.database().ref('/SoccerGames/' + self.selectedTeamId).child(self.activeGameId).child('OpponentsTotals');
      }
      else if (this.isBasketball){
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
        oppTotalsRef = firebase.database().ref('/BasketballGames/' + self.selectedTeamId).child(self.activeGameId).child('OpponentsTotals');
      }
      else{
        //Football
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
        oppTotalsRef = firebase.database().ref('/BasketballGames/' + self.selectedTeamId).child(self.activeGameId).child('OpponentsTotals');
      }

      if(this.isSoccer || this.isBasketball){
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
        await gameDataRef.on('value', function(snapshot) {
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
        await totalsRef.on('value', function(snapshot) {
          Object.keys(snapshot.val()['Period1']).forEach(key => {
            self.totals[key] = 0
          })
          Object.keys(snapshot.val()['Period1']).forEach(key => {
            self.totals[key] += snapshot.val()['Period1'][key]['Total']
            self.totals[key] += snapshot.val()['Period2'][key]['Total']
            if(self.isBasketball && self.numberOfPeriods == 4){
              self.totals[key] += snapshot.val()['Period3'][key]['Total']
              self.totals[key] += snapshot.val()['Period4'][key]['Total']
            }
          })
          self.getTeamTotals()
          self.drawTotalsGraph()
        });
        await oppTotalsRef.on('value', function(snapshot) {
          Object.keys(snapshot.val()['Period1']).forEach(key => {
            self.oppTotals[key] = 0
          })
          Object.keys(snapshot.val()['Period1']).forEach(key => {
            self.oppTotals[key] += snapshot.val()['Period1'][key]['Total']
            self.oppTotals[key] += snapshot.val()['Period2'][key]['Total']
            if(self.isBasketball && self.numberOfPeriods == 4){
              self.oppTotals[key] += snapshot.val()['Period3'][key]['Total']
              self.oppTotals[key] += snapshot.val()['Period4'][key]['Total']
            }
          })
          self.getTeamTotals()
          self.drawTotalsGraph()
        });
      }
      else{
        //Football
      }
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

  #teamstats_graphs {
    margin-top: 25px;
    margin-bottom: 50px;
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

  #myCanvas{
    border:2px solid #e00010;
    border-radius: 25px;
  }
</style>
