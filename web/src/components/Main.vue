<template>
  <div class="main">
    <p>Value: {{ testVal }}</p>
    <new-player @newPlayerAdded="hideModal" />
    <statlete-navbar v-if="!(viewMode==='isCreatingTeam' || viewMode==='isCreatingPlayer')"
                     @shouldOpenNav="openNav"
                     @shouldLogout="logout"
                     @GoBackClicked="hideCreating"></statlete-navbar>

    <side-nav id="mySidenav"
              @showPlayer="showPlayer"
              @showTeam="showTeam"
              @teamSelected="teamSelected">
    </side-nav>

    <div id="notImplementedAlert" class="alert alert-primary alert-dismissible fade show" role="alert">
      <p>This functionality has not yet been implemented. Please check back soon!</p>
      <button type="button" class="close" data-dismiss="alert" aria-label="Close" style="margin: 7px; background-color: transparent;">
        <span aria-hidden="true">&times;</span>
      </button>
    </div>

    <div id="mainPage" v-if="viewMode==='mainViewMode'">
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
    <!-- WIZARDS -->
    <div v-if="viewMode==='isCreatingPlayer' || viewMode==='isCreatingTeam'" class="WizardsDiv">
      <div id="PlayerWizard" v-if="viewMode==='isCreatingPlayer'" style="padding-top=100px min-height: 100vh;">
          <tkd-wizard
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
          </tkd-wizard>
      </div>

      <div id="TeamWizard" v-if="viewMode==='isCreatingTeam'" class="teamWiz">
        <h1 style="color: rgb(242,209,24); margin-bottom: 50px;">Create a New Team Sportfolio</h1>
        <tkd-wizard
          :steps="teamSteps"
          :onBack="backClickedTeam"
          @SubmitSportfolio="submitTeamSportfolio"
          @SetDefaultPid="setPid">

          <div slot="teamPage1">
            <label class="myLabel">Team Name:</label>
            <input class="teamNameEntry" type="text" v-model="teamName" placeholder="Team Name">

            <div class="SportSelector">
              <label class="mySportLabel" for="sportSelector">Sport:</label>
              <select-sport id="sportSelector" :initialSport="selectedSport" style="display: inline-block;" @sportWasSelected="selectedSport=$event"></select-sport>
            </div>
          </div>

          <div slot="teamPage2">
            <h4>Add Players</h4>
            <player-selection-box @playerInfo="setPlayerInfo"
                                  :sport="selectedSport"></player-selection-box>
          </div>

          <div slot="teamPage3">
            <div class="step3Body">
              <label class="myLabel">Team ID:</label>
              <input class="teamIdEntry" type="text" v-model="teamID" placeholder="Team ID"><br>
              <br>
              <label class="myLabel">Team Token:</label>
              <input class="teamTokenEntry" type="text" v-model="teamToken" placeholder="Team Token"><br>
              <br>
            </div>
          </div>
        </tkd-wizard>
      </div>
    </div>
    <!-- END WIZARDS -->
    <!--<game-view v-if="viewMode==='isInGameView'"
               @GameViewClose="viewMode='mainViewMode'"
               :gameID="activeGameId"
               :players="players">
    </game-view>-->
    <!--
    <team-settings v-if="viewMode==='teamSettingsView'"
                   @TeamSettingsClose="viewMode='mainViewMode'"
                   :id="selectedTeamId"
                   :tok="selectedTeamToken">
    </team-settings>
    -->
    <!--
    <team-stats v-if="viewMode==='teamStatsView'"
                   @TeamStatsClose="viewMode='mainViewMode'">
    </team-stats>
    -->
    <!--
    <player-detail-view v-if="viewMode==='playerDetailView'"
                   @PlayerDetailViewClose="viewMode='mainViewMode'">
    </player-detail-view>
    -->
  </div>
</template>

<script>
import firebase from 'firebase'

