<template>
    <div class="footballOffense">
            <div id="offenseButtons">
                <div style="text-align: center"><h3>Offense Stats</h3></div>
                <div><p class="footballButton" @click="offenseRun">Run</p></div>
                <div><p class="footballButton" @click="offensePass">Pass</p></div>
                <div><p class="footballButton" @click="offensePenalty">Penalty</p></div>
                <div><p class="footballButton" @click="askStatlete">Ask Statlete</p></div>
            </div>

            <div id="getOffPosition">
              <table align="center">
                <tr><th>Spot The Ball</th></tr>
                <tr>
                  <td>Ball is on the: </td>
                  <td>
                    <vue-numeric-input  v-model="ballLocation" size="3" maxlength="2" :controls="false" :min="0" :max="50" ></vue-numeric-input>
                  <!--<input type="text" size="3" maxlength="2" v-model="ballLocation"> -->
                  </td>
                </tr>
                <tr>
                  <td>My Half</td>
                  <td><input type="checkbox" checked v-model="myHalf"></td>
                </tr>
              </table>
              <button class="footballButton" @click="startDrive">Start Drive</button>
            </div>

             <div id="runForm">
                <table align="center">
                  <tr><th>Run</th></tr>
                  <tr>
                    <td>Ran to the: </td>
                    <td>Left <input type="radio" value="Left" v-model="pickedRunSide"></td>
                    <td>Middle <input type="radio" value="Middle" v-model="pickedRunSide"></td>
                    <td>Right <input type="radio" value="Right" v-model="pickedRunSide"></td>
                  </tr>       
                    <tr>
                        <td> Run by Player: </td>
                        <td><vue-numeric-input align="right" type="text" maxlength="2" size="3" v-model="runPlayerNumber" :min="0" :max="99" :controls="false"></vue-numeric-input>
                        </td></tr>
                        <tr>
                            <td>Yards: </td><td><vue-numeric-input align="right" type="text" maxlength="3" size="3" v-model="runYards" :min="-99" :max="99" :controls="false"></vue-numeric-input></td></tr>
                            <tr><td>Touchdown </td><td><input type="checkbox" v-model="runTouchdown" value="td"></td></tr>
                            <tr><td>Fumble:</td><td><input type="checkbox" v-model="runFumble" value="fumble"></td></tr>
                  </table>
                    <button class="footballButton" @click="runConfirm">Confirm</button>
                </div>


            <div id="passForm">
                <table align="center">
                  <tr><th>Pass</th></tr>
                  <tr>
                    <td>Threw to the: </td>
                      <td>Left <input type="radio" value="Left" v-model="pickedPassSide"></td>
                      <td>Middle <input type="radio" value="Middle" v-model="pickedPassSide"></td>
                      <td>Right <input type="radio" value="Right" v-model="pickedPassSide"></td>
                  </tr>
                    <tr><td>Pass by Player: </td>
                    <td><vue-numeric-input type="text" maxlength="2" size="3" v-model="passPlayerNumber" :min="0" :max="99" :controls="false"></vue-numeric-input>
                    </td></tr>
                    <tr><td>Completion: </td><td><input type="checkbox" v-model="passCompletion" value="completion">
                    </td></tr>
                    <tr><td>Catch by Player: </td><td><vue-numeric-input type="text" maxlength="2" size="3" v-model="passCatchPlayerNum" :min="0" :max="99" :controls="false"></vue-numeric-input>
                    </td></tr>
                    <tr><td>Yards: </td><td><vue-numeric-input type="text" maxlength="3" size="3" v-model="passYards" :min="-99" :max="99" :controls="false"></vue-numeric-input>
                    </td></tr>
                    <tr><td>Touchdown </td><td><input type="checkbox" v-model="passTouchdown" value="td"></td></tr>
                    <tr><td>QB Sack</td><td><input align="right" type="checkbox" v-model="passSack" value="sack"></td>
                    <tr><td>Turnover</td><td><input type="checkbox" v-if="activeTurnover === 'false'" @click="offenseTurnover">
                    <input type="checkbox" v-else @click="offenseTurnoverHide"></td></tr></table>
                    <div id="turnoverForm">
                <table align="center">
                  <tr><td>Fumble:</td><td><input type="radio" value="fumble" v-model="passTurnover" checked>
                </td></tr>
                <tr>
                    <td>Interception:</td>
                    <td><input type="radio" value="interception" v-model="passTurnover"></td>
                  </tr>
                  <tr><td>Turnover By: </td><td><vue-numeric-input type="text" v-model="passTurnoverBy" maxlength="2" size="2" :min="0" :max="99" :controls="false"></vue-numeric-input></td></tr>
                  </table>
            </div>
                    <button class="footballButton" @click="passConfirm">Confirm</button>
            </div>

            <div id="penaltyForm">
                      <table align="center"><tr><td>Penalty: </td><td>
                        <select v-model="penaltyType" size="1">
                          <option value="falseStart">False Start Offense</option>
                          <option value="offensiveHolding">Holding Offense</option>
                          <option value="delayGame">Delay of Game Offense</option>
                          <option value="personalFoul">Personal Foul Offense</option>
                        </select>
                      </td></tr><tr><td>Yards: </td><td>
                        <vue-numeric-input type="text" size="3" maxlength="3" v-model="penaltyYards" :min="-15" :max="15" :controls="false"></vue-numeric-input></td></tr>
                        <tr><td>Down: </td><td>
                        <vue-numeric-input type="text" size="3" maxlength="1" v-model="penaltyDown" :min="1" :max="4" :controls="false"></vue-numeric-input></td></tr>        
                        </table>
                        <button class="footballButton" @click="penaltyConfirm">Confirm</button>
            </div>
            <div id="statleteForm">
              GO FOR IT!!!!!!!!!!!
              <button class="footballButton" @click="askStatleteConfirm">Confirm</button>
            </div>

            <div id="tracker">
              <p>Ball on the {{driveSpotBall}}</p>
              <p>Yards to go: {{driveYardsLeft}}</p>
              <p>Down {{driveDowns}} </p>
            </div>

            

            

		</div>
