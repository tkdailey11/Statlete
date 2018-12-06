<template>
  <div class="myNavComponent">
    <template>
      <v-toolbar dark>
        <v-toolbar-side-icon @click.stop="drawer = !drawer"></v-toolbar-side-icon>
        <v-toolbar-title @click="goBack">Statlete</v-toolbar-title>
        <v-spacer></v-spacer>
        <v-toolbar-items class="hidden-sm-and-down">
          <v-btn @click="goBack">
            <v-icon>arrow_back</v-icon>
            Back
          </v-btn>
        </v-toolbar-items>
        <v-toolbar-items class="sm">
          <v-btn @click="logout">
            <v-icon>input</v-icon>
            <v-spacer style="width: 5px;"></v-spacer>
            LOGOUT
          </v-btn>
        </v-toolbar-items>
      </v-toolbar>
    </template>
    <template>
      <v-navigation-drawer
        v-model="drawer"
        :mini-variant="mini"
        absolute
        dark
        temporary>
        <v-list class="pa-1">
          <v-list-tile v-if="mini" @click.stop="mini = !mini">
            <v-list-tile-action>
              <v-icon>chevron_right</v-icon>
            </v-list-tile-action>
          </v-list-tile>

          <v-list-tile avatar tag="div">
            <v-list-tile-avatar>
              <img :src="userImageURL" @click.stop="changeImage">
            </v-list-tile-avatar>

            <v-list-tile-content>
              <v-list-tile-title>{{currentUserName}}</v-list-tile-title>
            </v-list-tile-content>

            <v-list-tile-action>
              <v-btn icon @click.stop="mini = !mini">
                <v-icon>chevron_left</v-icon>
              </v-btn>
            </v-list-tile-action>
          </v-list-tile>
        </v-list>

        <v-list>
          <v-list-tile @click.stop="goBack">
            <v-list-tile-action>
              <v-icon>home</v-icon>
            </v-list-tile-action>
            <v-list-tile-title>Home</v-list-tile-title>
          </v-list-tile>

          <v-list-group
            no-action
            prepend-icon="settings"
            :value="false">
              <v-list-tile slot="activator">
                <v-list-tile-title>Settings</v-list-tile-title>
              </v-list-tile>
              <v-list-tile
                @click="changeColor">
                  <v-list-tile-action>
                    <v-icon>color_lens</v-icon>
                  </v-list-tile-action>
                  <v-list-tile-title v-text="'Choose Colors'"></v-list-tile-title>
              </v-list-tile>
          </v-list-group>

          <v-list-group
            prepend-icon="account_circle"
            :value="false">
            <v-list-tile slot="activator">
              <v-list-tile-title>My Sportfolios</v-list-tile-title>
            </v-list-tile>

            <v-list-group
              no-action
              sub-group
              value="true">
              <v-list-tile slot="activator">
                <v-list-tile-action>
                  <v-icon>group</v-icon>
                </v-list-tile-action>
                <v-list-tile-title>Team</v-list-tile-title>
              </v-list-tile>

              <v-list-tile
                v-for="(team, i) in teamSportfolios"
                :key="i"
                @click="selectedTeam(team.id)"
              >
              <v-list-tile-action>
                  <font-awesome-icon v-if="team.sport == 0" icon="basketball-ball" />
                  <font-awesome-icon v-else-if="team.sport == 1" icon="futbol" />
                  <font-awesome-icon v-else icon="football-ball" />
              </v-list-tile-action>
                <v-list-tile-title v-text="team.id"></v-list-tile-title>
              </v-list-tile>
            </v-list-group>

            <v-list-group
              no-action
              sub-group
              :value="false">
              <v-list-tile slot="activator">
                <v-list-tile-action>
                  <v-icon>person</v-icon>
                </v-list-tile-action>
                <v-list-tile-title>Player</v-list-tile-title>
              </v-list-tile>

              <v-list-tile
                v-for="(player, i) in playerSportfolios"
                :key="i"
                @click="selectedTeam(player.id)"
              >
              <v-list-tile-action>
                  <font-awesome-icon v-if="player.sport == 0" icon="basketball-ball" />
                  <font-awesome-icon v-else-if="player.sport == 1" icon="futbol" />
                  <font-awesome-icon v-else icon="football-ball" />
              </v-list-tile-action>
              <v-list-tile-title v-text="player.id"></v-list-tile-title>
                
              </v-list-tile>
            </v-list-group>
          </v-list-group>

          <v-list-group
            no-action
            prepend-icon="add_circle"
            :value="false">
            <v-list-tile slot="activator">
              <v-list-tile-title>Add New Sportfolios</v-list-tile-title>
            </v-list-tile>
            <v-list-tile
              @click="showTeam">
              <v-list-tile-action>
                <v-icon>group_add</v-icon>
              </v-list-tile-action>
              <v-list-tile-title v-text="'New Team Sportfolio'"></v-list-tile-title>
            </v-list-tile>
            <v-list-tile
              @click="showPlayer">
              <v-list-tile-action>
                <v-icon>person_add</v-icon>
              </v-list-tile-action>
              <v-list-tile-title v-text="'New Player Sportfolio'"></v-list-tile-title>
            </v-list-tile>
          </v-list-group>
        </v-list>

        <v-btn flat color="red" @click="drawer = false">Close</v-btn>
      </v-navigation-drawer>
    </template>
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
      gamesList: 'mainStore/gamesList',
      currentUserName: 'mainStore/currentUserName'
    })
  },
  async created() {
    this.getTeamSportfolios()
    await this.getPlayerSportfolios()
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
      userImageURL: 'src/assets/images/testUser.png',
      drawer: null,
      items: [
        { title: 'Home', icon: 'dashboard' },
        { title: 'About', icon: 'question_answer' }
      ],
      mini: true,
      right: null,
      admins: [
        ['Management', 'people_outline'],
        ['Settings', 'settings']
      ],
      teamSportfolios: [],
      playerSportfolios: []
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
    changeColor: function() {
      this.drawer = !this.drawer
      this.$emit('ChangeColor')
    },
    logout: function() {
      firebase.auth().signOut().then(() => {
        this.CLEAR_STATE();
        this.GV_CLEAR_STATE();
        this.$router.replace('login')
        
      })
    },
    getPlayerSportfolios: async function() {
      var emailStr = this.currentUserEmail;
      var email = emailStr.replace('.', '');
      var self = this
      firebase.database().ref('Users/' + email + '/PlayerTeams').on('value', function(snapshot){
        var obj = snapshot.val()
        var ref = firebase.database().ref('PlayerSportfolios');
        if (obj) {
          self.playerSportfolios = []
          var promises = []
          Object.values(obj).forEach(key => {
            promises.push(ref.child(key).once('value', function(snap){
              self.playerSportfolios.push({
                sport: typeof snap.val().Sport !== 'undefined' ? snap.val().Sport : 0,
                id: key
              })
            }))
          });

          Promise.all(promises).then(() =>{
            console.log("players loaded")
          })

        }
      });
    },
    getTeamSportfolios: function() {
      var emailStr = this.currentUserEmail;
      var email = emailStr.replace('.', '');
      var self = this
      firebase.database().ref('Users/' + email + '/AdminTeams').on('value', function(snapshot){
        var obj = snapshot.val()
        var ref = firebase.database().ref('TeamSportfolios');
        if (obj) {
          self.teamSportfolios = []
          var promises = []
          Object.keys(obj).forEach(key => {
            promises.push(ref.child(key).once('value', function(snap){
              self.teamSportfolios.push({
                sport: typeof snap.val().Sport !== 'undefined' ? snap.val().Sport : 0,
                id: key
              })
            }))
          });

          Promise.all(promises).then(() =>{
            console.log("teams loaded")
          })
        }
      });
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
      // setTimeout(function(){
      //   document.getElementById("mySidenav").style = "width: 250px; position: absolute; z-index: 2;";
      // }, 90);
    },
    showTeam: function() {
      this.$router.push('/createteam')
    },
    changeImage: function(){
      var message = "Do you want to upload a new image?"
        var options = {
          okText: 'YES',
          cancelText: 'NO',
          animation: 'bounce'
        }
        var self = this;
        self.$dialog.confirm(message, options).then(function() {
          self.isModalVisible = true
        })
      
    },
    closeModal: function() {
      this.isModalVisible = false
      location.reload();
    },
    selectedTeam(id){
      var self = this;
      firebase.database().ref('TeamSportfolios').child(id).once('value', function(snapshot){
        var obj = snapshot.val();
        var name = obj.TeamName;
        var sport = obj.Sport;
        if(sport.toString().toLowerCase() === 'soccer'){
          sport = 1;
        }
        else if(sport.toString().toLowerCase() === 'basketball') {
          sport = 0;
        }
        else if(sport.toString().toLowerCase() === 'football') {
          sport = 2;
        }

        self.SET_SELECTED_TEAM({
          id: id,
          name: name.split('|')[0],
          token: obj.Token,
          sport: sport
        });

        self.getGamesTeam();
        self.getPlayers();
        self.drawer = !self.drawer
        location.reload();
      });
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
    },
    goBack: function() {
      if(!(this.$route.path.includes('main') || this.$route.path.includes('playerhome'))){
        this.$router.go(-1);
      }
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

  .wrap {
    height: 0px;
    background-color: green;
  }
</style>
