<template>
  <div class="main">
    <nav-component @ChangeColor="changeColor" />
    <v-content>
      <new-player @newPlayerAdded="hideModal" />
      <player-detail-view @close="hideModalDetail" :playerID="playerIDProp" :playerData="testArr" />
      <ngmodal
        v-show="isModalVisible"
        @NewGame="addGame"
        @close="closeNGModal()" 
        />
      <colorModal
        v-show="isColorModalVisible"
        @close="closeColorModal()"
        @SubmitColors="submitColors"
      />
      <div id="mainPage">

        <div class="mainHeader">
          <h1 class="mainH1">{{selectedTeamName}}</h1>
        </div>
        <div class="mainBody">
          <div class="list-wrapper">
            <v-card dark style="margin-right: 1vw;" class="mbgl">
                <v-data-table
                  :headers="[{
                    text: 'Games',
                    align: 'center',
                    sortable: false,
                    value: 'name'
                  }]"
                  :items="v_gameslist"
                  class="elevation-1"
                >
                  <template slot="items" slot-scope="props">
                    <tr @click="gameSelected(props.item.name)">
                      <td>{{ props.item.name }}</td>
                    </tr>
                  </template>
                </v-data-table>
              <v-card-actions>
                <v-btn flat color="red" @click.stop="showNGModal">New Game</v-btn>
              </v-card-actions>
            </v-card>
            <v-card dark style="margin-left: 1vw;" class="mbpl">
                <v-data-table
                  :headers="[{
                    text: 'Players',
                    align: 'center',
                    sortable: false,
                    value: 'name'
                  }]"
                  :items="playersList"
                  class="elevation-1"
                >
                  <template slot="items" slot-scope="props">
                    <tr @click="viewPlayerInfo(props.item.name)">
                      <td>{{ props.item.name }}
                        <v-spacer style="width: 10px;" />
                        <v-dialog v-model="dialog" width="500">
                          <v-btn slot="activator" flat color="red" dark>View Stats</v-btn>
                          <v-card dark>
                            <v-card-title>
                              {{props.item.name}} Stats
                              <v-spacer></v-spacer>
                            </v-card-title>
                            <table style="width: 100%">
                                <thead>
                                  <th>Type</th>
                                  <th>Total</th>
                                </thead>
                                <tbody>
                                  <tr v-for="type in Object.keys(playerData[props.item.name.split(' ')[0].replace('#','p')])" :key="props.item.name.split(' ')[0].replace('#','p') + '-'+type">
                                    <td>{{type}}</td>
                                    <td>{{getVal(playerData[props.item.name.split(' ')[0].replace('#','p')][type])}}</td>
                                  </tr>
                                </tbody>
                            </table>
                          </v-card>
                        </v-dialog>
                      </td>
                    </tr>
                  </template>
                </v-data-table>
                <v-card-actions>
                  <v-btn flat color="red" @click.stop="showModal('new-player')">New Player</v-btn>
                </v-card-actions>
            </v-card>
          </div>
          <div class="button-wrapper">
            <v-card dark>
              <v-btn @click="editTeamSettings" dark class="myVbtn">Edit Team Settings</v-btn>
              <v-btn @click="viewTeamStats" dark class="myVbtn">View Team Stats</v-btn>
              <v-btn @click="goToAnalysis" dark class="myVbtn">Go to Analysis Page</v-btn>
              <v-btn @click="goToPdf" dark class="myVbtn">Export Stats to PDF</v-btn>
              <v-btn v-if="!isFootball" @click="goToGoals" dark class="myVbtn">View/Edit Goals</v-btn>
            </v-card>
          </div>
        </div>
      </div>
    </v-content>
  </div>
</template>

<script>
import firebase from 'firebase';
import { mapGetters, mapMutations } from 'vuex';
import NewGame from '../MainPageTP/NewGame.vue';
import ngmodal from '../NewGameModal.vue';
import colorModal from '../UploadColors.vue';
import { isNull, isNullOrUndefined } from 'util';

