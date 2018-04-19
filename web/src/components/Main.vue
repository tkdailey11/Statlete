<template>
  <div class="main">
    <new-player @newPlayerAdded="hideModal" />
    <statlete-navbar v-if="!(viewMode==='isCreatingTeam' || viewMode==='isCreatingPlayer')"
                     @shouldOpenNav="openNav"
                     @shouldLogout="logout"></statlete-navbar>

    <side-nav id="mySidenav"
              @showPlayer="showPlayer"
              @showTeam="showTeam">
    </side-nav>

    <div id="mainPage" v-if="viewMode==='mainViewMode'">

      <div class="mainHeader">
        <h1 style="color: rgb(180, 41, 102);">Team Name</h1>
        <div class="button-wrapper">
          <button @click="editTeamSettings" class="btn btn-outline-primary">Edit Team Settings</button>
          <button @click="viewTeamStats" class="btn btn-outline-primary">View Team Stats</button>
        </div>
      </div>
      <div class="mainBody">
        <games-list :games="gamesList"
                    style="margin-top: 20px;"
                    @gameSelected="viewMode='isInGameView'"></games-list>
        <players-list style="margin-top: 20px;"
                      @playerSelected="viewPlayerInfo"
                      @addPlayerClicked="showModal"
                      :players="players"></players-list>
      </div>

    </div>
    <!-- WIZARDS -->
    <div v-else>
      <div id="PlayerWizard" v-if="viewMode==='isCreatingPlayer'" style="padding-top=100px;">
          <vue-good-wizard
            :steps="playerSteps"
            :onNext="nextClickedPlayer"
            :onBack="backClickedPlayer">

            <div slot="playerPage1">
              <label class="myLabel">Team Name:</label>
              <input type="text" v-model="teamName" placeholder="Team Name"><br>
              <br>
              <label class="myLabel">Sport:</label>
              <br>
              <select-sport :initialSport="selectedSport" style="display: inline-block;" @sportWasSelected="selectedSport=$event"></select-sport>
              <h1></h1>
            </div>

            <div slot="playerPage2">
              <h4>Step 2</h4>
              <label class="myLabel">Team ID:</label>
              <input type="text" v-model="teamID" placeholder="Team ID"><br>
              <br>
              <label class="myLabel">Team Token:</label>
              <input type="text" v-model="teamToken" placeholder="Team Token"><br>
              <br>
            </div>
          </vue-good-wizard>
      </div>

      <div id="TeamWizard" v-if="viewMode==='isCreatingTeam'" class="teamWiz">
        <vue-good-wizard
          :steps="teamSteps"
          :onNext="nextClickedTeam"
          :onBack="backClickedTeam">

          <div slot="teamPage1">
            <label class="myLabel">Team Name:</label>
            <input type="text" v-model="teamName" placeholder="Team Name"><br>
            <br>
            <label class="myLabel">Sport:</label>
            <br>
            <select-sport :initialSport="selectedSport" style="display: inline-block;" @sportWasSelected="selectedSport=$event"></select-sport>
            <h1></h1>
          </div>

          <div slot="teamPage2">
            <h4>Add Players</h4>
            <player-selection-box @playerInfo="setPlayerInfo"></player-selection-box>
          </div>

          <div slot="teamPage3">
            <h4>Step 3</h4>
            <label class="myLabel">Team ID:</label>
            <input type="text" v-model="teamID" placeholder="Team ID"><br>
            <br>
            <label class="myLabel">Team Token:</label>
            <input type="text" v-model="teamToken" placeholder="Team Token"><br>
            <br>
          </div>
        </vue-good-wizard>
      </div>
    </div>
    <!-- END WIZARDS -->
    <game-view v-if="viewMode==='isInGameView'"
               @GameViewClose="viewMode='mainViewMode'">
    </game-view>
    <team-settings v-if="viewMode==='teamSettingsView'"
                   @TeamSettingsClose="viewMode='mainViewMode'">
    </team-settings>
    <team-stats v-if="viewMode==='teamStatsView'"
                   @TeamStatsClose="viewMode='mainViewMode'">
    </team-stats>
    <player-detail-view v-if="viewMode==='playerDetailView'"
                   @PlayerDetailViewClose="viewMode='mainViewMode'">
    </player-detail-view>
  </div>
