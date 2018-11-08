<template>
  <div class="myNavComponent">
    <statlete-navbar @shouldOpenNav="openNav"
                     @shouldLogout="logout"></statlete-navbar>
    <side-nav id="mySidenav"
              @showPlayer="showPlayer"
              @showTeam="showTeam"
              @teamSelected="teamSelected">
    </side-nav>
  </div>
</template>

<script>
import firebase from 'firebase'
import { mapGetters, mapMutations } from 'vuex';
export default {
  name: 'NavComponent',
  computed: {
    ...mapGetters({
      selectedTeamId: 'mainStore/selectedTeamId',
      currentUserEmail: 'mainStore/currentUserEmail',
      gamesList: 'mainStore/gamesList'
    })
  },
  mounted () {
      
  },
  methods: {
    ...mapMutations({
      SET_SELECTED_TEAM: 'mainStore/SET_SELECTED_TEAM',
      SET_PLAYERS: 'mainStore/SET_PLAYERS',
      SET_GAMES_LIST: 'mainStore/SET_GAMES_LIST',
      CLEAR_STATE: 'mainStore/CLEAR_STATE',
      GV_CLEAR_STATE: 'gameViewStore/GV_CLEAR_STATE'
    }),
    logout: function() {
      firebase.auth().signOut().then(() => {
        this.CLEAR_STATE();
        this.GV_CLEAR_STATE();
        this.$router.replace('login')
        
      })
    },
    openNav: function() {
      setTimeout(function(){
        document.getElementById("mySidenav").style = "width: 250px; position: absolute; z-index: 2;";
      }, 90);
    },
    showTeam: function() {
      this.$router.push('/createteam')
    },
    teamSelected: function(event) {
      var sport = event.Sport;
      if(sport.toString().toLowerCase() === 'soccer'){
        sport = 1;
      }
      else if(sport.toString().toLowerCase() === 'basketball') {
        sport = 0;
      }
      
      this.SET_SELECTED_TEAM({
        id: event.Id,
        name: event.Name.split('|')[0],
        token: event.Token,
        sport: sport
      });

      this.getGamesTeam();
      this.getPlayers();

      this.$router.push('/main')
    },
    showPlayer: function() {
      this.$router.push('createplayer');
    },
    getGamesTeam() {
      console.log('GetGamesSideNav')
      var email = this.currentUserEmail.replace('.', '');
      var self = this;

      var keysList = [];
      var gamesListRef = firebase.database().ref('/TeamSportfolios/' + self.selectedTeamId + '/Games/');
      if (typeof gamesListRef !== 'undefined') {
        console.log('Got games')
        gamesListRef.on('value', function(snapshot) {
          var obj = snapshot.val();
          if (obj) {
            console.log('There were games')
            console.log(obj)
            self.SET_GAMES_LIST(Object.keys(obj));
          }
          else{
            console.log('There weren\'t games')
          }
        });
      }
      else{
        console.log('Didn\'t get games')
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
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style>
 .myNavComponent {
      transition: margin-left .5s;
      margin:0px;
      z-index: 2;
  }

  /* The side navigation menu */
  .sidenav {
      height: 100%; /* 100% Full-height */
      width: 0; /* 0 width - change this with JavaScript */
      position: fixed; /* Stay in place */
      z-index: 2; /* Stay on top */
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
      z-index: 2;
  }

  /* When you mouse over the navigation links, change their color */
  .sidenav a:hover {
      color: #f1f1f1;
      z-index: 2;
  }

  /* Position and style the close button (top right corner) */
  .sidenav .closebtn {
      position: absolute;
      top: 0;
      right: 25px;
      font-size: 36px;
      margin-left: 50px;
      z-index: 2;
  }
</style>
