<template>
  <div id="GameView">
    <div class="TopBanner">
      <h2 style="float: left; margin: 30px 30px 0px 10px;">{{activeGameId}}</h2>
    </div>
    <player-stat-selector style="float: left;"
                          :players="players"
                          @playerSelected="playerWasSelected">
    </player-stat-selector>
    <sb-data-entry id="sbde1"
                   style="float: left;"
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
        shotsArrLength: 'gameViewStore/shotsArrLength'
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
        GV_REMOVE_SHOT: 'gameViewStore/GV_REMOVE_SHOT'
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
    background-color: grey;
    min-height: 100px;
    margin-bottom: -20px;
    border: medium black solid;
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
</style>
