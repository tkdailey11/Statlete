<template>
    <div>
        <v-stepper v-model="e1" :dark="darkMode">
            <v-stepper-header>
                <v-stepper-step :complete="e1 > 1" step="1">Name and Sport</v-stepper-step>

                <v-divider></v-divider>

                <v-stepper-step :complete="e1 > 2" step="2">Add Players</v-stepper-step>

                <v-divider></v-divider>

                <v-stepper-step :complete="e1 > 3" step="3">Setup Linking Info</v-stepper-step>
            </v-stepper-header>

            <v-stepper-items>
                <v-stepper-content step="1">
                    <v-card class="mb-5"
                            height="200px"
                            id="vcard1PSW">
                        <div id="sportDivPSW">
                            <p>SPORT</p>
                            <v-btn-toggle mandatory v-model="selectedSport" >
                                <v-btn flat>
                                    <font-awesome-icon icon="basketball-ball" />
                                    <v-spacer style="width: 10px;" />
                                    Basketball
                                </v-btn>
                            <v-btn flat>
                                    <font-awesome-icon icon="futbol" />
                                    <v-spacer style="width: 10px;" />
                                    Soccer
                            </v-btn>
                            <v-btn flat>
                                <v-btn flat>
                                    <font-awesome-icon icon="football-ball" />
                                    <v-spacer style="width: 10px;" />
                                    Football
                                </v-btn>
                            </v-btn>
                            </v-btn-toggle>
                        </div>
                        <div id="entryDivPSW">
                            <div id="nameNumPSW">
                                <v-text-field
                                    v-model="teamName"
                                    label="Team Name"
                                    id="nameTxt">
                                </v-text-field>
                            </div>
                        </div>
                    </v-card>
                    <v-btn flat @click="goBack">Cancel</v-btn>
                    <v-btn color="primary"
                        @click="firstPageNextClicked">
                    Continue
                    </v-btn>
                </v-stepper-content>

                <v-stepper-content step="2">
                    <v-card class="mb-5"
                            height="200px"
                            id="vcard2PSW">
          <player-selection-box @playerInfo="setPlayerInfo"
                                :sport="sportName"
                                :playersList="playersList"></player-selection-box>
                    </v-card>

                    <v-btn flat @click="goBack">Cancel</v-btn>
                    <v-btn color="primary"
                        @click="e1 = 3">
                    Continue
                    </v-btn>
                </v-stepper-content>

                <v-stepper-content step="3">
                    <v-card class="mb-5"
                            height="200px"
                            id="vcard2PSW">
                        <div id="tnPSW">
                            <v-text-field
                                v-model="teamID"
                                label="Team ID"
                                id="tn_123">
                            </v-text-field>
                        </div>
                        <div id="ttPSW">
                            <v-text-field
                                v-model="teamToken"
                                label="Team Token"
                                id="tok_123">
                            </v-text-field>
                        </div>
                    </v-card>

                    <v-btn color="primary"
                           @click="submitTeamSportfolio">
                        Submit
                    </v-btn>
                </v-stepper-content>
            </v-stepper-items>
        </v-stepper>
    </div>
</template>

