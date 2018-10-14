<template>
  <div id="GameView">
    <nav-component />
    <div id="EntryView">
      <div class="TopBanner">
          <h1 style="font-size: 400%; font-weight: bold;">{{selectedTeamName}}</h1>
      </div>
      <div class="leftDiv">
        <player-stat-selector style="float: left;"
                              :players="players"
                              :height="'height: 600px;'"
                              @playerSelected="playerWasSelected">
        </player-stat-selector>
        <sb-data-entry id="sbde1"
                      style="float: left;"
                      :height="'height: 600px;'"
                      @StatChange="updateDB"
                      :gameID="activeGameId">
        </sb-data-entry>
        <div class="possession">
          <p class="possButton" @click="possButtonClicked('myTeam')">My Team</p>
          <p class="possButton possButtonMid" @click="possButtonClicked('opponent')">Opponent</p>
          <p class="possButton" @click="possButtonClicked('none')">No Possession</p>
        </div>
      </div>
      <div id="fieldEntry">
        <div class="TimeClock" @click="clockClicked">
          <period-marker style="float: left; margin-left: 25%; margin-top: 25px;" :period="1" :filled="activePeriod >= 1"></period-marker>
          <h1 style="width: 100px; float: left; margin-top: 25px;">{{currTime}}</h1>
          <period-marker style="float: left; margin-top: 25px;" :period="2" :filled="activePeriod >= 2"></period-marker>
        </div>
        <sb-field :shots="shotsArr"
                  @ShotPlaced="shotPlaced">
        </sb-field>
        <sb-shot-type @ShotTypeChanged="shotTypeChanged"
                      @SBSTUndo="undoClicked">
        </sb-shot-type>
      </div>
      <div id="toggleViewDiv" style="margin-right: 50px;" @click="toggleViewClicked">
        <p style="line-height: 650px; font-weight: bold; font-size: 150%;">Stats</p>
      </div>
    </div>
    <div id="StatView">
      <team-stats style="float: left;" />
      <div id="toggleViewDiv" style="margin: 100px;" @click="toggleStatsClicked">
        <p style="line-height: 650px; font-weight: bold; font-size: 150%;">Entry</p>
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
        gameLive: false
      }
    },
    mounted() {
      jQuery("#StatView").hide()
      var ref = firebase.database().ref('/SoccerGames/').child(this.selectedTeamId).child(this.activeGameId);
      var self = this;
      ref.child('InProgress').on('value', function(snap){
        if(self.inProgress){
          clearInterval(self.activeInterval)

        }
        self.inProgress = snap.val()

      })
      ref.child('Live').on('value', function(snap){
        self.gameLive = snap.val()
      })
      ref.child('Period').on('value', function(snap){
        self.activePeriod = snap.val()
      })
      ref.once('value', function(snap) {
        var val = snap.val();

        self.GV_SET_PERIOD_LENGTH(val.HalfLength);
        self.GV_SET_PERIOD_START_TIME(val.PeriodStartTime);
      }).then(() => {
        if(self.inProgress){
          self.activeInterval = setInterval(self.updateTime, 1000);
        }
        
      });
    },
    computed: {
      ...mapGetters({
        activeGameId: 'mainStore/activeGameId',
        players: 'mainStore/players',
        selectedTeamId: 'mainStore/selectedTeamId',
        selectedPlayer: 'gameViewStore/selectedPlayer',
        selectedTeamName: 'mainStore/selectedTeamName',
        statString: 'gameViewStore/statString',
        shotType: 'gameViewStore/shotType',
        shotsArr: 'gameViewStore/shotsArr',
        shotsArrLength: 'gameViewStore/shotsArrLength',
        periodStartTime: 'gameViewStore/periodStartTime',
        currGameTime: 'gameViewStore/currGameTime',
        periodLength: 'gameViewStore/periodLength'
      })
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
      toggleViewClicked(event){
        jQuery('#EntryView').slideUp(500)
        jQuery('#StatView').slideDown(500)
      },
      toggleStatsClicked(event){
        jQuery('#StatView').slideUp(500)
        jQuery('#EntryView').slideDown(500)
      },
      clockClicked(event){
        if(this.activePeriod == -1){
          var message = "Start Game?";
          var options = {
            okText: 'YES',
            cancelText: 'NO',
            animation: 'bounce'
          }
          var self = this;
          self.$dialog.confirm(message, options).then(function() {
            //YES
            self.activePeriod = 1;
            var ref = firebase.database().ref('/SoccerGames').child(self.selectedTeamId).child(self.activeGameId);

            var result = {};
            var d = new Date();
            var elapsedSeconds = Math.round(d.getTime() / 1000);


            ref.update({
              Period: 1,
              InProgress: true,
              Live: true,
              PeriodStartTime: elapsedSeconds
            })

            self.GV_SET_PERIOD_START_TIME(elapsedSeconds);
            self.activeInterval = setInterval(self.updateTime, 1000);
          }).catch(function() {
            //NO
          })
        }
        else if(this.activePeriod == 1){
          if(this.inProgress){
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
            return;
          }

          var self = this;
          self.activePeriod = 2
          var ref = firebase.database().ref('/SoccerGames').child(self.selectedTeamId).child(self.activeGameId);
          var d = new Date();
          var elapsedSeconds = Math.round(d.getTime() / 1000);

          ref.update({
            Period: 2,
            InProgress: true,
            PeriodStartTime: elapsedSeconds
          })

          self.GV_SET_PERIOD_START_TIME(elapsedSeconds);
          self.activeInterval= setInterval(self.updateTime, 1000);

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
              var ref = firebase.database().ref('/SoccerGames').child(self.selectedTeamId).child(self.activeGameId);
              ref.update({
                InProgress: false,
                Live: false
              })
            })

            return;
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
      },
      playerWasSelected(event) {
        //console.log(event);
      },
      updateDB(event){
        var self = this;
        var input = event.split(":");
        if(input[0]==='minus'){
          
        }
        else{
          var dbRef = firebase.database().ref('SoccerGames/').child(self.selectedTeamId).child(self.activeGameId).child(self.activePeriod)
          dbRef = dbRef.child(input[1])
        }

      },
      updateTime(){
        var minutes = parseInt(this.currTime.split(':')[0]);
        if (this.inProgress && minutes < this.periodLength) {
          this.currTime = this.getTimeString(this.getTime());
        }
        else if (minutes == this.periodLength && this.shouldStartClock){
          this.currTime = this.getTimeString(this.getTime());
          this.shouldStartClock = false;
        }
        else {
          clearInterval(this.activeInterval);
          this.currTime = this.periodLength + ':00+';
          var ref = firebase.database().ref('SoccerGames/').child(this.selectedTeamId).child(this.activeGameId);
          ref.update({
            InProgress: false
          });

          if(this.activePeriod == 1) {
            this.shouldStartClock = true;
          }
          else{
            ref.update({
              Live: false
            })
          }
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
    min-height: 100vh;
    height: 100vh;
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
    /* float: left; */
    min-height: 100px;
    height: 100%;
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
  #fieldEntry {
    float: left;
  }
  .TimeClock{
    width: 600px;
    height: 120px;
    border: black 5px solid;
    border-radius: 25px;
    display: inline-block;
  }

  .leftDiv {
    margin-left: 12%;
    position: relative;
    height: 800px;
    width: 750px;
    float: left;
    margin-right: 100px;
  }

  .possession{
    display: flex;
    width: 670px;
    height: 120px;
    position: absolute;
    bottom: 0;
    border: 5px black solid;
    border-radius: 35px;
    box-shadow: 5px 5px 5px grey;
    margin-left: 50px;
  }
  .possButton{
    flex-grow: 3;
    font-size: 150%;
    height: 110px;
    text-align: center;
    line-height: 110px;
    font-weight: bold;
  }

  .possButtonMid {
    border-left: 5px black solid;
    border-right: 5px black solid;
  }

  #toggleViewDiv {
    height: 650px;
    width: 100px;
    border: 5px black solid;
    border-radius: 35px;
    float: right;
  }
</style>
