<template>
  <div id="TeamWizard" class="teamWiz">
    <nav-component />
    <h1 style="color: rgb(242,209,24); margin-bottom: 50px;">Create a New Team Sportfolio</h1>
    <tkd-wizardT>
    </tkd-wizardT>
  </div>
</template>

<script>
import firebase from 'firebase'
import { mapGetters, mapMutations } from 'vuex';
export default {
  name: 'WizardTeam',
  computed: {
    ...mapGetters({
      currentUserEmail: 'mainStore/currentUserEmail',
      players: 'mainStore/players'
    })
  },
  data () {
    return {
      msg: 'Welcome to Your Vue.js App',
      playerName: '',
      playerNumber: '',
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
      teamName: '',
      selectedSport: 'basketball',
      teamID: '',
      teamToken: ''
    }
  },
  mounted () {
  },
  methods: {
    ...mapMutations({
      SET_SELECTED_TEAM: 'mainStore/SET_SELECTED_TEAM',
      SET_CURR_TEAM: 'mainStore/SET_CURR_TEAM',
      SET_SELECTED_SPORT: 'mainStore/SET_SELECTED_SPORT'
    }),
    setPid() {
      this.teamID = this.teamName + '_' + Math.random().toString(36).substring(2,7);
    },
    nextClickedPlayer(currentPage) {
      if(currentPage==1){
        this.SET_SELECTED_SPORT('basketball');
        this.SET_CURR_TEAM({
          id: '',
          token: '',
          name: ''
        })
      }
      return true; //return false if you want to prevent moving to next page
    },
    backClickedPlayer(currentPage) {
      return false; //return false if you want to prevent moving to previous page
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

      this.SET_CURR_TEAM({
        id: '',
        token: '',
        name: ''
      });
      this.SET_SELECTED_SPORT('basketball');
      this.SET_SELECTED_TEAM({
        id: this.teamID,
        name: this.teamName,
        token: this.teamToken
      })

      this.teamID = ''
      this.teamName = ''
      this.teamToken = ''

      this.getGamesTeam();
      this.getPlayers();

      this.$router.push('/main');
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
  #mainPage {
    min-height: 100vh;
    background-color: white;
  }
  .myNav {
      background: transparent;
}
</style>
