<template>
    <div class="TimeClock">
        <!-- My Score -->
        <div class="myTeamScore" style="border-right-width: 5px; border-right-style: solid;">
            <h2>My Team</h2>
            <h2>{{ myScore }}</h2>
        </div>
        <!-- Left Periods -->
        <div class="left_periods">
            <period-marker style="float: left; margin-top: 25px;" :period="1" :filled="activePeriod == 1"></period-marker>
            <period-marker v-if="numberOfPeriods == 4" style="float: left; margin-top: 25px;" :period="2" :filled="activePeriod == 2"></period-marker>
        </div>
        <!-- Clock -->
        <div class="scoreboard_clock">
            <h1 @click="clockClicked" style="padding-top: 5px;">{{time}}</h1>
            <v-btn color="red" @click="pauseClicked"><v-icon>pause</v-icon><v-icon>play_arrow</v-icon></v-btn>
        </div>
        <!-- Right Periods -->
        <div class="right_periods">
            <period-marker v-if="numberOfPeriods == 4" style="float: left; margin-top: 25px;" :period="3" :filled="activePeriod == 3"></period-marker>
            <period-marker v-if="numberOfPeriods == 4" style="float: left; margin-top: 25px;" :period="4" :filled="activePeriod == 4"></period-marker>
            <period-marker v-else style="float: left; margin-top: 25px;" :period="2" :filled="activePeriod == 2"></period-marker>
        </div>
        <!-- Opp Score -->
        <div class="opponentScore" style="border-left-width: 5px; border-left-style: solid;">
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
            pauseBtnString: 'Start'
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
      }
    },
    methods: {
        clockClicked(event){
            this.$emit('ClockClicked')
        },
        pauseClicked(event){
            if(this.btnEnabled){
                this.$emit('PauseClicked')
                if(this.pauseBtnString === 'Start'){
                    this.pauseBtnString = 'Pause'
                }
                else{
                    this.pauseBtnString = 'Start'
                }
            }
        },
    },
    mounted() {
        if(this.setBtnToPause){
            this.pauseBtnString = 'Pause'
        }
        else {
            this.pauseBtnString = 'Start'
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
        },
        myScore: {
            type: Number,
            default: 0
        },
        oppScore: {
            type: Number,
            default: 0
        },
        setBtnToPause: {
            type: Boolean,
            default: false
        }
    },
    watch: {
        setBtnToPause: {
            handler() {
                if(this.setBtnToPause){
                    this.pauseBtnString = 'Pause'
                }
                else {
                    this.pauseBtnString = 'Start'
                }
            }
        }
    }
}
</script>

<style scoped>
    .TimeClock{
        border-width: 5px;
        border-style: solid;
        border-radius: 25px;
        margin-right: 15%;
        display: flex;
        margin-top: 3vh;
    }
    .myTeamScore {
        flex-basis: 25%;
    }
    .left_periods {
        flex-basis: 15%;
    }
    .scoreboard_clock {
        flex-basis: 20%;
    }
    .right_periods {
        flex-basis: 15%;
    }
    .opponentScore {
        flex-basis: 25%;
    }
</style>
