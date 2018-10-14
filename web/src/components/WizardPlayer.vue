<template>
  <div id="WizardPlayer" style="padding-top=100px min-height: 100vh;">
    <statlete-navbar @shouldOpenNav="openNav"
                     @shouldLogout="logout"
                     @GoBackClicked="goHome"
                     style="background: transparent;"></statlete-navbar>

    <side-nav id="mySidenav"
              @showPlayer="closeNav"
              @showTeam="showTeam"
              @teamSelected="teamSelected">
    </side-nav>
    <h1 style="color: rgb(242,209,24); margin-bottom: 50px;">Create a New Player Sportfolio</h1>
    <tkd-wizardP>
    </tkd-wizardP>
  </div>
</template>

<script>
import firebase from 'firebase'
import { mapGetters, mapMutations } from 'vuex';
export default {
  name: 'WizardPlayer',
  computed: {
    ...mapGetters({
      selectedTeamId: 'mainStore/selectedTeamId',
      currentUserEmail: 'mainStore/currentUserEmail'
    })
  },
  data () {
    return {
      playerNumber: '',
      teamName: '',
      selectedSport: 'basketball',
      teamID: '',
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
  },
  methods: {
    ...mapMutations({
      SET_SELECTED_TEAM: 'mainStore/SET_SELECTED_TEAM',
      SET_SELECTED_SPORT: 'mainStore/SET_SELECTED_SPORT'
    }),
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
    closeNav: function() {
      document.getElementById("mySidenav").style.width = "0";
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

      var playerData = {
          "Name" : this.teamName,
          "Number" : this.playerNumber,
          "TeamID" : this.teamID,
          "TotalStats" : " ",
          "User" : emailStr
      }

      var id = this.teamName + '-' + this.teamID;
      alert(id)
      var exists = firebase.database().ref('PlayerSportfolios/'+ id).key;

      if(exists===null){
        firebase.database().ref('PlayerSportfolios/').update({
          [id] : playerData
        });

        firebase.database().ref('Users/').child(email).child('PlayerTeams').update({
          [this.teamID] : id
        })



        this.SET_SELECTED_SPORT('basketball');

        this.teamID = ''
        this.teamName = ''
        this.teamToken = ''
        this.playerNumber = ''

        this.getGamesPlayer();
        this.$router.push('playerHome');
      }
      else{
        alert('A sportfolio with those settings already exists. Please Try Again.')
      }

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
    goHome: function(mode) {
      this.$router.push('/main');
    },
    showTeam: function() {
      this.$router.push('/createteam')
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
</style>
