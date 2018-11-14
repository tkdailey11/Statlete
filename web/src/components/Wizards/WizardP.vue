<template>
  <div class="wizardP">
    <ul class="wizard__steps">
      <li class="wizard__step"
        :class="{'active': currentStep >= index}"
        :style="{ width: 100/steps.length + '%' }"
        v-for="(step, index) of steps" :key="index">
        <span class="wizard__step__line"></span>
        <span class="wizard__step__label">{{step.label}}</span>
        <span class="wizard__step__indicator"></span>
      </li>
    </ul>
    <span
      class="wizard__arrow"
      :style="{ left: arrowPosition }">
    </span>
    <div class="wizard__body">
      <div class="wizard__body__step">
        <div v-if="isStepOne" class="stepOnePlayer">
          <h3>Step 1</h3>
          <label class="myLabel1">Player Name:</label>
          <input type="text" v-model="teamName" placeholder="Player Name" id="playerNameEntry"><br>
          <br>
          <label class="myLabel2" id="playerNumberLabel">Player Number:</label>
          <input type="text" v-model="playerNumber" placeholder="#" id="playerNumberEntry"><br>
          <br>
          <label class="myLabel3" id="sportLabelPlayer">Sport:</label>
          <br>
          <select-sport :initialSport="selectedSport" style="display: inline-block;" @sportWasSelected="selectedSport=$event" id="sportSelectorPlayer"></select-sport>
          <h1></h1>
        </div>
        <div v-else class="stepTwoPlayer">
          <h3>Step 2</h3>
          <label class="myLabel4" id="teamIDLabelPlayer">Team ID:</label>
          <input type="text" v-model="teamID" placeholder="Team ID" id="teamIDPlayer"><br>
          <br>
          <label class="myLabel5" id="teamTokenLabelPlayer">Team Token:</label>
          <input type="text" v-model="teamToken" placeholder="Team Token" id="teamTokenPlayer"><br>
          <br>
        </div>
      </div>
      <div class="wizard__body__actions clearfix">
        <a
          v-if="backEnabled"
          class="wizard__back pull-left"
          @click="goBack()">
          <i class="vgw-icon vgw-prev"></i>
          <span>{{previousStepLabel}}</span>
        </a>
        <a
          v-if="currentStep == 0" class="wizard__next pull-right"
          @click="goNextPlayersOne()">
          <span>{{nextStepLabel}}</span>
          <i class="vgw-icon vgw-next"></i>
        </a>
        <a
          v-if="currentStep == 1" class="wizard__next pull-right final-step" @click="submitPlayerSportfolio()">
          {{finalStepLabel}}
        </a>
      </div>
    </div>
  </div>
</template>

<script>
import firebase from 'firebase'
import { mapGetters, mapMutations } from 'vuex';

