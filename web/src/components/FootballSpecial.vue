<template>
    <div class="footballSpecial">
            <br>
			<div id="specialButtons">
                <div style="text-align: center"><h3>Special Teams Stats</h3></div>
				<table align="center" style="table-layout: fixed; width: 50%; height: 100%; align">                    
                    <tr><td class="button" @click="punt">Punt</td>
                    <td class="button" @click="puntReturn">Punt Return</td></tr>
                    <tr><td class="button" @click="fieldGoal">FG</td>
                    <td class="button" @click="fieldGoalDef">FG Def</td></tr>
                    <tr><td class="button" @click="kickoff">Kickoff</td> 
                    <td class="button" @click="kickoffReturn"> Kick Return</td></tr>
                </table>
		</div>

        <div id="puntForm">
            <table align="center">
                <tr>
                    <th>Punt</th>
                </tr>
                <tr>
                    <td>Kicker: </td>
                    <td><input align="right" type="text" size="3" maxlength="2" v-model="punterNum"></td>
                </tr>
                <tr>
                    <td>Kick Yards:</td>
                    <td><input align="right" type="text" size="3" maxlength="3" v-model="puntYards"></td>
                </tr>
                <!-- <tr>
                    <td>Turnover</td>
                    <td><input type="checkbox" v-if="activePuntTurnover === 'false'" @click="puntTurnover">
                        <input type="checkbox" v-else @click="puntTurnoverHide"></td>
                </tr> -->
            </table>
            <!-- <div id="turnoverPuntForm">
                <table>
                    <tr>
                        <td>Fumble</td><td><input type="radio" name="turnoverType" value="fumble" checked></td>
                    </tr>
                    <tr>
                        <td>Block</td><td><input type="radio" name="turnoverType" value="block"></td>
                    </tr>
                  </table>
            </div> -->

            <button class="button" @click="puntConfirm">Confirm</button> 
        </div>

        <div id="puntRetForm">
            <table align="center">
                <tr>
                    <th>Punt Return</th>
                </tr>
                <tr>
                    <td>Kick Returner: </td><td><input type="text" size="3" maxlength="3" v-model="puntRetNum"></td>
                </tr>
                <tr>
                    <td>Return Yards: </td><td><input type="text" size="3" maxlength="3" v-model="puntRetYards"></td>
                </tr>
                <!-- <tr>
                    <td>Turnover</td>
                    <td><input type="checkbox" v-if="activePuntRetTurnover === 'false'" @click="puntRetTurnover">
                        <input type="checkbox" v-else @click="puntRetTurnoverHide"></td>
                </tr> -->
            </table>
           <!-- <div id="turnoverRetPuntForm">
                <table>
                    <tr>
                        <td>Fumble</td><td><input type="radio" name="turnoverType" value="fumble" checked></td>
                    </tr>
                    <tr>
                        <td>Block</td><td><input type="radio" name="turnoverType" value="block"></td>
                    </tr>
                    <tr>
                      <td>Recovered By: </td><td><input type="text" name="recoverNumber" maxlength="2" size="2"></td>
                    </tr>
                    <tr>
                      <td>Spot of Ball: </td><td><input type="text" name="spotBall" maxlength="2" size="2"></td>
                    </tr>
                    <tr>
                      <td>My Ball </td><td><input type="checkbox" name="myBall"></td>
                    </tr>
                  </table> 
            </div> -->
            <button class="button" @click="puntRetConfirm">Confirm</button> 
        </div>

        <div id="fg">
            <table align="center">
                <tr>
                    <th>Field Goal</th>
                </tr>
                <tr>
                    <td>Extra Point</td>
                    <td><input type="checkbox" v-model="extraPoint" checked></td>
                </tr>
                <tr>
                    <td>Attempt Yards: </td><td><input type="text" v-model="fieldGoalYards" maxlength="2" size="3"></td>
                </tr>
                <tr>
                    <td>Attempt Made</td> <td><input type="checkbox" v-model="fieldGoalMake"></td>
                </tr>
                <tr>
                    <td>Block</td><td><input type="checkbox" v-model="fieldGoalBlock"></td>
                </tr>
                </table>
            <button class="button" @click="fgConfirm">Confirm</button> 
        </div>

        <div id="fgDef">
            <table align="center">
                <tr>
                    <th>Field Goal Defense</th>
                </tr>
                <tr>
                    <td>Extra Point</td>
                    <td><input type="checkbox" v-model="extraPointDef" checked></td>
                </tr>
                <tr>
                    <td>Attempt Made</td> <td><input type="checkbox" v-model="fieldGoalDefMade"></td>
                </tr>
                <!-- <tr>
                    <td>Turnover</td>
                    <td><input type="checkbox" v-if="activeFgDefTurnover === 'false'" @click="fgDefTurnover">
                        <input type="checkbox" v-else @click="fgDefTurnoverHide"></td>
                </tr> -->
            </table>
            <!-- <div id="turnoverFgDefForm">
                <table>
                    <tr>
                        <td>Fumble</td><td><input type="radio" name="turnoverType" value="fumble" checked></td>
                    </tr>
                    <tr>
                        <td>Block</td><td><input type="radio" name="turnoverType" value="block"></td>
                    </tr>
                  </table>
            </div> -->
            <button class="button" @click="fgDefConfirm">Confirm</button> 
        </div>

        <div id="kickOff">
            <table align="center">
                <tr>
                    <th>KickOff</th>
                </tr>
                <tr><td>Touchdown </td><td><input type="checkbox" v-model="kickoffTouchdown"></td></tr>
                <tr><td>Turnover</td><td><input type="checkbox" v-if="activeKickoffTurnover === 'false'" @click="kickoffTurnover">
                <input type="checkbox" v-else @click="kickoffTurnoverHide"></td></tr>
                </table>

            <div id="turnoverKickoffForm">
                <table align="center">
                    <tr><td>Fumble:</td><td><input type="checkbox" v-model="kickoffFumble"></td></tr>
                    <tr><td>Recovered By: </td><td><input type="text" v-model="kickoffRecoveredNum" maxlength="2" size="2"></td></tr>
                  </table>
            </div>
            <button class="button" @click="kickoffConfirm">Confirm</button>
        </div>

        <div id="kickOffRet">
            <table align="center">
                <tr>
                    <th>KickOff</th>
                </tr>
                <tr>
                    <td>Kick Returner: </td>
                    <td><input type="text" maxlength="2" size="3" v-model="kickoffRetNum"></td>
                </tr>
                <tr>
                    <td>Return Yards: </td>
                    <td><input alilgn="right" type="text" maxlength="3" size="3" v-model="kickoffRetYards"></td>
                </tr>
                <tr><td>Touchdown </td><td><input type="checkbox" v-model="kickoffRetTouchdown"></td></tr>
                <tr><td>Fumble:</td><td><input type="checkbox" v-model="kickoffRetFumble"></td></tr>
                </table>

            <button class="button" @click="kickoffReturnConfirm">Confirm</button>
        </div>
    </div>
