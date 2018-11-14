<template>
    <div class="footballOffense">
            <div id="offenseButtons">
                <div style="text-align: center"><h3>Offense Stats</h3></div>
                <div><p class="button" @click="offenseRun">Run</p></div>
                <div><p class="button" @click="offensePass">Pass</p></div>
                <div><p class="button" @click="offensePenalty">Penalty</p></div>
            </div>

            <div id="getOffPosition">
              <table align="center">
                <tr><th>Spot The Ball</th></tr>
                <tr>
                  <td>Ball is on the: </td>
                  <td><input type="text" size="3" maxlength="2" v-model="ballLocation"></td>
                </tr>
                <tr>
                  <td>My Half</td>
                  <td><input type="checkbox" checked v-model="myHalf"></td>
                </tr>
              </table>
              <button class="button" @click="startDrive">Start Drive</button>
            </div>

             <div id="runForm">
                <table align="center">
                  <tr><th>Run</th></tr>
                  <tr>
                    <td>Ran to the: </td>
                    <td>Left <input type="radio" value="left" v-model="pickedRunSide"></td>
                    <td>Middle <input type="radio" value="middle" v-model="pickedRunSide"></td>
                    <td>Right <input type="radio" value="right" v-model="pickedRunSide"></td>
                  </tr>       
                    <tr>
                        <td> Run by Player: </td>
                        <td><input align="right" type="text" maxlength="2" size="3" v-model="runPlayerNumber">
                        </td></tr>
                        <tr>
                            <td>Yards: </td><td><input align="right" type="text" maxlength="3" size="3" v-model="runYards"></td></tr>
                            <tr><td>Touchdown </td><td><input type="checkbox" v-model="runTouchdown" value="td"></td></tr>
                            <tr><td>Fumble:</td><td><input type="checkbox" v-model="runFumble" value="fumble"></td></tr>
                  </table>
                    <button class="button" @click="runConfirm">Confirm</button>
                </div>


            <div id="passForm">
                <table align="center">
                  <tr><th>Pass</th></tr>
                  <tr>
                    <td>Threw to the: </td>
                      <td>Left <input type="radio" value="left" v-model="pickedPassSide"></td>
                      <td>Middle <input type="radio" value="middle" v-model="pickedPassSide"></td>
                      <td>Right <input type="radio" value="right" v-model="pickedPassSide"></td>
                  </tr>
                    <tr><td>Pass by Player: </td>
                    <td><input type="text" maxlength="2" size="3" v-model="passPlayerNumber">
                    </td></tr>
                    <tr><td>Completion: </td><td><input type="checkbox" v-model="passCompletion">
                    </td></tr>
                    <tr><td>Catch by Player: </td><td><input type="text" maxlength="2" size="3" v-model="passCatchPlayerNum">
                    </td></tr>
                    <tr><td>Yards: </td><td><input type="text" maxlength="3" size="3" v-model="passYards">
                    </td></tr>
                    <tr><td>Touchdown </td><td><input type="checkbox" v-model="passTouchdown"></td></tr>
                    <tr><td>QB Sack</td><td><input align="right" type="checkbox" v-model="passSack"></td>
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
                  <tr><td>Turnover By: </td><td><input type="text" v-model="passTurnoverBy" maxlength="2" size="2"></td></tr>
                  </table>
            </div>
                    <button class="button" @click="passConfirm">Confirm</button>
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
                        <input type="text" size="2" maxlength="2" v-model="penaltyYards"></td></tr>
                        <tr><td>Down: </td><td>
                        <input type="text" size="2" maxlength="1" v-model="penaltyDown"></td></tr>        
                        </table>
                        <button class="button" @click="penaltyConfirm">Confirm</button>
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
      driveSpotBall: 50,
      driveMyHalf: true,

      //Spot Ball
      ballLocation: 20,
      myHalf: "true",

      //Runs
      pickedRunSide: "middle",
      runPlayerNumber: "",
      runYards: "",
      runTouchdown: "",
      runFumble: "",

      //Passes
      pickedPassSide: "middle",
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
      jQuery("#offenseButtons").show();
      this.activeButton = 'offense';
      //Send input to Database

      // Set Tracker
      this.driveSpotBall = this.ballLocation;
      this.driveMyHalf = this.myHalf;

      console.log(typeof(this.driveSpotBall));
      console.log(typeof(this.ballLocation));

      //Reset Values
      this.ballLocation = 20;
      this.myHalf = "true";
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
      alert(this.runTouchdown)
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
      // Database
      // var ref =firebase.database().ref("FootballGames/Example/Example-01/Totals/Period1/Offense")
      var self = this
      var ref =firebase.database().ref("FootballGames".child(self.selectedTeamId).child(self.activeGameId))
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
          if(self.runTouchdown)
          {
            ref.child("RushTD").once("value", function(points){
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
            })
          }
          
        })
        
        .then(()=>{
          self.pickedRunSide = "middle";
          self.runPlayerNumber = "";
          self.runYards = "";
          self.runTouchdown = "";
          self.runFumble = "";
        })

        // Reset Values
      // self.pickedRunSide = "middle";
      // self.runPlayerNumber = ""; used
      // self.runYards = ""; used
      // self.runTouchdown = "";
      // self.runFumble = "";
      })


      
    },
    passConfirm: function() {
      jQuery("#passForm").hide();
      jQuery("#turnoverForm").hide();
      jQuery("#offenseButtons").show();

      //database stuff

      // Reset values
      this.pickedPassSide = "middle";
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
    },
    penaltyConfirm: function() {
      jQuery("#penaltyForm").hide();
      jQuery("#turnoverForm").hide();
      jQuery("#offenseButtons").show();

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
.button {
  text-decoration: none;
  margin: auto;
  width: 60%;
  border: 2px solid black;
  background-color: red;
  padding: 10px;
  margin-bottom: 10px;
  text-align: center;
  cursor: default;
}
</style>


