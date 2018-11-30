<template>
  <div id="GoalsPage">
    <nav-component />
    <h1 class="goalsH1">Goals</h1>
    <table class="goalsTable">
        <thead class="goalsHeader">
            <th>Stat</th>
            <th>Goal</th>
            <th>Actual</th>
        </thead>
        <tbody class="goalsBody">
            <tr v-for="stat in goalsDict" :key="stat.Stat.split(' ').join('') + '-key'" class="goalsRow">
                <td style="font-weight: bold;">{{stat.Stat}}</td>
                <td style="font-weight: bold;"><vue-numeric-input :align="'center'" v-model="goalsArr[stat.Stat]" :controls="false" @change="goalChanged({'STAT': stat.Stat})"></vue-numeric-input></td>
                <td v-if="stat.Stat.endsWith('%')" style="font-weight: bold; color: white;"><div :id="stat.Stat.replace('%', '') + '-goalID'" style="border: 10px white solid;">{{actuals[stat.Stat]}}%</div></td>
                <td v-else style="font-weight: bold; color: white;"><div :id="stat.Stat.split(' ').join('') + '-goalID'" style="border: 10px white solid;">{{actuals[stat.Stat]}}</div></td>
            </tr>
        </tbody>
    </table>
  </div>
</template>

<script>
  import firebase from 'firebase'
  import { mapGetters, mapMutations } from 'vuex';

  export default {
    name: 'GoalsPage',
    data: function() {
      return {
        myNum: 0,
        goalsArr: {
            "Assists": 0,
            "Corners" : 0,
            "Crosses": 0,
            "Goals": 0,
            "Saves": 0,
            "Shots": 0,
            "Shots on Goal": 0
        },
        actuals: {}
      }
    },
    mounted(){
        var self = this;
        var ref = firebase.database().ref('TeamSportfolios/').child(self.selectedTeamId);
        ref.child('Goals').on('value', function(snapshot){
            if(snapshot.val() === 'undefined' || snapshot.val() == null){
                var goalsInit = {}
                if(self.isSoccer){
                    goalsInit = { "Assists": 0,
                                  "Corners" : 0,
                                  "Crosses": 0,
                                  "Goals": 0,
                                  "Saves": 0,
                                  "Shots": 0,
                                  "Shots on Goal": 0
                    }
                }
                else if(self.isBasketball){
                    goalsInit = { "AST": 0,
                                  "BLK": 0,
                                  "DREB": 0,
                                  "FG2M": 0,
                                  "FG2%": 0,
                                  "FG3M": 0,
                                  "FG3%": 0,
                                  "FTM": 0,
                                  "FT%": 0,
                                  "OREB": 0,
                                  "STL": 0
                    }
                }
                else{
                    goalsInit = { "Touchdowns": 0,
                                  "Pass Completion": 0,
                                  "Passing Yards": 0,
                                  "Rushing Yards": 0
                    }
                }
                ref.update({
                    'Goals': goalsInit
                })
                self.SS_SET_GOALS(goalsInit)
                self.goalsArr = goalsInit
                
            }
            else{
                self.SS_SET_GOALS(snapshot.val())
                self.goalsArr = snapshot.val()
            }
            self.computeActuals()
        })
    },
    computed: {
      ...mapGetters({
        selectedTeamId: 'mainStore/selectedTeamId',
        selectedTeamName: 'mainStore/selectedTeamName',
        currentUserEmail: 'mainStore/currentUserEmail',
        selectedTeamSport: 'mainStore/selectedTeamSport',
        soccerStatsArr: 'statStore/soccerStatsArr',
        basketballStatsArr: 'statStore/basketballStatsArr',
        goals: 'statStore/goals',
        numberOfPeriods: 'gameViewStore/numberOfPeriods'
      }),
      isSoccer: function() {
        return this.selectedTeamSport == 1;
      },
      isBasketball: function() {
          return this.selectedTeamSport == 0;
      },
      statsArr: function() {
        if(this.isSoccer){
            return this.soccerStatsArr;
        }
        else{
            return this.basketballStatsArr;
        }
      },
      goalsDict: function() {
          var result = [];
          Object.keys(this.goals).forEach(stat => {
              result.push({
                  'Stat': stat,
                  'Goal': this.goals[stat],
                  'Actual': 0
              })
          });
          return result;
      }
    },
    methods: {
        ...mapMutations({
            SET_LOGGED_IN_USER: 'mainStore/SET_LOGGED_IN_USER',
            SS_SET_GOALS: 'statStore/SS_SET_GOALS',
            SS_UPDATE_GOAL: 'statStore/SS_UPDATE_GOAL'
        }),
        goalChanged(stat){
            var self = this;
            self.SS_UPDATE_GOAL({
                'stat': stat.STAT,
                'val': self.goalsArr[stat.STAT]
            })
            var ref = firebase.database().ref('TeamSportfolios/').child(self.selectedTeamId).child('Goals');
            ref.update({
                [stat.STAT]: self.goalsArr[stat.STAT]
            }).then(function(){
                self.computeActuals();
            })
        },
        computeActuals() {
            var result = jQuery.extend(true, {}, this.goalsArr)
            Object.keys(result).forEach(key => {
                result[key] = 0
            })
            var self = this;
            var promises = []
            var ref = null;
            
            if(this.isSoccer){
                ref = firebase.database().ref('SoccerGames/').child(self.selectedTeamId);
                ref.once('value', function(snapshot){
                    Object.keys(snapshot.val()).forEach(key => {
                        var game = snapshot.val()[key];
                        Object.keys(result).forEach(element => {
                            result[element] += game.MyTotals.Period1[element].Total
                            result[element] += game.MyTotals.Period2[element].Total
                        })
                    })
                    var gameCount = Object.keys(snapshot.val()).length
                    
                    Object.keys(result).forEach(element => {
                        var num = result[element] / gameCount;
                        result[element] = Math.round(10*num)/10
                    })
                    var tmp = {}
                    Object.keys(self.goalsArr).forEach(key => {
                        tmp[key] = result[key]
                    })
                    result = tmp;
                    self.actuals = result
                }).then(function(){
                    Object.keys(result).forEach(element => {
                        var el = element.split(' ').join('')
                        var id = '#' + el + '-goalID'
                        if(result[element] >= self.goalsArr[element]){
                            jQuery(id).css('background-color', 'green')
                        }
                        else {
                            jQuery(id).css('background-color', 'red')
                        }
                    })
                })
            }
            else if(this.isBasketball){
                ref = firebase.database().ref('BasketballGames/').child(self.selectedTeamId);
                ref.once('value', function(snapshot){
                    Object.keys(snapshot.val()).forEach(key => {
                        var game = snapshot.val()[key];
                        Object.keys(result).forEach(element => {
                            if(element === 'FG2%'){
                                if(self.numberOfPeriods == 2){
                                    var attempted = 0
                                    attempted += game.MyTotals.Period1['FG2A'].Total
                                    attempted += game.MyTotals.Period2['FG2A'].Total
                                    var made = 0
                                    made += game.MyTotals.Period1['FG2M'].Total
                                    made += game.MyTotals.Period2['FG2M'].Total
                                    
                                    if(attempted == 0){
                                        if(made == 0){
                                            result[element] = 0
                                        }
                                        else{
                                            result[element] = 100
                                        }
                                    }
                                    else{
                                        result[element] = Math.round(1000 * (made/attempted))/10
                                    }
                                }
                                else {
                                    var attempted = 0
                                    attempted += game.MyTotals.Period1['FG2A'].Total
                                    attempted += game.MyTotals.Period2['FG2A'].Total
                                    attempted += game.MyTotals.Period3['FG2A'].Total
                                    attempted += game.MyTotals.Period4['FG2A'].Total
                                    var made = 0
                                    made += game.MyTotals.Period1['FG2M'].Total
                                    made += game.MyTotals.Period2['FG2M'].Total
                                    made += game.MyTotals.Period3['FG2M'].Total
                                    made += game.MyTotals.Period4['FG2M'].Total
                                    
                                    if(attempted == 0){
                                        if(made == 0){
                                            result[element] = 0
                                        }
                                        else{
                                            result[element] = 100
                                        }
                                    }
                                    else{
                                        result[element] = Math.round(1000 * (made/attempted))/10
                                    }
                                }
                            }
                            else if(element === 'FG3%'){
                                if(self.numberOfPeriods == 2){
                                    var attempted = 0
                                    attempted += game.MyTotals.Period1['FG3A'].Total
                                    attempted += game.MyTotals.Period2['FG3A'].Total
                                    var made = 0
                                    made += game.MyTotals.Period1['FG3M'].Total
                                    made += game.MyTotals.Period2['FG3M'].Total
                                    
                                    if(attempted == 0){
                                        if(made == 0){
                                            result[element] = 0
                                        }
                                        else{
                                            result[element] = 100
                                        }
                                    }
                                    else{
                                        result[element] = Math.round(1000 * (made/attempted))/10
                                    }
                                }
                                else {
                                    var attempted = 0
                                    attempted += game.MyTotals.Period1['FG3A'].Total
                                    attempted += game.MyTotals.Period2['FG3A'].Total
                                    attempted += game.MyTotals.Period3['FG3A'].Total
                                    attempted += game.MyTotals.Period4['FG3A'].Total
                                    var made = 0
                                    made += game.MyTotals.Period1['FG3M'].Total
                                    made += game.MyTotals.Period2['FG3M'].Total
                                    made += game.MyTotals.Period3['FG3M'].Total
                                    made += game.MyTotals.Period4['FG3M'].Total
                                    
                                    if(attempted == 0){
                                        if(made == 0){
                                            result[element] = 0
                                        }
                                        else{
                                            result[element] = 100
                                        }
                                    }
                                    else{
                                        result[element] = Math.round(1000 * (made/attempted))/10
                                    }
                                }
                            }
                            else if(element === 'FT%'){
                                if(self.numberOfPeriods == 2){
                                    var attempted = 0
                                    attempted += game.MyTotals.Period1['FTA'].Total
                                    attempted += game.MyTotals.Period2['FTA'].Total
                                    var made = 0
                                    made += game.MyTotals.Period1['FTM'].Total
                                    made += game.MyTotals.Period2['FTM'].Total
                                    
                                    if(attempted == 0){
                                        if(made == 0){
                                            result[element] = 0
                                        }
                                        else{
                                            result[element] = 100
                                        }
                                    }
                                    else{
                                        result[element] = Math.round(1000 * (made/attempted))/10
                                    }
                                }
                                else {
                                    var attempted = 0
                                    attempted += game.MyTotals.Period1['FTA'].Total
                                    attempted += game.MyTotals.Period2['FTA'].Total
                                    attempted += game.MyTotals.Period3['FTA'].Total
                                    attempted += game.MyTotals.Period4['FTA'].Total
                                    var made = 0
                                    made += game.MyTotals.Period1['FTM'].Total
                                    made += game.MyTotals.Period2['FTM'].Total
                                    made += game.MyTotals.Period3['FTM'].Total
                                    made += game.MyTotals.Period4['FTM'].Total
                                    
                                    if(attempted == 0){
                                        if(made == 0){
                                            result[element] = 0
                                        }
                                        else{
                                            result[element] = 100
                                        }
                                    }
                                    else{
                                        result[element] = Math.round(1000 * (made/attempted))/10
                                    }
                                }
                            }
                            else {
                                if(self.numberOfPeriods == 2){
                                    result[element] += game.MyTotals.Period1[element].Total
                                    result[element] += game.MyTotals.Period2[element].Total
                                }
                                else {
                                    result[element] += game.MyTotals.Period1[element].Total
                                    result[element] += game.MyTotals.Period2[element].Total
                                    result[element] += game.MyTotals.Period3[element].Total
                                    result[element] += game.MyTotals.Period4[element].Total
                                }
                            }
                            
                        })
                    })
                    var gameCount = Object.keys(snapshot.val()).length
                    
                    Object.keys(result).forEach(element => {
                        var num = result[element] / gameCount;
                        result[element] = Math.round(10 * num) / 10
                    })
                    self.actuals = result
                }).then(function() {
                    console.log(result)
                    Object.keys(result).forEach(element => {
                        console.log(result[element])
                        var el = element
                        if(element.endsWith('%')){
                            el = element.slice(0, -1);
                        }
                        var id = '#' + el + '-goalID'
                        if(result[element] >= self.goalsArr[element]){
                            jQuery(id).css('background-color', 'green')
                        }
                        else {
                            jQuery(id).css('background-color', 'red')
                        }
                    })
                })
            }
            else {
                ref = firebase.database().ref('FootballGames/').child(self.selectedTeamId);
                ref.once('value', function(snapshot){
                    Object.keys(snapshot.val()).forEach(key => {
                        var game = snapshot.val()[key];
                        Object.keys(result).forEach(element => {
                            result[element] += game.MyTotals.Period1[element].Total
                            result[element] += game.MyTotals.Period2[element].Total
                            result[element] += game.MyTotals.Period3[element].Total
                            result[element] += game.MyTotals.Period4[element].Total
                        })
                    })
                    var gameCount = Object.keys(snapshot.val()).length
                    
                    Object.keys(result).forEach(element => {
                        var num = result[element] / gameCount;
                        result[element] = parseFloat(num.toFixed(2))
                    })
                    var tmp = {}
                    Object.keys(self.goalsArr).forEach(key => {
                        tmp[key] = result[key]
                    })
                    result = tmp;
                    self.actuals = result
                }).then(function() {
                    Object.keys(result).forEach(element => {
                        var el = element.split(' ').join('')
                        var id = '#' + el + '-goalID'
                        if(result[element] >= self.goalsArr[element]){
                            jQuery(id).css('background-color', 'green')
                        }
                        else {
                            jQuery(id).css('background-color', 'red')
                        }
                    })
                })
            }
        }
    }
  }
</script>

<style scoped>
  #GoalsPage {
    width: 100vw;
    height: 100vh;
  }
  .goalsTable {
      width: 60vw;
      height: 60vh;
      margin-top: 5vh;
      margin-left: 20vw;
      margin-right: 20vw;
      color: red;
      background-color: white;
  }

  .goalsH1 {
      margin-top: 5vh;
  }

  table {
    border-collapse: separate;
    border-spacing: 0;
    border: 3px solid red;
    border-radius: 20px;
    -moz-border-radius: 20px;
}

  .goalsHeader {
    border-radius: 20px;
  }
  .goalsBody {
      overflow-y: scroll;
  }

    td {
        border-top: 3px solid red;
    }

    .acheivedGoal {
        background-color: green;
    }

    .missedGoal {
        background-color: red;
    }
</style>
