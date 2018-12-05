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

            <div id="runLeftForm">
              Best Option<br>
              <img src="../assets/images/football-ask-statlete/run_left.png">
              <br>
            </div>

            <div id="runRightForm">
              Best Option<br>
              <img src="../assets/images/football-ask-statlete/run_right.png">
              <br>
            </div>

            <div id="runMiddleForm">
              Best Option<br>
              <img src="../assets/images/football-ask-statlete/run_middle.png">
              <br>
            </div>

            <div id="throwLeftForm">
              Best Option<br>
              <img src="../assets/images/football-ask-statlete/pass_left.png">
              <br>
            </div>

            <div id="throwMiddleForm">
              Best Option<br>
              <img src="../assets/images/football-ask-statlete/pass_middle.png">
              <br>
            </div>

            <div id="throwRightForm">
              Best Option<br>
              <img src="../assets/images/football-ask-statlete/pass_right.png">
              <br>
            </div>

            <div id="runLeftFormW">
              Worst Option<br>
              <img src="../assets/images/football-ask-statlete/run_left.png">
              <br>
              <button class="footballButton" @click="askStatleteConfirm">Confirm</button>
            </div>

            <div id="runRightFormW">
              Worst Option<br>
              <img src="../assets/images/football-ask-statlete/run_right.png">
              <br>
              <button class="footballButton" @click="askStatleteConfirm">Confirm</button>
            </div>

            <div id="runMiddleFormW">
              Worst Option<br>
              <img src="../assets/images/football-ask-statlete/run_middle.png">
              <br>
              <button class="footballButton" @click="askStatleteConfirm">Confirm</button>
            </div>

            <div id="throwLeftFormW">
              Worst Option<br>
              <img src="../assets/images/football-ask-statlete/pass_left.png">
              <br>
              <button class="footballButton" @click="askStatleteConfirm">Confirm</button>
            </div>

            <div id="throwMiddleFormW">
              Worst Option<br>
              <img src="../assets/images/football-ask-statlete/pass_middle.png">
              <br>
              <button class="footballButton" @click="askStatleteConfirm">Confirm</button>
            </div>

            <div id="throwRightFormW">
              Worst Option<br>
              <img src="../assets/images/football-ask-statlete/pass_right.png">
              <br>
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

      //Reset Values
      this.ballLocation = parseInt(25);
      this.myHalf = "true";
    },

    askStatlete: function() {
      jQuery("#statleteForm").hide();
      jQuery("#offenseButtons").hide();
      jQuery("#turnoverForm").hide();

      var short = 3;
      var medium = 8;
      var downDist = this.driveDowns.toString();

      if(downDist == "1")
      {
        downDist = "1Down";
      }
      if(downDist == "4")
      {
        downDist = "4DownAndLong"
      }
      if(this.driveYardsLeft <= short)
      {
        if(downDist != "1Down" && downDist != "4DownAndLong")
        {
          downDist += "DownAndShort"
        }

      }
      else if(this.driveYardsLeft <= medium && this.driveYardsLeft > short)
      {
        if(downDist != "1Down" && downDist != "4DownAndLong")
        {
          downDist += "DownAndMedium"
        }
      }
      else
      {
        if(downDist != "1Down" && downDist != "4DownAndLong")
        {
          downDist += "DownAndLong"
        }
      }
      var direc = "PassLeft";
      var direcW = "PassLeft";

      var self = this;
      var askRef = firebase.database().ref("AskStatlete").child(self.selectedTeamId)
      askRef.child(downDist).once("value", function(getValue){
        var askYds = getValue.val();
        var pL = parseInt(askYds.PassLeft);
        var pM = parseInt(askYds.PassMiddle);
        var pR = parseInt(askYds.PassRight);
        var rL = parseInt(askYds.RunLeft);
        var rM = parseInt(askYds.RunMiddle);
        var rR = parseInt(askYds.RunRight);

        var maxx = pL;
        var minn = pL;
        if(pM > maxx)
        {
          maxx = pM;
          direc = "PassMiddle";
        }
        if(pR > maxx)
        {
          maxx = pR
          direc = "PassRight"
        }
        if(rL > maxx)
        {
          maxx = rL;
          direc = "RunLeft"
        }
        if(rM > maxx)
        {
          maxx = rM;
          direc = "RunMiddle"
        }
        if(rR > maxx)
        {
          maxx = rR;
          direc = "RunRight"
        }
        if(pM < minn)
        {
          minn = pM;
          direcW = "PassMiddle";
        }
        if(pR < minn)
        {
          minn = pR
          direcW = "PassRight";
        }
        if(rL < minn)
        {
          minn = rL;
          direcW = "RunLeft";
        }
        if(rM < minn)
        {
          minn = rM;
          direcW = "RunMiddle";
        }
        if(rR < minn)
        {
          minn = rR;
          direcW = "RunRight"
        }

        
      }).then(()=>{
        if(direc == "RunLeft")
      {
        jQuery("#runLeftForm").show();
      }
      else if(direc == "RunMiddle")
      {
        jQuery("#runMiddleForm").show();
      }
      else if(direc == "RunRight")
      {
        jQuery("#runRightForm").show();
      }
      else if(direc == "PassLeft")
      {
        jQuery("#throwLeftForm").show();
      }
      else if(direc == "PassMiddle") 
      {
        jQuery("#throwMiddleForm").show();
      }
      else
      {
        jQuery("#throwRightForm").show();
      }

      if(direcW == "RunLeft")
      {
        jQuery("#runLeftFormW").show();
      }
      else if(direcW == "RunMiddle")
      {
        jQuery("#runMiddleFormW").show();
      }
      else if(direcW == "RunRight")
      {
        jQuery("#runRightFormW").show();
      }
      else if(direcW == "PassLeft")
      {
        jQuery("#throwLeftFormW").show();
      }
      else if(direcW == "PassMiddle") 
      {
        jQuery("#throwMiddleFormW").show();
      }
      else
      {
        jQuery("#throwRightFormW").show();
      }
      })

      
    },

    askStatleteConfirm: function() {
      jQuery("#statleteForm").hide();
      jQuery("#runLeftForm").hide();
      jQuery("#runMiddleForm").hide();
      jQuery("#runRightForm").hide();
      jQuery("#throwLeftForm").hide();
      jQuery("#throwMiddleForm").hide();
      jQuery("#throwRightForm").hide();

      jQuery("#statleteFormW").hide();
      jQuery("#runLeftFormW").hide();
      jQuery("#runMiddleFormW").hide();
      jQuery("#runRightFormW").hide();
      jQuery("#throwLeftFormW").hide();
      jQuery("#throwMiddleFormW").hide();
      jQuery("#throwRightFormW").hide();
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

      var short = 3;
      var medium = 8;

      var downDistance = "1Down";
      var playSide = "Run" + this.pickedRunSide;
      var playResult = 0;


      //AskStatlete
      if(this.driveDowns <= 4 && this.runYards != "")
      {
        if(this.driveYardsLeft <= short)
        {
          if(this.driveDowns == 1)
          {
            downDistance = "1Down";
            if(this.runYards < 0 || this.runFumble)
            {
              playResult = 0;
            }
            else if(this.runYards == 0)
            {
              playResult = 1;
            }
            else if(this.runYards <=3 && this.runYards > 0)
            {
              playResult = 2;
            }
            else if(this.runYards > 3 && this.runYards <= 7)
            {
              playResult = 3;
            }
            else if(this.runYards > 7 && this.runYards <= 19)
            {
              playResult = 4;
            }
            else if(this.runYards > 19)
            {
              playResult = 5;
            }
          }
          else if(this.driveDowns == 2)
          {
            downDistance = "2DownAndShort";
            if(this.runYards < 0 || this.runFumble)
            {
              playResult = 0;
            }
            else if(this.runYards == 0)
            {
              playResult = 1;
            }
            else if(this.runYards == 1)
            {
              playResult = 2;
            }
            else if(this.runYards == 2)
            {
              playResult = 3;
            }
            else if(this.runYards > 2 && this.runYards <= 19)
            {
              playResult = 4;
            }
            else if(this.runYards > 19)
            {
              playResult = 5;
            }
          }
          else if(this.driveDowns == 3)
          {
            downDistance = "3DownAndShort";
            if(this.runYards < 0 || this.runFumble)
            {
              playResult = 0;
            }
            else if(this.runYards == 0 || this.runYards == 1)
            {
              playResult = 1;
            }
            else if(this.runYards == 2)
            {
              playResult = 2;
            }
            else if(this.runYards > 2 && this.runYards <= 19)
            {
              playResult = 4;
            }
            else if(this.runYards > 19)
            {
              playResult = 5;
            }
          }
          else
          {
            downDistance = "4DownAndLong";
            if(this.runYards >= this.driveYardsLeft)
            {
              playResult = 4
            }
          }
        }
        if(this.driveYardsLeft > short && this.driveYardsLeft <= medium)
        {
          if(this.driveDowns == 1)
          {
            downDistance = "1Down";
            if(this.runYards < 0 || this.runFumble)
            {
              playResult = 0;
            }
            else if(this.runYards == 0)
            {
              playResult = 1;
            }
            else if(this.runYards <=3 && this.runYards > 0)
            {
              playResult = 2;
            }
            else if(this.runYards > 3 && this.runYards <= 7)
            {
              playResult = 3;
            }
            else if(this.runYards > 7 && this.runYards <= 19)
            {
              playResult = 4;
            }
            else if(this.runYards > 19)
            {
              playResult = 5;
            }
          }
          else if(this.driveDowns == 2)
          {
            downDistance = "2DownAndMedium";
            if(this.runYards < 0 || this.runFumble)
            {
              playResult = 0;
            }
            else if(this.runYards == 0)
            {
              playResult = 1;
            }
            else if(this.runYards <=3 && this.runYards > 0)
            {
              playResult = 2;
            }
            else if(this.runYards > 3 && this.runYards <= 7)
            {
              playResult = 3;
            }
            else if(this.runYards > 7 && this.runYards <= 19)
            {
              playResult = 4;
            }
            else if(this.runYards > 19)
            {
              playResult = 5;
            }
          }
          else if(this.driveDowns == 3)
          {
            downDistance = "3DownAndMedium";
            if(this.runYards < 0 || this.runFumble)
            {
              playResult = 0;
            }
            else if(this.runYards >= 0 && this.runYards <= 2)
            {
              playResult = 1;
            }
            else if(this.runYards > 2 && this.runYards <= 5)
            {
              playResult = 2;
            }
            else if(this.runYards > 5 && this.runYards <= 7)
            {
              playResult = 3;
            }
            else if(this.runYards > 7 && this.runYards <= 19)
            {
              playResult = 4;
            }
            else if(this.runYards > 19)
            {
              playResult = 5;
            }
          }
          else
          {
            downDistance = "4DownAndLong";
            if(this.runYards >= this.driveYardsLeft)
            {
              playResult = 4
            }
          }
        }
        if(this.driveYardsLeft > medium)
        {
          if(this.driveDowns == 1)
          {
            downDistance = "1Down";
            if(this.runYards < 0 || this.runFumble)
            {
              playResult = 0;
            }
            else if(this.runYards == 0)
            {
              playResult = 1;
            }
            else if(this.runYards <=3 && this.runYards > 0)
            {
              playResult = 2;
            }
            else if(this.runYards > 3 && this.runYards <= 7)
            {
              playResult = 3;
            }
            else if(this.runYards > 7 && this.runYards <= 19)
            {
              playResult = 4;
            }
            else if(this.runYards > 19)
            {
              playResult = 5;
            }
          }
          else if(this.driveDowns == 2)
          {
            downDistance = "2DownAndLong";
            if(this.runYards < 0 || this.runFumble)
            {
              playResult = 0;
            }
            else if(this.runYards == 0)
            {
              playResult = 1;
            }
            else if(this.runYards <=3 && this.runYards > 0)
            {
              playResult = 2;
            }
            else if(this.runYards > 3 && this.runYards <= 7)
            {
              playResult = 3;
            }
            else if(this.runYards > 7 && this.runYards <= 19)
            {
              playResult = 4;
            }
            else if(this.runYards > 19)
            {
              playResult = 5;
            }
          }
          else if(this.driveDowns == 3)
          {
            downDistance = "3DownAndLong";
            if(this.runYards < 0 || this.runFumble)
            {
              playResult = 0;
            }
            else if(this.runYards > 0 && this.runYards <= 5)
            {
              playResult = 1;
            }
            else if(this.runYards <= 8 && this.runYards > 5)
            {
              playResult = 2;
            }
            else if(this.runYards > 8 && this.runYards <= 19)
            {
              playResult = 3;
            }
            else if(this.runYards >= this.driveYardsLeft)
            {
              playResult = 4;
            }
            else if(this.runYards > 19)
            {
              playResult = 5;
            }
          }
          else
          {
            downDistance = "4DownAndLong";
            if(this.runYards >= this.driveYardsLeft)
            {
              playResult = 4;
            }
          }
        }
      }
      var self = this;
      var askRef = firebase.database().ref("AskStatlete").child(self.selectedTeamId)
      askRef.child(downDistance).once("value", function(askValue){
        var askYds = askValue.val();
        var needVals = askYds[playSide]

        askRef.child(downDistance).update({
            [playSide]: parseInt(needVals) + parseInt(playResult)
          })
      })
      //Tracker
      if(this.runYards != "")
      {  
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
      }
      if(this.driveSpotBall > 50 || this.driveSpotBall < 0 || this.driveDowns > 4 || this.runYards == "")
      {
        jQuery("#tracker").hide();
      }
      // Database
      // var ref =firebase.database().ref("FootballGames/Example/Example-01/Totals/Period1/Offense")
      var self = this
      var ref =firebase.database().ref("FootballGames").child(self.selectedTeamId).child(self.activeGameId).child("Totals").child("Offense")
      var ref2 = firebase.database().ref("FootballGames").child(self.selectedTeamId).child(self.activeGameId).child("Totals").child("Special");
        ref2.child("TotalTDAllowed").once("value", function(rand2){
          if(self.runFumble && self.runTouchdown && self.runPlayerNumber != "")
          {
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
          }
        }).then(()=>{
        ref.child("RushCarries").once("value", function(snapshot){
          if(self.runPlayerNumber != "" && self.runYards != "")
          {
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
          }
        
      }).then(()=>{
        ref.child("RushYds").once("value", function(shot){
          if(self.runPlayerNumber != "" && self.runYards != "")
          {
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
          }
          
        }).then(()=>{
          ref.child("RushYds").child("Side").once("value", function(side){
            if(self.runPlayerNumber != "" && self.runYards != "")
            {
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
            }
            
          }).then(()=>{
          
            ref.child("RushTD").once("value", function(points){ 
            if(self.runTouchdown && self.runPlayerNumber != "" && self.runYards != "")
            {
              self.$emit("incMyScore", 6) 
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
                if(self.runFumble && self.runPlayerNumber != "")
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
          })})
      })


      
    },
    passConfirm: function() {
      jQuery("#passForm").hide();
      jQuery("#turnoverForm").hide();
      jQuery("#offenseButtons").show();

      //AskStatlete
      var short = 3;
      var medium = 8;

      var downDistance = "1Down";
      var playSide = "Pass" + this.pickedPassSide;
      var playResult = 0;

      if(this.driveDowns <= 4 && this.passYards != "")
      {
        if(this.driveYardsLeft <= short)
        {
          if(this.driveDowns == 1)
          {
            downDistance = "1Down";
            if(this.passYards < 0 || this.passInterception || this.passFumble || this.passSack)
            {
              playResult = 0;
            }
            else if(this.passYards == 0)
            {
              playResult = 1;
            }
            else if(this.passYards <=3 && this.passYards > 0)
            {
              playResult = 2;
            }
            else if(this.passYards > 3 && this.passYards <= 7)
            {
              playResult = 3;
            }
            else if(this.passYards > 7 && this.passYards <= 19)
            {
              playResult = 4;
            }
            else if(this.passYards > 19)
            {
              playResult = 5;
            }
          }
          else if(this.driveDowns == 2)
          {
            downDistance = "2DownAndShort";
            if(this.passYards < 0 || this.passInterception || this.passFumble || this.passSack)
            {
              playResult = 0;
            }
            else if(this.passYards == 0)
            {
              playResult = 1;
            }
            else if(this.passYards == 1)
            {
              playResult = 2;
            }
            else if(this.passYards == 2)
            {
              playResult = 3;
            }
            else if(this.passYards > 2 && this.passYards <= 19)
            {
              playResult = 4;
            }
            else if(this.passYards > 19)
            {
              playResult = 5;
            }
          }
          else if(this.driveDowns == 3)
          {
            downDistance = "3DownAndShort";
            if(this.passYards < 0 || this.passInterception || this.passFumble || this.passSack)
            {
              playResult = 0;
            }
            else if(this.passYards == 0 || this.passYards == 1)
            {
              playResult = 1;
            }
            else if(this.passYards == 2)
            {
              playResult = 2;
            }
            else if(this.passYards > 2 && this.passYards <= 19)
            {
              playResult = 4;
            }
            else if(this.passYards > 19)
            {
              playResult = 5;
            }
          }
          else
          {
            downDistance = "4DownAndLong";
            if(this.passYards >= this.driveYardsLeft)
            {
              playResult = 4
            }
          }
        }
        if(this.driveYardsLeft > short && this.driveYardsLeft <= medium)
        {
          if(this.driveDowns == 1)
          {
            downDistance = "1Down";
            if(this.passYards < 0 || this.passInterception || this.passFumble || this.passSack)
            {
              playResult = 0;
            }
            else if(this.passYards == 0)
            {
              playResult = 1;
            }
            else if(this.passYards <=3 && this.passYards > 0)
            {
              playResult = 2;
            }
            else if(this.passYards > 3 && this.passYards <= 7)
            {
              playResult = 3;
            }
            else if(this.passYards > 7 && this.passYards <= 19)
            {
              playResult = 4;
            }
            else if(this.passYards > 19)
            {
              playResult = 5;
            }
          }
          else if(this.driveDowns == 2)
          {
            downDistance = "2DownAndMedium";
            if(this.passYards < 0 || this.passInterception || this.passFumble || this.passSack)
            {
              playResult = 0;
            }
            else if(this.passYards == 0)
            {
              playResult = 1;
            }
            else if(this.passYards <=3 && this.passYards > 0)
            {
              playResult = 2;
            }
            else if(this.passYards > 3 && this.passYards <= 7)
            {
              playResult = 3;
            }
            else if(this.passYards > 7 && this.passYards <= 19)
            {
              playResult = 4;
            }
            else if(this.passYards > 19)
            {
              playResult = 5;
            }
          }
          else if(this.driveDowns == 3)
          {
            downDistance = "3DownAndMedium";
            if(this.passYards < 0 || this.passInterception || this.passFumble || this.passSack)
            {
              playResult = 0;
            }
            else if(this.passYards >= 0 && this.passYards <= 2)
            {
              playResult = 1;
            }
            else if(this.passYards > 2 && this.passYards <= 5)
            {
              playResult = 2;
            }
            else if(this.passYards > 5 && this.passYards <= 7)
            {
              playResult = 3;
            }
            else if(this.passYards > 7 && this.passYards <= 19)
            {
              playResult = 4;
            }
            else if(this.passYards > 19)
            {
              playResult = 5;
            }
          }
          else
          {
            downDistance = "4DownAndLong";
            if(this.passYards >= this.driveYardsLeft)
            {
              playResult = 4
            }
          }
        }
        if(this.driveYardsLeft > medium)
        {
          if(this.driveDowns == 1)
          {
            downDistance = "1Down";
            if(this.passYards < 0 || this.passInterception || this.passFumble || this.passSack)
            {
              playResult = 0;
            }
            else if(this.passYards == 0)
            {
              playResult = 1;
            }
            else if(this.passYards <=3 && this.passYards > 0)
            {
              playResult = 2;
            }
            else if(this.passYards > 3 && this.passYards <= 7)
            {
              playResult = 3;
            }
            else if(this.passYards > 7 && this.passYards <= 19)
            {
              playResult = 4;
            }
            else if(this.passYards > 19)
            {
              playResult = 5;
            }
          }
          else if(this.driveDowns == 2)
          {
            downDistance = "2DownAndLong";
            if(this.passYards < 0 || this.passInterception || this.passFumble || this.passSack)
            {
              playResult = 0;
            }
            else if(this.passYards == 0)
            {
              playResult = 1;
            }
            else if(this.passYards <=3 && this.passYards > 0)
            {
              playResult = 2;
            }
            else if(this.passYards > 3 && this.passYards <= 7)
            {
              playResult = 3;
            }
            else if(this.passYards > 7 && this.passYards <= 19)
            {
              playResult = 4;
            }
            else if(this.passYards > 19)
            {
              playResult = 5;
            }
          }
          else if(this.driveDowns == 3)
          {
            downDistance = "3DownAndLong";
            if(this.passYards < 0 || this.passInterception || this.passFumble || this.passSack)
            {
              playResult = 0;
            }
            else if(this.passYards > 0 && this.passYards <= 5)
            {
              playResult = 1;
            }
            else if(this.passYards <= 8 && this.passYards > 5)
            {
              playResult = 2;
            }
            else if(this.passYards > 8 && this.passYards <= 19)
            {
              playResult = 3;
            }
            else if(this.passYards >= this.driveYardsLeft)
            {
              playResult = 4;
            }
            else if(this.passYards > 19)
            {
              playResult = 5;
            }
          }
          else
          {
            downDistance = "4DownAndLong";
            if(this.passYards >= this.driveYardsLeft)
            {
              playResult = 4;
            }
          }
        }
      }
      var self = this;
      var askRef = firebase.database().ref("AskStatlete").child(self.selectedTeamId)
      askRef.child(downDistance).once("value", function(askValue){
        var askYds = askValue.val();
        var needVals = askYds[playSide]

        askRef.child(downDistance).update({
            [playSide]: parseInt(needVals) + parseInt(playResult)
          })
      })

      //Tracker      
      if(this.passYards != "")
      { 
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
        if(this.driveSpotBall > 50 || this.driveSpotBall < 0 || this.driveDowns > 4 || this.passYards == "")
        {
          jQuery("#tracker").hide();
        }
      }

      //database stuff
      var self = this
      var ref = firebase.database().ref("FootballGames").child(self.selectedTeamId).child(self.activeGameId).child("Totals").child("Offense")
      ref.child("PassAtt").once("value", function(snapshot){
        if(self.passPlayerNumber != "")
        {
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
        }
      }).then(()=>{
          ref.child("RushYds").once("value", function(qbsack){
            if(self.passSack && self.passPlayerNumber != "" && self.passYards != ""){
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
              if(self.passSack && self.passYards != "")
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
              var ref2 = firebase.database().ref("FootballGames").child(self.selectedTeamId).child(self.activeGameId).child("Totals").child("Special");
              ref2.child("TotalTDAllowed").once("value", function(rand2){
                if(self.passTurnover != "" && self.passTouchdown)
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
        ref.child("PassComp").once("value", function(snap){
          if(self.passCompletion && self.passPlayerNumber != "")
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
            if(self.passTouchdown && self.passCompletion && self.passPlayerNumber != "")
            {
              self.$emit("incMyScore", 6)
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
              if(self.passCompletion && self.passPlayerNumber != "" && self.passYards != ""){
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
                if(self.passCompletion && self.passYards != ""){
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
                  if(self.passCompletion && self.passCatchPlayerNum != "" && self.passYards != ""){
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
                  if(self.passCompletion && self.passTouchdown && self.passCatchPlayerNum != ""){
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
                    if(self.passCompletion && self.passCatchPlayerNum != "")
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
                      if(self.passTurnover == "fumble" && self.passTurnoverBy != "")
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
                      if(self.passTurnover == "interception" && self.passTurnoverBy != "")
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

    jQuery("#runLeftForm").hide();
    jQuery("#runMiddleForm").hide();
    jQuery("#runRightForm").hide();
    jQuery("#throwLeftForm").hide();
    jQuery("#throwMiddleForm").hide();
    jQuery("#throwRightForm").hide();

    jQuery("#statleteFormW").hide();
      jQuery("#runLeftFormW").hide();
      jQuery("#runMiddleFormW").hide();
      jQuery("#runRightFormW").hide();
      jQuery("#throwLeftFormW").hide();
      jQuery("#throwMiddleFormW").hide();
      jQuery("#throwRightFormW").hide();

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
img {
  margin: 3vw;
  zoom: 50%;
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


