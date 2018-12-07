<template>
  <div id="GoalsPage">
    <nav-component />
    <v-card :dark="darkMode" style="margin: 10vw; padding-bottom: 25px; margin-top: 5vh;">
        <v-card-title>
            <h3>Goals</h3>
            <v-spacer></v-spacer>
        </v-card-title>
        <table style="width: 80%; margin-left: 10%; margin-right: 10%;">
            <thead>
                <th>Stat</th>
                <th>Goal</th>
                <th>Actual</th>
            </thead>
            <tbody>
                <tr v-for="stat in goalsDict" :key="stat.Stat.split(' ').join('') + '-key'">
                    <td style="font-weight: bold;">{{stat.Stat}}</td>
                    <td style="font-weight: bold;"><vue-numeric-input :align="'center'" v-model="goalsArr[stat.Stat]" :controls="false" @change="goalChanged({'STAT': stat.Stat})"></vue-numeric-input></td>
                    <td v-if="stat.Stat.endsWith('%') || stat.Stat === 'PassComp'" style="font-weight: bold;"><div :id="stat.Stat.split(' ').join('').replace('%', '') + '-goalID'" >{{actuals[stat.Stat]}}%</div></td>
                    <td v-else style="font-weight: bold;"><div :id="stat.Stat.split(' ').join('') + '-goalID'">{{actuals[stat.Stat]}}</div></td>
                </tr>
            </tbody>
        </table>
    </v-card>
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
                                  "PassComp": 0,
                                  "PassYds": 0,
                                  "RushYds": 0
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
        numberOfPeriods: 'gameViewStore/numberOfPeriods',
        darkMode: 'mainStore/darkMode'
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
                    if(!isNullOrUndefined(snapshot.val())){
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
                    }
                }).then(function(){
                    Object.keys(result).forEach(element => {
                        var el = element.split(' ').join('')
                        var id = '#' + el + '-goalID'
                        if(result[element] >= self.goalsArr[element]){
                            jQuery(id).css('background-color', 'rgba(0,255,0,0.5)')
                        }
                        else {
                            jQuery(id).css('background-color', 'rgba(255,0,0,0.5)')
                        }
                    })
                })
            }
            else if(this.isBasketball){
                ref = firebase.database().ref('BasketballGames/').child(self.selectedTeamId);
                ref.once('value', function(snapshot){
                    var fg2a = 0;
                    var fg2m = 0;
                    var fg3a = 0;
                    var fg3m = 0;
                    var fta = 0;
                    var ftm = 0;
                    //sum up values
                    Object.keys(snapshot.val()).forEach(key => {
                        if(!isNullOrUndefined(snapshot.val())){
                            var game = snapshot.val()[key];
                        Object.keys(result).forEach(element => {
                            if(element === 'FG2%'){
                                if(self.numberOfPeriods == 2){
                                    fg2a += game.MyTotals.Period1['FG2A'].Total
                                    fg2a += game.MyTotals.Period2['FG2A'].Total

                                    fg2m += game.MyTotals.Period1['FG2M'].Total
                                    fg2m += game.MyTotals.Period2['FG2M'].Total
                                }
                                else {
                                    fg2a += game.MyTotals.Period1['FG2A'].Total
                                    fg2a += game.MyTotals.Period2['FG2A'].Total
                                    fg2a += game.MyTotals.Period3['FG2A'].Total
                                    fg2a += game.MyTotals.Period4['FG2A'].Total

                                    fg2m += game.MyTotals.Period1['FG2M'].Total
                                    fg2m += game.MyTotals.Period2['FG2M'].Total
                                    fg2m += game.MyTotals.Period3['FG2M'].Total
                                    fg2m += game.MyTotals.Period4['FG2M'].Total
                                }
                            }
                            else if(element === 'FG3%'){
                                if(self.numberOfPeriods == 2){
                                    fg3a += game.MyTotals.Period1['FG3A'].Total
                                    fg3a += game.MyTotals.Period2['FG3A'].Total

                                    fg3m += game.MyTotals.Period1['FG3M'].Total
                                    fg3m += game.MyTotals.Period2['FG3M'].Total
                                }
                                else {
                                    fg3a += game.MyTotals.Period1['FG3A'].Total
                                    fg3a += game.MyTotals.Period2['FG3A'].Total
                                    fg3a += game.MyTotals.Period3['FG3A'].Total
                                    fg3a += game.MyTotals.Period4['FG3A'].Total

                                    fg3m += game.MyTotals.Period1['FG3M'].Total
                                    fg3m += game.MyTotals.Period2['FG3M'].Total
                                    fg3m += game.MyTotals.Period3['FG3M'].Total
                                    fg3m += game.MyTotals.Period4['FG3M'].Total
                                }
                            }
                            else if(element === 'FT%'){
                                if(self.numberOfPeriods == 2){
                                    fta += game.MyTotals.Period1['FTA'].Total
                                    fta += game.MyTotals.Period2['FTA'].Total

                                    ftm += game.MyTotals.Period1['FTM'].Total
                                    ftm += game.MyTotals.Period2['FTM'].Total
                                }
                                else {
                                    fta += game.MyTotals.Period1['FTA'].Total
                                    fta += game.MyTotals.Period2['FTA'].Total
                                    fta += game.MyTotals.Period3['FTA'].Total
                                    fta += game.MyTotals.Period4['FTA'].Total

                                    ftm += game.MyTotals.Period1['FTM'].Total
                                    ftm += game.MyTotals.Period2['FTM'].Total
                                    ftm += game.MyTotals.Period3['FTM'].Total
                                    ftm += game.MyTotals.Period4['FTM'].Total
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
                        }
                        
                    })
                    var gameCount = Object.keys(snapshot.val()).length
                    //get avgs
                    Object.keys(result).forEach(element => {
                        if(element === 'FG2%'){
                            if(fg2a == 0){
                                if(fg2m == 0){
                                    fg2a = 1
                                }
                                else{
                                    fg2a = fg2m
                                }
                            }
                            var num = 100 * (fg2m / fg2a);
                            result[element] = Math.round(10 * num) / 10
                        }
                        else if(element === 'FG3%'){
                            if(fg3a == 0){
                                if(fg3m == 0){
                                    fg3a = 1
                                }
                                else{
                                    fg3a = fg3m
                                }
                            }
                            var num = 100 * (fg3m / fg3a);
                            result[element] = Math.round(10 * num) / 10
                        }
                        else if(element === 'FT%'){
                            if(fta == 0){
                                if(ftm == 0){
                                    fta = 1
                                }
                                else{
                                    fta = ftm
                                }
                            }
                            var num = 100 * (ftm / fta);
                            result[element] = Math.round(10 * num) / 10
                        }
                        else{
                            var num = result[element] / gameCount;
                            result[element] = Math.round(10 * num) / 10
                        }
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
                            jQuery(id).css('background-color', 'rgba(0,255,0,0.5)')
                        }
                        else {
                            jQuery(id).css('background-color', 'rgba(255,0,0,0.5)')
                        }
                    })
                })
            }
            else {
                ref = firebase.database().ref('FootballGames/').child(self.selectedTeamId);
                ref.once('value', function(snapshot){
                    var passComp = 0;
                    var passAtt = 0;
                    Object.keys(snapshot.val()).forEach(key => {
                        if(key !== 'AskStatlete'){
                            var game = snapshot.val()[key];

                            result['Touchdowns'] += game.Totals.Offense.PassTD.Total
                            result['Touchdowns'] += game.Totals.Offense.RushTD.Total
                            result['Touchdowns'] += game.Totals.Special.TotalTD
                            result['Touchdowns'] += game.Totals.Defense.DefTD.Total
                            
                            passAtt += game.Totals.Offense.PassAtt.Total
                            passComp += game.Totals.Offense.PassComp.Total
                                
                            result['PassYds'] += game.Totals.Offense.PassYds.Total
                            result['RushYds'] += game.Totals.Offense.RushYds.Total
                        }
                    })
                    
                    var gameCount = Object.keys(snapshot.val()).length

                    var num = result['Touchdowns'] / gameCount;
                    result['Touchdowns'] = Math.round(10 * num) / 10

                    num = result['PassYds'] / gameCount;
                    result['PassYds'] = Math.round(10 * num) / 10

                    num = result['RushYds'] / gameCount;
                    result['RushYds'] = Math.round(10 * num) / 10

                    num = 100 * (passComp / passAtt);
                    result['PassComp'] = Math.round(10 * num) / 10

                    self.actuals = result
                }).then(function() {
                    Object.keys(result).forEach(element => {
                        var el = element.split(' ').join('')
                        var id = '#' + el + '-goalID'
                        if(result[element] >= self.goalsArr[element]){
                            jQuery(id).css('background-color', 'rgba(0,255,0,0.5)')
                        }
                        else {
                            jQuery(id).css('background-color', 'rgba(255,0,0,0.5)')
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
    height: 100%;
  }
  .goalsTable {
      width: 80%;
      margin-left: 10%;
      margin-right: 10%;
  }

  .goalsH1 {
      margin-top: 5vh;
  }

  table {
    border-collapse:separate;
    border-spacing:0 5px;
}

  .goalsHeader {
    
  }
  .goalsBody {
      
  }

    tr, td {
        border-bottom: 0.1px solid gray;
        padding-bottom: 5px;
    }

    .acheivedGoal {
        background-color: rgba(0,255,0,0.5);
    }

    .missedGoal {
        background-color: rgba(255,0,0,0.5);
    }
</style>
