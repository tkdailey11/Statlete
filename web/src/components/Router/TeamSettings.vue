<template>
  <div id="TeamSettings">
    <nav-component />

    <div class="TextFieldContainer">
      <div class="TextField" align="left">
        <input class="MyText" id="teamIDtext" type="text" :placeholder="id" :value="selectedTeamId">
        <button class="btn btn-default navbar-btn ts_button" @click="submitTeamID">Submit</button>
      </div>
      <div class="TextField" align="left">
        <input class="MyText" id="teamTokenID" type="text" :placeholder="tok" :value="selectedTeamToken">
        <button class="btn btn-default navbar-btn ts_button" @click="submitToken">Submit</button>
      </div>
    </div>
    <div class="ListContainer">
      <players-list :addPlayerEnabled="false"
                    :title="'Admins'"
                    style="float: left;"
                    :players="admins"></players-list>
      <players-list :addPlayerEnabled="false"
                    style="float: left;"
                    :players="players"></players-list>
    </div>
  </div>
</template>

<script>
  import firebase from 'firebase'
  import { mapGetters, mapMutations } from 'vuex';
import { resolve } from 'url';

  export default {
    name: 'TeamSettings',
    data: function() {
      return {
        teamID: '',
        token: '',
        admins: []
      }
    },
    mounted(){
      var self = this;
      firebase.database().ref('/TeamSportfolios/' + this.selectedTeamId + '/Admins').on('value', function(snapshot){
        self.admins = snapshot.val()
      })
    },
    props: {
      id: {
        default: 'TeamID'
      },
      tok: {
        default: 'Token'
      }
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
      logout: function() {
        firebase.auth().signOut().then(() => {
          this.$router.replace('login')
        })
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
  #TeamSettings {
    width: 100%;
    height: 100%;
    min-height: 100vh;
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

  .TextFieldContainer {
    float: left;
    display: block;
    min-width: 1000px;
    margin:50px 50px 50px 35px;
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
    margin-top: 50px;
  }
  .ts_button {
    margin: 20px;
    cursor: pointer;
  }
</style>
