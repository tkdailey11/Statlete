<template>
  <transition name="modal-fade">
    <div class="modal-backdrop">
        <div class="modal-left-pane" @click="close">
        </div>
        <div class="modal-center">
            <div class="ng-modal-header" @click="close">
            </div>
            <v-card :dark="darkMode" class="modal-body">
                <div class="ng-oppEntry">
                    <label class="ng_label">Opponent:</label>
                    <input class="ng_input ng_right" id="opponent" type="text" placeholder="Opponent" v-model="oppName">
                </div>
                <div class="ng-periodLength" v-if="!this.isFootball">
                    <label class="ng_label">Period Length:</label>
                    <multiselect v-if="isSoccer" 
                                v-model="selectedPeriodLength"
                                :options="periodLengths"
                                :multiple="false"
                                :close-on-select="true"
                                placeholder="45"
                                class="es_multiselect ng_right">
                    </multiselect>
                    <multiselect v-else-if="isBasketball" 
                                v-model="selectedPeriodLength"
                                :options="periodLengthsBBall"
                                :multiple="false"
                                :close-on-select="true"
                                placeholder="20"
                                class="es_multiselect ng_right">
                    </multiselect>
                </div>
                <div class="ng-numPeriods" v-if="isBasketball">
                    <label class="ng_label ng_hidden">Number of Periods:</label>
                    <v-btn-toggle v-model="numPeriods" class="ng_sc ng_right">
                        <v-btn flat value="2">
                          Halves
                        </v-btn>
                        <v-btn flat value="4">
                          Quarters
                        </v-btn>
                      </v-btn-toggle>
                </div>
                <div class="ng-shotChart" v-if="!this.isFootball">
                    <label class="ng_label">Shot Chart Enabled:</label>
                    <toggle-button :color="'#e00010'" v-model="scEnabled" class="ng_right" />
                </div>
                <div class="ng-teamCode" v-if="!this.isFootball">
                    <label class="ng_label">Viewable with Team Code:</label>
                    <toggle-button :color="'#e00010'" v-model="teamCode" class="ng_right" />
                </div>
                <div class="ng-submit">
                    <v-btn color="red" :dark="darkMode" @click="submit">SUBMIT</v-btn>
                </div>
            </v-card>
            <div class="ng-modal-footer" @click="close">
            </div>
        </div>
        <div class="modal-right-pane" @click="close">
        </div>
    </div>
  </transition>
</template>
<script>
import SegmentedControl from 'vue-segmented-control'
import { mapGetters, mapMutations } from 'vuex';

export default {
    name: 'ngmodal',
    components: {
        SegmentedControl
    },
    computed: {
        ...mapGetters({
            selectedTeamSport: 'mainStore/selectedTeamSport',
            darkMode: 'mainStore/darkMode'
        }),
        isSoccer() {
            return this.selectedTeamSport == 1;
        },
        isBasketball() {
            return this.selectedTeamSport == 0;
        },
        isFootball(){
            return this.selectedTeamSport == 2;
        }
    },
    methods: {
        close() {
            this.$emit('close');
        },
        submit() {
            this.$emit('NewGame', {
                Opponent: this.oppName,
                SCEnabled: this.scEnabled,
                TeamCode: this.teamCode,
                PeriodLength: parseInt(this.selectedPeriodLength),
                NumPeriods: parseInt(this.numPeriods)
            })
        },
        change(value) {
            
        },
        onSelect(selectedOption){
            this.numPeriods = selectedOption[0].value;
        }
    },
    mounted() {
        if(this.isBasketball){
            this.selectedPeriodLength = 20
        }
    },
    data() {
        return {
            oppName: '',
            scEnabled: false,
            teamCode: false,
            periodLengths: ['45', '40', '35', '30', '25', '20', '1'],
            periodLengthsBBall: ['20', '15', '12', '10', '8', '6', '5', '1'],
            selectedPeriodLength: 45,
            periodType: '',
            options: [
                        { label: 'Halves', value: 2 },
                        { label: 'Quarters', value: 4 }
            ],
            numPeriods: 2
        }
    }
  };
</script>
<style>
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