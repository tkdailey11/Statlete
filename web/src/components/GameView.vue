<template>
  <div id="GameView">
    <nav-component />
    <div class="TopBanner">
        <h1 style="font-size: 400%; font-weight: bold;">{{selectedTeamName}}</h1>
        <div class="TimeClock" @click="clockClicked">
          <period-marker style="float: left; margin-left: 25%; margin-top: 25px;" :period="1" :filled="activePeriod >= 1"></period-marker>
          <h1 style="width: 100px; float: left; margin-top: 25px;">{{currTime}}</h1>
          <period-marker style="float: left; margin-top: 25px;" :period="2" :filled="activePeriod >= 2"></period-marker>
        </div>
    </div>
    <div id="EntryView">
      <div id="entryDiv">
        <player-stat-selector style="float: left;"
                              :players="players"
                              :height="'height: 500px;'"
                              @playerSelected="playerWasSelected"></player-stat-selector>
        <sb-data-entry id="sbde1"
                      style="float: left;"
                      :height="'height: 500px;'"
                      @StatChange="updateDB"
                      :gameID="activeGameId"></sb-data-entry>
      </div>
      <div id="fieldDiv">
        <sb-field style="float: left;"
                  :shots="shotsArr"
                  @ShotPlaced="shotPlaced">
        </sb-field>
        <sb-shot-type style="float: left; margin-left: 50px;"
                      @ShotTypeChanged="shotTypeChanged"
                      @SBSTUndo="undoClicked">
        </sb-shot-type>
      </div>
      <div id="statDiv">
        <team-stats style="float: left; margin-left: 50px; margin-top: 65px;" />
      </div>
    </div>
    <div id="toggleViewDiv">
      <div id="entryMode" @click="toggleEntryClicked()" style="height: 150px; line-height: 150px;">
        Entry
      </div>
      <div id="chartMode" @click="toggleChartClicked()" style="height: 200px; line-height: 200px; border-bottom: 5px solid black; border-top: 5px solid black;">
        Shots
      </div>
      <div id="statMode" @click="toggleStatClicked()" style="height: 150px; line-height: 150px;">
        Stats
      </div>
    </div>
  </div>
</template>

