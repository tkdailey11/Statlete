<template>
  <div class="main">
    <div class="main_Nav">
      <new-player @newPlayerAdded="hideModal" />
      <ngmodal
        v-show="isModalVisible"
        @close="closeNGModal()"
      />
      <nav-component />
    </div>
    <div class="main_Other">
      <div id="mainPage">
        <div class="mainHeader">
          <h1 class="mainH1">{{selectedTeamName}}</h1>
        </div>
        <div class="mainBody">
          <div class="list-wrapper">
            <games-list class="mbgl"
                        @gameSelected="gameSelected"
                        @AddGame="showNGModal"
                        @NewGame="addGame(ngData)">
            </games-list>
            <players-list class="mbpl"
                          @playerSelected="viewPlayerInfo"
                          @addPlayerClicked="showModal('new-player')"
                          :players="players">
            </players-list>
          </div>
          <div class="button-wrapper">
            <button @click="editTeamSettings" class="btn btn-outline-primary main_button">Edit Team Settings</button>
            <button @click="viewTeamStats" class="btn btn-outline-primary main_button">View Team Stats</button>
            <button @click="goToAnalysis" class="btn btn-outline-primary main_button">Go to Analysis Page</button>
            <button @click="goToPdf" class="btn btn-outline-primary main_button">Export Stats to PDF</button>
            <button @click="goToGoals" class="btn btn-outline-primary main_button">View/Edit Goals</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import firebase from 'firebase';
import { mapGetters, mapMutations } from 'vuex';
import NewGame from '../MainPageTP/NewGame.vue';
import ngmodal from '../NewGameModal.vue';

export default {
  name: 'Main',
  components: {
    ngmodal,
  },
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
      basketballPlayerStats: 'statStore/basketballPlayerStats',
      gamesList: 'mainStore/gamesList'
    })
  },
  data () {
    return {
      sportfolios: [],
      teamName: '',
      teamToken: '',
      isModalVisible: false,
      darkModeEnabled: true
    }
  },
  mounted () {
    this.SET_LOGGED_IN_USER(firebase.auth().currentUser);
    var self = this;
    firebase.database().ref('/Users').child(firebase.auth().currentUser.email.replace('.', '')).child('Name').once('value', function(snapshot){
      self.SET_CURRENT_USER_NAME(snapshot.val())
    })
    this.getGamesTeam();
    this.getPlayers();
    this.getSportfolios();
    firebase.database().ref('/Users').child(firebase.auth().currentUser.email.replace('.', '')).child('DarkModeEnabled').once('value', function(snap){
      self.darkModeEnabled = (snap.val() == 1)
    })
  },
  methods: {
    ...mapMutations({
      SET_LOGGED_IN_USER: 'mainStore/SET_LOGGED_IN_USER',
      SET_ACTIVE_GAME_ID: 'mainStore/SET_ACTIVE_GAME_ID',
      SET_SELECTED_TEAM_ID: 'mainStore/SET_SELECTED_TEAM_ID',
      SET_PLAYERS: 'mainStore/SET_PLAYERS',
      SET_GAMES_LIST: 'mainStore/SET_GAMES_LIST',
      SET_CURRENT_USER_NAME: 'mainStore/SET_CURRENT_USER_NAME',
      SET_DARK_MODE: 'mainStore/SET_DARK_MODE'
    }),
    themeChanged(){
      this.SET_DARK_MODE(this.darkModeEnabled)
      var self = this;
      var value = 0;
      if(this.darkModeEnabled){
        value = 1;
      }
      firebase.database().ref('/Users').child(self.currentUserEmail.replace('.', '')).update({
        'DarkModeEnabled': value
      })
    },
    showNGModal() {
      this.isModalVisible = true;
    },
    closeNGModal() {
      this.isModalVisible = false;
    },
    addGameClicked: function() {
      //this.showModal('new-game');
      
 
      this.$modal.show(NewGame, {
        text: 'This text is passed as a property'
      }, {
        draggable: true
      })
    },
    goToAnalysis: function(event) {
      this.$router.push('/analysis');
    },
    goToPdf: function(event) {
      this.$router.push('/exportstats')
    },
    goToGoals: function(event) {
      this.$router.push('/goals')
    },
    gameSelected: function(event) {
      this.SET_ACTIVE_GAME_ID(this.gamesList[event - 1]);
      if(this.selectedTeamSport == 2){
        this.$router.push('/football');
      }
      else{
        this.$router.push('/gameview');
      }
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
      this.$modal.show(name, {
        title: 'Alert!',
        text: 'You are too awesome',
        buttons: [
          {
            title: 'Submit',       // Button title
            default: true,    // Will be triggered by default if 'Enter' pressed.
            handler: () => {
              alert('Submit clicked')
            } // Button click handler
          }
        ]
      });
    },
    hideGameModal (event) {
      this.addGame(event)
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
      console.log('New Game:')
      console.log(ngData)
      var gameCount = this.gamesList.length + 1;
      var gameCountStr = gameCount + '';
      if(gameCount < 10){
        gameCountStr = '0' + gameCount;
      }
      var gameID = this.selectedTeamId + '-' + gameCountStr;
      var oppData = [];
      var myData = [];
      var isSoccer = this.selectedTeamSport == 1
      var isBball = this.selectedTeamSport == 0
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
        "OpponentsTotals" : oppData,
        "Period" : 1,
        "ViewableWithTeamCode" : ngData.TeamCode,
        "OpposingTeamName" : ngData.Opponent,
        "ShotChartEnabled" : ngData.SCEnabled
      }

      if(isBball){
        var playerData = {}
        Object.keys(this.players).forEach((player) => {
          playerData[player] = this.basketballPlayerStats
        })
        data['Players'] = playerData
      }

      if(isSoccer) {
        data['HalfLength'] = periodLength;
        data['PeriodStartTime'] = -1;
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
        data['Shots'] = " "
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
  .main_Other {
    height: 100vh;
    overflow: scroll;
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
  .main {
      transition: margin-left .5s;
      margin: 0px;
      min-height: 100vh;
  }
  .main_button {
    cursor: pointer;
    height: 50px;
    max-height: 50px;
    margin-right: 15px;
    margin-bottom: 15px;
    width: 175px;
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
    flex-basis: 33%;
    padding: 30px 15px 15px 20px;
  }

  .list-wrapper {
    flex-basis: 67%;
    padding: 25px;
    display: flex;
    max-height: 75vh;
  }

  .mbgl{
    flex-basis: 50%;
    min-width: 200px;
    margin-right: 30px;
    max-height: 70vh;
  }

  .mbpl{
    flex-basis: 50%;
    min-width: 200px;
    max-height: 70vh;
  }

  .mainHeader h1 {
    width: 100%;
    font-size: 70px;
    max-height: 100px;
    white-space: nowrap;
    text-align: left;
  }

  .mainBody {
    width: 100%;
    display: flex;
    flex-wrap: wrap;
    align-items: stretch;
  }

  #mainPage {
    height: 100vh;
    overflow-y: scroll;
  }

  .mainH1 {
    margin: 25px 50px 50px 50px;
  }

  .main-toggle {
    float: right;
    margin: 50px;
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

    .mbgl{
      width: 80%;
      margin-left: 3%;
      margin-bottom: 5%;
    }

    .mbpl{
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

</style>