</template>



<script>
import firebase from 'firebase'
import { mapGetters, mapMutations } from 'vuex'

export default {
  data() {
    return {
      activeTurnover: "false",
      activeRunTurnover: "false",

      // Tracker
      driveDowns: 1,
      driveYardsLeft: 10,
      driveSpotBall: parseInt(25),
      driveMyHalf: true,

      //Spot Ball
      ballLocation: parseInt(25),
      myHalf: "true",

      //Runs
      pickedRunSide: "Middle",
      runPlayerNumber: "",
      runYards: "",
      runTouchdown: "",
      runFumble: "",

      //Passes
      pickedPassSide: "Middle",
      passPlayerNumber: '',
      passCompletion: '',
      passCatchPlayerNum: '',
      passYards: '',
      passTouchdown: '',
      passSack: '',
      passFumble: '',
      passInterception: '',
      passTurnover: '',
      passTurnoverBy: '',
      
      //Penalty
      penaltyType: 'falseStart',
      penaltyYards: '',
      penaltyDown: '',
    };
  },

  computed: {
    ...mapGetters({
      selectedTeamId: 'mainStore/selectedTeamId',
      activeGameId: 'mainStore/activeGameId'
    })
  },

  methods: {
    startDrive: function() {
      jQuery("#runForm").hide();
      jQuery("#passForm").hide();
      jQuery("#penaltyForm").hide();
      jQuery("#turnoverForm").hide();
      jQuery("#getOffPosition").hide();
      jQuery("#statleteForm").hide();
      jQuery("#offenseButtons").show();
      jQuery("#tracker").show();
      this.activeButton = 'offense';
      //Send input to Database

      // Set Tracker
      this.driveSpotBall = this.ballLocation;
      this.driveMyHalf = this.myHalf;

      console.log(typeof(this.driveSpotBall));
      console.log(typeof(this.ballLocation));

      //Reset Values
      this.ballLocation = parseInt(25);
      this.myHalf = "true";
    },

    askStatlete: function() {
      jQuery("#statleteForm").show();
      jQuery("#offenseButtons").hide();
      jQuery("#turnoverForm").hide();
    },

    askStatleteConfirm: function() {
      jQuery("#statleteForm").hide();
      jQuery("#offenseButtons").show();
    },

    offenseRun: function() {
      jQuery("#runForm").show();
      jQuery("#offenseButtons").hide();
      jQuery("#turnoverForm").hide();
    },
    offensePass: function() {
      jQuery("#passForm").show();
      jQuery("#offenseButtons").hide();
      jQuery("#turnoverForm").hide();
    },
    offensePenalty: function() {
      jQuery("#penaltyForm").show();
      jQuery("#offenseButtons").hide();
      jQuery("#turnoverForm").hide();
    },
    offenseTurnover: function() {
      jQuery("#turnoverForm").show();
      this.activeTurnover = "true";
    },
    offenseTurnoverHide: function() {
      jQuery("#turnoverForm").hide();
      this.activeTurnover = "false";
    },
     offenseRunTurnover: function() {
      //alert("TURNOVER BUTTON CLICKED");
      jQuery("#turnoverRunForm").show();
      this.activeRunTurnover = "true";
    },
    offenseRunTurnoverHide: function() {
      jQuery("#turnoverRunForm").hide();
      this.activeRunTurnover = "false";
    },
    runConfirm: function() {
      jQuery("#runForm").hide();
      jQuery("#turnoverForm").hide();
      jQuery("#offenseButtons").show();

      //Database Stuff
      //Tracker
      if(this.runYards >= this.driveYardsLeft)
      {
        this.driveDowns = 1;
        this.driveYardsLeft = 10;
      }
      else
      {
        this.driveYardsLeft = parseInt(this.driveYardsLeft) - parseInt(this.runYards);
        this.driveDowns++;
      }
      if(this.driveMyHalf)
      {
        //this.driveSpotBall += this.runYards;
        this.driveSpotBall = parseInt(this.driveSpotBall) + parseInt(this.runYards);
        if(this.driveSpotBall > 50)
        {
          var temp = this.driveSpotBall - 50;
          this.driveSpotBall = 50 - temp;
          this.driveMyHalf = false;
        }
      }
      else
      {
        this.driveSpotBall -= this.runYards;
      }
      if(this.driveSpotBall > 50 || this.driveSpotBall < 0 || this.driveDowns > 4)
      {
        jQuery("#tracker").hide();
      }
      // Database
      // var ref =firebase.database().ref("FootballGames/Example/Example-01/Totals/Period1/Offense")
      var self = this
      var ref =firebase.database().ref("FootballGames").child(self.selectedTeamId).child(self.activeGameId).child("Totals").child("Period1").child("Offense")
      var ref2 = firebase.database().ref("FootballGames").child(self.selectedTeamId).child(self.activeGameId).child("Totals").child("Period1").child("Special");
        ref2.child("TotalTDAllowed").once("value", function(rand2){
          if(self.runFumble && self.runTouchdown)
          self.$emit("oppScore", 6)
          var numS = rand2.val()
          if(numS == null)
          {
            numS = 1
          }
          else
          {
            numS += 1
          }
          ref2.update({
            ["TotalTDAllowed"]: numS
          })
        }).then(()=>{
        ref.child("RushCarries").once("value", function(snapshot){
        var numCarries = snapshot.val()
        var playerNum = "p" + self.runPlayerNumber
        var total = numCarries.Total + 1
        var player = numCarries[playerNum]
        if(player == null)
        {
          player = 1
        }
        else{
          player++
        }
        ref.child("RushCarries").update({
          "Total": total,
          [playerNum]: player
        })
      }).then(()=>{
        ref.child("RushYds").once("value", function(shot){
          var rushYds = shot.val()
          var playerNum = "p" + self.runPlayerNumber
          var total = rushYds.Total + parseInt(self.runYards)
          var player = rushYds[playerNum]
          if(player == null)
          {
            player = parseInt(self.runYards)
          }
          else{
            player += parseInt(self.runYards)
          }
          ref.child("RushYds").update({
            "Total": total,
            [playerNum]: player
          })
        }).then(()=>{
          ref.child("RushYds").child("Side").once("value", function(side){
            var rushYds = side.val()
            var pos = self.pickedRunSide
            var selected = rushYds[pos]
            if(selected == null)
            {
              selected = parseInt(self.runYards)
            }
            else{
              selected += parseInt(self.runYards)
            }
            ref.child("RushYds").child("Side").update({
              [pos]: selected
            })
          })
        }).then(()=>{
          
            ref.child("RushTD").once("value", function(points){ 
            if(self.runTouchdown)
            {           
              var rushTD = points.val()
              var playerNum = "p" + self.runPlayerNumber
              var total = rushTD.Total + 1
              var player = rushTD[playerNum]
              if(player == null)
              {
                player = 1
              }
              else{
                player++
              }
              ref.child("RushTD").update({
                "Total": total,
                [playerNum]: player
              })
            }}).then(()=> {
            
              ref.child("Fumble").once("value", function(fumbles){
                if(self.runFumble)
            {
                var fum = fumbles.val()
                var playerNum = "p" + self.runPlayerNumber
                var total = fum.Total + 1
                var player = fum[playerNum]
                if(player == null)
                {
                  player = 1
                }
                else{
                  player++
                }
                ref.child("Fumble").update({
                  "Total": total,
                  [playerNum]: player
                })
              }}).then(()=>{
          self.pickedRunSide = "Middle";
          self.runPlayerNumber = "";
          self.runYards = "";
          self.runTouchdown = "";
          self.runFumble = "";
        })    })    
          })        
          })
      })


      
    },
    passConfirm: function() {
      jQuery("#passForm").hide();
      jQuery("#turnoverForm").hide();
      jQuery("#offenseButtons").show();

      //Tracker      
      if(this.passCompletion || this.passSack)
      {
        if(this.passYards >= this.driveYardsLeft)
        {
          this.driveDowns = 1;
          this.driveYardsLeft = 10;
        }
        else
        {
          this.driveYardsLeft = parseInt(this.driveYardsLeft) - parseInt(this.passYards);
          this.driveDowns++;
        }
        if(this.driveMyHalf)
        {
          //this.driveSpotBall += this.runYards;
          this.driveSpotBall = parseInt(this.driveSpotBall) + parseInt(this.passYards);
          if(this.driveSpotBall > 50)
          {
            var temp = this.driveSpotBall - 50;
            this.driveSpotBall = 50 - temp;
            this.driveMyHalf = false;
          }
        }
        else
        {
          this.driveSpotBall -= this.passYards;
        }
      }
      if(this.driveSpotBall > 50 || this.driveSpotBall < 0 || this.driveDowns > 4)
      {
        jQuery("#tracker").hide();
      }

      //database stuff
      var self = this
      var ref = firebase.database().ref("FootballGames").child(self.selectedTeamId).child(self.activeGameId).child("Totals").child("Period1").child("Offense")
      ref.child("PassAtt").once("value", function(snapshot){
        var numAtt = snapshot.val()
        var playerNum = "p" + self.passPlayerNumber
        var total = numAtt.Total + 1
        var playerStat = numAtt[playerNum]
        if(playerStat == null)
        {
          playerStat = 1
        }
        else{
          playerStat++
        }
        ref.child("PassAtt").update({
          "Total": total,
          [playerNum]: playerStat
        })
      }).then(()=>{
          ref.child("RushYds").once("value", function(qbsack){
            if(self.passSack){
              var sackInfo = qbsack.val()
              var playerNum = "p" + self.passPlayerNumber
              var playerStat = sackInfo[playerNum]
              if(playerStat == null)
              {
                playerStat = parseInt(self.passYards)
              }
              else
              {
                playerStat += parseInt(self.passYards)
              }
              ref.child("RushYds").update({
                [playerNum]: parseInt(playerStat)
              })
            }
          }).then(()=>{
              ref.child("RushYds").child("Side").once("value", function(rand){
              if(self.passSack)
              {
                var numYds = rand.val()
                var s = self.pickedPassSide
                var selected = numYds[s]
                if(selected == null)
                {
                  selected = parseInt(self.passYards)
                }
                else{
                  selected += parseInt(self.passYards)
                }
                ref.child("RushYds").child("Side").update({
                [s]: selected
                })  

              }            
            }).then(()=>{
              var ref2 = firebase.database().ref("FootballGames").child(self.selectedTeamId).child(self.activeGameId).child("Totals").child("Period1").child("Special");
              ref2.child("TotalTDAllowed").once("value", function(rand2){
                if(self.passTurnover != "" && self.passTouchdown)
                var numS = rand2.val()
                if(numS == null)
                {
                  numS = 1
                }
                else
                {
                  numS += 1
                }
                ref2.update({
                  ["TotalTDAllowed"]: numS
                })
              }).then(()=>{
        ref.child("PassComp").once("value", function(snap){
          if(self.passCompletion)
          {
            var numComp = snap.val()
            var playerNum = "p" + self.passPlayerNumber
            var total = numComp.Total + 1
            var playerStat = numComp[playerNum]
            if(playerStat == null)
            {
              playerStat = 1
            }
            else{
              playerStat++
            }
            ref.child("PassComp").update({
              "Total": total,
              [playerNum]: playerStat
            })
          }
        }).then(()=>{
          ref.child("PassTD").once("value", function(shot){
            if(self.passTouchdown && self.passCompletion)
            {
              var numPassTD = shot.val()
              var playerNum = "p" + self.passPlayerNumber
              var total = numPassTD.Total + 1
              var playerStat = numPassTD[playerNum]
              if(playerStat == null)
              {
                playerStat = 1
              }
              else{
                playerStat++
              }
              ref.child("PassTD").update({
                "Total": total,
                [playerNum]: playerStat
              })
            }
          }).then(()=> {
            ref.child("PassYds").once("value", function(py){
              if(self.passCompletion){
              var numYds = py.val()
              var playerNum = "p" + self.passPlayerNumber
              var total = parseInt(numYds.Total) + parseInt(self.passYards)
              var playerStat = numYds[playerNum]
              if(playerStat == null)
              {
                playerStat = parseInt(self.passYards)
              }
              else{
                playerStat+= parseInt(self.passYards)
              }
              ref.child("PassYds").update({
                "Total": total,
                [playerNum]: parseInt(playerStat)
              })
              }
            }).then(()=> {              
              ref.child("PassYds").child("Side").once("value", function(ps){
                if(!self.passSack)
                {
                if(self.passCompletion){
                var numYds = ps.val()
                var s = self.pickedPassSide
                var selected = numYds[s]
                if(selected == null)
                {
                  selected = parseInt(self.passYards)
                }
                else{
                  selected += parseInt(self.passYards)
                }
                ref.child("PassYds").child("Side").update({
                [s]: selected
                })  
                }

                }            
              }).then(()=>{
                ref.child("RecYds").once("value", function(rys){
                  if(self.passCompletion){
                  var numTD = rys.val()
                  var playerNum = "p" + self.passCatchPlayerNum
                  var total = parseInt(numTD.Total) + parseInt(self.passYards)
                  var playerStat = numTD[playerNum]
                  if(playerStat == null)
                  {
                    playerStat = parseInt(self.passYards)
                  }
                  else{
                    playerStat+= parseInt(self.passYards)
                  }
                  ref.child("RecYds").update({
                    "Total": total,
                    [playerNum]: parseInt(playerStat)
                  })
                  }
                }).then(()=>{
                  ref.child("RecTD").once("value", function(rtd){
                  if(self.passCompletion && self.passTouchdown){
                  var numTD = rtd.val()
                  var playerNum = "p" + self.passCatchPlayerNum
                  var total = parseInt(numTD.Total) + 1
                  var playerStat = numTD[playerNum]
                  if(playerStat == null)
                  {
                    playerStat = parseInt(1)
                  }
                  else{
                    playerStat++
                  }
                  ref.child("RecTD").update({
                    "Total": total,
                    [playerNum]: parseInt(playerStat)
                  })
                  }
                }).then(()=>{
                  ref.child("Receptions").once("value", function(rec){
                    if(self.passCompletion)
                    {
                      var numRec = rec.val()
                      var playerNum = "p" + self.passCatchPlayerNum
                      var total = parseInt(numRec.Total) + 1
                      var playerStat = numRec[playerNum]
                      if(playerStat == null)
                      {
                        playerStat = parseInt(1)
                      }
                      else{
                        playerStat++
                      }
                      ref.child("Receptions").update({
                        "Total": total,
                        [playerNum]: parseInt(playerStat)
                      })
                    }
                  }).then(()=>{
                    ref.child("Fumble").once("value", function(fum){
                      if(self.passTurnover == "fumble")
                      {
                        var numFum = fum.val()
                        var playerNum = "p" + self.passTurnoverBy
                        var total = parseInt(numFum.Total) + 1
                        var playerStat = numFum[playerNum]
                        if(playerStat == null)
                        {
                          playerStat = parseInt(1)
                        }
                        else{
                          playerStat++
                        }
                        ref.child("Fumble").update({
                          "Total": total,
                          [playerNum]: parseInt(playerStat)
                        })
                      }
                    }).then(()=>{
                      ref.child("INT").once("value", function(int){
                      if(self.passTurnover == "interception")
                      {
                        var numFum = int.val()
                        var playerNum = "p" + self.passTurnoverBy
                        var total = parseInt(numFum.Total) + 1
                        var playerStat = numFum[playerNum]
                        if(playerStat == null)
                        {
                          playerStat = parseInt(1)
                        }
                        else{
                          playerStat++
                        }
                        ref.child("INT").update({
                          "Total": total,
                          [playerNum]: parseInt(playerStat)
                        })
                      }
                      }).then(()=>{
                        this.pickedPassSide = "Middle";
                        this.passPlayerNumber = '';
                        this.passCompletion = '';
                        this.passCatchPlayerNum = '';
                        this.passYards = '';
                        this.passTouchdown = '';
                        this.passSack = '';
                        this.passFumble = '';
                        this.passInterception = '';
                        this.passTurnover = '';
                        this.passTurnoverBy = '';
                      })
                        })
                        
                        
                      })
                    })
                  })
                })            
              })
              })
              })
            })
          })
        })
      })
      
    },
    penaltyConfirm: function() {
      jQuery("#penaltyForm").hide();
      jQuery("#turnoverForm").hide();
      jQuery("#offenseButtons").show();

      //Tracker
      if(this.penaltyYards >= this.driveYardsLeft)
      {
        this.driveDowns = 1;
        this.driveYardsLeft = 10;
      }
      else
      {
        this.driveYardsLeft = parseInt(this.driveYardsLeft) - parseInt(this.penaltyYards);
        this.driveDowns = this.penaltyDown;
      }
      if(this.driveMyHalf)
      {
        this.driveSpotBall = parseInt(this.driveSpotBall) + parseInt(this.penaltyYards);
        if(this.driveSpotBall > 50)
        {
          var temp = this.driveSpotBall - 50;
          this.driveSpotBall = 50 - temp;
          this.driveMyHalf = false;
        }
      }
      else
      {
        this.driveSpotBall -= this.penaltyYards;
      }
      //Database stuff

      // Reset Values
      this.penaltyType = 'falseStart';
      this.penaltyYards = '';
      this.penaltyDown = '';
    }
  },
  // When page is refreshed this happens
  mounted() {
    jQuery("#runForm").hide();
    jQuery("#passForm").hide();
    jQuery("#penaltyForm").hide();
    jQuery("#turnoverForm").hide();
    jQuery("#turnoverRunForm").hide();
    jQuery("#specialForm").hide();
    jQuery("#statleteForm").hide();

    jQuery("#getOffPosition").show();
    jQuery("#offenseButtons").hide();
  }
};
</script>
<style scoped>
div button {
  box-sizing: border-box;
  min-width: 250px;
}
.footballButton {
  text-decoration: none;
  margin: auto;
  width: 60%;
  padding: 10px;
  margin-bottom: 10px;
  text-align: center;
  cursor: default;
  border-width: 2px;
  border-style: solid;
}
</style>


