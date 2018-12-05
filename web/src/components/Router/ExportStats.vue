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

        <button @click="exportStatsNew" class="btn btn-outline-primary main_button">ExportStats</button>
    </div>
</template>

<script>
import { mapGetters } from 'vuex';
import firebase from 'firebase';
import * as jsPDF from 'jspdf'
require('pdfmake/build/pdfmake.js');
require('pdfmake/build/vfs_fonts.js');

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
            selectedTeamName: 'mainStore/selectedTeamName',
            selectedTeamSport: 'mainStore/selectedTeamSport'
        }),
        playersList: function() {
            var list = []
            if(this.selectedTeamSport != 2)
            {
                
            var keys = Object.keys(this.players)
            var self = this
            keys.forEach(function(el) {
                var str = el.replace('p', '#')
                if(self.players[el].trim().length != 0){
                    str += ' : ' + self.players[el]
                }
                list.push(str)
            })}
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
            if(this.selectedTeamSport == 2)
            {
                dbRef = firebase.database().ref('/FootballGames/' + this.selectedTeamId);

                var promisesList = [];
                
                Promise.all(promisesList).then(function(vals){
                    var doc = new jsPDF();
                    var singlePlayerLength = 75;
                    var topOffset = 15
                    doc.setFontSize(25)
                    doc.setFontStyle('bold')
                    doc.text(self.selectedTeamName, 10, topOffset)
                    topOffset += 10
                    dataPointsArr.forEach(function(el, idx){
                        doc.setFontSize(12)
                        doc.setFontStyle('bold')
                        doc.text(el.GameID, 10, topOffset)
                        topOffset += 2
                        doc.setFontSize(10)
                        doc.setFontStyle('normal')
                        var arr = Object.keys(el.Data)
                        
                        topOffset += 5
                        var myLength = topOffset + (Object.keys(dataPointsArr).length * singlePlayerLength);
                        if(myLength > 1000){
                            doc.addPage()
                            topOffset = 15
                        }
                    
                    });
                    doc.save('Test-' + self.getRand() + '.pdf')
                })
            }
            else
            {
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
                    var topOffset = 15
                    doc.setFontSize(25)
                    doc.setFontStyle('bold')
                    doc.text(self.selectedTeamName, 10, topOffset)
                    topOffset += 10
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
                            topOffset = 15
                        }
                    
                    });
                    doc.save('Test-' + self.getRand() + '.pdf')
                })
            }
        },
        exportStatsNew: function() {
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
            if(this.selectedTeamSport==2)
            {
                dbRef = firebase.database().ref('/FootballGames/' + this.selectedTeamId);
                var promisesList = [];
                this.gamesList.forEach(function(el){
                    promisesList.push(dbRef.child(el).once('value', function(snap){
                        var obj = snap.val()
                        var opposingTeamName = obj['OpponentTeamName']
                        var date = obj['Date']
                        var offStats = obj.Totals.Offense;
                        var defStats = obj.Totals.Defense;
                        dataPointsArr.push({
                            'GameID' : el,
                            'Date' : date,
                            'OpposingTeam': opposingTeamName,
                            'Offense': offStats,
                            'Defense': defStats,
                        })
                    }))
                })
                Promise.all(promisesList).then(function(vals){
                    var docDefinition = {
                        content: [
                            { text: ' ', bold: true, fontSize: 8 },
                            self.addGameTables(dataPointsArr)
                        ]
                    }
                    pdfMake.createPdf(docDefinition).download(self.selectedTeamId + '-' + self.getRand() + '.pdf');
                })
            }
            else
            {
                if(this.selectedTeamSport==1){
                    dbRef = firebase.database().ref('/SoccerGames/' + this.selectedTeamId);
                }
                else {
                    dbRef = firebase.database().ref('/BasketballGames/' + this.selectedTeamId);
                }
                var promisesList = [];
                this.gamesList.forEach(function(el){
                    promisesList.push(dbRef.child(el).once('value', function(snap){
                        var obj = snap.val()
                        var players = obj['Players']
                        var opposingTeamName = obj['OpposingTeamName']
                        var date = obj['Date']
                        removePlayers.forEach(function(nam){
                            delete players[nam]
                        })
                        dataPointsArr.push({
                            'GameID' : el,
                            'Date' : date,
                            'OpposingTeam': opposingTeamName,
                            'Players' : players
                        })
                    }))
                })
                Promise.all(promisesList).then(function(vals){
                    var docDefinition = {
                        content: [
                            { text: 'TOTALS', bold: true, fontSize: 24 },
                            { text: ' ', bold: true, fontSize: 8 },
                            self.addTotalsTable(dataPointsArr, 0),
                            { text: ' ', bold: true, fontSize: 16 },
                            { text: 'PER GAME', bold: true, fontSize: 24 },
                            { text: ' ', bold: true, fontSize: 8 },
                            self.addTotalsTable(dataPointsArr, 1),
                            { text: ' ', bold: true, fontSize: 16 },
                            self.addGameTables(dataPointsArr)
                        ]
                    }
                    pdfMake.createPdf(docDefinition).download(self.selectedTeamId + '-' + self.getRand() + '.pdf');
                })
            }
            
        },
        addGameTables(dataPointsArr) {
            var self = this;
            var gamesTables = []
            
            dataPointsArr.forEach(function(el, idx){
                gamesTables.push({
                    text: ' ', 
                    fontSize: 16
                })
                gamesTables.push({
                    text: el.OpposingTeam + ' (' + el.Date + ')', 
                    fontSize: 24
                })
                gamesTables.push({
                    text: ' ', 
                    fontSize: 8
                })
                if(self.selectedTeamSport == 2)
                {
                   gamesTables.push({
                       table: {
                           headerRows:1,
                           body: self.buildGameTableBody(el)
                       }
                   }),
                   gamesTables.push({
                    text: ' ', 
                    fontSize: 8
                }),
                   gamesTables.push({

                       table: {
                           headerRows:1,
                           body: self.buildGameTableBodyDef(el)
                       }
                   })

                }
                else
                {
                     gamesTables.push({
                        table: {
                            headerRows: 1,
                            body: self.buildGameTableBody(el.Players)
                        }
                    })
                }
                
            })

            gamesTables
            return gamesTables
        },
        buildGameTableBodyDef(players) {
            var columnsDef = [];
            columnsDef = [' ',  'INT', 'Sacks', 'TotalPassTD', 'TotalPassYds', 'TotalRushTD', 'TotalRushYds']
            var body = [];
            body.push(columnsDef);

            var dataRow = [];
            dataRow.push('Defense');
            columnsDef.forEach(function(column) {
                if (column != ' ')
                {
                    if(column == 'TotalPassTD' || column == 'TotalRushTD')
                    {
                        dataRow.push(players.Defense[column].toString());
                    }
                    else
                    {
                        console.log("&&&&&&&&&************&&&&&&&&&&")
                        console.log(players.Defense)
                        dataRow.push(players.Defense[column].Total.toString());
                    }
                    
                }
            })
            body.push(dataRow);
            return body;
        },
        buildGameTableBody(players) {
            
            var columnsOff = [];
            if(this.selectedTeamSport==2)
            {
                columnsOff = [' ', 'Fumble', 'INT', 'PassAtt', 'PassComp', 'PassTD', 'PassYds', 'RushCarries', 'RushTD', 'RushYds']
                
                var body = [];
                body.push(columnsOff);

                var dataRow = [];
                dataRow.push('Offense');
                columnsOff.forEach(function(column) {
                    if (column != ' ')
                    {
                        console.log(column)
                        dataRow.push(players.Offense[column].Total.toString());
                        console.log(column)
                    }
                })
                body.push(dataRow);
            }
            else
            {
                if(this.selectedTeamSport==1){
                    columns = ['#', 'Goals', 'Assists', 'Shots on Goal', 'Shots', 'Saves', 'Crosses', 'Corners', 'Offsides', 'Fouls', 'Yellow Cards', 'Red Cards'];
                }
                else {
                    columns = ['#', 'FG2A', 'FG2M', 'FG3A', 'FG3M', 'FTA', 'FTM', 'AST', 'STL', 'BLK', 'OREB', 'DREB', 'TOV', 'PF' ]
                }
                var body = [];

                body.push(columns);

                for (var player in players){
                    var dataRow = [];
                    var playerData = players[player]
                    var number = player.substring(1)
                    dataRow.push(number)

                    columns.forEach(function(column) {
                        if (column != '#') {                        
                            dataRow.push(playerData[column].toString());
                        }
                    })

                    body.push(dataRow);
                }
            }

            return body;
        },
        addTotalsTable(dataPointsArr, perGame) {
            var self = this
            var gamesTables = []
            var players = dataPointsArr[0].Players
            var playersDict = {}
            var columns = []
            if(this.selectedTeamSport==1){
                columns = ['#', 'Goals', 'Assists', 'Shots on Goal', 'Shots', 'Saves', 'Crosses', 'Corners', 'Offsides', 'Fouls', 'Yellow Cards', 'Red Cards'];
            }
            else {
                columns = ['#', 'FG2A', 'FG2M', 'FG3A', 'FG3M', 'FTA', 'FTM', 'AST', 'STL', 'BLK', 'OREB', 'DREB', 'TOV', 'PF' ]
            }
            for (var player in players) { 
                playersDict[player] = {}
                columns.forEach(function(column) {
                    if (column != '#') {
                        playersDict[player][column] = 0
                    }
                })
            }
            dataPointsArr.forEach(function(el, idx){
                var playerStats = el.Players
                for (var player in players) { 
                    var gameStatsForPlayer = playerStats[player]
                    columns.forEach(function(column) {
                        if (column != '#') {
                            playersDict[player][column] += gameStatsForPlayer[column]
                        }
                    })
                }  
            })
            if (Boolean(perGame)) {
                var tempPlayersDict = {}
                var gamesCount = Object.keys(dataPointsArr).length
                for (var player in playersDict) {
                    tempPlayersDict[player] = {}
                    for (var stat in playersDict[player]) {
                        tempPlayersDict[player][stat] = parseFloat(playersDict[player][stat] / gamesCount).toFixed(2);
                    }
                }

                gamesTables.push({
                        table: {
                            headerRows: 1,
                            body: self.buildGameTableBody(tempPlayersDict)
                        }
                    })
                return gamesTables
            }
            else {
                gamesTables.push({
                        table: {
                            headerRows: 1,
                            body: self.buildGameTableBody(playersDict)
                        }
                    })
                return gamesTables
            }
        }
    }
}
</script>

<style scoped>
    .ExportStats {
        height: 100vh;
    }
    .es_multiselect {
        width: 50%;
        margin-left: 20%;
        margin-top: 25vh;
        float: left;
    }
    .main_button {
        margin-top: 24.5vh;
        cursor: pointer;
        height: 50px;
        max-height: 50px;
        float: left;
        margin-left: 20px;
    }
</style>
