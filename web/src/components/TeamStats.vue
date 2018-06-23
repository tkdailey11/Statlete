<template>
  <div class="TeamStats">
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
        <div id="headerBuffer">
        </div>
        <div id="headers">
          <h5 align="center" v-for="statType in statTypes">{{ statType }}</h5>
        </div>
      </div>
      <div id="dataTable">
        <table>
          <tr v-for="p in players">
            <th style="width: 163px; min-width: 163px; border: thin solid rgb(235,95,17); border-right-width: 2px;">{{ p.replace('p', '#') }}</th>
            <td v-for="statType in statTypes">
              <span v-if="statType.length == 7">
                <p v-if="playerData[p][statType]" style="width: 80px; margin-right: 10px; margin-top: 10px;">{{playerData[p][statType]}}</p>
                <p v-else style="width: 80px; margin-right: 10px; margin-top: 10px;">0</p>
              </span>
              <span v-if="statType.length == 8">
                <p v-if="playerData[p][statType]" style="width: 90px; margin-right: 17px; margin-top: 10px;">{{playerData[p][statType]}}</p>
                <p v-else style="width: 90px; margin-right: 17px; margin-top: 10px;">0</p>
              </span>
              <span v-if="statType.length == 5">
                <p v-if="playerData[p][statType]" style="width: 60px; margin-right: 8px; margin-top: 10px;">{{playerData[p][statType]}}</p>
                <p v-else style="width: 60px; margin-right: 8px; margin-top: 10px;">0</p>
              </span>
              <span v-if="statType.length == 11">
                <p v-if="playerData[p][statType]" style="width: 125px; margin-right: 20px; margin-top: 10px;">{{playerData[p][statType]}}</p>
                <p v-else style="width: 125px; margin-right: 20px; margin-top: 10px;">0</p>
              </span>
            </td>
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
        playerSportfolios: [{name: 'Tyler'},
                            {name: 'Joe'},
                            {name: 'Brandon'},
                            {name: 'Taylor'},
                            {name: 'Nate'},
                            {name: 'Tyler2'},
                            {name: 'Joe2'},
                            {name: 'Brandon2'},
                            {name: 'Taylor2'},
                            {name: 'Nate2'}]
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

      document.getElementById("dataTable").addEventListener("scroll", scrollTableFunction);
      document.getElementById("headers").addEventListener("scroll", scrollHeaderFunction);

      function scrollTableFunction() {
        var tabl = document.getElementById("dataTable");
        var headr = document.getElementById("headers");
        headr.scrollLeft = tabl.scrollLeft;
      }

      function scrollHeaderFunction() {
        var tabl = document.getElementById("dataTable");
        var headr = document.getElementById("headers");
        tabl.scrollLeft = headr.scrollLeft;
      }
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


.TeamStats {
  width: 100%;
  height: 100vh;
  min-height: 500px;
  background-color: white;
  padding: 7%;
}

.SBdataEntry {
  height: 500px;
  min-width: 84.5vw;
  background: white;
  border-width: 5px;
  border-color: rgb(235,95,17);
  border-style: solid;
  border-radius: 15px;
  /* Margin was at 10% */
  margin-bottom: 50px;
  box-shadow: 5px 5px 5px grey;
}

.title {
  height: 10%;
  background: white;
  border-radius: 15px 15px 0px 0px;
  border-bottom-color: rgb(235,95,17);
  border-bottom-width: medium;
  border-bottom-style: solid;
  background-color: white;

  width: 100%;
}
#headerBuffer{
  border-right: 2px solid rgb(235,95,17);
  float: left;
  width: 164px;
  height: 100%;
}
#headers{
  overflow: hidden;
  max-height: 100%;
  display: flex;
flex-direction: row;
flex-wrap: nowrap;
border-radius: 0px 10px 0px 0px;
overflow-x: scroll;
}

#dataTable {
  max-height: 90%;
  height: 450px;
  background-color: white;
  overflow-y: scroll;
  border-radius: 0px 0px 15px 15px;
}

table, th {
  border: 1px solid rgb(235,95,17);
  color: rgb(224,0,16);
}

td {
  border-bottom: 1px solid rgb(235,95,17);
  color: rgb(224,0,16);
}

h5 {
  line-height: 50px;
  height: 50px;
  color: rgb(224,0,16);
  padding-left: 11px;
  padding-right: 11px;
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
th:first-child{
}
</style>
