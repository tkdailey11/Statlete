<template>
<div class="FLP">
  <h1 style="margin: 75px; color: rgb(242,209,24);">Create Your First Sportfolio!</h1>
    <tkd-wizardT>
    </tkd-wizardT>
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
