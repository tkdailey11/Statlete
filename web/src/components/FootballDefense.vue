<template>
    <div class="footballDefense">
            <div id="defenseButtons">
                <div style="text-align: center"><h3>Defense Stats</h3></div>
                <div><p class="footballButton" @click="defenseRun">Run</p></div>
                <div><p class="footballButton" @click="defensePass">Pass</p></div>
                <div><p class="footballButton" @click="defensePenalty">Penalty</p></div>
            </div>

            <div id="getDefPosition">
              <table align="center">
                <tr><th>Spot The Ball</th></tr>
                <tr>
                  <td>Ball is on the: </td>
                  <td><vue-numeric-input type="text" size="3" maxlength="2" v-model="ballLocation" :min="0" :max="50" :controls="false"></vue-numeric-input></td>
                </tr>
                <tr>
                  <td>My Half</td>
                  <td><input type="checkbox" checked v-model="myHalf"></td>
                </tr>
              </table>
              <button class="footballButton" @click="startDrive">Start Drive</button>
            </div>


             <div id="runDefForm">
                <table align="center">
                    <tr><th>Run</th></tr>
                    <tr>
                    <td>Defend to the: </td>
                      <td>Left <input type="radio" value="Left" v-model="pickedRunDefSide"></td>
                      <td>Middle <input type="radio" value="Middle" v-model="pickedRunDefSide"></td>
                      <td>Right <input type="radio" value="Right" v-model="pickedRunDefSide"></td>
                    </tr>
                    <tr>
                        <td> Tackle by Player: </td>
                        <td><vue-numeric-input align="right" type="text" maxlength="2" size="3" v-model="runDefTackle" :min="0" :max="99" :controls="false"></vue-numeric-input>
                        </td>
                    </tr>
                        <tr>
                            <td>Offensive Yards: </td><td><vue-numeric-input alilgn="right" type="text" maxlength="3" size="3" v-model="runDefYards" :min="-99" :max="99" :controls="false"></vue-numeric-input></td></tr>
                            <tr><td>Touchdown </td><td><input type="checkbox" v-model="runDefTouchdown">
                            </td></tr>
                            <tr><td>QB Sack</td><td><input align="right" type="checkbox" v-model="runDefSack"></td>
                            <tr><td>Turnover</td><td><input type="checkbox" v-if="activeRunTurnover === 'false'" @click="defenseRunTurnover">
                            <input type="checkbox" v-else @click="defenseRunTurnoverHide"></td></tr></table>

                            <div id="turnoverRunForm">
                <table align="center"><tr><td>Fumble:</td><td><input type="checkbox" v-model="runDefFumble" value="fumble" checked>
                </td></tr>
                  <tr><td>Recovered By: </td><td><vue-numeric-input type="text" v-model="rundefRecoveredBy" maxlength="2" size="2" :min="0" :max="99" :controls="false"></vue-numeric-input></td></tr>
                  </table>
            </div>

                        <button class="footballButton" @click="runConfirm">Confirm</button>
                    </div>



            <div id="passDefForm">
                <table align="center">
                    <tr><th>Pass</th></tr>
                    <tr>
                    <td>Defend to the: </td>
                      <td>Left <input type="radio" value="Left" v-model="pickedPassDefSide"></td>
                      <td>Middle <input type="radio" value="Middle" v-model="pickedPassDefSide"></td>
                      <td>Right <input type="radio" value="Right" v-model="pickedPassDefSide"></td>
                    </tr>
                    <tr><td>Completion: </td><td><input type="checkbox" v-model="passDefCompletion">
                    </td></tr>
                    <tr>
                        <td> Tackle by Player: </td>
                        <td><vue-numeric-input align="right" type="text" maxlength="2" size="3" v-model="passDefTacklePlayerNum" :min="0" :max="99" :controls="false"></vue-numeric-input>
                        </td></tr>
                    <tr><td>Offensive Yards: </td><td><vue-numeric-input type="text" maxlength="3" size="3" v-model="passDefYards" :min="-99" :max="99" :controls="false"></vue-numeric-input>
                    </td></tr>
                    <tr><td>Touchdown </td><td><input type="checkbox" v-model="passDefTouchdown">
                    </td></tr>
                    <tr><td>QB Sack</td><td><input align="right" type="checkbox" v-model="passDefSack"></td>
                    <tr><td>Turnover</td><td><input type="checkbox" v-if="activeTurnover === 'false'" @click="defenseTurnover">
                    <input type="checkbox" v-else @click="defenseTurnoverHide"></td></tr></table>
                    <div id="turnoverForm">
                <table align="center"><tr><td>Fumble:</td><td><input type="radio" v-model="passTurnoverDefType" value="fumble">
                </td></tr><tr><td>Interception:</td><td>
                  <input type="radio" v-model="passTurnoverDefType" value="interception"></td></tr>
                  <tr><td>Recovered By: </td><td><vue-numeric-input type="text" v-model="passDefRecoveredBy" maxlength="2" size="2" :min="0" :max="99" :controls="false"></vue-numeric-input></td></tr>
                  </table>
            </div>
                    <button class="footballButton" @click="passConfirm">Confirm</button>
            </div>

            <div id="penaltyDefForm">
                      <table align="center"><tr><td>Penalty: </td><td>
                        <select v-model="penaltyDefType" size="1">
                          <option value="defensiveInterference">Defensive Pass Interference</option>
                          <option value="offside">Offside Defense</option>
                          <option value="defensiveHolding">Holding Defense</option>
                          <option value="delayGame">Delay of Game Defense</option>
                          <option value="personalFoul">Personal Foul Defense</option>
                        </select>
                      </td></tr><tr><td>Yards: </td><td>
                        <vue-numeric-input type="text" size="2" maxlength="2" v-model="penaltyDefYards" :min="-15" :max="15" :controls="false"></vue-numeric-input></td></tr>
                        <tr><td>Down: </td><td>
                        <vue-numeric-input type="text" size="2" maxlength="1" v-model="penaltyDefDown" :min="1" :max="4" :controls="false"></vue-numeric-input></td></tr>
                        </table>
                        <button class="footballButton" @click="penaltyConfirm">Confirm</button>
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
      driveSpotBall: 25,
      driveMyHalf: true,

      //Spot Ball
      ballLocation: 25,
      myHalf: "true",

      //Runs
      pickedRunDefSide: "Middle",
      runDefTackle: "",
      runDefYards: "",
      runDefTouchdown: "",
      runDefSack: "",
      runDefFumble: "",
      rundefRecoveredBy: "",

      //Passes
      pickedPassDefSide: "Middle",
      passDefCompletion: '',
      passDefTacklePlayerNum: '',
      passDefYards: '',
      passDefTouchdown: '',
      passDefSack: '',
      passTurnoverDefType: '',
      passDefRecoveredBy: '',
      
      //Penalty
      penaltyDefType: 'defensiveInterference',
      penaltyDefYards: '',
      penaltyDefDown: '',
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
      jQuery("#runDefForm").hide();
      jQuery("#passDefForm").hide();
      jQuery("#penaltyForm").hide();
      jQuery("#turnoverForm").hide();
      jQuery("#getDefPosition").hide();
      jQuery("#defenseButtons").show();
      jQuery("#tracker").show();
      this.activeButton = 'defense';

      // Set Tracker
      this.driveSpotBall = this.ballLocation;
      this.driveMyHalf = this.myHalf;

      // Reset data
      this.ballLocation = 25;
      this.myHalf = "true";
    },

    defenseRun: function() {
      jQuery("#runDefForm").show();
      jQuery("#defenseButtons").hide();
      jQuery("#turnoverForm").hide();
    },
    defensePass: function() {
      jQuery("#passDefForm").show();
      jQuery("#defenseButtons").hide();
      jQuery("#turnoverForm").hide();
    },
    defensePenalty: function() {
      jQuery("#penaltyDefForm").show();
      jQuery("#defenseButtons").hide();
      jQuery("#turnoverForm").hide();
    },
    defenseTurnover: function() {
      jQuery("#turnoverForm").show();
      this.activeTurnover = "true";
    },
    defenseTurnoverHide: function() {
      jQuery("#turnoverForm").hide();
      this.activeTurnover = "false";
    },
     defenseRunTurnover: function() {
      jQuery("#turnoverRunForm").show();
      this.activeRunTurnover = "true";
    },
    defenseRunTurnoverHide: function() {
      jQuery("#turnoverRunForm").hide();
      this.activeRunTurnover = "false";
    },
    runConfirm: function() {
      jQuery("#runDefForm").hide();
      jQuery("#turnoverForm").hide();
      jQuery("#defenseButtons").show();

      //Tracker
      if(this.runDefYards >= this.driveYardsLeft)
      {
        this.driveDowns = 1;
        this.driveYardsLeft = 10;
      }
      else
      {
        this.driveYardsLeft = parseInt(this.driveYardsLeft) - parseInt(this.runDefYards);
        this.driveDowns++;
      }
      if(this.driveMyHalf)
      {
        //this.driveSpotBall += this.runYards;
        this.driveSpotBall = parseInt(this.driveSpotBall) + parseInt(this.runDefYards);
        if(this.driveSpotBall > 50)
        {
          var temp = this.driveSpotBall - 50;
          this.driveSpotBall = 50 - temp;
          this.driveMyHalf = false;
        }
      }
      else
      {
        this.driveSpotBall -= this.runDefYards;
      }
      if(this.driveSpotBall > 50 || this.driveSpotBall < 0 || this.driveDowns > 4)
      {
        jQuery("#tracker").hide();
      }

      //Database
      self = this
      var ref = firebase.database().ref("FootballGames").child(self.selectedTeamId).child(self.activeGameId).child("Totals").child("Period1").child("Defense")
      ref.child("FumbleForced").once("value", function(snapshot){
        if(self.runDefFumble && self.runDefTackle != "")
        {
          var numFumForced = snapshot.val()
          var playerNum = "p" + self.runDefTackle
          var total = numFumForced.Total + 1
          var playerStat = numFumForced[playerNum]
          if(playerStat == null)
          {
            playerStat = 1
          }
          else{
            playerStat++
          }
          ref.child("FumbleForced").update({
            "Total": total,
            [playerNum]: playerStat
          })
        }        
      }).then(()=>{
        ref.child("FumbleRec").once("value", function(snap){
        if(self.runDefFumble && self.rundefRecoveredBy != "")
        {
          var numFumForced = snap.val()
          var playerNum = "p" + self.rundefRecoveredBy
          var total = numFumForced.Total + 1
          var playerStat = numFumForced[playerNum]
          if(playerStat == null)
          {
            playerStat = 1
          }
          else{
            playerStat++
          }
          ref.child("FumbleRec").update({
            "Total": total,
            [playerNum]: playerStat
          })
        }  
      }).then(()=>{
        ref.child("Sacks").once("value", function(sack){
          if(self.runDefSack && self.runDefTackle != "")
          {
            var numSack = sack.val()
            var playerNum = "p" + self.runDefTackle
            var total = numSack.Total + 1
            var playerStat = numSack[playerNum]
            if(playerStat == null)
            {
              playerStat = 1
            }
            else{
              playerStat++
            }
            ref.child("Sacks").update({
              "Total": total,
              [playerNum]: playerStat
            })
          }
        }).then(()=>{
          ref.child("Side").once("value", function(side){
            if(self.runDefYards != "")
            {
              var rushYds = side.val()
              var pos = self.pickedRunDefSide
              var selected = rushYds[pos]
              if(selected == null)
              {
                selected = parseInt(self.runDefYards)
              }
              else{
                selected += parseInt(self.runDefYards)
              }
              ref.child("Side").update({
                [pos]: selected
              })
            }
            
          }).then(()=>{
            ref.child("Tackles").once("value", function(tack){
              if(self.runDefTackle != "")
              var tackles = tack.val()
              var playerNum = "p" + self.runDefTackle
              var total = tackles.Total + 1
              var playerStat = tackles[playerNum]
              if(playerStat == null)
              {
                playerStat = 1
              }
              else{
                playerStat++
              }
              ref.child("Tackles").update({
                "Total": total,
                [playerNum]: playerStat
              })
            }).then(()=>{
              ref.once("value", function(tpt){
                if(self.runDefTouchdown)
                {
                  self.$emit("oppScore", 6)
                  var runTD = tpt.val()
                  var total = parseInt(runTD.TotalRushTD) + parseInt(1)
                  ref.update({
                    "TotalRushTD": total
                  })
                }
              }).then(()=>{
                ref.once("value", function(tryds){
                  if(self.runDefYards != "")
                  {
                    var rushYds = tryds.val()
                    var total = parseInt(rushYds.TotalRushYds) + parseInt(self.runDefYards)
                    ref.update({
                      "TotalRushYds": total
                    })
                  }
                }).then(()=>{
                  var ref2 = firebase.database().ref("FootballGames").child(self.selectedTeamId).child(self.activeGameId).child("Totals").child("Period1").child("Offense");
                  ref2.child("RushTD").once("value", function(rand2){
                    if(self.runDefTouchdown && self.runDefFumble)
                    {
                      self.$emit("incMyScore", 6)
                      var rushTD = rand2.val()
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
                      ref2.child("RushTD").update({
                        "Total": total,
                        [playerNum]: player
                      })
                    }
                  }).then(()=>{
                  this.pickedRunDefSide = "Middle";
                  this.runDefTackle = "";
                  this.runDefYards = "";
                  this.runDefTouchdown = "";
                  this.runDefSack = "";
                  this.runDefFumble = "";
                  this.rundefRecoveredBy = "";
                })
                  
                })
              })
            })
          })
        })
      })
      })
      // Reset Data
      // this.pickedRunDefSide = "Middle";
      // this.runDefTackle = "";
      // this.runDefYards = "";
      // this.runDefTouchdown = "";
      // this.runDefSack = "";
      // this.runDefFumble = "";
      // this.rundefRecoveredBy = "";
    },
    passConfirm: function() {
      jQuery("#passDefForm").hide();

      jQuery("#turnoverForm").hide();
      jQuery("#defenseButtons").show();

      //Tracker
      if(this.passDefCompletion)
      {
        if(this.passDefYards >= this.driveYardsLeft)
        {
          this.driveDowns = 1;
          this.driveYardsLeft = 10;
        }
        else
        {
          this.driveYardsLeft = parseInt(this.driveYardsLeft) - parseInt(this.passDefYards);
          this.driveDowns++;
        }
        if(this.driveMyHalf)
        {
          //this.driveSpotBall += this.runYards;
          this.driveSpotBall = parseInt(this.driveSpotBall) + parseInt(this.passDefYards);
          if(this.driveSpotBall > 50)
          {
            var temp = this.driveSpotBall - 50;
            this.driveSpotBall = 50 - temp;
            this.driveMyHalf = false;
          }
        }
        else
        {
          this.driveSpotBall -= this.passDefYards;
        }
      }
      if(this.driveSpotBall > 50 || this.driveSpotBall < 0 || this.driveDowns > 4)
      {
        jQuery("#tracker").hide();
      }

      self = this
      var ref = firebase.database().ref("FootballGames").child(self.selectedTeamId).child(self.activeGameId).child("Totals").child("Period1").child("Defense")
      ref.child("FumbleForced").once("value", function(snapshot){
        
        if(self.passTurnoverDefType == "fumble" && self.passDefRecoveredBy != "")
        {
          var numFumForced = snapshot.val()
          var playerNum = "p" + self.passDefRecoveredBy
          var total = numFumForced.Total + 1
          var playerStat = numFumForced[playerNum]
          if(playerStat == null)
          {
            playerStat = 1
          }
          else{
            playerStat++
          }
          ref.child("FumbleForced").update({
            "Total": total,
            [playerNum]: playerStat
          })
        }        
      }).then(()=>{
        ref.child("FumbleRec").once("value", function(snap){
        if(self.passTurnoverDefType == "fumble" && self.passDefRecoveredBy != "")
        {
          var numFumForced = snap.val()
          var playerNum = "p" + self.passDefRecoveredBy
          var total = numFumForced.Total + 1
          var playerStat = numFumForced[playerNum]
          if(playerStat == null)
          {
            playerStat = 1
          }
          else{
            playerStat++
          }
          ref.child("FumbleRec").update({
            "Total": total,
            [playerNum]: playerStat
          })
        }  
      }).then(()=>{
        ref.child("INT").once("value", function(shot){
        if(self.passTurnoverDefType == "interception" && self.passDefRecoveredBy != "")
        {
          var numInt = shot.val()
          var playerNum = "p" + self.passDefRecoveredBy
          var total = numInt.Total + 1
          var playerStat = numInt[playerNum]
          if(playerStat == null)
          {
            playerStat = 1
          }
          else{
            playerStat++
          }
          ref.child("INT").update({
            "Total": total,
            [playerNum]: playerStat
          })
        }  
      }).then(()=>{
        ref.child("Sacks").once("value", function(sack){
          if(self.passDefSack && self.passDefTacklePlayerNum != "")
          {
            var numSack = sack.val()
            var playerNum = "p" + self.passDefTacklePlayerNum
            var total = numSack.Total + 1
            var playerStat = numSack[playerNum]
            if(playerStat == null)
            {
              playerStat = 1
            }
            else{
              playerStat++
            }
            ref.child("Sacks").update({
              "Total": total,
              [playerNum]: playerStat
            })
          }
        }).then(()=>{
          ref.child("Side").once("value", function(side){
            if(self.passDefYards != "")
            {
              var rushYds = side.val()
              var pos = self.pickedPassDefSide
              var selected = rushYds[pos]
              if(selected == null)
              {
                selected = parseInt(self.passDefYards)
              }
              else{
                selected += parseInt(self.passDefYards)
              }
              ref.child("Side").update({
                [pos]: selected
              })
            }
          }).then(()=>{
            ref.child("Tackles").once("value", function(tack){
              if(self.passDefTacklePlayerNum != "")
              {
                  var tackles = tack.val()
                  var playerNum = "p" + self.passDefTacklePlayerNum
                  var total = tackles.Total + 1
                  var playerStat = tackles[playerNum]
                  if(playerStat == null)
                  {
                    playerStat = 1
                  }
                  else{
                    playerStat++
                  }
                  ref.child("Tackles").update({
                    "Total": total,
                    [playerNum]: playerStat
                  })
              }
            }).then(()=>{
              ref.once("value", function(tpt){
                if(self.passDefTouchdown)
                {
                  var runTD = tpt.val()
                  var total = parseInt(runTD.TotalPassTD) + parseInt(1)
                  ref.update({
                    "TotalPassTD": total
                  })
                }
              }).then(()=>{
                ref.once("value", function(tryds){
                  if(self.passDefYards != "")
                  {
                    var rushYds = tryds.val()
                    var total = parseInt(rushYds.TotalPassYds) + parseInt(self.passDefYards)
                    ref.update({
                      "TotalPassYds": total
                    })
                  }
                }).then(()=>{
                  var ref2 = firebase.database().ref("FootballGames").child(self.selectedTeamId).child(self.activeGameId).child("Totals").child("Period1").child("Offense");
                  ref2.child("RushTD").once("value", function(rand3){
                    if(self.passDefTouchdown && (self.passTurnoverDefType == "interception" || self.passTurnoverDefType == "fumble") && self.passDefRecoveredBy != "")
                    {
                      self.$emit("incMyScore", 6)
                      var rushTD = rand3.val()
                      var playerNum = "p" + self.passDefRecoveredBy
                      var total = rushTD.Total + 1
                      var player = rushTD[playerNum]
                      if(player == null)
                      {
                        player = 1
                      }
                      else{
                        player++
                      }
                      ref2.child("RushTD").update({
                        "Total": total,
                        [playerNum]: player
                      })
                    }
                  }).then(()=>{
                    this.pickedPassDefSide = "Middle";
                    this.passDefCompletion = '';
                    this.passDefTacklePlayerNum = '';
                    this.passDefYards = '';
                    this.passDefTouchdown = '';
                    this.passDefSack = '';
                    this.passDefFumble = '';
                    this.passDefInterception = '';
                    this.passDefRecoveredBy = '';
                })
                })
              })
            })
          })
        })
      })
      })
      })

      //Reset data
      // this.pickedPassDefSide = "Middle";
      // this.passDefCompletion = '';
      // this.passDefTacklePlayerNum = '';
      // this.passDefYards = '';
      // this.passDefTouchdown = '';
      // this.passDefSack = '';
      // this.passDefFumble = '';
      // this.passDefInterception = '';
      // this.passDefRecoveredBy = '';

    },
    penaltyConfirm: function() {
      jQuery("#penaltyDefForm").hide();
      jQuery("#turnoverForm").hide();
      jQuery("#defenseButtons").show();

      //Tracker
      if(this.penaltyDefYards >= this.driveYardsLeft)
      {
        this.driveDowns = 1;
        this.driveYardsLeft = 10;
      }
      else
      {
        this.driveYardsLeft = parseInt(this.driveYardsLeft) - parseInt(this.penaltyDefYards);
        this.driveDowns = this.penaltyDown;
      }
      if(this.driveMyHalf)
      {
        this.driveSpotBall = parseInt(this.driveSpotBall) + parseInt(this.penaltyDefYards);
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

      //Reset Data
      this.penaltyDefType = 'defensiveInterference';
      this.penaltyDefYards = '';
      this.penaltyDefDown = '';
    }
  },
  // When page is refreshed this happens
  mounted() {
    jQuery("#runDefForm").hide();
    jQuery("#passDefForm").hide();
    jQuery("#penaltyDefForm").hide();
    jQuery("#turnoverForm").hide();
    jQuery("#turnoverRunForm").hide();
    jQuery("#defenseButtons").hide();

    jQuery("#getDefPosition").show();
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


