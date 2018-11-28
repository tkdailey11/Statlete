<template>
  <transition name="modal-fade">
    <div class="modal-backdrop">
        <div class="modal-left-pane" @click="close">
        </div>
        <div class="modal-center">
            <div class="ng-modal-header" @click="close">
            </div>
            <div class="modal-body">
                <h1>Edit Stats</h1>

                <label for="playerSelector" style="float: left; margin-top: 2vw;">Player</label>
                <select v-model="playerID" size="1" style="float: left;" id="playerSelector">
                    <option v-for="player in Object.keys(players)" :value="player" :key="player">{{player}}</option>
                </select>

                <label for="periodSelector" style="float: left; margin-top: 2vw;">Period</label>
                <select v-model="periodID" size="1" style="float: left;" id="periodSelector">
                    <option v-for="period in numberOfPeriods" :value="period" :key="period">{{period}}</option>
                </select>

                <label for="statTypeSelector" style="float: left; margin-top: 2vw;">Stat Type</label>
                <select v-if="isSoccer" v-model="selectedStatType" size="1" style="float: left;" id="statTypeSelector">
                    <option v-for="statType in soccerStatsArr" :value="statType" :key="statType">{{statType}}</option>
                </select>
                <select v-else v-model="selectedStatType" size="1" style="float: left;" id="statTypeSelector">
                    <option v-for="statType in basketballStatsArr" :value="statType" :key="statType">{{statType}}</option>
                </select>

                <table class="editStatsTable">
                    <tr v-for="dataPoint in dataPoints" :key="Object.keys(dataPoint)[0]">
                        <td>{{Object.keys(dataPoint)[0]}}</td>
                        <td @click="deleteDataPoint(Object.keys(dataPoint)[0])">DELETE</td>
                    </tr>
                </table>
            </div>
            <div class="ng-modal-footer" @click="close">
            </div>
        </div>
        <div class="modal-right-pane" @click="close">
        </div>
    </div>
  </transition>
</template>
<script>
import firebase from 'firebase'
import { mapGetters, mapMutations } from 'vuex';