</template>

<script>
export default {
  data() {
    return {
      activePuntTurnover: "false",
      activePuntRetTurnover: "false",
      activeFgTurnover: "false",
      activeFgDefTurnover: "false",
      activeKickoffTurnover: "false",
      activeKickoffRetTurnover: "false",

      //Punt
      punterNum: '',
      puntYards: '',

      // Punt Ret
      puntRetNum: '',
      puntRetYards: '',

      //FG
      extraPoint: '',
      fieldGoalYards: '',
      fieldGoalMake: '',
      fieldGoalBlock: '',

      // FG Def
      extraPointDef: '',
      fieldGoalDefMade: '',

      //Kickoff
      kickoffGainedYards: '',
      kickoffTouchdown: '',
      kickoffFumble: '',
      kickoffRecoveredNum: '',

      // Kickoff Ret
      kickoffRetNum: '',
      kickoffRetYards: '',
      kickoffRetTouchdown: '',
      kickoffRetFumble: '',

    };
  },

  methods: {
    punt: function() {
        jQuery("#specialButtons").hide();
        jQuery("#puntForm").show();
    },
    puntConfirm: function() {
        jQuery("#puntForm").hide();
        jQuery("#specialButtons").show();
         
        this.punterNum = '';
        this.puntYards = '';
    },
    puntReturn: function() {
        jQuery("#puntRetForm").show();
        jQuery("#specialButtons").hide();
    },
    puntRetConfirm: function() {
        jQuery("#puntRetForm").hide();
        jQuery("#specialButtons").show();

        this.puntRetNum = '';
        this.puntRetYards = '';
    },
    fieldGoal: function() {
        jQuery("#specialButtons").hide();
        jQuery("#fg").show();
    },
    fgConfirm: function() {
        jQuery("#specialButtons").show();
        jQuery("#fg").hide();

      this.extraPoint = '';
      this.fieldGoalYards = '';
      this.fieldGoalMake = '';
      this.fieldGoalBlock = '';
    },
     fieldGoalDef: function() {
        jQuery("#specialButtons").hide();
        jQuery("#fgDef").show();
    },
    fgDefConfirm: function() {
        jQuery("#fgDef").hide();
        jQuery("#specialButtons").show();   
      // FG Def
        this.extraPointDef = '';
        this.fieldGoalDefMade = '';

    },
    kickoff: function() {
        jQuery("#kickOff").show();
        jQuery("#specialButtons").hide();
    },
    kickoffConfirm: function() {
        jQuery("#specialButtons").show();
        jQuery("#kickOff").hide();
        //Kickoff
        this.kickoffGainedYards = '';
        this.kickoffTouchdown = '';
        this.kickoffFumble = '';
        this.kickoffRecoveredNum = '';
    },
    kickoffReturn: function() {
        jQuery("#kickOffRet").show();
        jQuery("#specialButtons").hide();
    },
    kickoffReturnConfirm: function() {
        jQuery("#kickOffRet").hide();
        jQuery("#specialButtons").show();

        this.kickoffRetNum = '';
        this.kickoffRetYards = '';
        this.kickoffRetTouchdown = '';
        this.kickoffRetFumble = '';
    },
    puntTurnover: function() {
      jQuery("#turnoverPuntForm").show();
      this.activePuntTurnover = "true";
    },
    puntTurnoverHide: function() {
      jQuery("#turnoverPuntForm").hide();
      this.activePuntTurnover = "false";
    },
    puntRetTurnover: function() {
      jQuery("#turnoverRetPuntForm").show();
      this.activePuntRetTurnover = "true";
    },
    puntRetTurnoverHide: function() {
      jQuery("#turnoverRetPuntForm").hide();
      this.activePuntRetTurnover = "false";
    },
    fgTurnover: function() {
        jQuery("#turnoverFgForm").show();
        this.activeFgTurnover = "true";
    },
    fgTurnoverHide: function() {
        jQuery("#turnoverFgForm").hide();
        this.activeFgTurnover = "false";
    },
    fgDefTurnover: function() {
        jQuery("#turnoverFgDefForm").show();
        this.activeFgDefTurnover = "true";
    },
    fgDefTurnoverHide: function() {
        jQuery("#turnoverFgDefForm").hide();
        this.activeFgDefTurnover = "false";
    },
    kickoffTurnover: function() {
        jQuery("#turnoverKickoffForm").show();
        this.activeKickoffTurnover = "true";
    },
    kickoffTurnoverHide: function() {
        jQuery("#turnoverKickoffForm").hide();
        this.activeKickoffTurnover = "false";
    },
    kickoffRetTurnover: function() {
        jQuery("#turnoverKickoffRetForm").show();
        this.activeKickoffRetTurnover = "true";
    },
    kickoffRetTurnoverHide: function() {
        jQuery("#turnoverKickoffRetForm").hide();
        this.activeKickoffRetTurnover = "false";
    }
  },
  // When page is refreshed this happens
  mounted() {
    jQuery("#puntForm").hide();
    jQuery("#puntRetForm").hide();
    jQuery("#turnoverPuntForm").hide();
    jQuery("#turnoverRetPuntForm").hide();
    jQuery("#fg").hide();
    jQuery("#turnoverFgForm").hide();
    jQuery("#fgDef").hide();
    jQuery("#turnoverFgDefForm").hide();
    jQuery("#kickOff").hide();
    jQuery("#turnoverKickoffForm").hide();
    jQuery("#kickOffRet").hide();
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
        