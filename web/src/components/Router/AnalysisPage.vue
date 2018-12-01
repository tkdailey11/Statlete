<template>
    <div class="AnalysisPage">
        <nav-component />
        <label for="firstDropdown">First Stat:</label>
        <select id="firstDropdown">
            <option v-for="type in statTypes" :key="'fd-' + type">{{type}}</option>
        </select>
        <label for="secondDropdown">Second Stat:</label>
        <select id="secondDropdown">
            <option v-for="type in statTypes" :key="'sd-' + type">{{type}}</option>
        </select>
        <button @click="submitResponse" class="btn btn-outline-primary analysis_button">Get Analysis</button>
        <!--<button @click="saveChart" class="btn btn-outline-primary myButton">Save</button>-->
        <br>
        <br>
        <bar-chart :myLabels="chartLabels"
                    :myDatasets="chartDatasets"
                    :goalVal="currGoal"
                    :secondGoalVal="secondaryGoal"
                    :lineColor="myColor"
                    :lineSecondaryColor="mySecondaryColor"
                    id="resultBar"
                    class="statleteChart">
        </bar-chart>
        <line-chart :myLabels="chartLabels"
                    :myDatasets="chartDatasets"
                    :goalVal="currGoal"
                    :lineColor="myColor"
                    id="resultLine"
                    class="statleteChart">
        </line-chart>
    </div>
</template>

<script>
  import { mapGetters, mapMutations } from 'vuex';
  import firebase from 'firebase'
  import jsPDF from 'jspdf'

