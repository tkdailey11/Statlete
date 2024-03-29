<template>
  <div id="GameView">
    <nav-component />
    <div class="GV_Container">
      <div class="TopBanner">
          <h1 class="GV_NAME">{{selectedTeamName}}</h1>
          <time-clock class="GV_Clock"
                      @ClockClicked="clockClicked"
                      :time="currTime"
                      :activePeriod="activePeriod"
                      @PauseClicked="pauseClicked"
                      :btnEnabled="pauseEnabled"
                      :myScore="myScore"
                      :oppScore="oppScore"
                      :setToPause="setBtnToPause">
          </time-clock>
      </div>
      <div class="GV_Body">
        <esmodal
          v-show="isModalVisible"
          @close="closeESModal()"
        />
        <div id="EntryView">
          <div id="entryDiv">
            <div id="statEntry">
              <player-stat-selector id="GV_pss"
                                    :players="players"
                                    :height="'height: 500px;'"
                                    @playerSelected="playerWasSelected"></player-stat-selector>
              <sb-data-entry id="sbde1"
                            :height="'height: 500px;'"
                            :isActive="gameLive"
                            @StatChange="updateDB"
                            :gameID="activeGameId"></sb-data-entry>
            </div>
            <div id="possesionDiv">
              <v-radio-group v-if="isSoccer" v-model="hasPoss" :light="true">
                <v-radio :label="'My Team'" :value="1" />
                <v-radio :label="'None'" :value="0" />
                <v-radio :label="'Opponent'" :value="2" />
              </v-radio-group>
            </div>
          </div>
          <div id="fieldDiv">
            <sb-field class="GV_field"
                      :shots="shotsArr"
                      @ShotPlaced="shotPlaced">
            </sb-field>
            <sb-shot-type class="GV_shotType"
                          @ShotTypeChanged="shotTypeChanged"
                          @SBSTUndo="undoClicked">
            </sb-shot-type>
          </div>
          <div id="statDiv">
            <team-stats class="GV_statsTable"
                        @EditStats="showESModal" />
          </div>
          <div id="playDiv">
            <div class="playsTableContainer">
              <table class="playsTable">
                <thead class="playsHeader">
                  <th>Team</th>
                  <th colspan="2">Play</th>
                </thead>
                <tbody v-for="period in Object.keys(plays)" :key="period + '-key'">
                  <tr class="periodRow"><td colspan="3">{{period}}</td></tr>
                  <tr v-for="playKey in Object.keys(plays[period])" :key="period + '-' + playKey">
                    <td class="myTeamPlay" v-if="plays[period][playKey].split(' | ')[0] == 0">MY TEAM</td>
                    <td class="oppPlay" v-else>OPPONENT</td>
                    <td class="tdSeparator"></td>
                    <td class="playDescr">{{plays[period][playKey].split(' | ')[1]}}</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
        <div class="toggleContainer">
          <div id="toggleViewDiv">
            <div id="entryMode" @click="toggleEntryClicked()">
              Entry
            </div>
            <div id="chartMode" @click="toggleChartClicked()">
              Shots
            </div>
            <div id="statMode" @click="toggleStatClicked()">
              Stats
            </div>
            <div id="playMode" @click="togglePlayClicked()">
              Plays
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  import firebase from 'firebase'
  import { mapGetters, mapMutations } from 'vuex';

  import esmodal from '../EditStatsModal.vue';

  export default {
    name: 'GameView',
    data () {
      return {
        currTime: '00:00',
        activePeriod: 1,
        activeInterval: null,
        shouldStartClock: false,
        inProgress: false,
        gameLive: false,
        currentPlayer: '',
        myScore: 0,
        oppScore: 0,
        timeRemaining: 0,
        pauseEnabled: true,
        isModalVisible: false,
        hasPoss: 0,
        hadPossession: 0,
        possessionTimestamp: '00:00',
        setBtnToPause: false
      }
    },
    mounted() {
      jQuery("#statDiv").hide()
      jQuery("#fieldDiv").hide()
      jQuery("#playDiv").hide()
      var ref = null;
      var self = this;

      if(this.isSoccer){
        self.GV_SET_NUM_PERIODS(2);
        ref = firebase.database().ref('/SoccerGames/').child(this.selectedTeamId).child(this.activeGameId);
        ref.child('HalfLength').once('value', function(snap){
          self.GV_SET_PERIOD_LENGTH(snap.val());
        })
      }
      else{
        ref = firebase.database().ref('/BasketballGames/').child(this.selectedTeamId).child(this.activeGameId);
        ref.child('NumberOfPeriods').once('value', function(snap){
          if(snap.val()){
            self.GV_SET_NUM_PERIODS(snap.val());
          }
          else {
            self.GV_SET_NUM_PERIODS(4);
          }
        })
        ref.child('PeriodLength').once('value', function(snap){
          self.GV_SET_PERIOD_LENGTH(snap.val());
          self.currTime = snap.val() + ':00';
          
          ref.child('TimeRemainingInPeriod').once('value', function(snap){
            self.GV_SET_TIME_REMAINING(snap.val());
            self.timeRemaining = snap.val()
            self.currTime = self.secondsToMinutesString(snap.val())
          })
        })
        
      }

      ref.child('Plays').on('value', function(snapshot){
        if(snapshot.val()){
          self.GV_SET_PLAYS(snapshot.val())
        }
      })
      
      ref.child('Live').on('value', function(snap){
        self.gameLive = snap.val()
        if(!self.gameLive){
          self.currTime = 'FINAL'
        }
      })
      ref.child('Period').on('value', function(snap){
        self.activePeriod = snap.val()
      })
      
      ref.child('PeriodStartTime').on('value', function(snap){
        self.GV_SET_PERIOD_START_TIME(snap.val());
        //compute time remaining
        ref.child('InProgress').on('value', function(snap){
          self.inProgress = snap.val()
          if(self.inProgress){
            self.activeInterval = setInterval(self.updateTime, 1000);
            self.setBtnToPause = true
          }
        })
      })

      ref.child('MyTotals').on('value', function(snapshot){
        var val = snapshot.val();
        self.myScore = self.computeScore(val);
      })
      ref.child('OpponentsTotals').on('value', function(snapshot2){
        var val2 = snapshot2.val();
        self.oppScore = self.computeScore(val2);
      })
    },
    components: {
      esmodal
    },
    computed: {
      ...mapGetters({
        activeGameId: 'mainStore/activeGameId',
        players: 'mainStore/players',
        selectedTeamId: 'mainStore/selectedTeamId',
        selectedPlayer: 'gameViewStore/selectedPlayer',
        selectedTeamName: 'mainStore/selectedTeamName',
        selectedTeamSport: 'mainStore/selectedTeamSport',
        statString: 'gameViewStore/statString',
        shotType: 'gameViewStore/shotType',
        shotsArr: 'gameViewStore/shotsArr',
        shotsArrLength: 'gameViewStore/shotsArrLength',
        periodStartTime: 'gameViewStore/periodStartTime',
        currGameTime: 'gameViewStore/currGameTime',
        periodLength: 'gameViewStore/periodLength',
        numberOfPeriods: 'gameViewStore/numberOfPeriods',
        timeRemainingInPeriod: 'gameViewStore/timeRemainingInPeriod',
        plays: 'gameViewStore/plays',
        myColor: 'mainStore/myColor',
        oppColor: 'mainStore/oppColor'
      }),
      isSoccer: function() {
        return this.selectedTeamSport == 1;
      },
      isBasketball: function() {
        return this.selectedTeamSport == 0;
      }
    },
    methods: {
      ...mapMutations({
        GV_SET_PLAYER: 'gameViewStore/GV_SET_PLAYER',
        GV_SET_STAT_STRING: 'gameViewStore/GV_SET_STAT_STRING',
        GV_SET_SHOT_TYPE: 'gameViewStore/GV_SET_SHOT_TYPE',
        GV_SET_SHOTS_ARR: 'gameViewStore/GV_SET_SHOTS_ARR',
        GV_APPEND_SHOT: 'gameViewStore/GV_APPEND_SHOT',
        GV_REMOVE_SHOT: 'gameViewStore/GV_REMOVE_SHOT',
        GV_SET_PERIOD_START_TIME: 'gameViewStore/GV_SET_PERIOD_START_TIME',
        GV_SET_CURR_GAME_TIME: 'gameViewStore/GV_SET_CURR_GAME_TIME',
        GV_SET_PERIOD_LENGTH: 'gameViewStore/GV_SET_PERIOD_LENGTH',
        GV_SET_NUM_PERIODS: 'gameViewStore/GV_SET_NUM_PERIODS',
        GV_SET_TIME_REMAINING: 'gameViewStore/GV_SET_TIME_REMAINING',
        GV_APPEND_PLAY: 'gameViewStore/GV_APPEND_PLAY',
        GV_SET_PLAYS: 'gameViewStore/GV_SET_PLAYS'
      }),
      setMyTeamColor(){
        var self = this;
        jQuery('.myTeamPlay').each(function(){
          jQuery(this).css('background-color', self.myColor)
        })
      },
      setOppColor(){
        var self = this;
        jQuery('.oppPlay').each(function(){
          jQuery(this).css('background-color', self.oppColor)
        })
      },
      showESModal() {
        this.isModalVisible = true;
      },
      closeESModal() {
        this.isModalVisible = false;
      },
      possessionChanged(){
        var ref = firebase.database().ref('/SoccerGames').child(this.selectedTeamId).child(this.activeGameId);
        switch(this.hasPoss){
          case 1:
            if(this.hadPossession == 2){
              //Opponent's possession has ended
              var seconds = this.getTimeDifference(this.currTime, this.possessionTimestamp)
              ref = ref.child('OpponentsTotals')
              ref.child('Possession').once('value', function(snapshot){
                var total = parseInt(snapshot.val()) + seconds
                ref.update({
                  'Possession': total
                })
              })
            }
            this.possessionTimestamp = this.currTime;
            this.hadPossession = 1;
            break;
          case 2:
            if(this.hadPossession == 1){
              //My Team's possession has ended
              var seconds = this.getTimeDifference(this.currTime, this.possessionTimestamp)
              ref = ref.child('MyTotals')
              ref.child('Possession').once('value', function(snapshot){
                var total = parseInt(snapshot.val()) + seconds
                ref.update({
                  'Possession': total
                })
              })
            }
            this.possessionTimestamp = this.currTime;
            this.hadPossession = 2;
            break;
          default:
            var seconds = this.getTimeDifference(this.currTime, this.possessionTimestamp)
            if(this.hadPossession == 1){
              var seconds = this.getTimeDifference(this.currTime, this.possessionTimestamp)
              ref = ref.child('MyTotals')
              ref.child('Possession').once('value', function(snapshot){
                var total = parseInt(snapshot.val()) + seconds
                ref.update({
                  'Possession': total
                })
              })
            }
            else if(this.hadPossession == 2){
              var seconds = this.getTimeDifference(this.currTime, this.possessionTimestamp)
              ref = ref.child('OpponentsTotals')
              ref.child('Possession').once('value', function(snapshot){
                var total = parseInt(snapshot.val()) + seconds
                ref.update({
                  'Possession': total
                })
              })
            }
            this.hadPossession = 0;
            break;
        }
      },
      getTimeDifference(current, previous){
        var currArr = current.split(':')
        var currNums = [0,0]
        currNums[0] = parseInt(currArr[0])
        currNums[1] = parseInt(currArr[1])

        var prevArr = previous.split(':')
        var prevNums = [0,0]
        prevNums[0] = parseInt(prevArr[0])
        prevNums[1] = parseInt(prevArr[1])

        var diff = (currNums[0] - prevNums[0]) * 60
        diff += (currNums[1] - prevNums[1])
        return diff;
      },
      pauseClicked(){
        var self = this;
        if(this.currTime.toLowerCase() === "final"){
          return;
        }
        var gameData = {
          'InProgress': !this.inProgress
        }
        var ref = firebase.database().ref('/BasketballGames').child(self.selectedTeamId).child(self.activeGameId);
        //Start
        if(!this.inProgress){
          var d = new Date();
          var elapsedSeconds = Math.round(d.getTime() / 1000);
          gameData['TimeClockStarted'] = elapsedSeconds
          ref.update(gameData)
          self.GV_SET_PERIOD_START_TIME(elapsedSeconds);
          this.activeInterval = setInterval(self.updateTime, 1000);
        }
        //Pause
        else {
          clearInterval(this.activeInterval)
          this.inProgress = false
          ref.update({
            InProgress: false,
            TimeRemainingInPeriod: self.timeRemaining
          })
        }
      },
      computeScore(val){
        var score = 0;
        if(this.isSoccer){
          score += val.Period1.Goals.Total;
          score += val.Period2.Goals.Total;
        }
        else {
          score += val.Period1.FTM.Total;
          score += (2 * val.Period1.FG2M.Total);
          score += (3 * val.Period1.FG3M.Total);

          score += val.Period2.FTM.Total;
          score += (2 * val.Period2.FG2M.Total);
          score += (3 * val.Period2.FG3M.Total);

          if(this.numberOfPeriods == 4){
            score += val.Period3.FTM.Total;
            score += (2 * val.Period3.FG2M.Total);
            score += (3 * val.Period3.FG3M.Total);

            score += val.Period4.FTM.Total;
            score += (2 * val.Period4.FG2M.Total);
            score += (3 * val.Period4.FG3M.Total);
          }
        }
        return score;
      },
      toggleEntryClicked(){
        var entryDisplayed = jQuery('#entryDiv').css('display') != 'none';
        var fieldDisplayed = jQuery('#fieldDiv').css('display') != 'none';
        var statDisplayed = jQuery('#statDiv').css('display') != 'none';
        var playDisplayed = jQuery('#playDiv').css('display') != 'none';

        if(entryDisplayed){
        }
        else if(fieldDisplayed){
          jQuery('#fieldDiv').slideUp(350)
          jQuery('#entryDiv').slideDown(350)
        }
        else if(statDisplayed) {
          jQuery('#statDiv').slideUp(350)
          jQuery('#entryDiv').slideDown(350)
        }
        else {
          jQuery('#playDiv').slideUp(350)
          jQuery('#entryDiv').slideDown(350)
        }
      },
      toggleChartClicked(){
        var entryDisplayed = jQuery('#entryDiv').css('display') != 'none';
        var fieldDisplayed = jQuery('#fieldDiv').css('display') != 'none';
        var statDisplayed = jQuery('#statDiv').css('display') != 'none';
        var playDisplayed = jQuery('#playDiv').css('display') != 'none';

        if(fieldDisplayed){
        }
        else if(entryDisplayed){
          jQuery('#entryDiv').slideUp(350)
          jQuery('#fieldDiv').slideDown(350)
        }
        else if(statDisplayed) {
          jQuery('#statDiv').slideUp(350)
          jQuery('#fieldDiv').slideDown(350)
        }
        else {
          jQuery('#playDiv').slideUp(350)
          jQuery('#fieldDiv').slideDown(350)
        }
      },
      toggleStatClicked(){
        var entryDisplayed = jQuery('#entryDiv').css('display') != 'none';
        var fieldDisplayed = jQuery('#fieldDiv').css('display') != 'none';
        var statDisplayed = jQuery('#statDiv').css('display') != 'none';
        var playDisplayed = jQuery('#playDiv').css('display') != 'none';

        if(statDisplayed){
        }
        else if(entryDisplayed){
          jQuery('#entryDiv').slideUp(350)
          jQuery('#statDiv').slideDown(350)
        }
        else if(fieldDisplayed){
          jQuery('#fieldDiv').slideUp(350)
          jQuery('#statDiv').slideDown(350)
        }
        else {
          jQuery('#playDiv').slideUp(350)
          jQuery('#statDiv').slideDown(350)
        }
      },
      togglePlayClicked(){
        var entryDisplayed = jQuery('#entryDiv').css('display') != 'none';
        var fieldDisplayed = jQuery('#fieldDiv').css('display') != 'none';
        var statDisplayed = jQuery('#statDiv').css('display') != 'none';
        var playDisplayed = jQuery('#playDiv').css('display') != 'none';

        if(playDisplayed){
        }
        else if(entryDisplayed){
          jQuery('#entryDiv').slideUp(350)
          jQuery('#playDiv').slideDown(350)
        }
        else if(fieldDisplayed){
          jQuery('#fieldDiv').slideUp(350)
          jQuery('#playDiv').slideDown(350)
        }
        else {
          jQuery('#statDiv').slideUp(350)
          jQuery('#playDiv').slideDown(350)
        }
      },
      clockClicked(event){
        if(this.currTime.toLowerCase() === "final" || !this.isSoccer){
          return;
        }
        //Start a Period
        else if(!this.inProgress){
          var d = new Date();
          var elapsedSeconds = Math.round(d.getTime() / 1000);
          var message = "Start Game?";
          var gameData = {
            InProgress: true,
            PeriodStartTime: elapsedSeconds
          }
          if(this.activePeriod == 2){
            message = "Start 2nd Half?";
          }

          var options = {
            okText: 'YES',
            cancelText: 'NO',
            animation: 'bounce'
          }
          var self = this;
          self.$dialog.confirm(message, options).then(function() {
            //YES
            var ref = firebase.database().ref('/SoccerGames').child(self.selectedTeamId).child(self.activeGameId);

            var result = {};
            var d = new Date();
            var elapsedSeconds = Math.round(d.getTime() / 1000);

            ref.update(gameData)

            self.GV_SET_PERIOD_START_TIME(elapsedSeconds);
            self.activeInterval = setInterval(self.updateTime, 1000);
          }).catch(function() {
            //NO
          })
        }
        //End Game
        else if(this.activePeriod == this.numberOfPeriods){
          //end the game
          var message = "End Game?";
          var options = {
            okText: 'YES',
            cancelText: 'NO',
            animation: 'bounce'
          }
          var self = this;
          self.$dialog.confirm(message, options).then(function() {
            clearInterval(self.activeInterval);
            self.currTime = 'FINAL'
            var ref = firebase.database().ref('/SoccerGames').child(self.selectedTeamId).child(self.activeGameId);
            var result = '';
            if(self.myScore == self.oppScore){
              result = 'T'
            }
            else if(self.myScore > self.oppScore){
              result = 'W'
            }
            else{
              result = 'L'
            }

            ref.update({
              InProgress: false,
              Live: false,
              Period: -1,
              Result: result
            })
          })
        }
        //End a Period
        else {
          var message = "End 1st Half?";
          if(this.numberOfPeriods == 4){
            if(this.activePeriod == 1){
              message = "End 1st Quarter?";
            }
            else if(this.activePeriod == 3){
              message = "End 3rd Quarter?";
            }
          }
          var options = {
            okText: 'YES',
            cancelText: 'NO',
            animation: 'bounce'
          }
          var self = this;
          self.$dialog.confirm(message, options).then(function() {
            clearInterval(self.activeInterval);
            self.currTime = '00:00';
            var dbRoot = '/BasketballGames';
            if(self.isSoccer){
              dbRoot = '/SoccerGames';
            }
            var prd = self.activePeriod + 1;
            var ref = firebase.database().ref(dbRoot).child(self.selectedTeamId).child(self.activeGameId);
            ref.update({
              Period: prd,
              InProgress: false
            })

          }).catch(function() {

          })
        }
      },
      playerWasSelected(event) {
        this.currentPlayer = event
      },
      stringifyStatType(stat){
        if(this.isSoccer){
          if(stat.endsWith('es')){
            stat = stat.substring(0, stat.length - 2)
          }
          else if(stat.endsWith('s')){
            stat = stat.slice(0, -1)
          }
        }
        else if(this.isBasketball){
          switch(stat){
            case 'AST':
              stat = 'Assist';
              break;
            case 'BLK':
              stat = 'Block';
              break;
            case 'DREB':
              stat = 'Defensive Rebound';
              break;
            case 'FG2A':
              stat = '2pt shot missed';
              break;
            case 'FG2M':
              stat = '2pt shot made';
              break;
            case 'FG3A':
              stat = '3pt shot missed';
              break;
            case 'FG3M':
              stat = '3pt shot made';
              break;
            case 'FTA':
              stat = 'Free Throw missed';
              break;
            case 'FTM':
              stat = 'Free Throw made';
              break;
            case 'OREB':
              stat = 'Offensive Rebound';
              break;
            case 'PF':
              stat = 'Personal Foul';
              break;
            case 'STL':
              stat = 'Steal';
              break;
            case 'TOV':
              stat = 'Turnover';
              break;
            default:
              stat = stat.toLowerCase();
          }
        }
        return stat
      },
      updateDB(event){
        var self = this;
        var input = event.split(":");
        var statPeriod = this.activePeriod;
        if(!(statPeriod && statPeriod >= 1)){
          statPeriod = 1
        }
        var period = 'Period' + statPeriod
       
        if(this.isSoccer){
          var dbRefGame = firebase.database().ref('SoccerGames/').child(self.selectedTeamId).child(self.activeGameId)
          
          var player = self.currentPlayer;
          var myTeamStat = true;
          if(player.startsWith('p')){
            var refPlayer = dbRefGame.child('Players').child(player);
            refPlayer.child(input[1]).once('value', function(snapshot){
              var tot = snapshot.val() + 1;
              var key = input[1];
              refPlayer.update({
                [key]: tot
              })
            })
          }
          var dbRef = null;
          if(player === 'otherTeam'){
            dbRef = dbRefGame.child('OpponentsTotals').child(period).child(input[1]);
            player = ' ';
            myTeamStat = false;
          }
          else{
            dbRef = dbRefGame.child('MyTotals').child(period).child(input[1]);
          }
          
          dbRef.child('Total').once('value', function(snapshot){
            var tot = snapshot.val() + 1;
            var time = self.currTime;
            var minutes = parseInt(time.split(':')[0]) + ((statPeriod - 1) * self.periodLength);
            if(minutes > 10) {
              time = minutes+':'+time.split(':')[1]
            }
            else {
              time = '0'+minutes+':'+time.split(':')[1]
            }
            if(player.length == 0){
              player = ' ';
            }
            dbRef.update({
              Total : tot,
              [time] : player
            })
          })

          var playRef = dbRefGame.child('Plays').child(period);
          playRef.once('value', function(snapshot){
            var playCount = 0;
            if(typeof snapshot.val() === 'object'){
              playCount = Object.keys(snapshot.val()).length;
            }
            
            var key = 'Play' + playCount
            var play = myTeamStat ? '0 | ' : '1 | ';
            play += self.currTime + ' - '
            play += self.stringifyStatType(input[1])
            if (player.startsWith('p')){
              var playerNum = player.replace('p', '#')
              play += ' ' + playerNum + ' ' + self.players[player]
            }

            playRef.update({
              [key]: play
            })
          })
        }
        else{
          var dbRefGame = firebase.database().ref('BasketballGames/').child(self.selectedTeamId).child(self.activeGameId)
          
          var player = self.currentPlayer;
          var myTeamStat = true;
          if(player.startsWith('p')){
            var refPlayer = dbRefGame.child('Players').child(player);
            refPlayer.child(input[1]).once('value', function(snapshot){
              var tot = snapshot.val() + 1;
              var key = input[1];
              refPlayer.update({
                [key]: tot
              })
            })
          }
          var dbRef = null;
          if(player === 'otherTeam'){
            dbRef = dbRefGame.child('OpponentsTotals').child(period).child(input[1]);
            player = ' ';
            myTeamStat = false;
          }
          else{
            dbRef = dbRefGame.child('MyTotals').child(period).child(input[1]);
          }
          dbRef.child('Total').once('value', function(snapshot){
            var tot = snapshot.val() + 1;
            var time = self.currTime;
            var minutes = parseInt(time.split(':')[0]) + ((statPeriod - 1) * self.periodLength);
            if(minutes > 10) {
              time = minutes+':'+time.split(':')[1]
            }
            else {
              time = '0'+minutes+':'+time.split(':')[1]
            }
            if(player.length == 0){
              player = ' ';
            }
            dbRef.update({
              Total : tot,
              [time] : player
            })
          })

          var playRef = dbRefGame.child('Plays').child(period);
          
          playRef.once('value', function(snapshot){
            var playCount = 0;
            if(typeof snapshot.val() === 'object'){
              playCount = Object.keys(snapshot.val()).length;
            }
            
            var key = 'Play' + playCount
            var play = myTeamStat ? '0 | ' : '1 | ';
            play += self.currTime + ' - '
            play += self.stringifyStatType(input[1])
            if (player.startsWith('p')){
              var playerNum = player.replace('p', '#')
              play += ' ' + playerNum + ' ' + self.players[player]
            }

            playRef.update({
              [key]: play
            })
          })
        }
        self.com
      },
      updateTime(){
        if(this.isSoccer){
          if(!this.currTime){
            return;
          }
          if(!this.gameLive){
            clearInterval(this.activeInterval);
            this.currTime = 'FINAL';
            return;
          }
          if(!this.inProgress){
            clearInterval(this.activeInterval);
            this.currTime = '00:00'
            return;
          }
          var minutes = parseInt(this.currTime.split(':')[0]);
          if(isNaN(minutes)){
            return;
          }
          if (minutes < this.periodLength) {
            this.currTime = this.getTimeString(this.getTime());
          }
          else {
            clearInterval(this.activeInterval);
            this.currTime = this.periodLength + ':00+';
          }
        }
        else{
          var self = this;
          if(!this.gameLive){
            this.pauseEnabled = false;
            this.timeRemaining = 0;
            this.currTime = 'FINAL';
            return;
          }
          if(this.timeRemaining <= 0){
            clearInterval(this.activeInterval)
            var ref = firebase.database().ref('/BasketballGames').child(self.selectedTeamId).child(self.activeGameId);
            //End game
            if(this.activePeriod == this.numberOfPeriods){
              this.timeRemaining = 0
              this.currTime = 'FINAL';
              ref.update({
                Live: false,
                InProgress: false
              })
            }
            //End Period
            else{
              var prd = self.activePeriod + 1;
              ref.update({
                Period: prd,
                InProgress: false
              })
              this.timeRemaining = this.periodLength * 60
              self.GV_SET_TIME_REMAINING(this.timeRemaining)
              this.currTime = this.secondsToMinutesString(this.timeRemaining)
            }
            return;
          }
          this.timeRemaining -= 1;
          self.GV_SET_TIME_REMAINING(this.timeRemaining)
          this.currTime = this.secondsToMinutesString(this.timeRemaining)
        }
      },
      shotPlaced(event){
        var shotData = {
          style: event.style,
          shotType: this.shotType
        };
        this.GV_APPEND_SHOT(shotData);
      },
      shotTypeChanged(event){
        this.GV_SET_SHOT_TYPE(event);
      },
      undoClicked(){
        if (this.shotsArrLength > 0) {
          this.GV_REMOVE_SHOT();
        }
      },
      getTimeString(time) {
        var minutesString = time.minutes.toString();
        if(time.minutes < 10){
          minutesString = '0' + minutesString;
        }

        var secondsString = time.seconds.toString();
        if(time.seconds < 10){
          secondsString = '0' + secondsString;
        }

        return minutesString + ':' + secondsString;
      },
      getTime() {
        var result = {
          minutes: 0,
          seconds: 0
        }

        if(this.periodStartTime > 0){
          var d = new Date();
          var elapsedSeconds = Math.round(d.getTime() / 1000);
          elapsedSeconds = elapsedSeconds - this.periodStartTime;
          result.minutes = Math.floor(elapsedSeconds / 60);
          result.seconds = elapsedSeconds % 60;
        }
        
        return result;
      },
      secondsToMinutesString(seconds){
        if(seconds <= 0){
          return '00:00';
        }
        var min = Math.floor(seconds/60);
        min = min.toString();
        min = min.padStart(2, '0');
        var sec = seconds%60;
        sec = sec.toString();
        sec = sec.padStart(2, '0');

        return min + ':' + sec;
      }
    },
    watch: {
      plays: {
        handler: function() {
          this.setMyTeamColor()
          this.setOppColor()
        },
        deep: true
      },
      hasPoss: {
        handler: function() {
          this.possessionChanged()
        }
      }
    }
  }