export default {
  name: 'Main',
  components: {
    ngmodal,
    colorModal
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
      gamesList: 'mainStore/gamesList',
      footballOffenseStats: 'statStore/footballOffenseStats',
      footballDefenseStats: 'footballStore/footballDefenseStats',
      footballSpecialStats: 'statStore/footballSpecialStats',
      footballAskStatlete: 'statStore/footballAskStatlete'
    }),
      
    isFootball: function(){
      return this.selectedTeamSport == 2
    }
  },
  data () {
    return {
      sportfolios: [],
      teamName: '',
      teamToken: '',
      isModalVisible: false,
      darkModeEnabled: true,
      isColorModalVisible: false,
      playersList: [],
      v_gameslist: [],
      playerIDProp: '',
      playerDataArray: [],
        testArr: [],
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
        msHeaders: [{
          text: 'Stat Type',
          align: 'left',
          sortable: false,
          value: 'type'
      },
      {
        text: 'Total',
        align: 'left',
        sortable: false,
        value: 'total'
      }],
    }
  },
      async created() {
      if(this.isSoccer){
        this.gameDataRef = firebase.database().ref('/SoccerGames/' + this.selectedTeamId);
      }
      else {
        this.statTypes = [
          "AST",
          "BLK",
          "DREB",
          "FG3A",
          "FG3M",
          "FG2A",
          "FG2M",
          "FTA",
          "FTM",
          "OREB",
          "PF",
          "STL",
          "TOV"
        ]
        this.gameDataRef = firebase.database().ref('/BasketballGames/' + this.selectedTeamId);
      }

      Object.keys(this.players).forEach(player => {
        if(!this.playerData[player]){
          this.playerData[player] = {}
        }
      })
      Object.keys(this.players).forEach(player => {
        this.statTypes.forEach(stat => {
          if(!this.playerData[player][stat]){
            this.playerData[player][stat] = 0
          }
        })
      })
      await this.refreshStats();
      this.testArr = []
      this.playerDataArray.forEach(player => {
        var tmp = {'value': false, 'name': player.name}
        var obj = player.data;
        Object.keys(obj).forEach(key => {
          tmp[key] = obj[key]
        })
        this.testArr.push(tmp)
      })
    },
  async mounted () {
    this.SET_LOGGED_IN_USER(firebase.auth().currentUser);
    var self = this;
    await firebase.database().ref('/Users').child(firebase.auth().currentUser.email.replace('.', '')).child('Name').once('value', function(snapshot){
      self.SET_CURRENT_USER_NAME(snapshot.val())
      self.getGamesTeam();
      self.getPlayers();
      self.getSportfolios();
    })
    
    this.getSportfolios();
  },
  methods: {
    ...mapMutations({
      SET_LOGGED_IN_USER: 'mainStore/SET_LOGGED_IN_USER',
      SET_ACTIVE_GAME_ID: 'mainStore/SET_ACTIVE_GAME_ID',
      SET_SELECTED_TEAM_ID: 'mainStore/SET_SELECTED_TEAM_ID',
      SET_PLAYERS: 'mainStore/SET_PLAYERS',
      SET_GAMES_LIST: 'mainStore/SET_GAMES_LIST',
      SET_CURRENT_USER_NAME: 'mainStore/SET_CURRENT_USER_NAME',
      SET_MY_COLOR: 'mainStore/SET_MY_COLOR',
      SET_OPP_COLOR: 'mainStore/SET_OPP_COLOR',
      SET_SECONDARY_COLOR: 'mainStore/SET_SECONDARY_COLOR'
    }),
    getVal(data){
      return (isNullOrUndefined(data) || isNaN(data)) ? 0 : data
    },
    getDataArr: function(idstr){
      var id = idstr.split(' ')[0].replace('#', 'p')
      var tableArr = []
      var obj = null
      var p3 = id.split(' ')[0].replace('#','p')
        for(var i = 0; i < this.playerData.length; i++){
          if(this.playerData[i].name === p3){
            obj = this.playerData[i]
            break;
          }
        }
        if(obj != null){
          var tArr = []
          delete obj['name']
          delete obj['value']
          Object.keys(obj).forEach(key => {
            tArr.push({'value': 'false', 'type': key, 'total': obj[key]})
          })
          tableArr = tArr
        }
        return tableArr
    },
          getPlayerArray: function(){
        var tmpArr = []
        Object.keys(this.playerData).forEach(player => {
          tmpArr.push({
            'name': player,
            'data': this.playerData[player]
          })
        })
        this.playerDataArray = tmpArr
      },
      refreshStats: async function() {
        var self = this;
        await self.gameDataRef.on('value', function(snap){
          Object.keys(self.playerData).forEach(pl => {
            Object.keys(self.playerData[pl]).forEach(stat => {
              self.playerData[pl][stat] = 0
            })
          })
          
          Object.keys(snap.val()).forEach(id => {
            var playersObj = snap.val()[id].Players;
            var playersArr = Object.keys(playersObj);
            playersArr.forEach(p => {
              var data = playersObj[p];
              Object.keys(data).forEach(playerStat => {
                self.playerData[p][playerStat] += parseInt(data[playerStat])
              })
            })
          })
        })
        self.getPlayerArray()
      },
    showNGModal() {
      this.isModalVisible = true;
    },
    closeNGModal() {
      this.isModalVisible = false;
    },
    changeColor: function() {
      this.isColorModalVisible = true
    },
    closeColorModal: function() {
      this.isColorModalVisible = false
    },
    submitColors: function(data){
      this.SET_MY_COLOR(data.myColor);
      this.SET_OPP_COLOR(data.oppColor);
      this.SET_SECONDARY_COLOR(data.secondaryColor)
      firebase.database().ref('TeamSportfolios').child(this.selectedTeamId).update({
        'MyColor': data.myColor,
        'OppColor': data.oppColor,
        'MySecondaryColor': data.secondaryColor
      })
      this.isColorModalVisible = false;
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
    gameSelected: function(id) {
      this.SET_ACTIVE_GAME_ID(id);
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
      if(this.selectedTeamSport == 2){
        this.$router.push('/teamstatsfootball')
      }
      else{
        this.$router.push('/teamstats')
      }
      
    },
    viewPlayerInfo(id) {
      this.playerIDProp = id

      this.$modal.show('player-detail-view')
    },
    async getGamesTeam() {
      var email = this.currentUserEmail.replace('.', '');
      var self = this;

      var keysList = [];
      var gamesListRef = firebase.database().ref('/TeamSportfolios/' + self.selectedTeamId + '/Games/');
      if (typeof gamesListRef !== 'undefined') {
        await gamesListRef.on('value', function(snapshot) {
          self.v_gameslist = []
          var obj = snapshot.val();
          if (obj) {
            self.SET_GAMES_LIST(Object.keys(obj));

            Object.keys(obj).forEach(game => {
              self.v_gameslist.push({value: false, name: game})
            })
          }
        })
      }
    },
    async getPlayers() {
      var id = this.selectedTeamId;
      var self = this;
      self.SET_PLAYERS([]);
      var playersRef = firebase.database().ref('/TeamSportfolios/' + id + '/Players/');
      await playersRef.on('value', function(snapshot) {
        var obj = snapshot.val();
        if(obj){
          self.SET_PLAYERS(obj);
        }
        self.playersList = []
        Object.keys(self.players).forEach(player => {
          self.playersList.push({value: false, name: player.replace('p', '#') + ' ' + self.players[player]})
        })
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
    hideModalDetail (event) {
      this.$modal.hide('player-detail-view')
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
    async getSportfolios() {
      var id = this.selectedTeamId;
      var keysList = [];
      var self = this;
      var email = this.currentUserEmail.replace('.', '');
      var sportfoliosListRef = firebase.database().ref('/Users/' + email + '/AdminTeams/');
      await sportfoliosListRef.on('value', function(snapshot) {
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
      if(this.gamesList.length == 1 && (this.gamesList[0] == 0 || this.gamesList[0].includes("02")))
      {
        gameCount = 1
      }
      var gameCountStr = gameCount + '';
      if(gameCount < 10){
        gameCountStr = '0' + gameCount;
      }
      var gameID = this.selectedTeamId + '-' + gameCountStr;
      var oppData = [];
      var myData = [];
      var teamId = this.selectedTeamId
      var isSoccer = this.selectedTeamSport == 1
      var isBball = this.selectedTeamSport == 0
      var periodLength = ngData.PeriodLength;
      if(this.selectedTeamSport == 2){
        var gameData = {}
        var self = this
        if(gameCount == 1)
        {
            firebase.database().ref('AskStatlete').update({
            [teamId]: self.footballAskStatlete
          })
        }
        gameData['Live'] = false
        gameData['OpposingTeamName'] = ngData.Opponent
        gameData['Plays'] = {
          'Period1': " ",
          'Period2': " ",
          'Period3': " ",
          'Period4': " "
        }
        gameData['Totals'] = {
          'Defense': this.footballDefenseStats,
          'Offense': this.footballOffenseStats,
          'Special': this.footballSpecialStats
        }
        firebase.database().ref('FootballGames').child(this.selectedTeamId).update({
          [gameID]: gameData
        })
        var newdate = new Date();
        var dString = newdate.toJSON().substring(0,10);
        var str = "vs " + ngData.Opponent + "|" + dString + "|0-0"
        firebase.database().ref('TeamSportfolios').child(this.selectedTeamId).child('Games').update({
          [gameID] : str
        })
        this.closeNGModal()
        return;
      }
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
      this.closeNGModal()
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
  /* .main_Other {
    height: 100vh;
    overflow: scroll;
  } */
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
    flex-basis: 20%;
    padding: 30px 15px 15px 20px;
  }

  .list-wrapper {
    flex-basis: 67%;
    padding: 25px;
    display: flex;
    max-height: 75vh;
  }

  /* .mbgl{
    flex-basis: 50%;
    min-width: 200px;
    margin-right: 30px;
    max-height: 70vh;
  }

  .mbpl{
    flex-basis: 50%;
    min-width: 200px;
    max-height: 70vh;
  } */

  .myVbtn{
    margin-bottom: 28px;
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
      margin-bottom: 150px;
    }

    .button-wrapper {
      display: block;
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