export default {
    data() {
        return {
            statTypes: ["none"],
            firstSelectedStat: '',
            secondSelectedStat: '',
            analysisResult: '',
            chartLabels: [],
            chartDatasets: [],
            currGoal: 0,
            secondaryGoal: 0,
        }
    },
    computed: {
        ...mapGetters({
            selectedTeamId: 'mainStore/selectedTeamId',
            selectedTeamSport: 'mainStore/selectedTeamSport',
            soccerStatsArr: 'statStore/soccerStatsArr',
            basketballStatsArr: 'statStore/basketballStatsArr',
            goals: 'statStore/goals',
            mySecondaryColor: 'mainStore/mySecondaryColor',
            myColor: 'mainStore/myColor'
        }),
        isSoccer: function() {
            return this.selectedTeamSport == 1;
        }
    },
    mounted(){
        jQuery('#resultBar').hide();
        jQuery('#resultLine').hide();
        if(this.isSoccer){
            this.statTypes = this.statTypes.concat(this.soccerStatsArr)
        }
        else {
            this.statTypes = this.statTypes.concat(this.basketballStatsArr)
        }
        var self = this;
        var ref = firebase.database().ref('TeamSportfolios/').child(self.selectedTeamId).child('Goals');
        ref.on('value', function(snapshot){
            self.SS_SET_GOALS(snapshot.val())
        })
        
    },
    methods: {
        ...mapMutations({
            SS_SET_GOALS: 'statStore/SS_SET_GOALS'
        }),
        submitResponse: function() {
            var firstOption = jQuery('#firstDropdown').find(":selected").text();
            var secondOption = jQuery('#secondDropdown').find(":selected").text();
            if(firstOption === 'none' || secondOption === 'none'){
                if(firstOption === 'none' && secondOption === 'none'){
                    alert('Please choose stat(s) to analyze!')
                }
                else if(firstOption === 'none'){
                    //process second stat
                    var oneVarReq = null;
                    if(this.isSoccer){
                        oneVarReq = firebase.functions().httpsCallable('getSingleStatSoccer');
                    }
                    else {
                        oneVarReq = firebase.functions().httpsCallable('getSingleStatBasketball');
                    }
                    this.currGoal = this.goals[secondOption];
                    var self = this;
                    oneVarReq({
                        Stat: secondOption,
                        Team: this.selectedTeamId
                    }).then(function(result) {
                        self.analysisResult = JSON.parse(result.data);
                        self.processOneStatResponse(self.analysisResult, secondOption);
                    })
                }
                else{
                    //process first stat
                    var oneVarReq = null;
                    if(this.isSoccer){
                        oneVarReq = firebase.functions().httpsCallable('getSingleStatSoccer');
                    }
                    else {
                        oneVarReq = firebase.functions().httpsCallable('getSingleStatBasketball');
                    }
                    this.currGoal = this.goals[firstOption];
                    var self = this;
                    oneVarReq({
                        Stat: firstOption,
                        Team: this.selectedTeamId
                    }).then(function(result) {
                        self.analysisResult = JSON.parse(result.data);
                        self.processOneStatResponse(self.analysisResult, firstOption);
                    })
                }
            }
            else {
                var twoVarReq = null;
                if(this.isSoccer){
                    twoVarReq = firebase.functions().httpsCallable('getTwoStatsSoccer');
                }
                else {
                    twoVarReq = firebase.functions().httpsCallable('getTwoStatsBasketball');
                }
                this.currGoal = this.goals[firstOption];
                this.secondaryGoal = this.goals[secondOption];
                var self = this;
                twoVarReq({
                    Stat1: firstOption,
                    Stat2: secondOption,
                    Team: this.selectedTeamId
                }).then(function(result) {
                    self.analysisResult = JSON.parse(result.data);
                    self.processTwoStatResponse(self.analysisResult, firstOption, secondOption);
                })
            }
        },
        processTwoStatResponse: function(res, first, second) {
            var arr = Object.values(res.Games);
            var dataStat1 = [];
            var dataStat2 = [];
            arr.forEach(function(item) {
                dataStat1.push(item.Stat1);
                dataStat2.push(item.Stat2);
            })
            var datasetStat1 = {
                label: first,
                backgroundColor: 'rgba(224, 0, 16, 0.75)',
                data: dataStat1
            }
            if(this.myColor.startsWith('#')){
                datasetStat1['backgroundColor'] = this.hexToRgbA(this.myColor)
            }
            var datasetStat2 = {
                label: second,
                backgroundColor: 'rgba(247,204,78, 0.9)',
                data: dataStat2
            }
            if(this.mySecondaryColor.startsWith('#')){
                datasetStat2['backgroundColor'] = this.hexToRgbA(this.mySecondaryColor)
            }
            this.chartLabels = Object.keys(res.Games);
            this.chartDatasets = [datasetStat1, datasetStat2];
            console.log(this.chartDatasets)
            jQuery('#resultBar').show();
            jQuery('#resultLine').hide();
        },
        processOneStatResponse: function(res, stat) {
            var arr = Object.values(res.Games);
            var dataStat = [];
            arr.forEach(function(item) {
                dataStat.push(item.Stat);
            })
            var datasetStat = {
                label: stat,
                backgroundColor: 'rgba(224, 0, 16, 0.75)',
                data: dataStat
            }
            if(this.myColor.startsWith('#')){
                datasetStat['backgroundColor'] = this.hexToRgbA(this.myColor)
            }
            this.chartLabels = Object.keys(res.Games);
            this.chartDatasets = [datasetStat];
            jQuery('#resultLine').show();
            jQuery('#resultBar').hide();
        },
        saveChart(){
            var rand = Math.random().toString(36).substring(2,7);
            var pdf = new jsPDF();
            var element = null;
            var firstOption = jQuery('#firstDropdown').find(":selected").text();
            var secondOption = jQuery('#secondDropdown').find(":selected").text();
            if(firstOption != 'none' && secondOption != 'none'){
                element = jQuery('#resultBar');
            }
            else if(firstOption === 'none' && secondOption === 'none'){
                return;
            }
            else{
                element = jQuery('#resultLine');
            }
            setTimeout(function() {
                pdf.fromHTML(element[0], 750, 500);
                pdf.save('chart-' + rand + '.pdf')
            }, 6000);
            
        },
        hexToRgbA(hex){
            var c;
            if(/^#([A-Fa-f0-9]{3}){1,2}$/.test(hex)){
                c= hex.substring(1).split('');
                if(c.length== 3){
                    c= [c[0], c[0], c[1], c[1], c[2], c[2]];
                }
                c= '0x'+c.join('');
                return 'rgba('+[(c>>16)&255, (c>>8)&255, c&255].join(',')+',0.8)';
            }
            throw new Error('Bad Hex');
        }
    }
}
</script>

<style scoped>
    .AnalysisPage {
        height: 100vh;
    }
    .analysis_button {
        cursor: pointer;
        height: 50px;
        max-height: 50px;
        margin: 50px;
    }
    #firstDropdown {
        margin: 100px 50px 0px 5px;
    }
    #secondDropdown {
        margin: 100px 50px 0px 5px;
    }
    #resultP {
        width: 400px;
        height: 400px;
        border: 5px solid red;
        display: inline-block;
    }
    #resultBar {
        width: 75vw;
        height: 50vh;
        display: inline-block;
    }
    #resultLine {
        width: 75vw; 
        height: 50vh;
        display: inline-block;
    }
</style>

