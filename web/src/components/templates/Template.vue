<template>
  <div class="myNavComponent">
    <statlete-navbar @shouldOpenNav="openNav"
                     @shouldLogout="logout"></statlete-navbar>

    <side-nav id="mySidenav"
              @showPlayer="showPlayer"
              @showTeam="showTeam"
              @teamSelected="teamSelected">
    </side-nav>

    <!-- Insert content here -->

  </div>
</template>

<script>
import firebase from 'firebase'
import { mapGetters, mapMutations } from 'vuex';
export default {
  name: 'Main',
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
        document.getElementById("mySidenav").style.width = "250px";
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
    },
    showPlayer: function() {
      //jQuery("#notImplementedAlert").show();
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
<style scoped>
 .myNavComponent {
      transition: margin-left .5s;
      margin:0px;
      min-height: 100%;
  }
</style>
