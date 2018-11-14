<template>
    <div class="footballDefense">
            <div id="defenseButtons">
                <div style="text-align: center"><h3>Defense Stats</h3></div>
                <div><p class="button" @click="defenseRun">Run</p></div>
                <div><p class="button" @click="defensePass">Pass</p></div>
                <div><p class="button" @click="defensePenalty">Penalty</p></div>
            </div>

            <div id="getDefPosition">
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


             <div id="runDefForm">
                <table align="center">
                    <tr><th>Run</th></tr>
                    <tr>
                    <td>Defend to the: </td>
                      <td>Left <input type="radio" value="left" v-model="pickedRunDefSide"></td>
                      <td>Middle <input type="radio" value="middle" v-model="pickedRunDefSide"></td>
                      <td>Right <input type="radio" value="right" v-model="pickedRunDefSide"></td>
                    </tr>
                    <tr>
                        <td> Tackle by Player: </td>
                        <td><input align="right" type="text" maxlength="2" size="3" v-model="runDefTackle">
                        </td>
                    </tr>
                        <tr>
                            <td>Offensive Yards: </td><td><input alilgn="right" type="text" maxlength="3" size="3" v-model="runDefYards"></td></tr>
                            <tr><td>Touchdown </td><td><input type="checkbox" v-model="runDefTouchdown">
                            </td></tr>
                            <tr><td>QB Sack</td><td><input align="right" type="checkbox" v-model="runDefSack"></td>
                            <tr><td>Turnover</td><td><input type="checkbox" v-if="activeRunTurnover === 'false'" @click="defenseRunTurnover">
                            <input type="checkbox" v-else @click="defenseRunTurnoverHide"></td></tr></table>

                            <div id="turnoverRunForm">
                <table align="center"><tr><td>Fumble:</td><td><input type="checkbox" v-model="runDefFumble" value="fumble" checked>
                </td></tr>
                  <tr><td>Recovered By: </td><td><input type="text" v-model="rundefRecoveredBy" maxlength="2" size="2"></td></tr>
                  </table>
            </div>

                        <button class="button" @click="runConfirm">Confirm</button>
                    </div>



            <div id="passDefForm">
                <table align="center">
                    <tr><th>Pass</th></tr>
                    <tr>
                    <td>Defend to the: </td>
                      <td>Left <input type="radio" value="left" v-model="pickedPassDefSide"></td>
                      <td>Middle <input type="radio" value="middle" v-model="pickedPassDefSide"></td>
                      <td>Right <input type="radio" value="right" v-model="pickedPassDefSide"></td>
                    </tr>
                    <tr><td>Completion: </td><td><input type="checkbox" v-model="passDefCompletion">
                    </td></tr>
                    <tr>
                        <td> Tackle by Player: </td>
                        <td><input align="right" type="text" maxlength="2" size="3" v-model="passDefTacklePlayerNum">
                        </td></tr>
                    <tr><td>Offensive Yards: </td><td><input type="text" maxlength="3" size="3" v-model="passDefYards">
                    </td></tr>
                    <tr><td>Touchdown </td><td><input type="checkbox" v-model="passDefTouchdown">
                    </td></tr>
                    <tr><td>QB Sack</td><td><input align="right" type="checkbox" v-model="passDefSack"></td>
                    <tr><td>Turnover</td><td><input type="checkbox" v-if="activeTurnover === 'false'" @click="defenseTurnover">
                    <input type="checkbox" v-else @click="defenseTurnoverHide"></td></tr></table>
                    <div id="turnoverForm">
                <table align="center"><tr><td>Fumble:</td><td><input type="radio" v-model="passTurnoverDefType" value="fumble" checked>
                </td></tr><tr><td>Interception:</td><td>
                  <input type="radio" v-model="passTurnoverDefType" value="interception"></td></tr>
                  <tr><td>Recovered By: </td><td><input type="text" v-model="passDefRecoveredBy" maxlength="2" size="2"></td></tr>
                  </table>
            </div>
                    <button class="button" @click="passConfirm">Confirm</button>
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
                        <input type="text" size="2" maxlength="2" v-model="penaltyDefYards"></td></tr>
                        <tr><td>Down: </td><td>
                        <input type="text" size="2" maxlength="1" v-model="penaltyDefDown"></td></tr>
                        </table>
                        <button class="button" @click="penaltyConfirm">Confirm</button>
            </div>

            

            

		</div>
</template>



<script>
export default {
  data() {
    return {
      activeTurnover: "false",
      activeRunTurnover: "false",

      //Spot Ball
      ballLocation: "",
      myHalf: "true",

      //Runs
      pickedRunDefSide: "middle",
      runDefTackle: "",
      runDefYards: "",
      runDefTouchdown: "",
      runDefSack: "",
      runDefFumble: "",
      rundefRecoveredBy: "",

      //Passes
      pickedPassDefSide: "middle",
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

  methods: {
    startDrive: function() {
      jQuery("#runDefForm").hide();
      jQuery("#passDefForm").hide();
      jQuery("#penaltyForm").hide();
      jQuery("#turnoverForm").hide();
      jQuery("#getDefPosition").hide();
      jQuery("#defenseButtons").show();
      this.activeButton = 'defense';
      // Reset data
      this.ballLocation = "";
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

      // Reset Data
      this.pickedRunDefSide = "middle";
      this.runDefTackle = "";
      this.runDefYards = "";
      this.runDefTouchdown = "";
      this.runDefSack = "";
      this.runDefFumble = "";
      this.rundefRecoveredBy = "";
    },
    passConfirm: function() {
      jQuery("#passDefForm").hide();

      jQuery("#turnoverForm").hide();
      jQuery("#defenseButtons").show();

      //Reset data
      this.pickedPassDefSide = "middle";
      this.passDefCompletion = '';
      this.passDefTacklePlayerNum = '';
      this.passDefYards = '';
      this.passDefTouchdown = '';
      this.passDefSack = '';
      this.passDefFumble = '';
      this.passDefInterception = '';
      this.passDefRecoveredBy = '';

    },
    penaltyConfirm: function() {
      jQuery("#penaltyDefForm").hide();
      jQuery("#turnoverForm").hide();
      jQuery("#defenseButtons").show();

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


