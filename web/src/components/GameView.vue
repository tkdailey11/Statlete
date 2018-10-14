<template>
  <div id="GameView">
    <nav-component />
    <div class="TopBanner">
        <h1>{{activeGameId}}</h1>
        <div class="TimeClock" @click="clockClicked">
          <period-marker class="pm" :period="1" :filled="activePeriod >= 1" style="margin-left: 10px;"></period-marker>
          <h1>{{currTime}}</h1>
          <period-marker class="pm" :period="2" :filled="activePeriod >= 2"></period-marker>
        </div>
    </div>
    <player-stat-selector style="float: left;"
                          :players="players"
                          @playerSelected="playerWasSelected">
    </player-stat-selector>
    <sb-data-entry id="sbde1"
                   style="float: left; margin-right: 150px;"
                   @StatChange="updateDB"
                   :gameID="activeGameId">
    </sb-data-entry>
    <div id="fieldEntry">
      <sb-field :shots="shotsArr"
                @ShotPlaced="shotPlaced"></sb-field>
      <sb-shot-type @ShotTypeChanged="shotTypeChanged"
                    @SBSTUndo="undoClicked"></sb-shot-type>
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
        shouldStartClock: false
      }
    },
    mounted() {
      var ref = firebase.database().ref('/SoccerGames/').child(this.selectedTeamId).child(this.activeGameId);
      var self = this;
      ref.once('value', function(snap) {
        var val = snap.val();

        self.GV_SET_PERIOD(val.Period);
        self.GV_SET_IN_PROGRESS(val.InProgress);
        self.GV_SET_PERIOD_LENGTH(val.HalfLength);
        self.GV_SET_GAME_LIVE(val.Live);
        self.GV_SET_PERIOD_START_TIME(val.PeriodStartTime);
        self.activePeriod = val.Period;
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
        statString: 'gameViewStore/statString',
        currentPeriod: 'gameViewStore/currentPeriod',
        shotType: 'gameViewStore/shotType',
        shotsArr: 'gameViewStore/shotsArr',
        shotsArrLength: 'gameViewStore/shotsArrLength',
        periodStartTime: 'gameViewStore/periodStartTime',
        currGameTime: 'gameViewStore/currGameTime',
        inProgress: 'gameViewStore/inProgress',
        gameLive: 'gameViewStore/gameLive',
        periodLength: 'gameViewStore/periodLength'
      })
    },
    methods: {
      ...mapMutations({
        GV_SET_PLAYER: 'gameViewStore/GV_SET_PLAYER',
        GV_SET_STAT_STRING: 'gameViewStore/GV_SET_STAT_STRING',
        GV_SET_PERIOD: 'gameViewStore/GV_SET_PERIOD',
        GV_SET_SHOT_TYPE: 'gameViewStore/GV_SET_SHOT_TYPE',
        GV_SET_SHOTS_ARR: 'gameViewStore/GV_SET_SHOTS_ARR',
        GV_APPEND_SHOT: 'gameViewStore/GV_APPEND_SHOT',
        GV_REMOVE_SHOT: 'gameViewStore/GV_REMOVE_SHOT',
        GV_SET_PERIOD_START_TIME: 'gameViewStore/GV_SET_PERIOD_START_TIME',
        GV_SET_CURR_GAME_TIME: 'gameViewStore/GV_SET_CURR_GAME_TIME',
        GV_SET_IN_PROGRESS: 'gameViewStore/GV_SET_IN_PROGRESS',
        GV_SET_GAME_LIVE: 'gameViewStore/GV_SET_GAME_LIVE',
        GV_SET_PERIOD_LENGTH: 'gameViewStore/GV_SET_PERIOD_LENGTH'
      }),
      clockClicked(event){
        if(this.activePeriod == -1){
          this.activePeriod = 1;
          var ref = firebase.database().ref('/SoccerGames').child(this.selectedTeamId).child(this.activeGameId);

          var result = {};
          var d = new Date();
          var elapsedSeconds = Math.round(d.getTime() / 1000);


          ref.update({
            Period: 1,
            InProgress: true,
            Live: true,
            PeriodStartTime: elapsedSeconds
          })

          this.GV_SET_IN_PROGRESS(true);
          this.GV_SET_GAME_LIVE(true);
          this.GV_SET_PERIOD(1);
          this.GV_SET_PERIOD_START_TIME(elapsedSeconds);
          this.activeInterval = setInterval(this.updateTime, 1000);
        }
        else if(this.activePeriod == 1){
          this.activePeriod = 2
          var ref = firebase.database().ref('/SoccerGames').child(this.selectedTeamId).child(this.activeGameId);

          var result = {};
          var d = new Date();
          var elapsedSeconds = Math.round(d.getTime() / 1000);

          ref.update({
            Period: 2,
            InProgress: true,
            PeriodStartTime: elapsedSeconds
          })

          this.GV_SET_IN_PROGRESS(true);
          this.GV_SET_PERIOD(2);
          this.GV_SET_PERIOD_START_TIME(elapsedSeconds);
          this.activeInterval= setInterval(this.updateTime, 1000);
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
          var dbRef = firebase.database().ref('SoccerGames/').child(self.selectedTeamId).child(self.activeGameId).child(self.currentPeriod)
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
          this.GV_SET_IN_PROGRESS(false);
          var ref = firebase.database().ref('SoccerGames/').child(this.selectedTeamId).child(this.activeGameId);
          ref.update({
            InProgress: false
          });

          if(this.currentPeriod == 1) {
            this.shouldStartClock = true;
          }
          else{
            this.GV_SET_GAME_LIVE(false);
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
      }
    }
  }
</script>

<style scoped>
  #GameView {
    width: 100vw;
    min-height: 250vh;
    height: 250vh;
    background-color: white;
    margin-top: 0px;
  }
  .TopBanner {
    width: 100vw;
    min-height: 100px;
    color: rgb(224, 0, 16);
    display: flex;
    margin-top: 20px;
  }

  .TopBanner h1 {
    /* float: left; */
    min-height: 100px;
    height: 100%;
    text-align: center;
    padding: 25px;
    flex-grow: 2;
  }
  #sbde1{
    padding-left: 0px;
    width: 310px;
    height: 500px;
    background: white;
    margin: 50px;
    margin-right: 0px;
    border-width: 5px;
    border-color: rgb(235,95,17);
    border-style: solid;
    border-radius: 35px;
    position: relative;

    box-shadow: 5px 5px 5px grey;
  }
  #fieldEntry {
    float: left;
  }
  .TopBanner .TimeClock{
    min-width: 350px;
    min-height: 100px;
    height: 100%;
    flex-grow: 1;
    border: black 5px solid;
    border-radius: 25px;
    margin-right: 5vw; 
  }
  .TopBanner .TimeClock h1{
    float: right; 
    margin-top: 0px;
    flex-grow: 5;
    width: 30px;
  }

  .TimeClock {
    display: flex;
  }

  .pm {
    padding: 5%;
    flex-grow: 2;
  }
</style>
