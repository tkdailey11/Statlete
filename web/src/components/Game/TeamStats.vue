<template>
  <div class="TeamStats">
    <nav-component />
    <div id="teamstats_main">
      <vue-scrolling-table
                :scroll-horizontal="scrollHorizontal"
                :scroll-vertical="scrollVertical"
                :sync-header-scroll="syncHeaderScroll"
                :sync-footer-scroll="false"
                :include-footer="false"
                :dead-area-color="deadAreaColor"
                :class="{ freezeFirstColumn:freezeFirstColumn }"
                style="border: medium solid black;
                      border-radius: 5px;">
        <template slot="thead">
          <tr>
            <th style="border-right: medium solid black; border-bottom: medium solid black;"></th>
            <th v-for="stat in statTypes" 
                :key="stat + '-hd'"
                style="border-bottom: medium solid black;">
                {{ stat }}
            </th>
          </tr>
        </template>
        <template slot="tbody">
          <tr v-for="p in playerNumbers" :key="p + '-key'">
            <th style="border-right: medium solid black;">{{ p.replace('p', '#')}}</th>
            <td v-for="statType in statTypes" :key="p + '-' + statType">
              <p v-if="playerData && playerData[p] && playerData[p][statType]">{{playerData[p][statType]}}</p>
              <p v-else>0</p>
            </td>
          </tr>
        </template>
      </vue-scrolling-table>
    </div>
  </div>
</template>

<script>
  import firebase from 'firebase'
  import { mapGetters, mapMutations } from 'vuex';

  export default {
    name: 'TeamStats',
    data() {
      return {
        gameData : {},
        statTypes: ["Assists",
                    "Corners",
                    "Crosses",
                    "Fouls",
                    "Goals",
                    "Minutes",
                    "Offsides",
                    "Red Cards",
                    "Saves",
                    "Shots",
                    "Shots on Goal",
                    "Yellow Cards"],
        playerData: {},
        loggedInUser: '',
        currentUserEmail: '',
        scrollVertical: true,
        scrollHorizontal: true,
        syncHeaderScroll: true,
        deadAreaColor: "#DDDDDD",
        maxRows: 100,
        freezeFirstColumn: true

      }
    },
    computed: {
       ...mapGetters({
        activeGameId: 'mainStore/activeGameId',
        players: 'mainStore/players',
        selectedTeamId: 'mainStore/selectedTeamId',
        selectedTeamSport: 'mainStore/selectedTeamSport'
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

      },
      isSoccer: function() {
        return this.selectedTeamSport == 1;
      }
    },
    created() {
      this.loggedInUser = firebase.auth().currentUser;
      this.currentUserEmail = this.loggedInUser.email;

      var self = this;
      // var ref = firebase.database().ref('/SoccerGames/' + self.selectedTeamId).child(self.activeGameId).child('MyTotals').child('Period1');
      // ref.once('value', function(snap) {
      //   self.statTypes = Object.keys(snap.val())
      // })
      var gameDataRef = null;

      if(this.selectedTeamSport == 1){
        gameDataRef = firebase.database().ref('/SoccerGames/' + self.selectedTeamId).child(self.activeGameId).child('Players');
      }
      else {
        this.statTypes = [
          "AST",
          "BLK",
          "DREB",
          "FG3A",
          "FG3M",
          "FGA",
          "FGM",
          "FTA",
          "FTM",
          "OREB",
          "PF",
          "STL",
          "TOV"
        ]
        gameDataRef = firebase.database().ref('/BasketballGames/' + self.selectedTeamId).child(self.activeGameId).child('Players');
      }
      gameDataRef.on('value', function(snapshot) {
        self.playerData = snapshot.val();
      });

    },
    mounted() {

    }
  }
</script>

<style scoped>
  #teamstats_main {
    height: 400px;
    width: 1090px;
    margin-top: 10%;
    margin-left: 15%;
    margin-right: 15%;
  }
  .TeamStats {
    
  }
  th, td {
    color: black;
  }

  table.scrolling .w2 {
    width: 20em;
    min-width: 20em;
    max-width: 20em;
  }
  table.scrolling tfoot tr th {
    width: 130em;
    min-width: 130em;
    max-width: 130em;
  }
  table.freezeFirstColumn thead tr,
  table.freezeFirstColumn tbody tr {
    display: block;
    width: min-content;
  }
  table.freezeFirstColumn thead td:first-child,
  table.freezeFirstColumn tbody td:first-child,
  table.freezeFirstColumn thead th:first-child,
  table.freezeFirstColumn tbody th:first-child {
    position: sticky;
    position: -webkit-sticky;
    left: 0;
  }
  
  .box {
    clear: both;
    padding: 0;
    min-height: 300px;
    height: 40vh;
    margin-left: auto;
    margin-right: auto;
    overflow: hidden;
  }
</style>
