<template>
  <div id="TeamStats">
    <button @click="goBack">Go Back</button>
<!--
Code here
-->
    <table id="Stats">
      <thead>
        <th />
        <th v-for="statType in statTypes">{{ statType }}</th>
      </thead>

      <tr v-for="player in players">
        <td>{{player.replace('p', '#')}}: Name </td>

        <td v-for="statType in statTypes">
          <span v-if="playerData[player][statType]">
            {{playerData[player][statType]}}
          </span>
          <span v-else>
            0
          </span>
        </td>
      </tr>
    </table>

  </div>
</template>

<script>
  import firebase from 'firebase'

  export default {
    name: 'TeamStats',
    data() {
      return {
        gameData : {},
        statTypes: {},
        players: {},
        playerData: {},
        loggedInUser: '',
        currentUserEmail: ''
      }
    },
    methods: {
      goBack: function() {
        this.$emit('TeamStatsClose');
        console.log('CLOSE');
      },
      cellClick: function(x) {
        console.log(x);
      },
      getGameData: function() {
        var self = this;
        var id = 'team1-1';
        var gameDataRef = firebase.database().ref('/SoccerGames/' + id);
        console.log(gameDataRef)
        gameDataRef.on('value', function(snapshot) {
          console.log("VALUE")
          //console.log(snapshot)
          self.gameData = snapshot;
          console.log("V1");
          console.log(typeof self.gameData);
          if(self.gameData){
            console.log("V1-Not Null");
          }
          else {
            console.log("V1-NULL");
          }
          self.playerData = Object.values(self.gameData)[0].val()["Players"];
          console.log("V2");
          self.players = Object.keys(self.playerData);
          console.log("V3");
          self.statTypes = Object.keys(Object.values(self.gameData)[0].val()["MyTotals"]["Period1"]);
          console.log("V4");
          console.log(self.statTypes);
        });
      }
    },
    mounted() {
      //do something after mounting vue instance
      this.$nextTick(() => {
        console.log("NEXT TICK");
          this.loggedInUser = firebase.auth().currentUser;
          this.currentUserEmail = this.loggedInUser.email;
          this.getGameData();
      });
    }
  }
</script>

<style scoped>
  #TeamStats {
    width: 100%;
    background-color: orange;
  }
  #MyBox{
    width: 100px;
    height: 100px;
    background-color: red;
    float: left;
    margin: 10px;
  }
  #Stats {
    min-width: 300px;
    min-height: 300px;
    background-color: purple;
    color: white;
    border-style: solid;
    border-color: white;
    border-width: medium;
  }
  tr, td, th {
    border-style: solid;
    border-color: white;
    border-width: medium;
  }

</style>
