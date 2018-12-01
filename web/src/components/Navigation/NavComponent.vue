<template>
  <div class="myNavComponent">
    <statlete-navbar @shouldOpenNav="openNav"
                     @shouldLogout="logout"></statlete-navbar>
    <side-nav id="mySidenav"
              @showPlayer="showPlayer"
              @showTeam="showTeam"
              @teamSelected="teamSelected"
              @playerSelected="playerSelected"
              @ChangeImage ="changeImage"
              :photoURL="userImageURL">
    </side-nav>
    <photoModal
      v-show="isModalVisible"
      @close="closeModal()"
    />
  </div>
</template>

<script>
import firebase from 'firebase'
import { mapGetters, mapMutations } from 'vuex';
import photoModal from '../UploadPhoto.vue';


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
      this.downloadImage()
  },
  components: {
    photoModal
  },
  data() {
    return {
      isModalVisible: false,
      userImageURL: '../../assets/images/testUser.png'
    }
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
    downloadImage: function() {
      var self = this;
      var ref = firebase.storage().ref().child('/Users/').child(self.currentUserEmail.replace('.', ''));
      ref.getDownloadURL().then(function(url) {
        self.userImageURL = url;
      }).catch(function(error) {
        self.userImageURL = '../../assets/images/testUser.png'
      });
    },
    openNav: function() {
      setTimeout(function(){
        document.getElementById("mySidenav").style = "width: 250px; position: absolute; z-index: 2;";
      }, 90);
    },
    showTeam: function() {
      this.$router.push('/createteam')
    },
    changeImage: function(){
      this.isModalVisible = true
    },
    closeModal: function() {
      this.isModalVisible = false
      location.reload();
    },
    teamSelected: function(event) {
      var sport = event.Sport;
      if(sport.toString().toLowerCase() === 'soccer'){
        sport = 1;
      }
      else if(sport.toString().toLowerCase() === 'basketball') {
        sport = 0;
      }
      else if(sport.toString().toLowerCase() === 'football') {
        sport = 2;
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
    playerSelected: function(event) {
      var sport = event.Sport;
      if(sport.toString().toLowerCase() === 'soccer'){
        sport = 1;
      }
      else if(sport.toString().toLowerCase() === 'basketball') {
        sport = 0;
      }
      else if(sport.toString().toLowerCase() === 'football') {
        sport = 2;
      }

      this.SET_SELECTED_TEAM({
        id: event.Id,
        name: event.Name,
        token: event.Token,
        sport: sport
      });
      this.getGamesPlayer();
      this.$router.push('/playerhome')
    },
    showPlayer: function() {
      this.$router.push('createplayer');
    },
    getGamesTeam() {
      var email = this.currentUserEmail.replace('.', '');
      var self = this;

      var keysList = [];
      var gamesListRef = firebase.database().ref('/TeamSportfolios/' + self.selectedTeamId + '/Games/');
      if (typeof gamesListRef !== 'undefined') {
        gamesListRef.on('value', function(snapshot) {
          var obj = snapshot.val();
          if (obj) {
            self.SET_GAMES_LIST(Object.keys(obj));
          }
        });
      }
    },
    getGamesPlayer(){
      var email = this.currentUserEmail.replace('.', '');
      var self = this;

      var keysList = [];
      var gamesListRef = firebase.database().ref('/PlayerSportfolios/' + self.selectedTeamId + '/Games/');
      if (typeof gamesListRef !== 'undefined') {
        gamesListRef.on('value', function(snapshot) {
          var obj = snapshot.val();
          if (obj) {
            self.SET_GAMES_LIST(Object.keys(obj));
          }
          else {
            self.SET_GAMES_LIST([])
          }
        });
      }
      else{
        self.SET_GAMES_LIST([])
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
