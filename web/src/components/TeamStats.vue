<template>
  <div class="TeamStats">
    <div class="SBdataEntry">
      <div class="title">
        <div id="headerBuffer">
        </div>
        <div id="headers">
          <h5 align="center" v-for="statType in statTypes" :key="'h5-' + statType">{{ statType }}</h5>
        </div>
      </div>
      <div id="dataTable">
        <table>
          <tr v-for="p in playerNumbers" :key="p + '-key'">
            <th style="width: 163px; min-width: 163px; border: thin solid black; border-right-width: 2px;">{{ p.replace('p', '#')}}</th>
            <td v-for="statType in statTypes" :key="p + '-' + statType">
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
  import { mapGetters, mapMutations } from 'vuex';

  export default {
    name: 'TeamStats',
    data() {
      return {
        gameData : {},
        statTypes: {},
        playerData: {},
        loggedInUser: '',
        currentUserEmail: '',
      }
    },
    computed: {
       ...mapGetters({
        activeGameId: 'mainStore/activeGameId',
        players: 'mainStore/players',
        selectedTeamId: 'mainStore/selectedTeamId'
      }),
      playerNumbers() {
        return Object.keys(this.players);
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
        var gameDataRef = firebase.database().ref('/SoccerGames/' + self.selectedTeamId).child(self.activeGameId).child('Players');
        console.log(gameDataRef)
        gameDataRef.on('value', function(snapshot) {
          self.playerData = snapshot.val();
        });
      }
    },
    mounted() {
      this.loggedInUser = firebase.auth().currentUser;
      this.currentUserEmail = this.loggedInUser.email;
      this.getGameData();
      var self = this;
      var ref = firebase.database().ref('/SoccerGames/' + self.selectedTeamId).child(self.activeGameId).child('MyTotals').child('Period1');
      ref.once('value', function(snap) {
        self.statTypes = Object.keys(snap.val())
      })

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
.TeamStats {
  height: 650px;
  margin: 100px 0px 0px 100px;
  min-width: 1090px;
  max-width: 1500px;
}

.SBdataEntry {
  height: 650px;
  min-width: 1090px;
  max-width: 1500px;
  background: white;
  border-width: 5px;
  border-color: black;
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
  border-bottom-color: black;
  border-bottom-width: medium;
  border-bottom-style: solid;
  background-color: white;

  width: 100%;
}
#headerBuffer{
  border-right: 2px solid black;
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
  height: 650px;
  background-color: white;
  overflow-y: scroll;
  border-radius: 0px 0px 15px 15px;
}

table, th {
  border: 1px solid black;
  color: rgb(224,0,16);
}

td {
  border-bottom: 1px solid black;
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
