<template>
  <div class="FootballGame">
    <nav-component />
    <div id="fg_body">
      <div id="fg_banner">
        <h1 class="mainH1 fgTeamName">{{selectedTeamName}}</h1>
        <div id="fg_clock">
          <table style="margin-left: 5vw; min-width: 15vw;">
            <tr>
              <td class="item"> {{myScore}}</td>
              <td></td>
              <td></td>
              <td></td>
              <td></td>
              <td class="item">{{oppScore}}</td>
            </tr>
            <tr>
              <td>My Team</td>
              <td><input type="radio" value="first" v-model="period"></td>
              <td><input type="radio" value="second" v-model="period"></td>
              <td><input type="radio" value="third" v-model="period"></td>
              <td><input type="radio" value="fourth" v-model="period"></td>
              <td>Opponent</td>
            </tr>
            <tr>
              <td></td>
              <td>1</td>
              <td>2</td>
              <td>3</td>
              <td>4</td>
              <td></td>
            </tr>
          </table>
        </div>
                <div id="fg_btn">
          <div class="footballButton" id="startButton" @click="startButton">Start</div>
          <div class="footballButton" id="endButton" @click="endButton">End</div>
          <div class="footballButton" id="finalButton">Final</div>
        </div>
      </div>
      <div id="fg_main">
        <div class="footballPosDiv">
          <button v-if="activeButton === 'offense'" id="offenseButton" class="currPage" @click="offenseClicked">Offense</button>
          <button v-else id="offenseButton" class="footballNotCurr" @click="offenseClicked">Offense</button><br>
          <button v-if="activeButton === 'defense'" id="defenseButton" class="currPage" @click="defenseClicked">Defense</button>
          <button v-else id="defenseButton" class="footballNotCurr" @click="defenseClicked">Defense</button><br>

          <button v-if="activeButton === 'special'" id="specialButton" class="currPage" @click="specialClicked">Special Teams</button>
          <button v-else id="specialButton" class="footballNotCurr" @click="specialClicked">Special Teams</button><br>
        </div>

        <div class="footballStatDiv">
            <football-offense v-if="activeButton === 'offense'" @oppScore="incrementOpp" @incMyScore="incrementMyScore"/>
            <football-defense v-if="activeButton === 'defense'" @oppScore="incrementOpp" @incMyScore="incrementMyScore"/>
            <football-special v-if="activeButton === 'special'" @oppScore="incrementOpp" @incMyScore="incrementMyScore"/>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import {mapGetters} from 'vuex';
