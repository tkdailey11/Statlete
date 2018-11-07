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
                    <td>Left <input type="radio" name="playSide" v-model="left"></td>
                    <td>Middle <input type="radio" name="playSide" v-model="middle" checked></td>
                    <td>Right <input type="radio" name="playSide" v-model="right"></td>
                  </tr>       
                    <tr>
                        <td> Run by Player: </td>
                        <td><input align="right" type="text" maxlength="2" size="3" name="playerNumber">
                        </td></tr>
                        <tr>
                            <td>Yards: </td><td><input align="right" type="text" maxlength="3" size="3" v-model="yards"></td></tr>
                            <tr><td>Touchdown </td><td><input type="checkbox" v-model="touchdown"></td></tr>
                            <tr><td>Fumble:</td><td><input type="checkbox" v-model="turnoverType" value="fumble"></td></tr>
                  </table>
                    <button class="button" @click="runConfirm">Confirm</button>
                </div>
            <div id="passForm">
                <table align="center">
                  <tr><th>Pass</th></tr>
                  <tr>
                    <td>Threw to the: </td>
                      <td>Left <input type="radio" name="playSide" v-model="left"></td>
                      <td>Middle <input type="radio" name="playSide" v-model="middle" checked></td>
                      <td>Right <input type="radio" name="playSide" v-model="right"></td>
                  </tr>
                    <tr><td>Pass by Player: </td>
                    <td><input type="text" maxlength="2" size="3" v-model="passPlayerNumber">
                    </td></tr>
                    <tr><td>Completion: </td><td><input type="checkbox" v-model="completePass">
                    </td></tr>
                    <tr><td>Catch by Player: </td><td><input type="text" maxlength="2" size="3" v-model="catchPlayerNumber">
                    </td></tr>
                    <tr><td>Yards: </td><td><input type="text" maxlength="3" size="3" v-model="yards">
                    </td></tr>
                    <tr><td>Touchdown </td><td><input type="checkbox" v-model="touchdown"></td></tr>
                    <tr><td>QB Sack</td><td><input align="right" type="checkbox" v-model="sack"></td>
                    <tr><td>Turnover</td><td><input type="checkbox" v-if="activeTurnover === 'false'" @click="offenseTurnover">
                    <input type="checkbox" v-else @click="offenseTurnoverHide"></td></tr></table>
                    <div id="turnoverForm">
                <table align="center"><tr><td>Fumble:</td><td><input type="radio" name="turnoverType" v-model="fumble" checked>
                </td></tr><tr><td>Interception:</td><td>
                  <input type="radio" name="turnoverType" v-model="interception"></td></tr>
                  <tr><td>Turnover By: </td><td><input type="text" v-model="turnoverNumber" maxlength="2" size="2"></td></tr>
                  </table>
            </div>
                    <button class="button" @click="passConfirm">Confirm</button>
            </div>

            <div id="penaltyForm">
                      <table align="center"><tr><td>Penalty: </td><td>
                        <select v-model="fouls" size="1">
                          <option value="falseStart">False Start</option>
                          <option value="defensiveInterference">Defensive Pass Interference</option>
                          <option value="offside">Offside</option>
                          <option value="defensiveHolding">Defensive Holding</option>
                          <option value="offensiveHolding">Offensive Holding</option>
                          <option value="delayGame">Delay of Game</option>
                          <option value="personalFoul">Personal Foul</option>
                        </select>
                      </td></tr><tr><td>Yards: </td><td>
                        <input type="text" size="2" maxlength="2" v-model="yards"></td></tr>
                        <tr><td>Down: </td><td>
                        <input type="text" size="2" maxlength="1" v-model="down"></td></tr>                        
                        <tr><td>Spot of Ball</td><td><input type="text" size="2" maxlength="2" v-model="spot">
                        </td></tr>
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
      passPlayerNumber: '',
    };
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
    },
    passConfirm: function() {
      jQuery("#passForm").hide();

      jQuery("#turnoverForm").hide();
      jQuery("#offenseButtons").show();
      this.passPlayerNumber = '';
    },
    penaltyConfirm: function() {
      jQuery("#penaltyForm").hide();
      jQuery("#turnoverForm").hide();
      jQuery("#offenseButtons").show();
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


