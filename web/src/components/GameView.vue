<template>
  <div id="GameView">
    <div class="TopBanner">
      <h2 style="float: left; margin: 30px 30px 0px 10px;">{{gameID}}</h2>
    </div>
    <player-stat-selector style="float: left;"
                          :players="players"
                          @playerSelected="playerWasSelected">
    </player-stat-selector>
    <sb-data-entry style="float: left;"
                   @StatChange="updateDB"
                   :gameID="gameID">
    </sb-data-entry>
    <div style="float: left;">
      <sb-field></sb-field>
      <sb-shot-type></sb-shot-type>
    </div>
  </div>
</template>

<script>
  import firebase from 'firebase'

  export default {
    name: 'GameView',
    props: {
      gameID: '',
      players: {},
      teamID: ''
    },
    data() {
      return {
        selectedPlayer: '',
        statString: '',
        currentPeriod: 'Period1'
      }
    },
    methods: {
      playerWasSelected(event) {
        console.log(event);
      },
      updateDB(event){
        alert(event)
        var self = this;
        var input = event.split(":");
        if(input[0]==='minus'){
          alert('Subtracting Stats is not yet supported')
        }
        else{
          var dbRef = firebase.database().ref('SoccerGames/').child(self.gameID).child(self.currentPeriod)
          dbRef = dbRef.child(input[1])
        }

      }
    },
    mounted() {
      //do something after mounting vue instance
      console.log(this.gameID);
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
  .TopBanner {
    width: 100vw;
    background-color: grey;
    min-height: 100px;
    margin-bottom: -20px;
    border: medium black solid;
  }
</style>
