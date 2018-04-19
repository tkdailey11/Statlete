<template>
  <div id="TeamStats">
    <button @click="goBack">Go Back</button>
<!--
Code here
-->

<!--
    <div class="tableContainer">
      <table id="Stats">
        <thead>
          <th />
          <th v-for="statType in statTypes"><p style="margin: 10px;">{{ statType }}</p></th>
        </thead>

        <tr v-for="player in players">
          <td><p style="margin: 10px;">{{player.replace('p', '#')}}</p></td>

          <td v-for="statType in statTypes">
            <span v-if="playerData[player][statType]">
              <p style="margin:10px;">{{playerData[player][statType]}}</p>
            </span>
            <span v-else>
              <p style="margin:10px;">0</p>
            </span>
          </td>
        </tr>
      </table>
    </div>
-->

<div class="SBdataEntry">
  <div class="title">
    <h5 style="margin-right: 10px;" v-for="i in 10" />
    <h5 align="center" v-for="statType in statTypes" style="margin-right: 10px;">{{ statType }}</h5>
  </div>
  <div class="dataTable">
    <table>
      <tr v-for="p in playerSportfolios">
        <td>{{ i }}</td>
      </tr>
      <tr>
        <td @click="$emit('showPlayer'); closeNav();">+ New Player Sportfolio</td>
      </tr>
    </table>
  </div>
</div>


  </div>
</template>

<script>
  import firebase from 'firebase'
  import VueScrollingTable from "vue-scrolling-table"

  export default {
    name: 'TeamStats',
    data() {
      return {
        gameData : {},
        statTypes: {},
        players: {},
        playerData: {},
        loggedInUser: '',
        currentUserEmail: '',
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
/*
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
  .tableContainer{
    min-width: 500px;
    min-height: 500px;
    max-height: 500px;

    display: inline-block;
    overflow: scroll;
    margin: 5vw;
    background-color: green;
  }
  #Stats {
    background-color: purple;
    color: white;
    border-style: solid;
    border-color: white;
    border-width: medium;
    height: 80%;

  }
  tr, td, th {
    border-style: solid;
    border-color: white;
    border-width: medium;
  }


*/




.SBdataEntry {
  height: 250px;
  background: rgb(180, 41, 102);
  border-width: 5px;
  border-color: rgb(180, 41, 102);
  border-style: solid;
  border-radius: 15px;
  margin: 10%;
  margin-bottom: 50px;
    overflow: auto;
}

.title {
  height: 20%;
  background: white;
  border-radius: 15px 15px 0px 0px;
  border-bottom-color: rgb(180, 41, 102);
  border-bottom-width: medium;
  border-bottom-style: solid;
  background-color: #fadc7f;
  display: flex;
}

.dataTable {
  max-height: 80%;
  height: 189px;
  background-color: #fadc7f;
  overflow: scroll;
  border-radius: 0px 0px 15px 15px;
}

table, th {
  border: 1px solid rgb(180, 41, 102);
}

td {
  border-bottom: 1px solid rgb(180, 41, 102);
  color: rgb(180, 41, 102);
}

h5 {
  line-height: 50px;
  height: 50px;
  color: rgb(180, 41, 102);

}
img {
  zoom: 50%;
}
.dataLabelCell {
  overflow: hidden;
}
.dataLabel {
  margin-top: 5%;
  font-size: 25px;
  line-height: 50px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  text-align: center;
  vertical-align: middle;
}

</style>
