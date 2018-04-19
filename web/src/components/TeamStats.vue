<template>
  <!--<div id="TeamStats">
    <button @click="goBack">Go Back</button>-->
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

<table class="fixed_headers">
  <thead>
    <tr>
      <th style="background-color: orange; min-height: 30px;"/>
      <th v-for="statType in statTypes" style="background-color: blue;"><p v-if="statType==='ShotsOnGoal'" style="background-color: red;">{{ statType }}</p>
                                        <p v-else style="background-color: green;">{{statType}}</p></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Apple</td>
      <td>Red</td>
      <td>These are red.</td>
    </tr>
    <tr>
      <td>Pear</td>
      <td>Green</td>
      <td>These are green.</td>
    </tr>
    <tr>
      <td>Grape</td>
      <td>Purple / Green</td>
      <td>These are purple and green.</td>
    </tr>
    <tr>
      <td>Orange</td>
      <td>Orange</td>
      <td>These are orange.</td>
    </tr>
    <tr>
      <td>Banana</td>
      <td>Yellow</td>
      <td>These are yellow.</td>
    </tr>
    <tr>
      <td>Kiwi</td>
      <td>Green</td>
      <td>These are green.</td>
    </tr>
    <tr>
      <td>Plum</td>
      <td>Purple</td>
      <td>These are Purple</td>
    </tr>
    <tr>
      <td>Watermelon</td>
      <td>Red</td>
      <td>These are red.</td>
    </tr>
    <tr>
      <td>Tomato</td>
      <td>Red</td>
      <td>These are red.</td>
    </tr>
    <tr>
      <td>Cherry</td>
      <td>Red</td>
      <td>These are red.</td>
    </tr>
    <tr>
      <td>Cantelope</td>
      <td>Orange</td>
      <td>These are orange inside.</td>
    </tr>
    <tr>
      <td>Honeydew</td>
      <td>Green</td>
      <td>These are green inside.</td>
    </tr>
    <tr>
      <td>Papaya</td>
      <td>Green</td>
      <td>These are green.</td>
    </tr>
    <tr>
      <td>Raspberry</td>
      <td>Red</td>
      <td>These are red.</td>
    </tr>
    <tr>
      <td>Blueberry</td>
      <td>Blue</td>
      <td>These are blue.</td>
    </tr>
    <tr>
      <td>Mango</td>
      <td>Orange</td>
      <td>These are orange.</td>
    </tr>
    <tr>
      <td>Passion Fruit</td>
      <td>Green</td>
      <td>These are green.</td>
    </tr>
  </tbody>
</table>

  <!--</div>-->
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



.fixed_headers {
  width: 1500px;
  table-layout: fixed;
  border-collapse: collapse;
}
.fixed_headers th {
   margin-right: 5px;
  text-align: left;
  text-decoration: underline;
  display: inline-block;
  width:100px;
  overflow-x: scroll;
}
.fixed_headers td {
  padding: 5px;
  text-align: left;
}
.fixed_headers thead {
    background-color: #DDD;
    color: #FDFDFD;
      display:inline-block;
      width: 100%;
      overflow: scroll;

  }
.fixed_headers tbody {
  display: inline-block;
  overflow: auto;
  width: 100%;
  height: 300px;
  background-color: white;
}

.old_ie_wrapper {
  height: 100px;
  width: 1200px;
  overflow-x: hidden;
  overflow-y: auto;
}
</style>
