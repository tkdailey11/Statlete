<template>
    <div class="ExportStats">
        <nav-component />
        <multiselect v-model="selected"
                    :options="playersList"
                    :multiple="true"
                    :close-on-select="true"
                    placeholder="Whole Team"
                    class="es_multiselect">
        </multiselect>

        <button @click="exportStats" class="btn btn-outline-primary main_button">ExportStats</button>
    </div>
</template>

<script>
import { mapGetters } from 'vuex';
import firebase from 'firebase';
import * as jsPDF from 'jspdf'

export default {
    data() {
        return {
            selected: null
        }
    },
    computed: {
        ...mapGetters({
            gamesList: 'mainStore/gamesList',
            selectedTeamId: 'mainStore/selectedTeamId',
            players: 'mainStore/players',
            selectedTeamSport: 'mainStore/selectedTeamSport'
        }),
        playersList: function() {
            var list = []
            var keys = Object.keys(this.players)
            var self = this
            keys.forEach(function(el) {
                var str = el.replace('p', '#')
                if(self.players[el].trim().length != 0){
                    str += ' : ' + self.players[el]
                }
                list.push(str)
            })
            return list
        }
    },
    methods: {
        getRand(){
            return Math.random().toString(36).substring(2,7);
        },
        exportStats: function() {
            var self = this;
            var dataPointsArr = [];
            var playersList = [];
            var removePlayers = []
            if(this.selected == null){
                playersList = Object.keys(this.players)
            }
            else{
                this.selected.forEach(function(el){
                    playersList.push(el.split(' : ')[0].replace('#', 'p'))
                })
                
                removePlayers = Object.keys(this.players).filter(x => !playersList.includes(x));
            }

            var dbRef = null;
            if(this.selectedTeamSport==1){
                dbRef = firebase.database().ref('/SoccerGames/' + this.selectedTeamId);
            }
            else {
                dbRef = firebase.database().ref('/BasketballGames/' + this.selectedTeamId);
            }
            var promisesList = [];
            this.gamesList.forEach(function(el){
                promisesList.push(dbRef.child(el).child('Players').once('value', function(snap){
                    var obj = snap.val()
                    removePlayers.forEach(function(nam){
                        delete obj[nam]
                    })
                    dataPointsArr.push({
                        'GameID' : el,
                        'Data' : obj
                    })
                }))
            })
            Promise.all(promisesList).then(function(vals){
                var doc = new jsPDF();
                var singlePlayerLength = 75;
                var topOffset = 10
                dataPointsArr.forEach(function(el, idx){
                    doc.setFontSize(12)
                    doc.setFontStyle('bold')
                    doc.text(el.GameID, 10, topOffset)
                    topOffset += 2
                    doc.setFontSize(10)
                    doc.setFontStyle('normal')
                    var arr = Object.keys(el.Data)
                    
                    arr.forEach(function(playerNum){
                        topOffset += 5
                        doc.text(playerNum, 15, topOffset)
                        var myArr = el.Data[playerNum]
                        var count = 0
                        var txt = []
                        var txtVals = []
                        for(var entry in myArr){
                            txt.push(entry)
                            txtVals.push(':  ' + myArr[entry])
                            count++;
                        }
                        topOffset += 5
                        doc.text(txt, 20, topOffset)
                        doc.text(txtVals, 45, topOffset)
                        topOffset += (4 * count)
                    })
                    topOffset += 5
                    var myLength = topOffset + (Object.keys(dataPointsArr).length * singlePlayerLength);
                    if(myLength > 1000){
                        doc.addPage()
                        topOffset = 10
                    }
                   
                });
                doc.save('Test-' + self.getRand() + '.pdf')
            })
        }
    }
}
</script>

<style scoped>
    .es_multiselect {
        width: 50%;
        margin-left: 25%;
        margin-top: 10%;
    }
    .main_button {
        margin-top: 20px;
        cursor: pointer;
        height: 50px;
        max-height: 50px;
        margin: 50px;
    }
</style>