<script>
import firebase from 'firebase'
import { mapGetters, mapMutations } from 'vuex';
import { isNullOrUndefined } from 'util';
  export default {
    data () {
      return {
        e1: 0,
        selectedSport: 0,
        number: '',
        name: '',
        teamID: '',
        teamToken: '',
        teamName: '',
        playersList: []
      }
    },
    computed: {
        ...mapGetters({
            selectedTeamId: 'mainStore/selectedTeamId',
            currentUserEmail: 'mainStore/currentUserEmail',
            darkMode: 'mainStore/darkMode',
            basketballGoals: 'statStore/basketballGoals',
            soccerGoals: 'statStore/soccerGoals',
            footballGoals: 'statStore/footballGoals'
        }),
        sportName: function() {
            if(this.selectedSport == 0){
                return 'basketball'
            }
            else if(this.selectedSport == 1){
                return 'soccer'
            }
            else {
                return 'football'
            }
        }
    },
    methods: {
        ...mapMutations({
            SET_SELECTED_TEAM: 'mainStore/SET_SELECTED_TEAM',
            SET_SELECTED_SPORT: 'mainStore/SET_SELECTED_SPORT',
            SET_PLAYERS: 'mainStore/SET_PLAYERS'
        }),
            setPlayerInfo(event) {
      this.playersList = event;
    },
    firstPageNextClicked(){
        if(this.teamName.length == 0){
            alert('Please enter a team name.')
        }
        else{
            this.e1 = 2
        }
    },
    submitTeamSportfolio(){
        if(this.teamID.replace(/\s/g, "").length == 0){
            alert('Please enter a team ID.')
            return
        }
      var emailStr = this.currentUserEmail;
      var email = emailStr.replace('.', '');
      var nam = this.teamName + '|' + this.selectedSport;
      var tok = this.teamToken;
      var d1 = {}
      if(this.selectedSport == 0){
          d1 = this.basketballGoals
      }
      else if(this.selectedSport == 1){
          d1 = this.soccerGoals
      }
      else {
          d1 = this.footballGoals
      }

      var teamData = {
          "Admins" : {
            [email] : 'admin1'
          },
          "Creator" : email,
          "TeamName" : nam,
          "Token" : tok,
          "Goals" : d1,
          "Sport": this.selectedSport
      }

      var playerObj = {};
      this.playersList.forEach( function (player)
      {
        if(!isNullOrUndefined(player.num) && !isNaN(player.num)){
            var key = 'p' + player.num;
            if(player.name==='') {
                playerObj[key] = ' ';
            }
            else {
                playerObj[key] = player.name;
            }
        }
      });
      teamData.Players = playerObj;
      console.log(teamData)
      var id = this.teamID;
      firebase.database().ref('TeamSportfolios/').update({
        [id] : teamData
      });

      firebase.database().ref('Users/' + email + '/AdminTeams').update({
        [this.teamID] : " "
      });
      
      this.SET_SELECTED_TEAM({
        id: this.teamID,
        name: this.teamName,
        token: this.teamToken,
        sport: this.selectedSport
      })

      this.teamID = ''
      this.teamName = ''
      this.teamToken = ''

    //   this.getGamesTeam();
        this.getPlayers();

      this.$router.push('/main');
    },
        getSportNum: function(sport){
            switch(sport){
                case 'basketball':
                    return 0;
                case 'soccer':
                    return 1;
                default:
                    return 2;
            }
        },
        goBack: function() {
            if(!(this.$route.path.includes('main') || this.$route.path.includes('playerhome'))){
                this.$router.go(-1);
            }
        },
        submitPlayerSportfolio(){
            var emailStr = this.currentUserEmail;
            var email = emailStr.replace('.', '');
            var self = this;
            var playerData = {
                "Name" : this.name,
                "Number" : this.number,
                "TeamID" : this.teamID,
                "TotalStats" : " ",
                "User" : emailStr
            }

            var id = this.name+ '-' + this.teamID;
            var ref = firebase.database().ref('PlayerSportfolios/').child(id).once('value', function(snapshot){
                var obj = snapshot.val()
                if(obj === null || typeof obj === 'undefined'){
                    firebase.database().ref('PlayerSportfolios/').update({
                        [id] : playerData
                    });

                    firebase.database().ref('Users/').child(email).child('PlayerTeams').update({
                        [self.teamID] : id
                    })

                    self.SET_SELECTED_SPORT('basketball');

                    self.teamID = ''
                    self.name = ''
                    self.teamToken = ''
                    self.playerNumber = ''

                    self.getGamesPlayer();
                    self.$router.push('playerHome');
                }
                else{
                    alert('A sportfolio with those settings already exists. Please Try Again.')
                    self.goBack()
                }
            })

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

<style scoped>
#tnPSW {
    flex-basis: 50%;
}
#ttPSW {
    flex-basis: 50%;
}
#vcard2PSW {
    display: flex;
    flex-direction: column;
    padding-left: 5vw;
    padding-right: 5vw;
}
 #vcard1PSW {
     display: flex;
     flex-direction: column;
 }
 #sportDivPSW {
     flex-basis: 50%;
     margin-bottom: 2vh;
 }
 #entryDivPSW {
     flex-basis: 50%;
 }
 #nameNumPSW {
     display: flex;
     margin-left: 5vw;
     margin-right: 5vw;
 }
 #nameTxt {
     flex-basis: 40%;
     padding-right: 5vw;
 }
 #numTxt {
     flex-basis: 40%;
 }
</style>
