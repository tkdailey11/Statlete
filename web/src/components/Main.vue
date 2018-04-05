<template>
  <div class="main">
    <h1>{{ tkdSport }}</h1>
    <div id="mainPage" v-if="!(isCreatingTeam || isCreatingPlayer)">
      <div id="mySidenav" class="sidenav">
        <a href="javascript:void(0)" class="closebtn" @click="closeNav">&times;</a>
        <img src="../assets/images/testUser.png" width="100px" height="100px">
        <a href="#">About</a>
        <a href="#">Services</a>
        <a href="#">Clients</a>
        <a href="#">Contact</a>
        <div style="scroll">
          <div v-for="i in 50">
            <div style="margin=10px; color=red;"><p>Test {{ i }}</p></div>
          </div>

        </div>
      </div>

      <h1>{{ loggedInUser.email }}</h1>
      <button @click="logout">Logout</button>
      <button @click="openNav">Open Nav</button>
      <br>
      <br>
      <br>
      <br>
      <br>
      <button @click="showTeam">New Team Account</button>
      <br>
      <br>
      <br>
      <button @click="showPlayer">New Player Account</button>
    </div>
    <div v-else>
      <div id="createTeam" v-if="isCreatingTeam">
        <h1>TEAM</h1>
        <br>
      </div>
      <div id="createPlayer" v-if="isCreatingPlayer">
        <h1>PLAYER</h1>

      </div>

      <div id="PlayerWizard" v-if="isCreatingPlayer" style="padding-top=100px;">
        <div>
          <vue-good-wizard
            :steps="playerSteps"
            :onNext="nextClickedPlayer"
            :onBack="backClickedPlayer">

            <div slot="playerPage1">
              <label class="myLabel">Team Name:</label>
              <input type="text" v-model="teamName" placeholder="Team Name"><br>
              <br>
              <label class="myLabel">Sport:</label>
              <br>
              <select-sport :initialSport="tkdSport" style="display: inline-block;" @sportWasSelected="tkdSport=$event"></select-sport>
              <h1></h1>
            </div>

            <div slot="playerPage2">
              <h4>Add Players</h4>
              <h1>Player Selection will go here</h1>
            </div>
          </vue-good-wizard>
        </div>
      </div>

      <div id="TeamWizard" v-if="isCreatingTeam" style="padding-top=100px;">
        <vue-good-wizard
          :steps="teamSteps"
          :onNext="nextClickedTeam"
          :onBack="backClickedTeam">

          <div slot="teamPage1">
            <label class="myLabel">Team Name:</label>
            <input type="text" v-model="teamName" placeholder="Team Name"><br>
            <br>
            <label class="myLabel">Sport:</label>
            <br>
            <select-sport :initialSport="tkdSport" style="display: inline-block;" @sportWasSelected="tkdSport=$event"></select-sport>
            <h1></h1>
          </div>

          <div slot="teamPage2">
            <h4>Add Players</h4>
            <h1></h1>
            <player-selection-box></player-selection-box>
          </div>

          <div slot="teamPage3">
            <h4>Step 3</h4>
            <label class="myLabel">Team ID:</label>
            <input type="text" v-model="teamID" placeholder="Team ID"><br>
            <br>
            <label class="myLabel">Team Token:</label>
            <input type="text" v-model="teamToken" placeholder="Team Token"><br>
            <br>
          </div>
        </vue-good-wizard>
      </div>
    </div>


  </div>
</template>

<script>
  import firebase from 'firebase';

  export default {
    name: 'Main',
    data () {
      return {
        msg: 'Welcome to Your Vue.js App',
        loggedInUser: '',
        teamName: '',
        teamToken: '',
        teamID: '',
        playerName: '',
        tkdSport: 'basketball',
        isCreatingPlayer: false,
        isCreatingTeam: false,
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
        ]
      }
    },
    mounted () {
      this.$nextTick(() => {
          this.loggedInUser = firebase.auth().currentUser;
      });
    },
    methods: {
      logout: function() {
        firebase.auth().signOut().then(() => {
          this.$router.replace('login')
        })
      },
      openNav: function() {
        document.getElementById("mySidenav").style.width = "250px";
      },
      closeNav: function() {
        document.getElementById("mySidenav").style.width = "0";
      },
      showTeam: function() {
        this.isCreatingTeam = true
        this.isCreatingPlayer = false
      },
      hideCreating: function() {
        this.isCreatingTeam = false
        this.isCreatingPlayer = false
      },
      showPlayer: function() {
        this.isCreatingPlayer = true
        this.isCreatingTeam = false
      },
      onComplete: function() {
        alert('Yay. Done!');
      },
      nextClickedPlayer(currentPage) {
        if(currentPage==1){
          this.hideCreating()
        }
        return true; //return false if you want to prevent moving to next page
      },
      backClickedPlayer(currentPage) {
        return true; //return false if you want to prevent moving to previous page
      },
      nextClickedTeam(currentPage) {
        if(currentPage==2){
          this.hideCreating()
        }
        return true; //return false if you want to prevent moving to next page
      },
      backClickedTeam(currentPage) {
        return true; //return false if you want to prevent moving to previous page
      }
    }
  }
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
  h1, h2 {
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
  #main {
      transition: margin-left .5s;
      padding: 20px;
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
    display: inline-block;
    width: auto;
    text-align: right;
    padding-right: 30px;
  }

  .sportColor {
    background-color: blue;
  }

  .sportSelect {
    width: 210px;
    height: 97px;
    display: inline-block;
  }
  .sportButton {
    background-color: red;
    color: white;
    width: 200px;
  }
  .selectedButton {
    background-color: rgb(0, 0, 255);
    width: 200px;
    color: rgb(255,255,255);
  }

  .wizard-tab-content {
  display: flex; // to avoid horizontal scroll when animating
  .wizard-tab-container {
    display: block;
    animation: fadeInRight 0.3s;
  }
}

</style>
