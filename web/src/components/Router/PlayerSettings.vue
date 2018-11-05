<template>
  <div id="PlayerSettings">
    <statlete-navbar @shouldOpenNav="openNav"
                     @shouldLogout="logout"
                     style="background-color: rgb(224, 0, 16);"></statlete-navbar>

    <side-nav id="mySidenav"
              @showPlayer="showPlayer"
              @showTeam="showTeam"
              @teamSelected="teamSelected">
    </side-nav>
    
    <h1 style="margin: 75px; color: rgb(224, 0, 16);">Player Settings Page</h1>
    <table align="center">
        <tr>
            <td>
                <div class="TextField" align="left">
                    <label style="color: black;">Player Name:</label>
                </div>
            </td>
            <td>
                <div class="TextField" align="left">
                    <input class="MyText" id="playerName" type="text" :placeholder="tok" :value="selectedTeamName">
                    <button class="btn btn-default navbar-btn myButton" @click="submitPlayerName">Submit</button>
                </div>
            </td>
        </tr>
        <tr id="idTR">
            <td>
                <div class="TextField" align="left">
                    <label style="color: black;">Team ID:</label>
                </div>
            </td>
            <td>
                <div class="TextField" align="left">
                    <input disabled="true" class="MyText" id="teamIDtext" type="text" :placeholder="id" :value="selectedTeamId">
                    <button disabled="true" class="btn btn-default navbar-btn myButton" @click="submitTeamID">Submit</button>
                </div>
            </td>
        </tr>
        <tr id="tokTR">
            <td>
                <div class="TextField" align="left">
                    <label style="color: black;">Team Token:</label>
                </div>
            </td>
            <td>
                <div class="TextField" align="left">
                    <input disabled="true" class="MyText" id="teamTokenID" type="text" :placeholder="tok" :value="selectedTeamToken">
                    <button disabled="true" class="btn btn-default navbar-btn myButton" @click="submitToken">Submit</button>
                </div>
            </td>
        </tr>
    </table>
  </div>
</template>

<script>
  import firebase from 'firebase'
  import { mapGetters, mapMutations } from 'vuex';
import { resolve } from 'url';

  export default {
    name: 'PlayerSettings',
    data: function() {
      return {
        teamID: '',
        token: ''
      }
    },
    props: {
      id: {
        default: 'TeamID'
      },
      tok: {
        default: 'Token'
      }
    },
    mounted(){
        jQuery("#idTR").find("MyText,myButton").attr("disabled", true);
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
      })
    },
    methods: {
      ...mapMutations({
        SET_LOGGED_IN_USER: 'mainStore/SET_LOGGED_IN_USER',
        SET_SELECTED_TEAM: 'mainStore/SET_SELECTED_TEAM',
        SET_SELECTED_SPORT: 'mainStore/SET_SELECTED_SPORT',
        SET_ACTIVE_GAME_ID: 'mainStore/SET_ACTIVE_GAME_ID',
        SET_SELECTED_TEAM_ID: 'mainStore/SET_SELECTED_TEAM_ID',
        SET_SELECTED_TEAM_TOKEN: 'mainStore/SET_SELECTED_TEAM_TOKEN',
        SET_PLAYERS: 'mainStore/SET_PLAYERS',
        APPEND_PLAYER: 'mainStore/APPEND_PLAYER'
      }),
      goBack: function() {
        this.$emit('TeamSettingsClose');
      },
      submitTeamID: function() {        
        if(confirm('Are you sure you want to change your team\'s ID?')){
          var self = this;
          var newID = jQuery('#teamIDtext').val()
          var oldID = self.selectedTeamId
          
          firebase.database().ref('/TeamSportfolios/' + oldID).once('value', function(snapshot){
            var data = snapshot.val();
            var admin = Object.keys(data.Admins)[0];
            
            //Update Users table
            console.log('step 1')
            var ref = firebase.database().ref('/Users/' + admin + '/AdminTeams');
            ref.child(oldID).remove().then(() => {
              console.log('step 2')
              return ref.update({ [newID] : " " })
            }).then(function(val){
              console.log('step 3')
              return firebase.database().ref('/TeamSportfolios/').update({
                [newID] : data
              })
            }).then(function(val2) {
              console.log('step 4')
              return firebase.database().ref('/TeamSportfolios/' + oldID).remove();
            }).then(function(val3){
              self.SET_SELECTED_TEAM_ID(newID);
            });
          });
        }
        else{
          console.log('DO NOT SUBMIT ID');
        }
      },
      submitToken: function() {
        if(confirm('Are you sure you want to change your team\'s token?')){
          var self = this;
          var newToken = jQuery('#teamTokenID').val()
          firebase.database().ref('/TeamSportfolios/' + self.selectedTeamId).update({
            Token: newToken
          })
          self.SET_SELECTED_TEAM_TOKEN(newToken);
        }
        else{
          console.log('DO NOT SUBMIT TOKEN');
        }
      },
      submitPlayerName: function() {
          if(confirm('Are you sure you want to update your name?')){
              console.log('NAME CHANGE')
          }
          else{
              console.log('DON\'T CHANGE NAME')
          }
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
      showPlayer: function() {
        this.$router.push('/createplayer');
      },
      showTeam: function() {
        this.$router.push('/createteam')
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
        this.$router.push('/');
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
    }
  }
</script>

<style scoped>
  #PlayerSettings {
    width: 100%;
    height: 100%;
    min-height: 100vh;
    background-color: white;
  }
  input {
    margin: 10px 0;
    width: 30%;
    padding: 15px;
    border: 0;
    outline: 0;
    background: transparent;
    border-bottom: 3px solid rgb(109,8,8);
  }
  .myButton {
    margin-top: 10px;
    margin-left: 20px;
  }
  .myButton:hover {
    background-color: rgba(250, 220, 127, 0.9);
  }

  .TextFieldContainer {
    float: left;
    display: block;
    min-width: 1000px;
    margin:-20px 50px 50px 35px;
  }
    .TextFieldContainer2 {
    float: left;
    display: block;
    min-width: 300px;
    margin:-20px 50px 50px 35px;
  }
  .TextField {
    color: white;
    margin: 20px;
  }
  .MyText {
    min-width: 46vw;
  }
  .ListContainer {
    min-width: 1000px;
    background-color: blue;
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
</style>
