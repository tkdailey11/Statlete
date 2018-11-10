<template>
  <div class="main">
    <new-player @newPlayerAdded="hideModal" />
    <new-game @NewGame="hideGameModal"/>
    <nav-component />

    <div id="notImplementedAlert" class="alert alert-primary alert-dismissible fade show" role="alert">
      <p>This functionality has not yet been implemented. Please check back soon!</p>
      <button type="button" class="close" data-dismiss="alert" aria-label="Close" style="margin: 7px; background-color: transparent;">
        <span aria-hidden="true">&times;</span>
      </button>
    </div>

    <div id="mainPage">
      <div class="mainHeader">
        <h1 class="mainH1">{{selectedTeamName}}</h1>
      </div>
      <div class="mainBody">
        <games-list style="margin-top: 20px;"
                    @gameSelected="gameSelected"
                    @AddGame="addGameClicked"
                    @NewGame="addGame(ngData)">
        </games-list>
        <players-list style="margin-top: 20px;"
                      @playerSelected="viewPlayerInfo"
                      @addPlayerClicked="showModal('new-player')"
                      :players="players">
        </players-list>
        <div class="button-wrapper">
          <button @click="editTeamSettings" class="btn btn-outline-primary main_button">Edit Team Settings</button>
          <button @click="viewTeamStats" class="btn btn-outline-primary main_button">View Team Stats</button>
          <button @click="goToAnalysis" class="btn btn-outline-primary main_button">Go to Analysis Page</button>
          <button @click="goToPdf" class="btn btn-outline-primary main_button">Export Stats to PDF</button>
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
      selectedTeamSport: 'mainStore/selectedTeamSport',
      currentUserEmail: 'mainStore/currentUserEmail',
      activeGameId: 'mainStore/activeGameId',
      players: 'mainStore/players',
      soccerStats: 'statStore/soccerStats',
      basketballStats: 'statStore/basketballStats',
      gamesList: 'mainStore/gamesList'
    })
  },
  data () {
    return {
      sportfolios: [],
      teamName: '',
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
    this.SET_LOGGED_IN_USER(firebase.auth().currentUser);
    this.getGamesTeam();
    this.getPlayers();
    this.getSportfolios();
  },
  methods: {
    ...mapMutations({
      SET_LOGGED_IN_USER: 'mainStore/SET_LOGGED_IN_USER',
      SET_ACTIVE_GAME_ID: 'mainStore/SET_ACTIVE_GAME_ID',
      SET_SELECTED_TEAM_ID: 'mainStore/SET_SELECTED_TEAM_ID',
      SET_PLAYERS: 'mainStore/SET_PLAYERS',
      SET_GAMES_LIST: 'mainStore/SET_GAMES_LIST'
    }),
    addGameClicked: function() {
      this.showModal('new-game');
    },
    goToAnalysis: function(event) {
      this.$router.push('/analysis');
    },
    goToPdf: function(event) {
      this.$router.push('/exportstats')
    },
    gameSelected: function(event) {
      this.SET_ACTIVE_GAME_ID(this.gamesList[event - 1]);
      this.$router.push('/gameview');
    },
    editTeamSettings() {
      this.$router.push('/teamsettings');
    },
    viewTeamStats() {
      this.$router.push('/teamstats')
    },
    viewPlayerInfo() {
      console.log("View PLAYER INFO");
    },
    getGamesTeam() {
      var email = this.currentUserEmail.replace('.', '');
      var self = this;

      var keysList = [];
      var gamesListRef = firebase.database().ref('/TeamSportfolios/' + self.selectedTeamId + '/Games/');
      if (typeof gamesListRef !== 'undefined') {
        gamesListRef.on('value', function(snapshot) {
          var obj = snapshot.val();
          if (obj) {
            self.SET_GAMES_LIST(Object.keys(obj));
          }
        })
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
          console.log('*** Players: ')
          console.log(obj)
          console.log('*********')
        }
      });
    },
    showModal (name) {
      this.$modal.show(name);
    },
    hideGameModal (event) {
      console.log("NEW GAME: ")
      console.log(event)
      console.log('----------')
      this.$modal.hide('new-game')
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
        //self.SET_SELECTED_TEAM_ID(keysList[0]);
        var sportfoliosRef = firebase.database().ref('/TeamSportfolios');
        self.sportfolios = [];
        keysList.forEach(function(key) {
          sportfoliosRef.child(key).once('value', function(snap) {
            self.sportfolios.push(snap.val());
          })
        })
      })
    },
    addGame(ngData) {
      var gameCount = this.gamesList.length + 1;
      var gameCountStr = gameCount + '';
      if(gameCount < 10){
        gameCountStr = '0' + gameCount;
      }
      var gameID = this.selectedTeamId + '-' + gameCountStr;
      var oppData = [];
      var myData = [];
      var isSoccer = this.selectedTeamSport == 1
      var periodLength = ngData.PeriodLength;

      // SCEnabled: this.scEnabled,

      if(isSoccer){
        oppData = {
            "Period1" : this.soccerStats,
            "Period2" : this.soccerStats,
            "Possession" : 0
        };
      }
      else {
        if(ngData.NumPeriods == 2){
          oppData = {
            "Period1" : this.basketballStats,
            "Period2" : this.basketballStats
          };
        }
        else{
          oppData = {
            "Period1" : this.basketballStats,
            "Period2" : this.basketballStats,
            "Period3" : this.basketballStats,
            "Period4" : this.basketballStats
          };
        }
        
      }
      

      if(isSoccer){
        myData = {
            "Period1" : this.soccerStats,
            "Period2" : this.soccerStats,
            "Possession" : 0
        };
      }
      else {
        if(ngData.NumPeriods == 2){
          myData = {
            "Period1" : this.basketballStats,
            "Period2" : this.basketballStats
          };
        }
        else {
          myData = {
            "Period1" : this.basketballStats,
            "Period2" : this.basketballStats,
            "Period3" : this.basketballStats,
            "Period4" : this.basketballStats
          };
        }
        
      }
      var d = new Date();
      var dateStr = d.toJSON().substring(0,10);
      
      var data = {
        "Date" : dateStr,
        "InProgress" : false,
        "Live" : true,
        "MyTotals" : myData,
        "Name" : gameID,
        "OpponentsTotals" : oppData,
        "Period" : 1,
        "PeriodStartTime" : -1,
        "ViewableWithTeamCode" : ngData.TeamCode,
        "OpposingTeamName" : ngData.Opponent,
        "ShotChartEnabled" : ngData.ShotChartEnabled
      }

      if(isSoccer) {
        data['HalfLength'] = periodLength;
        var ref = firebase.database().ref('SoccerGames').child(this.selectedTeamId).update({
          [gameID] : data
        })
        var ref = firebase.database().ref('TeamSportfolios').child(this.selectedTeamId).child('Games').update({
          [gameID] : 'soccer'
        })
      }
      else {
        data['PeriodLength'] = periodLength;
        data['NumberOfPeriods'] = ngData.NumPeriods;
        data['TimeClockStarted'] = " "
        data['TimeRemainingInPeriod'] = periodLength * 60
        var ref = firebase.database().ref('BasketballGames').child(this.selectedTeamId).update({
          [gameID] : data
        })
        var ref = firebase.database().ref('TeamSportfolios').child(this.selectedTeamId).child('Games').update({
          [gameID] : 'basketball'
        })
      }
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

  /* Style page content - use this if you want to push the page content to the right when you open the side navigation */
  .main {
      transition: margin-left .5s;
      margin:0px;
      min-height: 100%;
  }
  .main_button {
    margin-top: 20px;
    cursor: pointer;
    height: 50px;
    max-height: 50px;
    margin: 50px;
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
  }

  #mainPage {
    min-height: 100vh;
  }

  .mainH1 {
    margin: 25px 50px 50px 50px;
  }
</style>