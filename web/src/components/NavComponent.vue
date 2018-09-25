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
      currentUserEmail: 'mainStore/currentUserEmail'
    })
  },
  data () {
    return {
      gamesList: []
    }
  },
  mounted () {
      
  },
  methods: {
    ...mapMutations({
      SET_SELECTED_TEAM: 'mainStore/SET_SELECTED_TEAM',
      SET_CURR_TEAM: 'mainStore/SET_CURR_TEAM',
      SET_PLAYERS: 'mainStore/SET_PLAYERS',
    }),
    logout: function() {
      firebase.auth().signOut().then(() => {
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
      console.log('Selected: ' + event.Id)
      this.SET_SELECTED_TEAM({
        id: event.Id,
        name: event.Name,
        token: event.Token
      });

      this.getGamesTeam();
      this.getPlayers();

      this.$router.push('/main')
    },
    showPlayer: function() {
      this.$router.push('createplayer');
    },
    //<!-- CHANGE THIS -->
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
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style>
 .myNavComponent {
      transition: margin-left .5s;
      margin:0px;
      min-height: 100%;
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
