<template>
  <div id="GameView">
    <nav-component />
    <div class="GV_Container">
      <div class="TopBanner">
          <h1 class="GV_NAME">{{selectedTeamName}}</h1>
          <time-clock class="GV_Clock"
                      @ClockClicked="clockClicked"
                      :time="currTime"
                      :activePeriod="activePeriod"
                      @PauseClicked="pauseClicked"
                      :pauseLabel="pauseBtnString"
                      :btnEnabled="pauseEnabled">
          </time-clock>
      </div>
      <div class="GV_Body">
        <esmodal
          v-show="isModalVisible"
          @close="closeESModal()"
        />
        <div id="EntryView">
          <div id="entryDiv">
            <!-- Add in selector for player/Opponent -->
            <!-- Do we want players to keep track of opponent's data? -->
            <sb-data-entry id="sbde1"
                          :height="'height: 500px;'"
                          :isActive="gameLive"
                          @StatChange="updateDB"
                          :gameID="activeGameId"></sb-data-entry>
          </div>
          <div id="fieldDiv">
            <sb-field class="GV_field"
                      :shots="shotsArr"
                      @ShotPlaced="shotPlaced">
            </sb-field>
            <sb-shot-type class="GV_shotType"
                          @ShotTypeChanged="shotTypeChanged"
                          @SBSTUndo="undoClicked">
            </sb-shot-type>
          </div>
          <div id="statDiv">
            <!-- This should probably be different -->
            <team-stats class="GV_statsTable"
                        @EditStats="showESModal" />
          </div>
        </div>
        <div class="toggleContainer">
          <div id="toggleViewDiv">
            <div id="entryMode" @click="toggleEntryClicked()">
              Entry
            </div>
            <div id="chartMode" @click="toggleChartClicked()">
              Shots
            </div>
            <div id="statMode" @click="toggleStatClicked()">
              Stats
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  import firebase from 'firebase'
  import { mapGetters, mapMutations } from 'vuex';

  import esmodal from '../EditStatsModal.vue';

  export default {
    name: 'GameView',
    data () {
      return {
        currTime: '00:00',
        activePeriod: 1,
        activeInterval: null,
        shouldStartClock: false,
        inProgress: false,
        gameLive: false,
        currentPlayer: '',
        myScore: 0,
        oppScore: 0,
        timeRemaining: 0,
        pauseBtnString: 'Start',
        pauseEnabled: true,
        isModalVisible: false
      }
    },
    mounted() {
      jQuery("#statDiv").hide()
      jQuery("#fieldDiv").hide()
      var ref = null;
      var self = this;

      if(this.isSoccer){
        ref = firebase.database().ref('/SoccerGames/').child(this.selectedTeamId).child(this.activeGameId);
        ref.child('HalfLength').once('value', function(snap){
          self.GV_SET_PERIOD_LENGTH(snap.val());
        })
      }
      else{
        ref = firebase.database().ref('/BasketballGames/').child(this.selectedTeamId).child(this.activeGameId);
        ref.child('NumberOfPeriods').once('value', function(snap){
          if(snap.val()){
            self.GV_SET_NUM_PERIODS(snap.val());
          }
        })
        ref.child('PeriodLength').once('value', function(snap){
          self.GV_SET_PERIOD_LENGTH(snap.val());
          self.currTime = snap.val() + ':00';
        })
        ref.child('TimeRemainingInPeriod').once('value', function(snap){
          self.GV_SET_TIME_REMAINING(snap.val());
          self.timeRemaining = snap.val()
          self.currTime = self.secondsToMinutesString(snap.val())
        })
      }
      
      ref.child('Live').on('value', function(snap){
        self.gameLive = snap.val()
        if(!self.gameLive){
          self.currTime = 'FINAL'
        }
      })
      ref.child('Period').on('value', function(snap){
        self.activePeriod = snap.val()
      })
      
      ref.child('PeriodStartTime').on('value', function(snap){
        self.GV_SET_PERIOD_START_TIME(snap.val());
        ref.child('InProgress').on('value', function(snap){
          self.inProgress = snap.val()
        })
      })

      ref.child('MyTotals').on('value', function(snapshot){
        var val = snapshot.val();
        self.myScore = self.computeScore(val);
      })
      ref.child('OpponentsTotals').on('value', function(snapshot2){
        var val2 = snapshot2.val();
        self.oppScore = self.computeScore(val2);
      })
    },
    components: {
      esmodal
    },
    computed: {
      ...mapGetters({
        activeGameId: 'mainStore/activeGameId',
        players: 'mainStore/players',
        selectedTeamId: 'mainStore/selectedTeamId',
        selectedPlayer: 'gameViewStore/selectedPlayer',
        selectedTeamName: 'mainStore/selectedTeamName',
        selectedTeamSport: 'mainStore/selectedTeamSport',
        statString: 'gameViewStore/statString',
        shotType: 'gameViewStore/shotType',
        shotsArr: 'gameViewStore/shotsArr',
        shotsArrLength: 'gameViewStore/shotsArrLength',
        periodStartTime: 'gameViewStore/periodStartTime',
        currGameTime: 'gameViewStore/currGameTime',
        periodLength: 'gameViewStore/periodLength',
        numberOfPeriods: 'gameViewStore/numberOfPeriods',
        timeRemainingInPeriod: 'gameViewStore/timeRemainingInPeriod'
      }),
      isSoccer: function() {
        return this.selectedTeamSport == 1;
      }
    },
    methods: {
      ...mapMutations({
        GV_SET_PLAYER: 'gameViewStore/GV_SET_PLAYER',
        GV_SET_STAT_STRING: 'gameViewStore/GV_SET_STAT_STRING',
        GV_SET_SHOT_TYPE: 'gameViewStore/GV_SET_SHOT_TYPE',
        GV_SET_SHOTS_ARR: 'gameViewStore/GV_SET_SHOTS_ARR',
        GV_APPEND_SHOT: 'gameViewStore/GV_APPEND_SHOT',
        GV_REMOVE_SHOT: 'gameViewStore/GV_REMOVE_SHOT',
        GV_SET_PERIOD_START_TIME: 'gameViewStore/GV_SET_PERIOD_START_TIME',
        GV_SET_CURR_GAME_TIME: 'gameViewStore/GV_SET_CURR_GAME_TIME',
        GV_SET_PERIOD_LENGTH: 'gameViewStore/GV_SET_PERIOD_LENGTH',
        GV_SET_NUM_PERIODS: 'gameViewStore/GV_SET_NUM_PERIODS',
        GV_SET_TIME_REMAINING: 'gameViewStore/GV_SET_TIME_REMAINING'
      }),
      showESModal() {
        this.isModalVisible = true;
      },
      closeESModal() {
        this.isModalVisible = false;
      },
      pauseClicked(){
        var self = this;
        if(this.currTime.toLowerCase() === "final"){
          return;
        }
        var gameData = {
          'InProgress': !this.inProgress
        }
        var ref = firebase.database().ref('/BasketballGames').child(self.selectedTeamId).child(self.activeGameId);
        //Start
        if(!this.inProgress){
          var d = new Date();
          var elapsedSeconds = Math.round(d.getTime() / 1000);
          gameData['TimeClockStarted'] = elapsedSeconds
          ref.update(gameData)
          self.GV_SET_PERIOD_START_TIME(elapsedSeconds);
          this.activeInterval = setInterval(self.updateTime, 1000);
        }
        //Pause
        else {
          clearInterval(this.activeInterval)
          this.inProgress = false
          ref.update({
            InProgress: false,
            TimeRemainingInPeriod: self.timeRemaining
          })
        }
      },
      computeScore(val){
        var score = 0;
        // if(this.isSoccer){
        //   score += val.Period1.Goals.Total;
        //   score += val.Period2.Goals.Total;
        // }
        // else {
        //   score += val.Period1.FTM.Total;
        //   score += (2 * val.Period1.FG2M.Total);
        //   score += (3 * val.Period1.FG3M.Total);

        //   score += val.Period2.FTM.Total;
        //   score += (2 * val.Period2.FG2M.Total);
        //   score += (3 * val.Period2.FG3M.Total);

        //   if(this.numberOfPeriods == 4){
        //     score += val.Period3.FTM.Total;
        //     score += (2 * val.Period3.FG2M.Total);
        //     score += (3 * val.Period3.FG3M.Total);

        //     score += val.Period4.FTM.Total;
        //     score += (2 * val.Period4.FG2M.Total);
        //     score += (3 * val.Period4.FG3M.Total);
        //   }
        // }
        return score;
      },
      toggleEntryClicked(){
        var entryDisplayed = jQuery('#entryDiv').css('display') != 'none';
        var fieldDisplayed = jQuery('#fieldDiv').css('display') != 'none';
        var statDisplayed = jQuery('#statDiv').css('display') != 'none';
        if(entryDisplayed){
        }
        else if(fieldDisplayed){
          jQuery('#fieldDiv').slideUp(350)
          jQuery('#entryDiv').slideDown(350)
        }
        else {
          jQuery('#statDiv').slideUp(350)
          jQuery('#entryDiv').slideDown(350)
        }
      },
      toggleChartClicked(){
        var entryDisplayed = jQuery('#entryDiv').css('display') != 'none';
        var fieldDisplayed = jQuery('#fieldDiv').css('display') != 'none';
        var statDisplayed = jQuery('#statDiv').css('display') != 'none';
        var width = jQuery(window).width()
        if(fieldDisplayed){
        }
        else if(entryDisplayed){
          jQuery('#entryDiv').slideUp(350)
          jQuery('#fieldDiv').slideDown(350)
        }
        else {
          jQuery('#statDiv').slideUp(350)
          jQuery('#fieldDiv').slideDown(350)
        }
      },
      toggleStatClicked(){
        var entryDisplayed = jQuery('#entryDiv').css('display') != 'none';
        var fieldDisplayed = jQuery('#fieldDiv').css('display') != 'none';
        var statDisplayed = jQuery('#statDiv').css('display') != 'none';
        if(statDisplayed){
        }
        else if(entryDisplayed){
          jQuery('#entryDiv').slideUp(350)
          jQuery('#statDiv').slideDown(350)
        }
        else {
          jQuery('#fieldDiv').slideUp(350)
          jQuery('#statDiv').slideDown(350)
        }
      },
      clockClicked(event){
        alert('Clock Clicked')
        if(this.currTime.toLowerCase() === "final" || !this.isSoccer){
          return;
        }
        //Start a Period
        else if(!this.inProgress){
          var d = new Date();
          var elapsedSeconds = Math.round(d.getTime() / 1000);
          var message = "Start Game?";
          var gameData = {
            InProgress: true,
            PeriodStartTime: elapsedSeconds
          }
          if(this.activePeriod == 2){
            message = "Start 2nd Half?";
          }

          var options = {
            okText: 'YES',
            cancelText: 'NO',
            animation: 'bounce'
          }
          var self = this;
          self.$dialog.confirm(message, options).then(function() {
            //YES
            var ref = firebase.database().ref('/SoccerGames').child(self.selectedTeamId).child(self.activeGameId);

            var result = {};
            var d = new Date();
            var elapsedSeconds = Math.round(d.getTime() / 1000);

            ref.update(gameData)

            self.GV_SET_PERIOD_START_TIME(elapsedSeconds);
            self.activeInterval = setInterval(self.updateTime, 1000);
          }).catch(function() {
            //NO
          })
        }
        //End Game
        else if(this.activePeriod == this.numberOfPeriods){
          //end the game
          var message = "End Game?";
          var options = {
            okText: 'YES',
            cancelText: 'NO',
            animation: 'bounce'
          }
          var self = this;
          self.$dialog.confirm(message, options).then(function() {
            clearInterval(self.activeInterval);
            self.currTime = 'FINAL'
            var ref = firebase.database().ref('/SoccerGames').child(self.selectedTeamId).child(self.activeGameId);
            var result = '';
            if(self.myScore == self.oppScore){
              result = 'T'
            }
            else if(self.myScore > self.oppScore){
              result = 'W'
            }
            else{
              result = 'L'
            }

            ref.update({
              InProgress: false,
              Live: false,
              Period: -1,
              Result: result
            })
          })
        }
        //End a Period
        else {
          var message = "End 1st Half?";
          if(this.numberOfPeriods == 4){
            if(this.activePeriod == 1){
              message = "End 1st Quarter?";
            }
            else if(this.activePeriod == 3){
              message = "End 3rd Quarter?";
            }
          }
          var options = {
            okText: 'YES',
            cancelText: 'NO',
            animation: 'bounce'
          }
          var self = this;
          self.$dialog.confirm(message, options).then(function() {
            clearInterval(self.activeInterval);
            self.currTime = '00:00';
            var dbRoot = '/BasketballGames';
            if(self.isSoccer){
              dbRoot = '/SoccerGames';
            }
            var prd = self.activePeriod + 1;
            var ref = firebase.database().ref(dbRoot).child(self.selectedTeamId).child(self.activeGameId);
            ref.update({
              Period: prd,
              InProgress: false
            })

          }).catch(function() {

          })
        }
      },
      playerWasSelected(event) {
        this.currentPlayer = event
      },
      updateDB(event){
        var self = this;
        var input = event.split(":");
        var statPeriod = this.activePeriod;
        if(!(statPeriod && statPeriod >= 1)){
          statPeriod = 1
        }
        var period = 'Period' + statPeriod
       
        if(this.isSoccer){
          var dbRefGame = firebase.database().ref('SoccerGames/').child(self.selectedTeamId).child(self.activeGameId)
          
          var player = self.currentPlayer;
          if(player.startsWith('p')){
            var refPlayer = dbRefGame.child('Players').child(player);
            refPlayer.child(input[1]).once('value', function(snapshot){
              var tot = snapshot.val() + 1;
              var key = input[1];
              refPlayer.update({
                [key]: tot
              })
            })
          }
          var dbRef = null;
          if(player === 'otherTeam'){
            dbRef = dbRefGame.child('OpponentsTotals').child(period).child(input[1]);
            player = ' ';
          }
          else{
            dbRef = dbRefGame.child('MyTotals').child(period).child(input[1]);
          }
          
          dbRef.child('Total').once('value', function(snapshot){
            var tot = snapshot.val() + 1;
            var time = self.currTime;
            var minutes = parseInt(time.split(':')[0]) + ((statPeriod - 1) * self.periodLength);
            if(minutes > 10) {
              time = minutes+':'+time.split(':')[1]
            }
            else {
              time = '0'+minutes+':'+time.split(':')[1]
            }
            if(player.length == 0){
              player = ' ';
            }
            dbRef.update({
              Total : tot,
              [time] : player
            })
          })
        }
        else{
          var dbRefGame = firebase.database().ref('BasketballGames/').child(self.selectedTeamId).child(self.activeGameId)
          
          var player = self.currentPlayer;
          if(player.startsWith('p')){
            var refPlayer = dbRefGame.child('Players').child(player);
            refPlayer.child(input[1]).once('value', function(snapshot){
              var tot = snapshot.val() + 1;
              var key = input[1];
              refPlayer.update({
                [key]: tot
              })
            })
          }
          var dbRef = null;
          if(player === 'otherTeam'){
            dbRef = dbRefGame.child('OpponentsTotals').child(period).child(input[1]);
            player = ' ';
          }
          else{
            dbRef = dbRefGame.child('MyTotals').child(period).child(input[1]);
          }
          dbRef.child('Total').once('value', function(snapshot){
            var tot = snapshot.val() + 1;
            var time = self.currTime;
            var minutes = parseInt(time.split(':')[0]) + ((statPeriod - 1) * self.periodLength);
            if(minutes > 10) {
              time = minutes+':'+time.split(':')[1]
            }
            else {
              time = '0'+minutes+':'+time.split(':')[1]
            }
            if(player.length == 0){
              player = ' ';
            }
            dbRef.update({
              Total : tot,
              [time] : player
            })
          })
        }
      },
      updateTime(){
        if(this.isSoccer){
          alert('SOCCER')
          if(!this.currTime){
            return;
          }
          if(!this.gameLive){
            clearInterval(this.activeInterval);
            this.currTime = 'FINAL';
            return;
          }
          if(!this.inProgress){
            clearInterval(this.activeInterval);
            this.currTime = '00:00'
            return;
          }
          var minutes = parseInt(this.currTime.split(':')[0]);
          if(isNaN(minutes)){
            return;
          }
          if (minutes < this.periodLength) {
            this.currTime = this.getTimeString(this.getTime());
          }
          else {
            clearInterval(this.activeInterval);
            this.currTime = this.periodLength + ':00+';
          }
        }
        else{
          var self = this;
          if(!this.gameLive){
            this.pauseEnabled = false;
            this.timeRemaining = 0;
            this.currTime = 'FINAL';
            return;
          }
          if(this.timeRemaining <= 0){
            clearInterval(this.activeInterval)
            var ref = firebase.database().ref('/BasketballGames').child(self.selectedTeamId).child(self.activeGameId);
            //End game
            if(this.activePeriod == this.numberOfPeriods){
              this.timeRemaining = 0
              this.currTime = 'FINAL';
              ref.update({
                Live: false,
                InProgress: false
              })
            }
            //End Period
            else{
              var prd = self.activePeriod + 1;
              ref.update({
                Period: prd,
                InProgress: false
              })
              this.pauseBtnString = 'Start'
              this.timeRemaining = this.periodLength * 60
              self.GV_SET_TIME_REMAINING(this.timeRemaining)
              this.currTime = this.secondsToMinutesString(this.timeRemaining)
            }
            return;
          }
          this.timeRemaining -= 1;
          self.GV_SET_TIME_REMAINING(this.timeRemaining)
          this.currTime = this.secondsToMinutesString(this.timeRemaining)
        }
      },
      shotPlaced(event){
        var shotData = {
          style: event.style,
          shotType: this.shotType
        };
        this.GV_APPEND_SHOT(shotData);
      },
      shotTypeChanged(event){
        this.GV_SET_SHOT_TYPE(event);
      },
      undoClicked(){
        if (this.shotsArrLength > 0) {
          this.GV_REMOVE_SHOT();
        }
      },
      getTimeString(time) {
        var minutesString = time.minutes.toString();
        if(time.minutes < 10){
          minutesString = '0' + minutesString;
        }

        var secondsString = time.seconds.toString();
        if(time.seconds < 10){
          secondsString = '0' + secondsString;
        }

        return minutesString + ':' + secondsString;
      },
      getTime() {
        var result = {
          minutes: 0,
          seconds: 0
        }

        if(this.periodStartTime > 0){
          var d = new Date();
          var elapsedSeconds = Math.round(d.getTime() / 1000);
          elapsedSeconds = elapsedSeconds - this.periodStartTime;
          result.minutes = Math.floor(elapsedSeconds / 60);
          result.seconds = elapsedSeconds % 60;
        }
        
        return result;
      },
      possButtonClicked(buttonName){
        switch(buttonName) {
          case 'myTeam':
            alert('1');
            break;
          case 'opponent':
            alert('2');
            break;
          default:
            alert('3');
        }
      },
      secondsToMinutesString(seconds){
        if(seconds <= 0){
          return '00:00';
        }
        var min = Math.floor(seconds/60);
        min = min.toString();
        min = min.padStart(2, '0');
        var sec = seconds%60;
        sec = sec.toString();
        sec = sec.padStart(2, '0');

        return min + ':' + sec;
      }
    }
  }
