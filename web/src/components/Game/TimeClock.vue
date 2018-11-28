<template>
    <div class="TimeClock">
        <!-- My Score -->
        <div id="myTeamScore" style="width: 150px; height: 110px; float: left; padding: 10px 10px 20px 10px; border-right: 5px solid black;">
            <h2>My Team</h2>
            <h2>{{ myScore }}</h2>
        </div>
        <!-- Left Periods -->
        <div style="height: 110px; float: left; padding: 0px 10px 20px 10px;">
            <period-marker style="float: left; margin-top: 25px;" :period="1" :filled="activePeriod == 1"></period-marker>
            <period-marker v-if="numberOfPeriods == 4" style="float: left; margin-top: 25px;" :period="2" :filled="activePeriod == 2"></period-marker>
        </div>
        <!-- Clock -->
        <div style="width: 150px; height: 110px; float: left;">
            <h1 @click="clockClicked" style="padding-top: 5px;">{{time}}</h1>
            <button class="btn clockPause" @click="pauseClicked">{{clockText}}</button>
        </div>
        <!-- Right Periods -->
        <div style="height: 110px; float: left; padding: 0px 10px 20px 10px;">
            <period-marker v-if="numberOfPeriods == 4" style="float: left; margin-top: 25px;" :period="3" :filled="activePeriod == 3"></period-marker>
            <period-marker v-if="numberOfPeriods == 4" style="float: left; margin-top: 25px;" :period="4" :filled="activePeriod == 4"></period-marker>
            <period-marker v-else style="float: left; margin-top: 25px;" :period="2" :filled="activePeriod == 2"></period-marker>
        </div>
        <!-- Opp Score -->
        <div id="opponentScore" style="width: 150px; height: 110px; float: left; padding: 10px 10px 20px 10px; border-left: 5px solid black; margin-right: 15px;">
            <h2>Opponent</h2>
            <h2>{{ oppScore }}</h2>
        </div>
    </div>
</template>

<script>
  import firebase from 'firebase'
  import { mapGetters } from 'vuex';

export default {
    data () {
        return {
            activeInterval: null,
            shouldStartClock: false,
            inProgress: false,
            gameLive: false,
            currentPlayer: '',
            myScore: 0,
            oppScore: 0
      }
    },
    computed: {
      ...mapGetters({
        periodStartTime: 'gameViewStore/periodStartTime',
        currGameTime: 'gameViewStore/currGameTime',
        periodLength: 'gameViewStore/periodLength',
        numberOfPeriods: 'gameViewStore/numberOfPeriods',
        selectedTeamSport: 'mainStore/selectedTeamSport',
      }),
      isSoccer: function() {
        return this.selectedTeamSport == 1;
      },
      clockText: function() {
          return this.pauseLabel;
      }
    },
    methods: {
        clockClicked(event){
            this.$emit('ClockClicked')
        },
        pauseClicked(event){
            if(this.btnEnabled){
                this.$emit('PauseClicked')
                if(this.clockText === 'Start'){
                    this.pauseLabel = 'Pause'
                }
                else{
                    this.pauseLabel = 'Start'
                }
            }
        }
    },
    props: {
        time: {
            type: String,
            default: '00:00'
        },
        activePeriod: {
            type: Number,
            default: 1
        },
        pauseLabel: {
            type: String,
            default: 'Start'
        },
        btnEnabled: {
            type: Boolean,
            default: true
        }
    }
}
</script>

<style scoped>
    .TimeClock{
        height: 120px;
        border: black 5px solid;
        border-radius: 25px;
        margin-right: 15%;
    }
    .clockPause {
        
    }
</style>