</script>

<style scoped>
  #GameView {
    width: 100vw;
    min-height: 103vh;
    height: 100%;
    margin-top: 0px;
  }
  .GV_Container {
    display: flex;
    flex-direction: column;
  }
  .TopBanner {
    flex-basis: 20%;
    width: 100vw;
    display: flex;
  }
  .GV_NAME {
    flex-basis: 50%;
    font-size: 400%; 
    font-weight: bold;
  }
  .GV_Clock {
    flex-basis: 50%;
  }
  .GV_Body {
    flex-basis: 80%;
    display: flex;
  }
  #EntryView {
    flex-basis: 85%;
    overflow-x: scroll;
  }
  #fieldDiv {
  }

  #entryDiv {
    display: flex;
    flex-direction: column;
  }

  #possesionDiv{
    flex-basis: 20%;
  }

  #statEntry {
    flex-basis: 80%;
  }


  /* #statDiv {
  } */

  .GV_field {
    float: left;
    margin-top: 5%;
    margin-left: 15%;
    margin-right: 15px;
  }
  .GV_shotType {
    float: left;
    margin-top: 5%;
    margin-left: 15px;
    margin-right: 15%;
  }

  .GV_statsTable {
    float: left;
    margin-top: 7%;
    margin-left: 15%;
    margin-right: 15%;
  }

  .TopBanner h1 {
    text-align: center;
    flex-grow: 2;
  }
  #sbde1{
    float: left;
    width: 500px;
    height: 500px;
    border-width: 5px;
    border-style: solid;
    border-radius: 35px;
    position: relative;
    margin-top: 5%;
    margin-left: 15px;
    margin-right: 15%;
  }
  #GV_pss {
    float: left;
    margin-top: 5%;
    margin-left: 15%;
    margin-right: 15px;
  }

  .toggleContainer {
    flex-basis: 15%;
    padding-left: 5%;
    padding-right: 5%;
    padding-top: 3%;
  }
  #toggleViewDiv {
    border-width: 3px;
    border-style: solid;
    border-radius: 20px;
  }

  #entryMode {
    height: 100px; 
    line-height: 100px;
    border-top-left-radius: 15px;
    border-top-right-radius: 15px;
  }

  #chartMode {
    height: 100px; 
    line-height: 100px;
    border-top-style: solid;
    border-top-width: 3px;
    border-bottom-style: solid;
    border-bottom-width: 3px;
  }

  #statMode {
    height: 100px; 
    line-height: 100px;
    border-bottom-style: solid;
    border-bottom-width: 3px;
  }

  #playMode {
    height: 100px; 
    line-height: 100px;
    border-bottom-left-radius: 15px;
    border-bottom-right-radius: 15px;
  }

  .playsTable {
    width: 100%;
  }

  .playsTableContainer {
    border-width: 4px;
    border-style: solid;
    margin: 5vw;
    height: 60vh;
    width: 50vw;
    overflow-y: scroll;
    margin-left: 20vw;
    border-radius: 20px;
  }

  .myTeamPlay {
    border-width: 2px;
    border-style: solid;
    width: 50px;
    font-size: 75%;
  }

  .oppPlay {
    border-width: 2px;
    border-style: solid;
    width: 50px;
    font-size: 75%;
  }

  .tdSeparator {
    width: 10px;
  }

  td {
    padding: 5px;
  }

  .playDescr {
    text-align: left;
  }

  .playsHeader {
  }
</style>
