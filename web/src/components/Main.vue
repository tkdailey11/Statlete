<template>
  <div class="main">
    <new-player @newPlayerAdded="hideModal" />
    <nav-component />

    <div id="notImplementedAlert" class="alert alert-primary alert-dismissible fade show" role="alert">
      <p>This functionality has not yet been implemented. Please check back soon!</p>
      <button type="button" class="close" data-dismiss="alert" aria-label="Close" style="margin: 7px; background-color: transparent;">
        <span aria-hidden="true">&times;</span>
      </button>
    </div>

    <div id="mainPage">
      <div class="mainHeader">
        <h1 style="color: rgb(224, 0, 16); margin: 25px 50px 50px 50px;">{{selectedTeamName}}</h1>
      </div>
      <div class="mainBody">
        <games-list :games="gamesList"
                    style="margin-top: 20px;"
                    @gameSelected="gameSelected"
                    @AddGame="addGame">
        </games-list>
        <players-list style="margin-top: 20px;"
                      @playerSelected="viewPlayerInfo"
                      @addPlayerClicked="showModal"
                      :players="players">
        </players-list>
        <div class="button-wrapper">
          <button @click="editTeamSettings" class="btn btn-outline-primary myButton">Edit Team Settings</button>
          <button @click="viewTeamStats" class="btn btn-outline-primary myButton">View Team Stats</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import firebase from 'firebase'