export default {

  name: 'tkd-wizardP',

  props: {
    previousStepLabel: {default: 'Back'},
    nextStepLabel: {default: 'Next'},
    finalStepLabel: {default: 'Save'}
  },

  data () {
    return {
      currentStep: 0,
      teamName: '',
      isStepOne: true,
      steps: [
        {
          label: 'Name and Sport'
        },
        {
          label: 'Linking (Optional)'
        }
      ],
      playerNumber: '',
      selectedSport: 'basketball',
      teamID: '',
      teamToken: ''
    };
  },
  computed: {
    ...mapGetters({
      selectedTeamId: 'mainStore/selectedTeamId',
      currentUserEmail: 'mainStore/currentUserEmail'
    }),
    arrowPosition() {
      var stepSize = 50;
      var currentStepStart = stepSize * this.currentStep;
      var currentStepMiddle = currentStepStart + (stepSize/2);
      return 'calc('+currentStepMiddle+'% - 14px)'
    },
    backEnabled() {
      return this.currentStep != 0;
    }
  },
  methods: {
    goNextPlayersOne (skipFunction){
      //add code to validate players info here...
      this.currentStep = 1;
      this.isStepOne = false;
      return true;
    },
    goBack (skipFunction) {
      if (this.currentStep == 1) {
        this.currentStep = 0;
        this.isStepOne = true;
      }
    },
    ...mapMutations({
      SET_SELECTED_TEAM: 'mainStore/SET_SELECTED_TEAM',
      SET_SELECTED_SPORT: 'mainStore/SET_SELECTED_SPORT',
      PL_SET_ADD_GAME_ENABLED: 'playerStore/PL_SET_ADD_GAME_ENABLED'
    }),
    logout: function() {
      firebase.auth().signOut().then(() => {
        this.$router.replace('login')
      })
    },
    backClickedPlayer(currentPage) {
      if(currentPage == 0){
        return false; //return false if you want to prevent moving to previous page
      }
      else {
        currentPage = 0;
        return true;
      }
    },
    submitPlayerSportfolio(){
      var emailStr = this.currentUserEmail;
      var email = emailStr.replace('.', '');
      var self = this;

      //this.teamName is really the player name
      if(self.teamID == '' && self.teamToken != ''){
        alert('Please enter a team id')
        return;
      }
      else if (self.teamToken == '' && self.teamID != ''){
        alert('Please enter a team token')
        return;
      }
      else if(self.teamToken != '' && self.teamID != ''){
        //Validate token/id
        firebase.database().ref('/TeamSportfolios/' + self.teamID + '/Token').once('value', function(snapshot){
          if(snapshot.val() != self.teamToken){
            alert('The provided team id and token don\'t match, please try again')
          }
          else{
            //Verify the teamID exists
            firebase.database().ref('/TeamSportfolios/' + self.teamID).once('value', function(snapshot){
              if(snapshot.val() == null){
                alert('That team ID doesn\'t exist, please try again')
              }
              else{
                //id does exist, now make sure player with that name doesn't already exist
                var players = snapshot.val().Players;
                var playerfound = false;
                Object.keys(players).forEach(player => {
                  if(player.includes(self.playerNumber)){
                    playerfound = true
                  }
                });

                if(playerfound){
                  alert('A player with that number already exists, please try again')
                }
                else{
                  alert('Good to go')
                  //Good to go
                  var playerData = {
                      "Name" : self.teamName,
                      "Number" : self.playerNumber,
                      "TeamID" : self.teamID,
                      "TotalStats" : " ",
                      "User" : emailStr
                  }

                  var id = self.teamName + '-' + self.teamID;
                  alert('ID: ' + id);
                  firebase.database().ref('PlayerSportfolios/' + id).once("value", function(snapshot){
                    if(!(snapshot.val()===null)){
                      alert('A sportfolio with those settings already exists. Please Try Again.')
                      return;
                    }
                    else{
                      firebase.database().ref('PlayerSportfolios/').update({
                        [id] : playerData
                      });

                      firebase.database().ref('Users/').child(email).child('PlayerTeams').update({
                        [self.teamID] : id
                      })

                      var playerNum = 'p' + self.playerNumber
                      //Add to team's data
                      firebase.database().ref('/TeamSportfolios/' + self.teamID + '/Players').update({
                        [playerNum] : self.teamName
                      })


                      self.SET_SELECTED_SPORT('basketball');
                      self.SET_SELECTED_TEAM({
                        id: self.teamID,
                        token: self.teamToken,
                        name: self.teamName,
                        sport: 'basketball'
                      });

                      self.teamID = ''
                      self.teamName = ''
                      self.teamToken = ''
                      self.playerNumber = ''

                      self.getGamesPlayer();
                      self.PL_SET_ADD_GAME_ENABLED(false);
                      self.$router.push('playerHome');
                    }
                  });
                }
              }
            })
          }
        })
      }
      else{
        //No team id and token
        var fakeID =  Math.random().toString(36).substring(2,7);
        var playerData = {
            "Name" : self.teamName,
            "Number" : self.playerNumber,
            "TeamID" :  fakeID,
            "TotalStats" : " ",
            "User" : emailStr
        }

        var id = self.teamName + '-' + fakeID;
        firebase.database().ref('PlayerSportfolios/').update({
          [id] : playerData
        });

        firebase.database().ref('Users/').child(email).child('PlayerTeams').update({
          [fakeID] : id
        })

        self.SET_SELECTED_SPORT('basketball');
        self.SET_SELECTED_TEAM({
          id: self.teamID,
          token: self.teamToken,
          name: self.teamName,
          sport: 'basketball'
        });

        self.teamID = ''
        self.teamName = ''
        self.teamToken = ''
        self.playerNumber = ''

        self.getGamesPlayer();
        self.$router.push('playerHome');
      }
    },
    getGamesPlayer() {
      var teamIDList = [];
      var emailStr = this.currentUserEmail;
      var email = emailStr.replace('.', '');
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
    }
  }
};
</script>

<style scoped>

.pull-left{
  float:  left !important;
}

.pull-right{
  float:  right !important;
}

