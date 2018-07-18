<template>
  <div id="GameView">
    <div class="TopBanner">
      <h2 style="float: left; margin: 30px 30px 0px 10px;">{{gameID}}</h2>
    </div>
    <player-stat-selector style="float: left;"
                          :players="players"
                          @playerSelected="playerWasSelected">
    </player-stat-selector>
    <sb-data-entry id="sbde1"
                   style="float: left;"
                   @StatChange="updateDB"
                   :gameID="gameID">
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
        currentPeriod: 'Period1',
        shotType: 'gcf',
        shotsArr: []
      }
    },
    methods: {
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
          var dbRef = firebase.database().ref('SoccerGames/').child(self.gameID).child(self.currentPeriod)
          dbRef = dbRef.child(input[1])
        }

      },
      shotPlaced(event){
        var shotData = {
          style: event.style,
          shotType: this.shotType
        };
        this.shotsArr.push(shotData);
      },
      shotTypeChanged(event){
        this.shotType = event;
      },
      undoClicked(){
        if (this.shotsArr.length > 0) {
          this.shotsArr.pop();
        }
      }
    },
    beforeCreate() {
      //do something before creating vue instance
      console.log('BEFORE CREATE');
    },
    created() {
      //do something after creating vue instance
      console.log('CREATED');
    },
    mounted() {
      //do something after mounting vue instance
      console.log(this.gameID);
      console.log('MOUNTED');
    },
    beforeDestroy() {
      //do something before destroying vue instance
      alert('BEFORE DESTROY');
    },
    destroyed() {
      //do something after destroying vue instance
      alert('DESTROYED');
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