import { mapGetters, mapMutations } from 'vuex';
export default {
  name: 'Main',
  computed: {
    ...mapGetters({
      selectedTeamId: 'mainStore/selectedTeamId',
      selectedTeamName: 'mainStore/selectedTeamName',
      selectedTeamToken: 'mainStore/selectedTeamToken',
      currentUserEmail: 'mainStore/currentUserEmail',
      activeGameId: 'mainStore/activeGameId',
      players: 'mainStore/players'
    })
  },
  data () {
    return {
      sportfolios: [],
      gamesList: [],
      teamName: '',
      teamID: '',
      teamToken: ''
    }
  },
  mounted () {
    jQuery("#notImplementedAlert").hide();
    var niMsg = jQuery("#notImplementedAlert");

    niMsg.on("close.bs.alert", function () {
          niMsg.hide();
          return false;
    });
    this.$nextTick(() => {
        this.SET_LOGGED_IN_USER(firebase.auth().currentUser);
        this.getGamesTeam();
        this.getPlayers();
        this.getSportfolios();
    });
  },
  methods: {
    ...mapMutations({
      SET_LOGGED_IN_USER: 'mainStore/SET_LOGGED_IN_USER',
      SET_SELECTED_TEAM: 'mainStore/SET_SELECTED_TEAM',
      SET_CURR_TEAM: 'mainStore/SET_CURR_TEAM',
      SET_ACTIVE_GAME_ID: 'mainStore/SET_ACTIVE_GAME_ID',
      SET_SELECTED_TEAM_ID: 'mainStore/SET_SELECTED_TEAM_ID',
      SET_PLAYERS: 'mainStore/SET_PLAYERS',
    }),
    gameSelected: function(event) {
      this.SET_ACTIVE_GAME_ID(this.gamesList[event - 1]);
      this.$router.push('/gameview');
    },
    editTeamSettings() {
      this.$router.push('/teamsettings');
    },
    viewTeamStats() {
      console.log("VIEW TEAM STATS");
    },
    viewPlayerInfo() {
      console.log("View PLAYER INFO");
    },
    //<!-- CHANGE THIS -->
    getGamesTeam() {
      var teamIDList = [];
      var email = this.currentUserEmail.replace('.', '');
      var self = this;

      var keysList = [];
      self.gamesList = [];
      var gamesListRef = firebase.database().ref('/TeamSportfolios/' + self.selectedTeamId + '/Games/');
      if (typeof gamesListRef !== 'undefined') {
        gamesListRef.on('value', function(snapshot) {
          var obj = snapshot.val();
          if (obj) {
            self.gamesList = Object.keys(obj);
          }
        });
      }
    },
    getPlayers() {
      var id = this.selectedTeamId;
      var self = this;
      self.SET_PLAYERS([]);
      var playersRef = firebase.database().ref('/TeamSportfolios/' + id + '/Players/');
      playersRef.on('value', function(snapshot) {
        var obj = snapshot.val();
        if(obj){
          self.SET_PLAYERS(obj);
        }
      });
    },
    showModal () {
      this.$modal.show('new-player');
    },
    hideModal (event) {
      var id = this.selectedTeamId;
      var playersRef = firebase.database().ref('/TeamSportfolios/' + id + '/Players/');
      var num = 'p' + event.num;
      var name = event.name;
      if(!name){
        name = ' ';
      }
      playersRef.update({
        [num] : name
      });
      this.$modal.hide('new-player');
    },
    getSportfolios() {
      var id = this.selectedTeamId;
      var keysList = [];
      var self = this;
      var email = this.currentUserEmail.replace('.', '');
      var sportfoliosListRef = firebase.database().ref('/Users/' + email + '/AdminTeams/');
      sportfoliosListRef.on('value', function(snapshot) {
        var obj = snapshot.val();
        keysList = Object.keys(obj);
        self.SET_SELECTED_TEAM_ID(keysList[0]);
        var sportfoliosRef = firebase.database().ref('/TeamSportfolios');
        self.sportfolios = [];
        keysList.forEach(function(key) {
          sportfoliosRef.child(key).once('value', function(snap) {
            self.sportfolios.push(snap.val());
          })
        })
      })
    },
    addGame() {
      var gameID = this.selectedTeamId + '_' + Math.random().toString(36).substring(2,7);
      var data = {
          "Date" : "4-21-2018",
          "HalfLength" : 45,
          "InProgress" : true,
          "Live" : true,
          "MyTotals" : {
            "Period1" : {
              "Assists" : {
                "Total" : 0
              },
              "Corners" : {
                "Total" : 0
              },
              "Crosses" : {
                "Total" : 0
              },
              "Fouls" : {
                "Total" : 0
              },
              "Goals" : {
                "Total" : 0
              },
              "Offsides" : {
                "Total" : 0
              },
              "Red Cards" : {
                "Total" : 0
              },
              "Saves" : {
                "Total" : 0
              },
              "Shots" : {
                "Total" : 0
              },
              "Shots on Goal" : {
                "Total" : 0
              },
              "Yellow Cards" : {
                "Total" : 0
              }
            },
            "Period2" : {
              "Assists" : {
                "Total" : 0
              },
              "Corners" : {
                "Total" : 0
              },
              "Crosses" : {
                "Total" : 0
              },
              "Fouls" : {
                "Total" : 0
              },
              "Goals" : {
                "Total" : 0
              },
              "Offsides" : {
                "Total" : 0
              },
              "Red Cards" : {
                "Total" : 0
              },
              "Saves" : {
                "Total" : 0
              },
              "Shots" : {
                "Total" : 0
              },
              "Shots on Goal" : {
                "Total" : 0
              },
              "Yellow Cards" : {
                "Total" : 0
              }
            },
            "Possession" : 0
          },
          "Name" : gameID,
          "OpponentsTotals" : {
            "Period1" : {
              "Assists" : {
                "Total" : 0
              },
              "Corners" : {
                "Total" : 0
              },
              "Crosses" : {
                "Total" : 0
              },
              "Fouls" : {
                "Total" : 0
              },
              "Goals" : {
                "Total" : 0
              },
              "Offsides" : {
                "Total" : 0
              },
              "Red Cards" : {
                "Total" : 0
              },
              "Saves" : {
                "Total" : 0
              },
              "Shots" : {
                "Total" : 0
              },
              "Shots on Goal" : {
                "Total" : 0
              },
              "Yellow Cards" : {
                "Total" : 0
              }
            },
            "Period2" : {
              "Assists" : {
                "Total" : 0
              },
              "Corners" : {
                "Total" : 0
              },
              "Crosses" : {
                "Total" : 0
              },
              "Fouls" : {
                "Total" : 0
              },
              "Goals" : {
                "Total" : 0
              },
              "Offsides" : {
                "Total" : 0
              },
              "Red Cards" : {
                "Total" : 0
              },
              "Saves" : {
                "Total" : 0
              },
              "Shots" : {
                "Total" : 0
              },
              "Shots on Goal" : {
                "Total" : 0
              },
              "Yellow Cards" : {
                "Total" : 0
              }
            },
            "Possession" : 0
          },
          "Period" : 1,
          "PeriodStartTime" : 1524338307
        }
      var ref = firebase.database().ref('SoccerGames').update({
        [gameID] : data
      })
      var ref = firebase.database().ref('TeamSportfolios').child(this.selectedTeamId).child('Games').update({
        [gameID] : 'game'
      })
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
  #header h1{
      margin:0px;
      font-weight: normal;
  }
  ul {
    list-style-type: none;
    padding: 0;
  }
  li {
    display: inline-block;
    margin: 0 10px;
  }
  a {
    color: #42b983;
  }

  

  /* Style page content - use this if you want to push the page content to the right when you open the side navigation */
  .main {
      transition: margin-left .5s;
      margin:0px;
      min-height: 100%;
  }
  button {
    margin-top: 20px;
    cursor: pointer;
    color: white;
    background-color: rgb(255,158,0);
    border-color: rgb(224,0,16);
    color: rgb(224,0,16);
  }
  button:hover {
    background-color: rgb(242,209,24);
    border-color: rgb(224,0,16);
    color: rgb(180, 41, 102);
  }


  .mainHeader {
    width: 100%;
    height: 20%;
    min-height: 100px;
    max-height: 110px;
    display: flex;
    flex-direction: row;
    flex-wrap: nowrap;
    overflow: hidden;
    white-space: nowrap;
  }

  .button-wrapper {
    float: right;
    white-space: nowrap;
    margin-top: 18px;
    display: flex;
    flex-wrap: wrap;
    margin-left: 75px;
  }

  .mainHeader h1 {
    width: 100%;
    font-size: 70px;
    max-height: 100px;
    white-space: nowrap;
    text-align: left;
    margin-left: 15px;
  }

  .mainBody {
    width: 100%;
    display: flex;
    flex-wrap: wrap;
    background-color: white;
  }
  .myButton {
    height: 50px;
    max-height: 50px;
    margin: 50px;
  }

  #mainPage {
    min-height: 100vh;
    background-color: white;
  }
</style>