.clearfix::after {
  display: block;
  content: "";
  clear: both;
}

.wizardP {
  position: relative;
  width:  100%;
}

.wizard__steps{
  list-style-type:  none;
  text-align: justify;
  -ms-text-justify: distribute-all-lines;
  text-justify: distribute-all-lines;
  padding:  0;
  height:  70px;
  position:  relative;
}

.stretch {
  width: 100%;
  display: inline-block;
  font-size: 0;
  line-height: 0
}

.wizard__step{
  height: 70px;
  vertical-align: bottom;
  display: inline-block;
  text-align: center;
  position:  relative;
}

.wizard__step:not(:first-child) .wizard__step__line{
  position: absolute;
  width:  100%;
  left:  -50%;
  bottom:  12px;
  height:  3px;
}

.wizard__step__indicator{
  box-sizing: content-box;
  display:  block;
  width:  16px;
  height:  16px;
  border-radius: 50%;
  border-width: 3px;
  border-style: solid;
  position:  absolute;
  left:  50%;
  margin-left:  -10px;
  bottom:  2px;
  z-index: 1;
}

.wizard__step__label{
  font-weight: bold;
}

/* Wizard body
*******************************/
.wizard__body{
  margin-top:  25px;
  min-height:  400px;
  margin-left:  50px;
  margin-right:  50px;
  border:  3px solid white;
  background-color: green;
  position: relative;
  border-radius: 5px;
  padding-bottom: 50px;
}

.wizard__body__step{
  padding:  16px;
}

.wizard__arrow{
  position:  absolute;
  display: block;
  width:  30px;
  height:  30px;
  border:  1px solid green;
  top:  85px; /* height of step + body margin -15 */
  border-top-right-radius: 5px;
  background-color: green;
  border-left: none;
  border-bottom:  none;
  transform: rotate(-45deg);
  z-index: 2;
  -webkit-transition: left 0.3s;
  -o-transition: left 0.3s;
  transition: left 0.3s;
}

/* Wizard body
*******************************/
.wizard__body__actions{
  position:  absolute;
  bottom:  0px;
  height:  50px;
  width:  100%;
  border-top:  1px solid rgb(242,209,24);
  background-color: rgba(252,102,0, 0.7);
}

.wizard__body__actions a{
  width:  120px;
  height:  100%;
  display: block;
  background-color: rgb(235,95,17);
  color: white;
  font-weight: bold;
  text-align: center;
  line-height: 50px;
  cursor: pointer;
  -webkit-transition: background-color 0.3s;
  -o-transition: background-color 0.3s;
  transition: background-color 0.3s;
}

.wizard__body__actions a>.vgw-icon, .wizard__body__actions a>span{
  display: inline-block;
  vertical-align: middle;
  position: relative;
}

.wizard__body__actions .vgw-icon::after{
  position: absolute;
  content: "";
  transform: rotate(-45deg);
  width: 8px;
  height: 8px;
  top: 50%;
  margin-top: -5px;
}

.vgw-icon.vgw-next::after{
  border-bottom: 2px solid rgb(242,209,24);
  border-right: 2px solid rgb(242,209,24);
}

.vgw-icon.vgw-prev::after{
  border-top: 2px solid white;
  border-left: 2px solid white;
  left: -10px;
}

.wizard__body__actions a:hover{
  background-color: rgb(224,0,16);
  color: white;
}

.wizard__body__actions a.final-step{
  background-color: rgb(252,102,0);
}

.wizard__body__actions a.final-step:hover{
  background-color: rgb(224,0,16);
}

.myLabel1 {
  width: auto;
  text-align: right;
  padding-right: 30px;
}
.myLabel2 {
  width: auto;
  text-align: right;
  padding-right: 30px;
}
.myLabel3 {
  width: auto;
  text-align: right;
  padding-right: 30px;
}
.myLabel4 {
  width: auto;
  text-align: right;
  padding-right: 30px;
}
.myLabel5 {
  width: auto;
  text-align: right;
  padding-right: 30px;
}
.myLabel6 {
  width: auto;
  text-align: right;
  padding-right: 30px;
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

.button-wrapper {
  float: right;
  white-space: nowrap;
  margin-top: 18px;
  display: flex;
  flex-wrap: wrap;
  margin-left: 75px;
}

#sportSelectorPlayer {
  margin-top: 10px;
}

input {
  border: none;
  margin-bottom: 10px;
  border-bottom: 2px rgb(252,102,0) solid;
}
</style>
