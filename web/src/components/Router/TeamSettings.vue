<template>
  <div id="TeamSettings">
    <nav-component />
    <new-admin @newPlayerAdded="hideModal" />
    <div id="settingsBody">
      <div class="TextFieldContainer">
        <v-card dark>
          <v-flex xs9 style="padding-left: 15vw; padding-top: 2vh;">
            <v-text-field
              label="Team ID"
              outline
              disabled
              :value="selectedTeamId">
            </v-text-field>
          </v-flex>
          <v-flex xs9 style="padding-left: 15vw;">
            <v-text-field
              id="teamTokenID"
              label="Team Token"
              append-icon="thumb_up_alt"
              :append-icon-cb="submitToken"
              :value="selectedTeamToken"
              outline>
            </v-text-field>
          </v-flex>
        </v-card>
      </div>
      <div class="ListContainer">
        <v-card dark class="adminLs">
          <v-card-title>ADMINS</v-card-title>
          <v-data-table
            :headers="[{
              text: 'Email',
              align: 'left',
              sortable: false,
              value: 'email'
            },
            {
              text: 'Name',
              align: 'left',
              sortable: false,
              value: 'name'
            }]"
            :items="adminsList"
            class="elevation-1"
            dark>
            <template slot="items" slot-scope="props">
              <tr>
                <td>{{ props.item.email }}</td>
                <td>{{ props.item.name }}</td>
              </tr>
            </template>
          </v-data-table>
          <v-card-actions>
            <v-dialog v-model="dialog" width="500">
              <v-btn slot="activator" flat color="red" dark>Add</v-btn>
              <v-card dark>
                <v-card-title class="headline" primary-title>New Admin</v-card-title>
                <v-flex xs12 style="padding: 2vh;">
                    <v-text-field
                    outline
                    placeholder="Email"
                    id="newAdminEmail">
                    </v-text-field>
                </v-flex>
                <v-divider></v-divider>
                <v-card-actions>
                  <v-spacer></v-spacer>
                  <v-btn color="red" flat @click="submitAdmin">Submit</v-btn>
                </v-card-actions>
              </v-card>
            </v-dialog>
          </v-card-actions>
        </v-card>
        <v-card dark class="playerLs">
          <v-card-title>Players</v-card-title>
          <v-data-table
            :headers="[{
              text: 'Number',
              align: 'left',
              sortable: false,
              value: 'number'
            },
            {
              text: 'Name',
              align: 'left',
              sortable: false,
              value: 'name'
            },
            {
              text: 'Delete',
              align: 'center',
              sortable: false,
              value: 'delete'
            }]"
            :items="playersArr"
            class="elevation-1"
            dark>
            <template slot="items" slot-scope="props">
              <tr>
                <td style="text-align: left;">{{ props.item.number }}</td>
                <td style="text-align: left;">{{ props.item.name }}</td>
                <td><v-btn flat color="red" @click.stop="deletePlayer(props.item.number)">DELETE</v-btn></td>
              </tr>
            </template>
          </v-data-table>
        </v-card>
      </div>
    </div>
  </div>
</template>

