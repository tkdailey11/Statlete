<template>
  <div class="main">
    <statlete-navbar v-if="!(viewMode==='isCreatingTeam' || viewMode==='isCreatingPlayer')"
                     @shouldOpenNav="openNav"
                     @shouldLogout="logout"></statlete-navbar>
    <h1>{{ selectedSport }}</h1>
    <div id="mainPage" v-if="viewMode==='mainViewMode'">
      <div id="mySidenav" class="sidenav">
        <a href="javascript:void(0)" class="closebtn" @click="closeNav">&times;</a>
        <img src="../assets/images/testUser.png" width="100px" height="100px">
        <a href="#">About</a>
        <a href="#">Services</a>
        <a href="#">Clients</a>
        <a href="#">Contact</a>
        <button @click="showPlayer" class="sportButton">New Player Account</button><br>
        <button @click="showTeam" class="sportButton">New Team Account</button><br>
        <div style="scroll">
            <button style="background-color: white; width: 150px;" v-for="i in sportfolios.length">Test {{ i }}</button>
        </div>
      </div>

      <h1>{{ loggedInUser.email }}</h1>
      <br>
      <games-list :games="gamesList"
                  style="float: left; margin: 0px 50px 50px 150px;"
                  @gameSelected="viewMode='isInGameView'"></games-list>
      <players-list style="float: left; margin: 0px 50px 50px 50px;"
                    @playerSelected="viewPlayerInfo"></players-list>

      <div style="float: left;">
        <button @click="editTeamSettings" class="sportButton">Edit Team Settings</button><br>
        <button @click="viewTeamStats" class="sportButton">View Team Stats</button><br>
      </div>
    </div>
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

      <div id="TeamWizard" v-if="viewMode==='isCreatingTeam'" style="padding-top=100px;">
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
      gamesList: [{gameID: 'game-a'}, {gameID: 'game-b'}]
    }
  },
  mounted () {
    this.$nextTick(() => {
        this.loggedInUser = firebase.auth().currentUser;
        this.currentUserEmail = this.loggedInUser.email;
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
    closeNav: function() {
      document.getElementById("mySidenav").style.width = "0";
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
        console.log(s);
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
        console.log(playerObj);
        teamData.Players = playerObj;

        var id = this.teamID;
        firebase.database().ref('TeamSportfolios/').update({
          [id] : teamData
        });


        /*
        //build up json for database
        console.log('**************************************');
        console.log('TeamID: ' + this.teamID);
        console.log('TeamToken: ' + this.teamToken);
        console.log('Players: ');
        var s = this.sportfolios.splice(-1)[0];
        console.log(s);
        console.log('Sport: ' + this.selectedSport);
        console.log('TeamName: ' + this.teamName);
        console.log('**************************************');
        */

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
    viewPlayerInfo() {
      this.viewMode = 'playerDetailView';
      console.log("View PLAYER INFO");
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
  .sportButton {
    background-color: red;
    color: white;
    width: 150px;
    margin: 30px 30px 30px 0px;
    border-radius: 50px;
  }
  .selectedButton {
    background-color: rgb(0, 0, 255);
    width: 200px;
    color: rgb(255,255,255);
  }

  .wizard-tab-content {
    display: flex; // to avoid horizontal scroll when animating
    .wizard-tab-container {
      display: block;
      animation: fadeInRight 0.3s;
    }
  }
</style>
