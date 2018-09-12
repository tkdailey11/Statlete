<template>
  <div class="playerHome">
    <statlete-navbar v-if="!(viewMode==='isCreatingTeam' || viewMode==='isCreatingPlayer')"
                     @shouldOpenNav="openNav"
                     @shouldLogout="logout"
                     style="background-color: rgb(224, 0, 16);"></statlete-navbar>

    <side-nav id="mySidenav"
              @showPlayer="showPlayer"
              @showTeam="showTeam"
              @teamSelected="teamSelected">
    </side-nav>

    <div class="mainHeader">
      <h1 style="color: rgb(224, 0, 16); margin: 25px 50px 50px 50px;">{{selectedTeamName}} - {{theTeamName}}</h1>
    </div>
    <div class="mainBody">
      <games-list :games="gamesList"
                  style="margin-top: 20px;"
                  @gameSelected="gameSelected"
                  @AddGame="addGame"
                  :addGameEnabled="addGameEnabled">
      </games-list>
      <div class="button-wrapper">
        <button @click="editMySettings" class="btn btn-outline-primary myButton">Edit My Settings</button>
        <button @click="viewMyStats" class="btn btn-outline-primary myButton">View My Stats</button>
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
          console.log(snapshot);
          self.theTeamName = snapshot.val();
        })
    });
  },
  methods: {
    ...mapMutations({
      SET_LOGGED_IN_USER: 'mainStore/SET_LOGGED_IN_USER',
      SET_SELECTED_TEAM: 'mainStore/SET_SELECTED_TEAM',
      SET_CURR_TEAM: 'mainStore/SET_CURR_TEAM',
      //SET_CURR_TEAM_NAME: 'mainStore/SET_CURR_TEAM_NAME',
      SET_SELECTED_SPORT: 'mainStore/SET_SELECTED_SPORT',
      SET_ACTIVE_GAME_ID: 'mainStore/SET_ACTIVE_GAME_ID',
      SET_SELECTED_TEAM_ID: 'mainStore/SET_SELECTED_TEAM_ID',
      SET_PLAYERS: 'mainStore/SET_PLAYERS',
      APPEND_PLAYER: 'mainStore/APPEND_PLAYER'
    }),
    gameSelected: function(event) {
      this.SET_ACTIVE_GAME_ID(this.gamesList[event - 1]);
      //this.viewMode='isInGameView';
      this.$router.push('/gameview');
    },
    openNav: function() {
      setTimeout(function(){
        document.getElementById("mySidenav").style.width = "250px";
      }, 90);
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
    teamSelected: function(event) {
      this.SET_SELECTED_TEAM({
        id: event.Id,
        name: event.Name,
        token: event.Token
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
      console.log("VIEW TEAM STATS");
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

  /* The side navigation menu */
  .sidenav {
      height: 100%; /* 100% Full-height */
      width: 0; /* 0 width - change this with JavaScript */
      position: fixed; /* Stay in place */
      z-index: 1; /* Stay on top */
      top: 0; /* Stay at the top */
      left: 0;
      background-color: #111; /* Black*/
      overflow-x: hidden; /* Disable horizontal scroll */
      padding-top: 60px; /* Place content 60px from the top */
      transition: 0.5s; /* 0.5 second transition effect to slide in the sidenav */
  }

  /* The navigation menu links */
  .sidenav a {
      padding: 8px 8px 8px 32px;
      text-decoration: none;
      font-size: 25px;
      color: #818181;
      display: block;
      transition: 0.3s;
  }

  /* When you mouse over the navigation links, change their color */
  .sidenav a:hover {
      color: #f1f1f1;
  }

  /* Position and style the close button (top right corner) */
  .sidenav .closebtn {
      position: absolute;
      top: 0;
      right: 25px;
      font-size: 36px;
      margin-left: 50px;
  }

  /* Style page content - use this if you want to push the page content to the right when you open the side navigation */
  .playerHome {
      transition: margin-left .5s;
      margin:0px;
      min-height: 100%;
      background-color: white;
      height: 100vh
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

  ::placeholder { /* Chrome, Firefox, Opera, Safari 10.1+ */
    color: rgba(255,0,0,0.5);
    opacity: 1; /* Firefox */
  }

  :-ms-input-placeholder { /* Internet Explorer 10-11 */
    color: rgba(255,0,0,0.5);
  }

  ::-ms-input-placeholder { /* Microsoft Edge */
    color: rgba(255,0,0,0.5);
  }

  #mainPage {
    min-height: 100vh;
    background-color: white;
  }

  #leftList {

  }
  #rightList {

  }
</style>