import firebase from 'firebase';
export default {
  computed: {
    ...mapGetters({
      selectedTeamName: 'mainStore/selectedTeamName',
      selectedTeamId: 'mainStore/selectedTeamId',
      activeGameId: 'mainStore/activeGameId'
    })
  },

  data() {
    return {
      activeButton: 'offense',
      period: 'first',
      myScore: 0,
      oppScore: 0
    }
    

  },
  mounted() {
    jQuery("#endButton").hide();
    jQuery("#finalButton").hide();
    var self = this
    var ref5 = firebase.database().ref("FootballGames").child(self.selectedTeamId).child(self.activeGameId).child("Score")
    ref5.once("value", function(scoreVals){
      var dbScores = scoreVals.val();
      var splitScore = dbScores.split("-")
      self.myScore = splitScore[0]
      self.oppScore = splitScore[1]
    })
    var ref6 = firebase.database().ref("FootballGames").child(self.selectedTeamId).child(self.activeGameId)
    ref6.once("value", function(hasStarted){
      var sVals = hasStarted.val();
      var isLive = sVals.Live
      var isOver = sVals.Result
      if(isLive)
      {
        jQuery("#startButton").hide();
        jQuery("#endButton").show();
      }
      if(isOver != null)
      {
        jQuery("#startButton").hide();
        jQuery("#endButton").hide();
        jQuery("#finalButton").show();
      }
      
    })
  },
  methods: {
    startButton: function(data) {
      jQuery("#startButton").hide();
      jQuery("#endButton").show();
      var newdate = new Date();
      var dString = newdate.toJSON().substring(0,10);
      var self = this
      var ref = firebase.database().ref("FootballGames").child(self.selectedTeamId).child(self.activeGameId)
      ref.update({
        "Date": dString,
        "Live": true,
        "Score": "0-0"
      })
    var ref5 = firebase.database().ref("FootballGames").child(self.selectedTeamId).child(self.activeGameId).child("Score")
    ref5.once("value", function(scoreVals){
      var dbScores = scoreVals.val();
      var splitScore = dbScores.split("-")
      self.myScore = parseInt(splitScore[0])
      self.oppScore = parseInt(splitScore[1])
    })
    },
    endButton: function(data) {
      // Set game to over
      var result = "L"
      if(this.myScore > this.oppScore)
      {
        result = "W"
      }
      else if(this.myScore == this.oppScore)
      {
        result = "T"
      }
      var self = this
      var ref = firebase.database().ref("FootballGames").child(self.selectedTeamId).child(self.activeGameId)
      ref.update({
        "Score": self.myScore + "-" + self.oppScore,
        "Live": false,
        "Result": result
      })
      jQuery("#endButton").hide();
      jQuery("#finalButton").show();
    },
    incrementOpp: function(data) {
      var self = this
      this.oppScore = parseInt(this.oppScore) + parseInt(data);
      var ref4 = firebase.database().ref("FootballGames").child(self.selectedTeamId).child(self.activeGameId)
      ref4.update({
        "Score": self.myScore + "-" + self.oppScore
      })
    },
    incrementMyScore: function(data) {
      var self = this
      this.myScore = parseInt(this.myScore) + parseInt(data);
      var ref4 = firebase.database().ref("FootballGames").child(self.selectedTeamId).child(self.activeGameId)
      ref4.update({
        "Score": self.myScore + "-" + self.oppScore
      })
    },
    offenseClicked: function() {
      jQuery("#getOffPosition").show();

      jQuery("#runForm").hide();
      jQuery("#passForm").hide();
      jQuery("#penaltyForm").hide();
      jQuery("#turnoverForm").hide();
      jQuery("#offenseButtons").hide();

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
      this.activeButton = 'offense';
    },
    defenseClicked: function() {
      jQuery("#getDefPosition").show();
      
      jQuery("#runDefForm").hide();
      jQuery("#passDefForm").hide();
      jQuery("#penaltyDefForm").hide();
      jQuery("#turnoverDefForm").hide();
      jQuery("#defenseButtons").hide();
      this.activeButton = 'defense';
      
    },
    specialClicked: function() {
      jQuery("#puntForm").hide();
      jQuery("#puntRetForm").hide();
      jQuery("#fg").hide();
      jQuery("#fgDef").hide();
      jQuery("#kickOff").hide();
      jQuery("#kickOffRet").hide();
      jQuery("#specialButtons").show();
      this.activeButton = 'special';
    },
    statsClicked: function() {
      
    },
    askClicked: function() {
      
    },
  },
  created() {
    jQuery("#runForm").hide();
    jQuery("#passForm").hide();
    jQuery("#endButton").hide();
  }
}
</script>

<style scoped>
.currPage, .footballNotCurr {
  padding: 10px 30px 10px 30px; 
  
  text-decoration: none;
  
  border-radius: 15px;
  margin: 5px;
  
  text-decoration: none;
  text-align: center;
}

.scores {
  font-size: 50px;
}
div button {
  box-sizing: border-box;
  min-width: 250px;
}
.footballButton {
  text-decoration: none;
  padding: 10px;
  margin-bottom: 10px;
  text-align: center;
  cursor: default;
  border-width: 2px;
  border-style: solid;
}

tr {
  color: rgb(240,240,240);

}

.item {
  font-size: 50px;
  flex-shrink: 3;
  align-content: flex-start;
  align-items: stretch;
  justify-content: space-between;
  flex-wrap: wrap;
  flex-direction: row;
  border-radius: 3px;
  background-color: rgb(224, 0, 16);
  color: rgb(240,240,240);
}
template { overflow-y: scroll; }

.period_item {
  /* flex-shrink: 4;
  flex-grow: 10; */
  align-content: flex-start;
  align-items: flex-end;
  justify-content: space-between;
  flex-wrap: wrap;
  flex-direction: row;
}

.toggleContainer {
  display: flex;
  flex-direction: column;
  flex-wrap: wrap;
}

  table {
    margin-left: 44vw;
  }

  #fg_body {
    height: 100%;
    min-height: 100vh;
    display: flex;
    flex-direction: column;
    overflow: scroll;
  }
  #fg_banner{
    margin-top: 5vh;
    flex-basis: 20%;
    display: flex;
  }
  #fg_main{
    margin-top: 10vh;
    flex-basis: 80%;
    display: flex;
    
  }
  .footballPosDiv {
    flex-basis: 50%;
    padding: 50px;
  }
  .footballStatDiv {
    flex-basis: 50%;
  }
  .fgTeamName {
    flex-basis: 25%;
    width: 100%;
  }
  #fg_clock {
    flex-basis: 32%;
    width: 100%;
    margin-left: 10vw;
  }
  #fg_btn {
    flex-basis: 15%;
    width: 100%;
    margin-left: 5vw;
  }
</style>


