<template>
  <div class="wizardT">
    <nav-component />
    <h1 style="color: rgb(242,209,24); margin: 50px 0px 50px 0px; background: transparent;">Create a New Team Sportfolio</h1>
    <ul class="wizard__steps">
      <li class="wizard__step"
        :class="{'active': currentStep >= index}"
        :style="{ width: 100/3 + '%' }"
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
        <div v-if="currentStep == 0" id="teamPage1">
          <label class="myLabel">Team Name:</label>
          <input class="teamNameEntry" type="text" v-model="teamName" placeholder="Team Name">
          <br>
          <br>
          <label class="myLabel3" id="sportLabelPlayer">Sport:</label>
          <br>
          <select-sport :initialSport="selectedSport" style="display: inline-block;" @sportWasSelected="selectedSport=$event" id="sportSelectorPlayer"></select-sport>

        </div>

        <div v-if="currentStep == 1" id="teamPage2">
          <h4>Add Players</h4>
          <player-selection-box @playerInfo="setPlayerInfo"
                                :sport="selectedSport"
                                :playersList="playersList"></player-selection-box>
        </div>

        <div v-if="currentStep == 2" id="teamPage3">
          <div class="step3Body">
            <label class="myLabel">Team ID:</label>
            <input class="teamIdEntry" type="text" v-model="teamID" placeholder="Team ID"><br>
            <br>
            <label class="myLabel">Team Token:</label>
            <input class="teamTokenEntry" type="text" v-model="teamToken" placeholder="Team Token"><br>
            <br>
          </div>
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
          @click="goNextTeamName()">
          <span>{{nextStepLabel}}</span>
          <i class="vgw-icon vgw-next"></i>
        </a>
        <a
          v-if="currentStep == 1" class="wizard__next pull-right"
          @click="goNextPlayers()">
          <span>{{nextStepLabel}}</span>
          <i class="vgw-icon vgw-next"></i>
        </a>
        <a
          v-if="currentStep == 2" class="wizard__next pull-right final-step" @click="submitTeamSportfolio()">
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

  name: 'tkd-wizardT',

  props: {
    previousStepLabel: {default: 'Back'},
    nextStepLabel: {default: 'Next'},
    finalStepLabel: {default: 'Save'}
  },

  data () {
    return {
      currentStep: 0,
      teamName: '',
      steps: [
        {
          label: 'Name and Sport'
        },
        {
          label: 'Add Players'
        },
        {
          label: 'Linking (Optional)'
        }
      ],
      playerNumber: '',
      selectedSport: 'basketball',
      teamID: '',
      teamToken: '',
      playersList: []
    };
  },
  computed: {
    ...mapGetters({
      loggedInUser: 'mainStore/loggedInUser',
      selectedTeamId: 'mainStore/selectedTeamId',
      selectedTeamName: 'mainStore/selectedTeamName',
      selectedTeamToken: 'mainStore/selectedTeamToken',
      currentUserEmail: 'mainStore/currentUserEmail',
      activeGameId: 'mainStore/activeGameId',
      players: 'mainStore/players'
    }),
    arrowPosition() {
      var stepSize = 100/3;
      var currentStepStart = stepSize * this.currentStep;
      var currentStepMiddle = currentStepStart + (stepSize/2);
      return 'calc('+currentStepMiddle+'% - 14px)'
    },
    backEnabled() {
      return this.currentStep != 0;
    }
  },
  methods: {
    ...mapMutations({
      SET_LOGGED_IN_USER: 'mainStore/SET_LOGGED_IN_USER',
      SET_SELECTED_TEAM: 'mainStore/SET_SELECTED_TEAM',
      SET_ACTIVE_GAME_ID: 'mainStore/SET_ACTIVE_GAME_ID',
      SET_SELECTED_TEAM_ID: 'mainStore/SET_SELECTED_TEAM_ID',
      SET_PLAYERS: 'mainStore/SET_PLAYERS',
      APPEND_PLAYER: 'mainStore/APPEND_PLAYER'
    }),
    setPlayerInfo(event) {
      this.playersList = event;
    },
    goNextPlayers (skipFunction) {
      if (this.currentStep < this.steps.length-1) {
        this.currentStep++;
        this.$emit('SetDefaultPid')
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
    goNextTeamName (skipFunction) {
        var tn_str = jQuery('.teamNameEntry').val();
        if(tn_str===''){
          alert('Please Enter a Team Name');
          return false;
        }
        else {
          this.teamName = tn_str;
          this.currentStep++;
          return true;
        }

    },
    submitTeamSportfolio(){
      var emailStr = this.currentUserEmail;
      var email = emailStr.replace('.', '');
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

      var playerObj = {};
      this.playersList.forEach( function (player)
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
      
      this.SET_SELECTED_TEAM({
        id: this.teamID,
        name: this.teamName,
        token: this.teamToken,
        sport: this.selectedSport
      })

      this.teamID = ''
      this.teamName = ''
      this.teamToken = ''

      this.getGamesTeam();
      this.getPlayers();

      this.$router.push('/main');
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
    goHome: function(mode) {
      this.$router.push('/main');
    },
    createPlayer: function() {
      this.$router.push('/createplayer')
    },
    goBack: function() {
      if (this.currentStep > 0) {
        this.currentStep--;
      }
    }
  }
};
</script>

<style lang="scss" scoped>
$bright_red: rgb(224, 0, 16);
$transparent_red: rgba(224, 0, 16, 0.5);
$light_gray: rgb(240,240,240);
$transparent_light_gray: rgba(240,240,240, 0.5);
$dark_bgrd: rgb(43, 42, 41);
$dark_fgrd: rgb(85, 85, 85);

h3 {
  color: $light_gray;
}

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


.wizardT {
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
  color: $light_gray;
}

// .wizard__step.active .wizard__step__indicator{
//   background-color: rgb(242,209,24);
// }

// .wizard__step.active:not(:first-child) .wizard__step__line{
//   background-color: rgb(242,209,24);
// }

.wizard__step__label{
  font-weight: bold;
  color: $light_gray;
}

.wizard__body{
  margin-top:  25px;
  min-height:  400px;
  margin-left:  50px;
  margin-right:  50px;
  border:  3px solid $light_gray;
  background-color: $dark_fgrd;
  position: relative;
  border-radius: 5px;
  padding-bottom: 50px;
  color: $light_gray;
}

.wizard__body__step{
  padding:  16px;
}

.wizard__arrow{
  position:  absolute;
  display: block;
  width:  30px;
  height:  30px;
  border:  1px solid $light_gray;
  top:  85px; /* height of step + body margin -15 */
  border-top-right-radius: 5px;
  background-color: $light_gray;
  border-left: none;
  border-bottom:  none;
  transform: rotate(-45deg);
  z-index: 0;
  -webkit-transition: left 0.3s;
  -o-transition: left 0.3s;
  transition: left 0.3s;
}

.wizard__body__actions{
  position:  absolute;
  bottom:  0px;
  height:  50px;
  width:  100%;
  border-top:  3px solid $light_gray;
  background-color: $bright_red;
}

.wizard__body__actions a{
  width:  120px;
  height:  100%;
  display: block;
  background-color: $transparent_red;
  border-left: 3px solid $light_gray;
  color: $light_gray;
  font-weight: bold;
  text-align: center;
  line-height: 40px;
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
  border-bottom: 2px solid $light_gray;
  border-right: 2px solid $light_gray;
}

.vgw-icon.vgw-prev::after{
  border-top: 2px solid $light_gray;
  border-left: 2px solid $light_gray;
  left: -10px;
}

.wizard__body__actions a:hover{
  background-color: $bright_red;
  color: $light_gray;
}

.wizard__body__actions a.final-step{
  background-color: $bright_red;
  color: $light_gray;
}

.wizard__body__actions a.final-step:hover{
  background-color: $bright_red;
  color: $light_gray;
}

.mySportLabel {
  width: auto;
  text-align: right;
  padding-right: 30px;
}

.myLabel {
  width: auto;
  text-align: right;
  padding-right: 30px;
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
  margin: 10px 0;
  width: 50%;
  padding: 15px;
  border: 0;
  outline: 0;
  border-bottom-width: 3px;
  border-bottom-style: solid;
  color: $light_gray;
  border-color: $bright_red !important;
  background: $dark_fgrd;
  border-radius: 5px;
}
</style>
