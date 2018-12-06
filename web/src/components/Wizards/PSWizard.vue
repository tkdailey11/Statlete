<template>
    <div>
        <v-stepper v-model="e1" :dark="darkMode">
            <v-stepper-header>
                <v-stepper-step :complete="e1 > 1" step="1">Name and Sport</v-stepper-step>

                <v-divider></v-divider>

                <v-stepper-step :complete="e1 > 2" step="2">Linking (Optional)</v-stepper-step>
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
                            <p>Player</p>
                            <div id="nameNumPSW">
                                <v-text-field
                                    v-model="number"
                                    label="Number"
                                    type="number"
                                    id="nameTxt">
                                </v-text-field>
                                <v-text-field
                                    v-model="name"
                                    label="Name"
                                    id="numTxt">
                                </v-text-field>
                            </div>
                        </div>
                    </v-card>

                    <v-btn color="primary"
                        @click="e1 = 2">
                    Continue
                    </v-btn>

                    <v-btn flat @click="goBack">Cancel</v-btn>
                </v-stepper-content>

                <v-stepper-content step="2">
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
                           @click="submitPlayerSportfolio">
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
  export default {
    data () {
      return {
        e1: 0,
        selectedSport: 0,
        number: '',
        name: '',
        teamID: '',
        teamToken: ''
      }
    },
    computed: {
        ...mapGetters({
            selectedTeamId: 'mainStore/selectedTeamId',
            currentUserEmail: 'mainStore/currentUserEmail',
            darkMode: 'mainStore/darkMode'
        })
    },
    methods: {
        ...mapMutations({
            SET_SELECTED_TEAM: 'mainStore/SET_SELECTED_TEAM',
            SET_SELECTED_SPORT: 'mainStore/SET_SELECTED_SPORT'
        }),
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
        getGamesPlayer() {
            var teamIDList = [];
            var emailStr = this.currentUserEmail;
            var email = emailStr.replace('.', '');
            var self = this;

            var keysList = [];
            self.gamesList = [];
            var gamesListRef = firebase.database().ref('/PlayerSportfolios/' + self.selectedTeamId + '/Games/');
            if (typeof gamesListRef !== 'undefined') {
                gamesListRef.on('value', function(snapshot) {
                var obj = snapshot.val();
                if (obj) {
                    self.gamesList = Object.keys(obj);
                }
                });
            }
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
