<template>
  <div id="GameView">
    <nav-component />
    <div class="TopBanner">
        <h1>{{activeGameId}}</h1>
        <h1 class="TimeClock">{{currTime}}</h1>
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
        currTime: '1:11'
      }
    },
    mounted() {
      var updateClockLoop = setInterval(this.updateTime, 1000);
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
        currGameTime: 'gameViewStore/currGameTime'
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
        GV_SET_CURR_GAME_TIME: 'gameViewStore/GV_SET_CURR_GAME_TIME'
      }),
      playerWasSelected(event) {
        console.log(event);
      },
      updateDB(event){
        var self = this;
        var input = event.split(":");
        if(input[0]==='minus'){
          alert('Subtracting Stats is not yet supported')
        }
        else{
          var dbRef = firebase.database().ref('SoccerGames/').child(self.activeGameId).child(self.currentPeriod)
          dbRef = dbRef.child(input[1])
        }

      },
      updateTime(){
        this.currTime = this.getTimeString(this.getTime());
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

        var d = new Date();
        var elapsedSeconds = Math.round(d.getTime() / 1000);
        elapsedSeconds = elapsedSeconds - this.periodStartTime;
        result.minutes = Math.floor(elapsedSeconds / 60);
        result.seconds = elapsedSeconds % 60;

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
    padding: 25px;
    flex-grow: 1;
  }
</style>