export default {
    name: 'esmodal',
    methods: {
        close() {
            this.$emit('close');
        },
        deleteDataPoint(key){
            var period = jQuery('#periodSelector').val();
            var statType = jQuery('#statTypeSelector').val();
            var playerID = jQuery('#playerSelector').val();
            if(this.isSoccer){
                var ref = firebase.database().ref('/SoccerGames').child(this.selectedTeamId).child(this.activeGameId).child('MyTotals')
                            .child('Period' + period).child(statType);
                var playerRef = firebase.database().ref('/SoccerGames').child(this.selectedTeamId).child(this.activeGameId).child('Players')
                            .child(playerID)

                ref.child(key).remove();

                var a = ref.child('Total').once('value', function(snapshot){
                    ref.update({
                        'Total': snapshot.val() - 1
                    })
                });

                playerRef.child(statType).once('value', function(snap){
                    playerRef.update({
                        [statType]: snap.val() - 1
                    })
                })
            }
            else {
                firebase.database().ref('/BasketballGames').child(this.selectedTeamId).child(this.activeGameId).child('MyTotals')
                    .child('Period' + period).child(statType).child(key).remove();
            }
            for(var idx = 0; idx < this.dataPoints.length; idx++){
                if(Object.keys(this.dataPoints[idx])[0] == key){
                    this.dataPoints.pop(this.dataPoints[idx])
                    break
                }
            }
        }
    },
    data() {
        return {
            playerID: '',
            periodID: 0,
            selectedStatType: '',
            dataPoints: []
        }
    },
    props: {
        gameData: null
    },
    watch: {
        playerID: function () {
            var playerID = jQuery('#playerSelector').val();
            var statType = jQuery('#statTypeSelector').val();
            var period = jQuery('#periodSelector').val();
            var periodValid = period > 0;
            var self = this;
            if(playerID && statType && periodValid){
                if(this.isSoccer){
                    self.dataPoints = []
                    firebase.database().ref('/SoccerGames').child(this.selectedTeamId).child(this.activeGameId).child('MyTotals')
                    .child('Period' + period).child(statType).once('value', function(snapshot){
                        Object.keys(snapshot.val()).forEach(key => {
                            if(snapshot.val()[key] == playerID){
                                self.dataPoints.push({
                                    [key]: snapshot.val()[key]
                                })
                            }
                        })
                    })
                }
                else{
                    self.dataPoints = []
                    firebase.database().ref('/BasketballGames').child(this.selectedTeamId).child(this.activeGameId).child('MyTotals')
                    .child('Period' + period).child(statType).once('value', function(snapshot){
                        Object.keys(snapshot.val()).forEach(key => {
                            if(snapshot.val()[key] == playerID){
                                self.dataPoints.push({
                                    [key]: snapshot.val()[key]
                                })
                            }
                        })
                    })
                }
            }
        },
        periodID: function () {
            var period = jQuery('#periodSelector').val();
            var periodValid = period > 0;
            var playerID = jQuery('#playerSelector').val();
            var statType = jQuery('#statTypeSelector').val();
            var self = this;
            if(playerID && statType && periodValid){
                if(this.isSoccer){
                    self.dataPoints = []
                    firebase.database().ref('/SoccerGames').child(this.selectedTeamId).child(this.activeGameId).child('MyTotals')
                    .child('Period' + period).child(statType).once('value', function(snapshot){
                        Object.keys(snapshot.val()).forEach(key => {
                            if(snapshot.val()[key] == playerID){
                                self.dataPoints.push({
                                    [key]: snapshot.val()[key]
                                })
                            }
                        })
                    })
                }
                else{
                    self.dataPoints = []
                    firebase.database().ref('/BasketballGames').child(this.selectedTeamId).child(this.activeGameId).child('MyTotals')
                    .child('Period' + period).child(statType).once('value', function(snapshot){
                        Object.keys(snapshot.val()).forEach(key => {
                            if(snapshot.val()[key] == playerID){
                                self.dataPoints.push({
                                    [key]: snapshot.val()[key]
                                })
                            }
                        })
                    })
                }
            }
        },
        selectedStatType: function () {
            var statType = jQuery('#statTypeSelector').val();
            var playerID = jQuery('#playerSelector').val();
            var period = jQuery('#periodSelector').val();
            var periodValid = period > 0;
            var self = this;
            if(playerID && statType && periodValid){
                if(this.isSoccer){
                    self.dataPoints = []
                    firebase.database().ref('/SoccerGames').child(this.selectedTeamId).child(this.activeGameId).child('MyTotals')
                    .child('Period' + period).child(statType).once('value', function(snapshot){
                        Object.keys(snapshot.val()).forEach(key => {
                            if(snapshot.val()[key] == playerID){
                                self.dataPoints.push({
                                    [key]: snapshot.val()[key]
                                })
                            }
                        })
                    })
                }
                else{
                    self.dataPoints = []
                    firebase.database().ref('/BasketballGames').child(this.selectedTeamId).child(this.activeGameId).child('MyTotals')
                    .child('Period' + period).child(statType).once('value', function(snapshot){
                        Object.keys(snapshot.val()).forEach(key => {
                            if(snapshot.val()[key] == playerID){
                                self.dataPoints.push({
                                    [key]: snapshot.val()[key]
                                })
                            }
                        })
                    })
                }
            }
        }
    },
    computed: {
        ...mapGetters({
            activeGameId: 'mainStore/activeGameId',
            selectedTeamId: 'mainStore/selectedTeamId',
            selectedTeamSport: 'mainStore/selectedTeamSport',
            soccerStatsArr: 'statStore/soccerStatsArr',
            basketballStatsArr: 'statStore/basketballStatsArr',
            numberOfPeriods: 'gameViewStore/numberOfPeriods',
            players: 'mainStore/players'
        }),
        isSoccer: function() {
            return this.selectedTeamSport == 1;
        }
    }
  };
</script>
<style>
    .editStatsTable{
        border: 2px solid black;
        margin-top: 2vw;
        height: 15vw;
    }
    .modal-backdrop {
        background-color: rgba(0, 0, 0, 0.3);
        display: flex;
    }

    .modal-right-pane {
        flex-basis: 10%;
    }

    .modal-left-pane {
        flex-basis: 10%;
    }

    .modal-center {
        display: flex;
        flex-direction: column;
        flex-basis: 80%;
    }

    .ng-modal-header, .ng-modal-footer {
        flex-basis: 10%;
    }

    .modal-body {
        flex-basis: 80%;
        border-radius: 20px;
        display: flex;
        flex-direction: column;
    }

    .ng_input {
        border: 0;
        outline: 0;
        background: transparent;
        border-bottom-width: 1px;
        border-bottom-style: solid;
    }

    .ng_label {
        width: 20%;
        font-size: 15px;
    }

    .es_multiselect {
        width: 60%;
        margin-bottom: 15px;
        float: left;
    }
    .ng_sc {
        float: left;
    }

    .ng-oppEntry{
        flex-basis: 16%;
        display: flex;
        padding: 2vh;
    }

    .ng_label {
        flex-basis: 35%;
        text-align: left;
    }

    .ng-periodLength {
        flex-basis: 16%;
        display: flex;
        padding: 2vh;
    }

    .ng-numPeriods {
        flex-basis: 16%;
        display: flex;
        padding: 2vh;
    }

    .ng-shotChart {
        flex-basis: 16%;
        display: flex;
        padding: 2vh;
    }

    .ng-teamCode {
        flex-basis: 16%;
        display: flex;
        padding: 2vh;
    }

    .ng-submit {
        flex-basis: 20%;
    }

    .ng_right {
        flex-basis: 65%;
    }

    .ng_button {
        width: 100%;
        height: 70%;
    }
</style>