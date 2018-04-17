<template>
<div class="FLP">
  <h1 style="margin: 75px;">Create Your First Sportfolio!</h1>
    <vue-good-wizard :steps="teamSteps" :onNext="nextClickedTeam" :onBack="backClickedTeam">
      <div slot="teamPage1">
        <label class="myLabel">Team Name:</label>
        <input type="text" v-model="teamName" placeholder="Team Name"><br>
        <br>
        <label class="myLabel">Sport:</label>
        <br>
        <select-sport :initialSport="selectedSport" style="display: inline-block;" @sportWasSelected="selectedSport=$event"></select-sport>
        <h1></h1>
      </div>

      <div slot="teamPage2">
        <h4>Add Players</h4>
        <player-selection-box @playerInfo="setPlayerInfo"></player-selection-box>
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
</template>

<script>
import firebase from 'firebase';

export default {
  name: "FLP",
  mounted () {
    this.$nextTick(() => {
        this.loggedInUser = firebase.auth().currentUser;
        this.currentUserEmail = this.loggedInUser.email;
    });
  },
  data() {
    return {
      teamSteps: [{
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
      sportfolios: [],
      gamesList: [],
      players: [],
      msg: 'Welcome to Your Vue.js App',
      loggedInUser: '',
      currentUserEmail: '',
      teamName: '',
      teamToken: '',
      teamID: '',
      playerName: '',
      selectedSport: 'basketball'
    }
  },
  methods: {
    createSportfolio() {
      this.clickedCreate = true
    },
    backClickedTeam(currentPage) {
      return false; //return false if you want to prevent moving to previous page
    },
    setPlayerInfo(event) {
      this.sportfolios.push(event);
    },
    validateTeamName() {
      return true;
    },
    isValidTeamID() {
        const query = firebase.database().ref('TeamSportfolios/').child(this.teamID);
        return query

    },
    isValidTeamToken() {
      if (this.teamToken === '') {
        alert('Please enter a Team Token!');
        return false;
      } else {
        return true;
      }
    },
    nextClickedTeam(currentPage) {
      if (currentPage == 0) {
        if (this.teamName === '') {
          alert('Please enter a Team Name!');
          return false;
        }
        return true;
      } else if (currentPage == 1) {
        return true;
      } else {
        var self = this;
        if (self.teamID === '') {
          alert('EMPTY ID')
          return false;
        } else if (!self.isValidTeamToken()) {
          return false;
        }
        else {
          firebase.database().ref('TeamSportfolios/' + self.teamID).once('value', function(snapshot) {
            if(snapshot.exists()){
              alert('A team with that id already exists');
            }
            else{
              var email = self.currentUserEmail.replace('.', '');
              var nam = self.teamName;
              var tok = self.teamToken;
              var teamData = {
                "Admins": {
                  [email]: 'admin1'
                },
                "Creator": email,
                "TeamName": nam,
                "Token": tok
              }

              var s = self.sportfolios.splice(-1)[0];
              console.log(s);
              var playerObj = {};
              s.forEach(function(player) {
                var key = 'p' + player.num;
                if (player.name === '') {
                  playerObj[key] = ' ';
                } else {
                  playerObj[key] = player.name;
                }
              });

              teamData.Players = playerObj;

              var id = self.teamID;

              // Add team to TeamSportfolios "table"
              firebase.database().ref('TeamSportfolios/').update({
                [id]: teamData
              });

              // Add user to Users "table"
              firebase.database().ref('Users/').update({
                [email]: {
                  'AdminTeams': {
                    [id]: 'team1'
                  }
                }
              });

              self.$router.replace('main');
            }
          });
        }
      }
    }
  }
}
</script>

<style scoped>
.FLP {
  width: inherit;
  height: inherit;
}
</style>
