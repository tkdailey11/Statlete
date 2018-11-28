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
                    <td><vue-numeric-input align="right" type="text" size="3" maxlength="2" v-model="punterNum" :min="0" :max="99" :controls="false"></vue-numeric-input></td>
                </tr>
                <tr>
                    <td>Kick Yards:</td>
                    <td><vue-numeric-input align="right" type="text" size="3" maxlength="3" v-model="puntYards" :min="-99" :max="99" :controls="false"></vue-numeric-input></td>
                </tr>
                <tr>
                    <td>Touchback:</td>
                    <td><input type="checkbox" v-model="puntTouchback"></td>
                </tr>
                <tr><td>Touchdown </td><td><input type="checkbox" v-model="puntTouchdown"></td></tr>
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
                    <td>Kick Returner: </td><td><vue-numeric-input type="text" size="3" maxlength="3" v-model="puntRetNum" :min="0" :max="99" :controls="false"></vue-numeric-input></td>
                </tr>
                <tr>
                    <td>Return Yards: </td><td><vue-numeric-input type="text" size="3" maxlength="3" v-model="puntRetYards" :min="-99" :max="100" :controls="false"></vue-numeric-input></td>
                </tr>
                <tr>
                    <td>Touchdown:</td>
                    <td><input type="checkbox" v-model="puntRetTD"></td>
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
                    <td>Kicker: </td><td><vue-numeric-input type="text" v-model="fieldGoalKicker" maxlength="2" size="3" :min="0" :max="99" :controls="false"></vue-numeric-input></td>
                </tr>
                <tr>
                    <td>Attempt Yards: </td><td><vue-numeric-input type="text" v-model="fieldGoalYards" maxlength="2" size="3" :min="0" :max="60" :controls="false"></vue-numeric-input></td>
                </tr>
                <tr>
                    <td>Attempt Made</td> <td><input type="checkbox" v-model="fieldGoalMake"></td>
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
                    <tr><td>Recovered By: </td><td><vue-numeric-input type="text" v-model="kickoffRecoveredNum" maxlength="2" size="2" :min="0" :max="99" :controls="false"></vue-numeric-input></td></tr>
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
                    <td><vue-numeric-input type="text" maxlength="2" size="3" v-model="kickoffRetNum" :min="0" :max="99" :controls="false"></vue-numeric-input></td>
                </tr>
                <tr>
                    <td>Return Yards: </td>
                    <td><vue-numeric-input alilgn="right" type="text" maxlength="3" size="3" v-model="kickoffRetYards" :min="-50" :max="100" :controls="false"></vue-numeric-input></td>
                </tr>
                <tr><td>Touchdown </td><td><input type="checkbox" v-model="kickoffRetTouchdown"></td></tr>
                </table>

            <button class="button" @click="kickoffReturnConfirm">Confirm</button>
        </div>
    </div>
</template>