<script>
  import firebase from 'firebase'
  import { mapGetters, mapMutations } from 'vuex';

  export default {
    name: 'TeamSettings',
    data: function() {
      return {
        teamID: '',
        token: '',
        admins: [],
        adminsList: [],
        dialog: false
      }
    },
    mounted(){
      var self = this;
      firebase.database().ref('/TeamSportfolios/' + this.selectedTeamId + '/Admins').on('value', function(snapshot){
        self.admins = snapshot.val()
        self.adminsList = []
        console.log('ADMINS')
        console.log(self.admins)
        Object.keys(self.admins).forEach(adminKey => {
          var n = self.admins[adminKey]
          self.adminsList.push({value: false, email: adminKey, name: n})
        })
      })
    },
    props: {
      id: {
        default: 'TeamID'
      },
      tok: {
        default: 'Token'
      }
    },
    computed: {
      ...mapGetters({
        loggedInUser: 'mainStore/loggedInUser',
        selectedTeamId: 'mainStore/selectedTeamId',
        selectedTeamName: 'mainStore/selectedTeamName',
        selectedTeamToken: 'mainStore/selectedTeamToken',
        currentUserEmail: 'mainStore/currentUserEmail',
        activeGameId: 'mainStore/activeGameId',
        players: 'mainStore/players'
      }),
      playersArr: function(){
        var arr = []
        Object.keys(this.players).forEach(p => {
          arr.push({value: false, number: p.replace('p','#'), name: this.players[p]})
        })
        return arr
      }
    },
    methods: {
      ...mapMutations({
        SET_LOGGED_IN_USER: 'mainStore/SET_LOGGED_IN_USER',
        SET_SELECTED_TEAM: 'mainStore/SET_SELECTED_TEAM',
        SET_SELECTED_SPORT: 'mainStore/SET_SELECTED_SPORT',
        SET_ACTIVE_GAME_ID: 'mainStore/SET_ACTIVE_GAME_ID',
        SET_SELECTED_TEAM_ID: 'mainStore/SET_SELECTED_TEAM_ID',
        SET_SELECTED_TEAM_TOKEN: 'mainStore/SET_SELECTED_TEAM_TOKEN',
        SET_PLAYERS: 'mainStore/SET_PLAYERS',
        APPEND_PLAYER: 'mainStore/APPEND_PLAYER',
        DELETE_PLAYER: 'mainStore/DELETE_PLAYER'
      }),
      deletePlayer: function(data){
        var self = this;
        if(confirm('Are you sure you want to delete player ' + data + '?')){
          firebase.database().ref('TeamSportfolios').child(self.selectedTeamId).child('Players').child(data.replace('#', 'p')).remove()
          self.DELETE_PLAYER(data.replace('#', 'p'))
          location.reload()
        }
      },
      submitTeamID: function() {        
        if(confirm('Are you sure you want to change your team\'s ID?')){
          var self = this;
          var newID = jQuery('#teamIDtext').val()
          var oldID = self.selectedTeamId
          
          firebase.database().ref('/TeamSportfolios/' + oldID).once('value', function(snapshot){
            var data = snapshot.val();
            var admin = Object.keys(data.Admins)[0];
            
            //Update Users table
            var ref = firebase.database().ref('/Users/' + admin + '/AdminTeams');
            ref.child(oldID).remove().then(() => {
              return ref.update({ [newID] : " " })
            }).then(function(val){
              return firebase.database().ref('/TeamSportfolios/').update({
                [newID] : data
              })
            }).then(function(val2) {
              return firebase.database().ref('/TeamSportfolios/' + oldID).remove();
            }).then(function(val3){
              self.SET_SELECTED_TEAM_ID(newID);
            });
          });
        }
      },
      submitToken: function() {
        if(confirm('Are you sure you want to change your team\'s token?')){
          var self = this;
          var newToken = jQuery('#teamTokenID').val()
          firebase.database().ref('/TeamSportfolios/' + self.selectedTeamId).update({
            Token: newToken
          })
          self.SET_SELECTED_TEAM_TOKEN(newToken);
        }
      },
      newAdmin: function() {
        this.$modal.show('new-admin')
      },
      hideModal (event) {
        this.$modal.hide('new-admin');
      },
      submitAdmin: async function() {
        var email = jQuery('#newAdminEmail').val()
        var self = this;
        var ref = firebase.database().ref('Users').child(email.replace('.',''));
        ref.once('value', function(snapshot){
          var obj = snapshot.val()
          if(obj !== null && typeof obj !== 'undefined'){
            var AdminTeams = obj.AdminTeams;
            var Name = obj.Name;
            if(typeof AdminTeams !== 'string'){
              ref.child('AdminTeams').update({
                [self.selectedTeamId]: " "
              })
            }
            else{
              ref.update({
                AdminTeams: {[self.selectedTeamId]: " "}
              })
            }
            var otherRef = firebase.database().ref('TeamSportfolios').child(self.selectedTeamId)
            otherRef.once('value', function(snap){
              var adminsObj = snap.val()['Admins']
              adminsObj[email.replace('.','')] = Name
              otherRef.update({
                Admins: adminsObj
              })
            })
          }
          else{
            alert('That user doesn\'t appear to have been created yet. Please have them create an account and try again.')
          }
        })
        this.dialog = false
      }
    }
  }
</script>

<style scoped>
  #TeamSettings {
    width: 100%;
    height: 100%;
    min-height: 100vh;
  }

  .adminLs {
    flex-basis: 50%;
    margin: 2vh 1vw 10vh 5vw;
  }

  .playerLs {
    flex-basis: 50%;
    margin: 2vh 5vw 10vh 5vw;
  }
  input {
    margin: 10px 0;
    width: 30%;
    padding: 15px;
    border: 0;
    outline: 0;
    background: transparent;
    border-bottom: 3px solid rgb(109,8,8);
  }

  .TextFieldContainer {
    flex-basis: 40%;
    padding: 4vw;
  }
  .TextField {
    color: white;
    margin: 20px;
  }
  .MyText {
    min-width: 46vw;
  }
  .ListContainer {
    flex-basis: 60%;
    display: flex;
  }
  .ts_button {
    margin: 20px;
    cursor: pointer;
  }

  #settingsBody {
    display: flex;
    flex-direction: column;
  }
</style>