export default {
  name: 'Main',
  computed: {
    testVal: {
      get() {
        return this.$store.state.value;
      }
    }
  },
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
      selectedTeamId: '',
      selectedTeamName: '',
      selectedTeamToken: '',
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
    jQuery("#notImplementedAlert").hide();
    var niMsg = jQuery("#notImplementedAlert");

    niMsg.on("close.bs.alert", function () {
          niMsg.hide();
          return false;
    });
    this.$nextTick(() => {
        this.loggedInUser = firebase.auth().currentUser;
        this.currentUserEmail = this.loggedInUser.email;
        this.getGames();
        this.getSportfolios();
        console.log("NEXT TICK");
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
      setTimeout(function(){
        document.getElementById("mySidenav").style.width = "250px";
      }, 90);

    },
    showTeam: function() {
      this.viewMode = 'isCreatingTeam'
    },
    teamSelected: function(event) {
      this.selectedTeamId = event.Id;
      this.selectedTeamName = event.Name;
      this.selectedTeamToken = event.Token;
      this.getGames();
      this.getPlayers();
    },
    hideCreating: function() {
      this.viewMode = 'mainViewMode'
    },
    showPlayer: function() {
      jQuery("#notImplementedAlert").show();
      console.log("ALERT");
      //this.viewMode = 'isCreatingPlayer'
    },
    gameSelected: function(event) {
      this.activeGameId = this.gamesList[event - 1];
      this.viewMode='isInGameView';
      this.$router.push('/gameview');
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
    submitTeamSportfolio(){
      this.hideCreating();

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

      firebase.database().ref('Users/' + email + '/AdminTeams').update({
        [this.teamID] : " "
      });

      this.teamID = '';
      this.teamToken = '';
      this.selectedSport = 'basketball';
      this.teamName = '';
    },
    backClickedTeam(currentPage) {
      return false; //return false if you want to prevent moving to previous page
    },
    setPlayerInfo(event) {
      console.log('[[[[[[[ SET PLAYER INFO ]]]]]]]');
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
        console.log('IN GET GAMES');
        var keysList = [];
        self.gamesList = [];
          var gamesListRef = firebase.database().ref('/TeamSportfolios/' + self.selectedTeamId + '/Games/');
          if (typeof gamesListRef !== 'undefined') {
            gamesListRef.on('value', function(snapshot) {
              var obj = snapshot.val();
              if (obj) {
                self.gamesList = Object.keys(obj);
                // if(typeof keysList !== 'undefined' && keysList.length > 0){
                //   var gamesRef = firebase.database().ref('/SoccerGames/');
                //   self.gamesList = [];
                //   keysList.forEach(function(key) {
                //     if(!self.gamesList[key])
                //     {
                //       self.gamesList.push(key);
                //     }
                //   });
                // }
              }
            });
          }
    },
    getPlayers() {
      var id = this.selectedTeamId;
      var self = this;
      self.players = [];
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
      console.log('^^^^^^^^');
      var email = this.currentUserEmail.replace('.', '');
      var sportfoliosListRef = firebase.database().ref('/Users/' + email + '/AdminTeams/');
      sportfoliosListRef.on('value', function(snapshot) {
        var obj = snapshot.val();
        keysList = Object.keys(obj);
        self.selectedTeamId = keysList[0];
        self.getGames();
        self.getPlayers();
        var sportfoliosRef = firebase.database().ref('/TeamSportfolios');
        self.sportfolios = [];
        keysList.forEach(function(key) {
          sportfoliosRef.child(key).once('value', function(snap) {
            self.sportfolios.push(snap.val());
          })
        })
      })
    },
    setPid() {
      this.teamID = this.teamName + '_' + Math.random().toString(36).substring(2,7);
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
    width: auto;
    text-align: right;
    padding-right: 30px;
  }

  .mySportLabel {
    margin: 0px 40px 0px 0px;
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

  .teamWiz {
    margin-top: 50px;
  }

  .myButton {
    height: 50px;
    max-height: 50px;
    margin: 50px;
  }
  .WizardsDiv {
    height: 100vh;
    min-height: 100vh;
    background-color: transparent;
  }
  .teamNameEntry {
    border: none;
    margin-bottom: 10px;
    border-bottom: 2px rgb(252,102,0) solid;
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

  .SportSelector {
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