</template>

<script>
import firebase from 'firebase'

export default {
  name: 'Main',
  data () {
    return {
      msg: 'Welcome to Your Vue.js App',
      loggedInUser: '',
      currentUserEmail: '',
      teamName: '',
      teamToken: '',
      teamID: '',
      playerName: '',
      activeGameId: '',
      selectedSport: 'basketball',
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
      players: []
    }
  },
  mounted () {
    this.$nextTick(() => {
        this.loggedInUser = firebase.auth().currentUser;
        this.currentUserEmail = this.loggedInUser.email;
        this.teamID = "team2";
        this.getGames();
        this.getPlayers();
        this.getSportfolios();
    });
  },
  methods: {
    sendStuffToDB: function() {
      console.log("SUBMIT TO DB");
      firebase.database().ref('Users/').child('tkdailey11@gmailcom').child('AdminTeams').update({
        "team1" : "qeguqer"
      });
    },
    logout: function() {
      firebase.auth().signOut().then(() => {
        this.$router.replace('login')
      })
    },
    openNav: function() {
      document.getElementById("mySidenav").style.width = "250px";
    },
    showTeam: function() {
      this.viewMode = 'isCreatingTeam'
    },
    hideCreating: function() {
      this.viewMode = 'mainViewMode'
    },
    showPlayer: function() {
      this.viewMode = 'isCreatingPlayer'
    },
    onComplete: function() {
      alert('Yay. Done!');
    },
    nextClickedPlayer(currentPage) {
      if(currentPage==1){
        this.hideCreating()

        //build up json for database
        console.log('**************************************');
        console.log('TeamID: ' + this.teamID);
        console.log('TeamToken: ' + this.teamToken);
        console.log('Sport: ' + this.selectedSport);
        console.log('TeamName: ' + this.teamName);
        console.log('**************************************');

        this.teamID = '';
        this.teamToken = '';
        this.selectedSport = 'basketball';
        this.teamName = '';
      }
      return true; //return false if you want to prevent moving to next page
    },
    backClickedPlayer(currentPage) {
      return false; //return false if you want to prevent moving to previous page
    },
    nextClickedTeam(currentPage) {
      if(currentPage==2){
        this.hideCreating()

        var email = this.currentUserEmail.replace('.', '');
        var nam = this.teamName;
        var tok = this.teamToken;
        var teamData = {
            "Admins" : {
              [email] : 'admin1'
            },
            "Creator" : email,
            "TeamName" : nam,
            "Token" : tok
        }

        var s = this.sportfolios.splice(-1)[0];
        var playerObj = {};
        s.forEach( function (player)
        {
          var key = 'p' + player.num;
          if(player.name==='') {
            playerObj[key] = ' ';
          }
          else {
            playerObj[key] = player.name;
          }
        });
        teamData.Players = playerObj;

        var id = this.teamID;
        firebase.database().ref('TeamSportfolios/').update({
          [id] : teamData
        });

        this.teamID = '';
        this.teamToken = '';
        this.selectedSport = 'basketball';
        this.teamName = '';
      }
      return true; //return false if you want to prevent moving to next page
    },
    backClickedTeam(currentPage) {
      return false; //return false if you want to prevent moving to previous page
    },
    setPlayerInfo(event) {
      this.sportfolios.push(event);
    },
    editTeamSettings() {
      this.viewMode = 'teamSettingsView';
      console.log("EDIT TEAM SETTINGS");
    },
    viewTeamStats() {
      this.viewMode = 'teamStatsView';
      console.log("VIEW TEAM STATS");
    },
    //inGameView() {
      //this.viewMode = 'isInGameView';
      //console.log("In Game View");
    //},
    viewPlayerInfo() {
      this.viewMode = 'playerDetailView';
      console.log("View PLAYER INFO");
    },
    //<!-- CHANGE THIS -->
    getGames() {
      var teamIDList = [];
      var email = this.currentUserEmail.replace('.', '');
      var self = this;
      var userTeamIDList = firebase.database().ref('/Users/' + email + '/AdminTeams/')
      if(typeof userTeamIDList !== 'undefined') {
        userTeamIDList.on('value', function(snapshot) {
          var obj2 = snapshot.val();
          if(obj2) {
            teamIDList = Object.keys(obj2); // Has all the team IDs that email is admin for

            var keysList = [];
            self.gamesList = [];

            teamIDList.forEach(function(id) {
              var gamesListRef = firebase.database().ref('/TeamSportfolios/' + id + '/Games/');
              if (typeof gamesListRef !== 'undefined') {
                gamesListRef.on('value', function(snapshot) {
                  var obj = snapshot.val();
                  if (obj) {
                    keysList = Object.keys(obj);
                    if(typeof keysList !== 'undefined' && keysList.length > 0){
                      var gamesRef = firebase.database().ref('/SoccerGames/');
                      //self.gamesList = [];
                      keysList.forEach(function(key) {
                        self.gamesList.push(key);
                      });
                    }
                  }
                });
              }
            });
          }
        });
      }
    },
    getPlayers() {
      var id = this.teamID;
      var self = this;
      var playersRef = firebase.database().ref('/TeamSportfolios/' + id + '/Players/');
      playersRef.on('value', function(snapshot) {
        var obj = snapshot.val();
        if(obj){
          self.players = obj;
        }
      });
    },
    showModal () {
      this.$modal.show('new-player');
    },
    hideModal (event) {
      console.log('Hide Modal');
      console.log(event);
      var id = this.teamID;
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
      var id = this.teamID;
      var keysList = [];
      var self = this;

      var email = this.currentUserEmail.replace('.', '');
      var sportfoliosListRef = firebase.database().ref('/Users/' + email + '/AdminTeams/');
      sportfoliosListRef.on('value', function(snapshot) {
        var obj = snapshot.val();
        keysList = Object.keys(obj);
        var sportfoliosRef = firebase.database().ref('/TeamSportfolios');
        self.sportfolios = [];
        keysList.forEach(function(key) {
          sportfoliosRef.child(key).once('value', function(snap) {
            self.sportfolios.push(snap.val());
          })
        });
      });
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
  .main {
      transition: margin-left .5s;
      margin:0px;
      min-height: 100%;
  }

  /* On smaller screens, where height is less than 450px, change the style of the sidenav (less padding and a smaller font size) */
  @media screen and (max-height: 450px) {
      .sidenav {padding-top: 15px;}
      .sidenav a {font-size: 18px;}
  }

  .glyphicon-menu-hamburger {
    size: 50px;
  }

  .myLabel {
    display: inline-block;
    width: auto;
    text-align: right;
    padding-right: 30px;
  }

  .sportColor {
    background-color: blue;
  }

  .sportSelect {
    width: 210px;
    height: 97px;
    display: inline-block;
  }
  button {
    margin-top: 20px;
    cursor: pointer;
    color: white;
    background-color: rgb(180, 41, 102);
    border-color: rgb(180, 41, 102);
    color: rgba(250, 220, 127, 0.9);
  }
  button:hover {
    background-color: rgba(250, 220, 127, 0.9);
    border-color: rgba(250, 220, 127, 0.9);
    color: rgb(180, 41, 102);
  }
  .wizard-tab-content {
    display: flex; // to avoid horizontal scroll when animating
    .wizard-tab-container {
      display: block;
      animation: fadeInRight 0.3s;
    }
  }

  .mainHeader {
    width: 100%;
    height: 10%;
    min-height: 100px;
    max-height: 100px;
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
    width: inherit;
    white-space: nowrap;
    margin-top: 18px;
    margin-right: 20px;
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

  }

  .teamWiz {
  }


  #mainPage {
    height: 100vh;
background: radial-gradient(circle, rgba(240,138,59,0.7) 0%, rgba(246,113,78,0.7) 53%, rgba(237,108,73,0.7) 77%);
background-color: white;
  }

  #leftList {

  }
  #rightList {

  }

</style>