<script>
import firebase from 'firebase'
import { mapGetters, mapMutations } from 'vuex'
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
      puntTouchback: '',
      puntTouchdown: '',

      // Punt Ret
      puntRetNum: '',
      puntRetYards: '',
      puntRetTD: '',

      //FG
      extraPoint: '',
      fieldGoalYards: '',
      fieldGoalMake: '',
      fieldGoalBlock: '',
      fieldGoalKicker: '',

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

  computed: {
    ...mapGetters({
      selectedTeamId: 'mainStore/selectedTeamId',
      activeGameId: 'mainStore/activeGameId'
    })
  },

  methods: {
    punt: function() {
        jQuery("#specialButtons").hide();
        jQuery("#puntForm").show();
    },
    puntConfirm: function() {
        jQuery("#puntForm").hide();
        jQuery("#specialButtons").show();

        //Database
        self = this
        var ref = firebase.database().ref("FootballGames").child(self.selectedTeamId).child(self.activeGameId).child("Totals").child("Period1").child("Special")
        ref.child("Punt").once("value", function(snapshot){
            var punts = snapshot.val()
            var playerNum = "p" + self.punterNum
            var total = punts.Total + 1
            var playerStat = punts[playerNum]
            var tb = self.puntTouchback
            var tbNum = 0
            var ptotal = 1
            if(playerStat == null)
            {
                if(tb){
                    tbNum = 1
                }
                ref.child("Punt").child(playerNum).update({
                    "Total": 1,
                    "TotalTB": parseInt(tbNum),
                    "TotalYds": parseInt(self.puntYards) + 0
                })
            }
            else{
                if(tb){
                    tbNum = 1
                }
                ptotal = parseInt(playerStat.Total) + parseInt(1)
                ref.child("Punt").child(playerNum).update({
                    "Total": (parseInt(playerStat.Total) + parseInt(1)),
                    "TotalTB": (parseInt(playerStat.TotalTB) + parseInt(tbNum)),
                    "TotalYds": (parseInt(playerStat.TotalYds) + parseInt(self.puntYards))
                })
            }
            ref.child("Punt").child(playerNum).child("Punt-"+ptotal).update({
                "Touchback": parseInt(tbNum),
                "Yds": self.puntYards
            })
            ref.child("Punt").update({
                "Total": total,
            })
        }).then(()=>{
            ref.child("TotalTDAllowed").once("value", function(shot){
                if(self.puntTouchdown)
                {
                    var numS = shot.val()
                    if(numS == null)
                    {
                        numS = 1
                    }
                    else
                    {
                        numS += 1
                    }
                    ref.update({
                        ["TotalTDAllowed"]: numS
                    })
                }
            }).then(()=>{
            this.punterNum = '',
            this.puntYards = ''
        })
        })
    },
    puntReturn: function() {
        jQuery("#puntRetForm").show();
        jQuery("#specialButtons").hide();
    },
    puntRetConfirm: function() {
        jQuery("#puntRetForm").hide();
        jQuery("#specialButtons").show();

        self = this
        var ref = firebase.database().ref("FootballGames").child(self.selectedTeamId).child(self.activeGameId).child("Totals").child("Period1").child("Special")
        ref.child("PuntRet").once("value", function(snap){
            var puntRet = snap.val()
            var playerNum = "p" + self.puntRetNum
            var totalPuntRet = parseInt(puntRet.TotalRets) + 1
            var totalPuntTD = puntRet.TotalTD
            var totalPuntYds = puntRet.TotalYds
            var playerStat = puntRet[playerNum]
            var puntRetTDCheck = self.puntRetTD
            var tdVar = "N"
            var ptotal = 1
            var puntTDNum = 0
            if(puntRetTDCheck)
            {
                puntTDNum = 1
                tdVar = "Y"
            }
            if(playerStat == null)
            {
                ref.child("PuntRet").child(playerNum).update({
                    "TotalTD": parseInt(puntTDNum),
                    "TotalYds" : parseInt(self.puntRetYards),
                    "TotalRets" : parseInt(1)
                })
            }
            else
            {
                ptotal = parseInt(playerStat.TotalRets) + parseInt(1)
                ref.child("PuntRet").child(playerNum).update({
                    "TotalTD": parseInt(playerStat.TotalTD) + parseInt(puntTDNum),
                    "TotalYds" : parseInt(playerStat.TotalYds) + parseInt(self.puntRetYards),
                    "TotalRets" : ptotal
                })
            }
            ref.child("PuntRet").child(playerNum).child("PuntRet-"+ptotal).update({
                "TD": tdVar,
                "Yds": parseInt(self.puntRetYards)
            })
            ref.child("PuntRet").update({
                "TotalRets": parseInt(totalPuntRet),
                "TotalTD": parseInt(totalPuntTD) + parseInt(puntTDNum),
                "TotalYds": parseInt(totalPuntYds) + parseInt(self.puntRetYards)
            })

        }).then(()=>{
            this.puntRetNum = '';
            this.puntRetYards = '';
        })

        
    },
    fieldGoal: function() {
        jQuery("#specialButtons").hide();
        jQuery("#fg").show();
    },
    fgConfirm: function() {
        jQuery("#specialButtons").show();
        jQuery("#fg").hide();

        self = this
        var ref = firebase.database().ref("FootballGames").child(self.selectedTeamId).child(self.activeGameId).child("Totals").child("Period1").child("Special")
        if(this.extraPoint)
        {
            ref.child("XP").once("value", function(shot){
                var xps = shot.val()
                var addPoints = 0
                if(self.fieldGoalMake)
                {
                    addPoints = 1
                }
                ref.child("XP").update({
                    "TotalAtt": parseInt(xps.TotalAtt) + parseInt(1),
                    "TotalMade": parseInt(xps.TotalMade) + parseInt(addPoints)
                })
            }).then(()=>{
                this.extraPoint = '';
                this.fieldGoalYards = '';
                this.fieldGoalMake = '';
                this.fieldGoalKicker = '';
            })
        }
        else
        {
            ref.child("FG").once("value", function(fg){
                var fgStats = fg.val()
                var playerNum = "p" + self.fieldGoalKicker
                var totalAtt = parseInt(fgStats.TotalAtt) + parseInt(1)
                var totalMade = parseInt(fgStats.TotalMade)
                var playerMade = 0
                var madeString = "N"
                if(self.fieldGoalMake)
                {
                    madeString = "Y"
                    totalMade++
                    playerMade = 1
                }
                var playerStat = fgStats[playerNum]
                var ptotal = 1
                if(playerStat == null)
                {
                    ref.child("FG").child(playerNum).update({
                        "TotalAtt": 1,
                        "TotalMade": playerMade
                    })
                }
                else
                {
                    ptotal = parseInt(playerStat.TotalAtt) + parseInt(1)
                    ref.child("FG").child(playerNum).update({
                        "TotalAtt": parseInt(playerStat.TotalAtt) + parseInt(1),
                        "TotalMade": parseInt(playerStat.TotalMade) + parseInt(playerMade)
                    })
                }
                ref.child("FG").child(playerNum).child("Kick-"+ptotal).update({
                    "Made": madeString,
                    "Yards": parseInt(self.fieldGoalYards)
                })
                ref.child("FG").update({
                    "TotalAtt": parseInt(totalAtt),
                    "TotalMade": parseInt(totalMade)
                })
            }).then(()=>{
                this.extraPoint = '';
                this.fieldGoalYards = '';
                this.fieldGoalMake = '';
                this.fieldGoalKicker = '';
            })
        }

      
    },
     fieldGoalDef: function() {
        jQuery("#specialButtons").hide();
        jQuery("#fgDef").show();
    },
    fgDefConfirm: function() {
        jQuery("#fgDef").hide();
        jQuery("#specialButtons").show();   
      // FG Def
        self = this
        var ref = firebase.database().ref("FootballGames").child(self.selectedTeamId).child(self.activeGameId).child("Totals").child("Period1").child("Special")
        ref.once("value", function(fgDef){
            var fgDefStat = fgDef.val()
            var xp = fgDefStat.TotalXPAllowed
            var fg = fgDefStat.TotalFGAllowed
            if(self.extraPointDef && self.fieldGoalDefMade)
            {
                if(xp == null)
                {
                    xp = 1
                }
                else
                {
                    xp += 1
                }
                ref.update({
                    ["TotalXPAllowed"]:  xp
                })
            }
            else if(!self.extraPointDef && self.fieldGoalDefMade)
            {
                if(fg == null)
                {
                    fg = 1
                }
                else
                {
                    fg += 1
                }
                ref.update({
                    "TotalFGAllowed": fg
                })
            }
        }).then(()=>{
            this.extraPointDef = '';
            this.fieldGoalDefMade = '';
        })
    },
    kickoff: function() {
        jQuery("#kickOff").show();
        jQuery("#specialButtons").hide();
    },
    kickoffConfirm: function() {
        jQuery("#specialButtons").show();
        jQuery("#kickOff").hide();
        //Kickoff
        self = this
        var ref = firebase.database().ref("FootballGames").child(self.selectedTeamId).child(self.activeGameId).child("Totals").child("Period1").child("Special")
        ref.child("TotalTDAllowed").once("value", function(shot){
                if(self.kickoffTouchdown)
                {
                    var numS = shot.val()
                    if(numS == null)
                    {
                        numS = 1
                    }
                    else
                    {
                        numS += 1
                    }
                    ref.update({
                        ["TotalTDAllowed"]: numS
                    })
                }
            }).then(()=>{
                var ref2 = firebase.database().ref("FootballGames").child(self.selectedTeamId).child(self.activeGameId).child("Totals").child("Period1").child("Defense")
                ref2.child("FumbleRec").once("value", function(fum){
                    if(self.kickoffFumble)
                    {
                        var fumVal = fum.val()
                        var playerNum = "p" + self.kickoffRecoveredNum
                        var playerStat = fumVal[playerNum]
                        if(playerStat == null)
                        {
                            playerStat = 1
                        }
                        else
                        {
                            playerStat += 1
                        }
                        ref2.child("FumbleRec").update({
                            [playerNum]: playerStat
                        })
                    }
                }).then(()=>{
            this.kickoffGainedYards = '';
            this.kickoffTouchdown = '';
            this.kickoffFumble = '';
            this.kickoffRecoveredNum = '';
        })
            })
        
    },
    kickoffReturn: function() {
        jQuery("#kickOffRet").show();
        jQuery("#specialButtons").hide();
    },
    kickoffReturnConfirm: function() {
        jQuery("#kickOffRet").hide();
        jQuery("#specialButtons").show();
        self = this
        var ref = firebase.database().ref("FootballGames").child(self.selectedTeamId).child(self.activeGameId).child("Totals").child("Period1").child("Special")
        ref.child("KickRet").once("value", function(kickRet){
            var kickRetStats = kickRet.val()
            var playerNum = "p" + self.kickoffRetNum
            var totalRets = parseInt(kickRetStats.TotalRets) + parseInt(1)
            var totalYds = parseInt(kickRetStats.TotalYds) + parseInt(self.kickoffRetYards)
            var tdString = "N"
            var ptotal = 1
            if(self.kickoffRetTouchdown)
            {
                tdString = "Y"                
            }
            var playerStat = kickRetStats[playerNum]
            if(playerStat == null)
            {
                ref.child("KickRet").child(playerNum).update({
                    "TotalRets": parseInt(ptotal),
                    "TotalYds": parseInt(self.kickoffRetYards)
                })
            }
            else
            {
                ptotal = parseInt(playerStat.TotalRets) + parseInt(1)
                ref.child("KickRet").child(playerNum).update({
                    "TotalRets": ptotal,
                    "TotalYds": parseInt(playerStat.TotalYds) + parseInt(self.kickoffRetYards)
                })
            }
            ref.child("KickRet").child(playerNum).child("Ret-" + ptotal).update({
                "TD": tdString,
                "Yards": self.kickoffRetYards
            })
            ref.child("KickRet").update({
                "TotalRets": totalRets,
                "TotalYds": totalYds
            })
        }).then(()=>{
            this.kickoffRetNum = '';
            this.kickoffRetYards = '';
            this.kickoffRetTouchdown = '';
            this.kickoffRetFumble = '';
        })
        
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
        