</script>

<style scoped>
  #GameView {
    width: 100vw;
    min-height: 103vh;
    height: 100%;
    margin-top: 0px;
  }
  .GV_Container {
    display: flex;
    flex-direction: column;
  }
  .TopBanner {
    flex-basis: 20%;
    width: 100vw;
    display: flex;
  }
  .GV_NAME {
    flex-basis: 50%;
    font-size: 400%; 
    font-weight: bold;
  }
  .GV_Clock {
    flex-basis: 50%;
  }
  .GV_Body {
    flex-basis: 80%;
    display: flex;
  }
  #EntryView {
    flex-basis: 85%;
    overflow-x: scroll;
  }
  #fieldDiv {
  }

  #entryDiv {
  }

  #statDiv {
  }

  .GV_field {
    float: left;
    margin-top: 5%;
    margin-left: 15%;
    margin-right: 15px;
  }
  .GV_shotType {
    float: left;
    margin-top: 5%;
    margin-left: 15px;
    margin-right: 15%;
  }

  .GV_statsTable {
    float: left;
    margin-top: 7%;
    margin-left: 15%;
    margin-right: 15%;
  }

  .TopBanner h1 {
    text-align: center;
    flex-grow: 2;
  }
  #sbde1{
    float: left;
    width: 500px;
    height: 500px;
    border-width: 5px;
    border-style: solid;
    border-radius: 35px;
    position: relative;
    margin-top: 5%;
    margin-left: 15px;
    margin-right: 15%;
  }
  #GV_pss {
    float: left;
    margin-top: 5%;
    margin-left: 15%;
    margin-right: 15px;
  }

  .toggleContainer {
    flex-basis: 15%;
    padding-left: 5%;
    padding-right: 5%;
    padding-top: 3%;
  }
  #toggleViewDiv {
    border-width: 3px;
    border-style: solid;
    border-radius: 20px;
  }

  #entryMode {
    height: 147px; 
    line-height: 147px;
    border-top-left-radius: 15px;
    border-top-right-radius: 15px;
  }

  #chartMode {
    height: 200px; 
    line-height: 200px;
    border-top-style: solid;
    border-top-width: 3px;
    border-bottom-style: solid;
    border-bottom-width: 3px;
  }

  #statMode {
    height: 147px; 
    line-height: 147px;
    border-bottom-left-radius: 15px;
    border-bottom-right-radius: 15px;
  }
</style>
