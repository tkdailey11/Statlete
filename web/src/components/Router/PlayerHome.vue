<template>
  <div class="playerHome">
    <nav-component />

    <div class="mainHeader">
      <h1 v-if="theTeamName != ''" class="phH1">{{selectedTeamName}} - {{theTeamName}}</h1>
      <h1 v-else class="phH1">{{selectedTeamName}}</h1>
    </div>
    <div class="mainBody">
      <div class="list-wrapper">
        <games-list :games="gamesList"
                    @gameSelected="gameSelected"
                    @AddGame="addGame"
                    :addGameEnabled="addGameEnabled"
                    class="phgl">
        </games-list>
      </div>
      <div class="button-wrapper">
        <button @click="editMySettings" class="btn btn-outline-primary main_button">Edit My Settings</button>
        <button @click="viewMyStats" class="btn btn-outline-primary main_button">View My Stats</button>
        <button @click="goToAnalysis" class="btn btn-outline-primary main_button">Go to Analysis Page</button>
        <button @click="goToPdf" class="btn btn-outline-primary main_button">Export Stats to PDF</button>
      </div>
    </div>
  </div>
</template>

<script>
import firebase from 'firebase'
import { mapGetters, mapMutations } from 'vuex';
export default {
  name: 'PlayerHome',
  computed: {
    ...mapGetters({
      loggedInUser: 'mainStore/loggedInUser',
      selectedTeamId: 'mainStore/selectedTeamId',
      selectedTeamName: 'mainStore/selectedTeamName',
      selectedTeamToken: 'mainStore/selectedTeamToken',
      currentUserEmail: 'mainStore/currentUserEmail',
      activeGameId: 'mainStore/activeGameId',
      players: 'mainStore/players',
      addGameEnabled: 'playerStore/isAddGameEnabled'
    })
  },
  data () {
    return {
      msg: 'Welcome to Your Vue.js App',
      playerName: '',
      playerNumber: '',
      /*
        View Modes:
          - mainViewMode (default)
          - isCreatingTeam
          - isCreatingPlayer
          - isInGameView
      */
      viewMode: 'mainViewMode',
      playerSteps: [
        {
          label: 'Name and Sport',
          slot: 'playerPage1',
        },
        {
          label: 'Link (OPTIONAL)',
          slot: 'playerPage2',
        }
      ],
      teamSteps: [
        {
          label: 'Name and Sport',
          slot: 'teamPage1',
        },
        {
          label: 'Add Players',
          slot: 'teamPage2',
        },
        {
          label: 'Setup Linking (OPTIONAL)',
          slot: 'teamPage3',
        }
      ],
      sportfolios: [],
      gamesList: [],
      teamName: '',
      selectedSport: 'basketball',
      teamID: '',
      teamToken: '',
      theTeamName: ''
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
        this.getGames();

        var self = this;
        firebase.database().ref('/TeamSportfolios/' + this.selectedTeamId + '/TeamName').once("value", function(snapshot){
          self.theTeamName = snapshot.val();
        })
    });
  },
  methods: {
    ...mapMutations({
      SET_LOGGED_IN_USER: 'mainStore/SET_LOGGED_IN_USER',
      SET_SELECTED_TEAM: 'mainStore/SET_SELECTED_TEAM',
      SET_SELECTED_SPORT: 'mainStore/SET_SELECTED_SPORT',
      SET_ACTIVE_GAME_ID: 'mainStore/SET_ACTIVE_GAME_ID',
      SET_SELECTED_TEAM_ID: 'mainStore/SET_SELECTED_TEAM_ID',
      SET_PLAYERS: 'mainStore/SET_PLAYERS',
      APPEND_PLAYER: 'mainStore/APPEND_PLAYER'
    }),
    gameSelected: function(event) {
      this.SET_ACTIVE_GAME_ID(this.gamesList[event - 1]);
      //this.viewMode='isInGameView';
      this.$router.push('/playergameview');
    },
    logout: function() {
      firebase.auth().signOut().then(() => {
        this.$router.replace('login')
      })
    },
    showPlayer: function() {
      //jQuery("#notImplementedAlert").show();
      this.$router.push('/createplayer')
    },
    showTeam: function() {
      this.$router.push('/createteam')
    },
    goToAnalysis: function(event) {
      this.$router.push('/analysis');
    },
    goToPdf: function(event) {
      this.$router.push('/exportstats')
    },
    teamSelected: function(event) {
      this.SET_SELECTED_TEAM({
        id: event.Id,
        name: event.Name,
        token: event.Token,
        sport: event.Sport
      });

      this.getGamesTeam();
      this.getPlayers();
      this.$router.push('/main');
    },
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
    getGamesPlayer() {
      var teamIDList = [];
      var email = this.currentUserEmail.replace('.', '');
      var self = this;

      var keysList = [];
      self.gamesList = [];
      var gamesListRef = firebase.database().ref('/PlayerSportfolios/' + self.selectedTeamId + '/Games/');
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
    editMySettings() {
      this.$router.push('/playersettings')
    },
    viewMyStats() {
      this.viewMode = 'teamStatsView';
    },
    //<!-- CHANGE THIS -->
    getGames() {
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

.phgl {
    min-width: 200px;
    width: 100%;
    max-height: 70vh;
}
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

  /* Style page content - use this if you want to push the page content to the right when you open the side navigation */
  .playerHome {
      transition: margin-left .5s;
      margin:0px;
      height: 100vh;
      overflow-y: scroll;
  }

  /* On smaller screens, where height is less than 450px, change the style of the sidenav (less padding and a smaller font size) */
  @media screen and (max-height: 450px) {
      .sidenav {padding-top: 15px;}
      .sidenav a {font-size: 18px;}
  }

  .sportSelect {
    width: 210px;
    height: 97px;
  }
  .main_button {
    margin-top: 20px;
    cursor: pointer;
    height: 50px;
    max-height: 50px;
    margin: 10px;
    padding-top: 10px;
    padding-bottom: 15px;
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

  .mainHeader .sportButton {
    width: 40%;
    min-width: 50px;
    max-width: 200px;
    min-height: 50px;
    max-height: 50px;
    float: right;
    overflow: hidden;
    white-space: nowrap;
    margin-right: 5px;
    margin-left: 5px;
    text-overflow: ellipsis;
  }

  .button-wrapper {
    flex-basis: 50%;
    padding: 30px 15px 15px 20px;
  }

  .list-wrapper {
    flex-basis: 50%;
    padding: 25px;
    display: flex;
    max-height: 75vh;
  }

   .mainBody {
    width: 100%;
    display: flex;
    flex-wrap: wrap;
    align-items: stretch;
  }

  #mainPage {
    min-height: 100vh;
  }

  .phH1 {
    margin: 25px 50px 50px 50px;
  }

   @media screen and (max-width: 450px) {
    
    .mainBody {
      display: block;
    }
    .list-wrapper {
      display: block;
    }

    .button-wrapper {
      display: block;
      padding: 0px;
      margin-left: 105px;
    }

    .phgl{
      width: 80%;
      margin-left: 3%;
      margin-bottom: 5%;
    }

    .main_button {
      margin-bottom: 45px;
      width: 175px;
      display: block;
    }
  }

  @media screen and (min-width: 850px) {
    .phgl {
      font-size: 120%;
    }
  }

</style>