<script>
  import firebase from 'firebase'
  import { mapGetters, mapMutations } from 'vuex';

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
        currentPlayer: ''
      }
    },
    mounted() {
      jQuery("#statDiv").hide()
      jQuery("#fieldDiv").hide()
      var ref = null;
      
      if(this.isSoccer){
        ref = firebase.database().ref('/SoccerGames/').child(this.selectedTeamId).child(this.activeGameId);
      }
      else{
        ref = firebase.database().ref('/BasketballGames/').child(this.selectedTeamId).child(this.activeGameId);
      }
      var self = this;
      ref.child('InProgress').on('value', function(snap){
        self.inProgress = snap.val()
      })
      ref.child('Live').on('value', function(snap){
        self.gameLive = snap.val()
      })
      ref.child('Period').on('value', function(snap){
        self.activePeriod = snap.val()
      })
      ref.child('HalfLength').once('value', function(snap){
        self.GV_SET_PERIOD_LENGTH(snap.val());
      })
      ref.child('PeriodStartTime').on('value', function(snap){
        self.GV_SET_PERIOD_START_TIME(snap.val());
        if(self.activeInterval){
          clearInterval(self.activeInterval)
        }
        if(self.inProgress){
          self.activeInterval = setInterval(self.updateTime, 1000);
        }
      })
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
        periodLength: 'gameViewStore/periodLength'
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
        GV_SET_PERIOD_LENGTH: 'gameViewStore/GV_SET_PERIOD_LENGTH'
      }),
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
        if(this.isSoccer){
          if(this.currTime.toLowerCase() === "final"){
            return;
          }
          else if(this.activePeriod == 1 && !this.inProgress){
            var message = "Start Game?";
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

              ref.update({
                InProgress: true,
                PeriodStartTime: elapsedSeconds
              })

              self.GV_SET_PERIOD_START_TIME(elapsedSeconds);
              self.activeInterval = setInterval(self.updateTime, 1000);
            }).catch(function() {
              //NO
            })
          }
          else if(this.activePeriod == 1 && this.inProgress){
              var message = "End 1st Half?";
              var options = {
                okText: 'YES',
                cancelText: 'NO',
                animation: 'bounce'
              }
              var self = this;
              self.$dialog.confirm(message, options).then(function() {
                clearInterval(self.activeInterval);
                self.currTime = '00:00';

                var ref = firebase.database().ref('/SoccerGames').child(self.selectedTeamId).child(self.activeGameId);
                ref.update({
                  Period: 2,
                  InProgress: false
                })

              }).catch(function() {

              })
          }
          else if(this.activePeriod == 2){
            if(this.inProgress){
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
                var ref = firebase.database().ref('/SoccerGames').child(self.selectedTeamId).child(self.activeGameId)

                ref.child('MyTotals').once('value', function(snapshot){
                  var val = snapshot.val();
                  var score = val.Period1.Goals.Total;
                  score += val.Period2.Goals.Total;

                  ref.child('OpponentsTotals').once('value', function(snapshot2){
                    var val2 = snapshot2.val();
                    var score2 = val2.Period1.Goals.Total;
                    score2 += val2.Period2.Goals.Total;

                    var result = '';
                    if(score == score2){
                      result = 'T'
                    }
                    else if(score > score2){
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
                })
              })
            }
            else{
              var message = "Start 2nd Half?";
              var options = {
                okText: 'YES',
                cancelText: 'NO',
                animation: 'bounce'
              }
              var self = this;
              self.$dialog.confirm(message, options).then(function() {
                var ref = firebase.database().ref('/SoccerGames').child(self.selectedTeamId).child(self.activeGameId);
                var d = new Date();
                var elapsedSeconds = Math.round(d.getTime() / 1000);
                ref.update({
                  InProgress: true,
                  PeriodStartTime: elapsedSeconds
                })
                self.GV_SET_PERIOD_START_TIME(elapsedSeconds);
                self.activeInterval= setInterval(self.updateTime, 1000);
              })
            }
          }
        }
        else{
          //handle clock clicks for basketball
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
          var dbRef = dbRefGame.child('MyTotals').child(period).child(input[1]);
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
          var dbRef = dbRefGame.child('MyTotals').child(period).child(input[1]);
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
          this.currTime = '0:00'
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
          var ref = firebase.database().ref('SoccerGames/').child(this.selectedTeamId).child(this.activeGameId);
          ref.update({
            InProgress: false
          });
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
      }
    }
  }
</script>

<style scoped>
  #GameView {
    width: 100vw;
    min-height: 103vh;
    height: 100%;
    background-color: white;
    margin-top: 0px;
  }
  #EntryView{
    
  }
  .TopBanner {
    width: 100vw;
    min-height: 100px;
    color: rgb(224, 0, 16);
    display: flex;
    margin-top: 25px;
    margin-bottom: -20px;
  }

  .TopBanner h1 {
    text-align: center;
    flex-grow: 2;
  }
  #sbde1{
    width: 310px;
    height: 500px;
    background: white;
    margin: 50px;
    margin-right: 0px;
    border-width: 5px;
    border-color: black;
    border-style: solid;
    border-radius: 35px;
    position: relative;

    box-shadow: 5px 5px 5px grey;
  }
  #fieldDiv {
    float: left;
    margin-top: 50px;
    margin-left: 50px;
  }
  .TimeClock{
    width: 600px;
    height: 120px;
    border: black 5px solid;
    border-radius: 25px;
    display: inline-block;
    margin-right: 100px;
  }

  #entryDiv {
    margin-left: 0px;
    float: left;
  }

  #statDiv {
    margin-left: 0px;
    float: left;
  }

  #toggleViewDiv {
    height: 500px;
    width: 100px;
    border: 5px black solid;
    border-radius: 35px;
    float: right;
    margin-right: 100px;
    margin-top: 65px;
  }
</style>
