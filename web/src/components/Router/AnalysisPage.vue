<template>
    <div id="AnalysisPage">
        <nav-component />
        <label for="firstDropdown" style="color: red;">First Stat:</label>
        <select id="firstDropdown">
            <option v-for="type in statTypes" :key="'fd-' + type">{{type}}</option>
        </select>
        <label for="secondDropdown" style="color: red;">Second Stat:</label>
        <select id="secondDropdown">
            <option v-for="type in statTypes" :key="'sd-' + type">{{type}}</option>
        </select>
        <button @click="submitResponse" class="btn btn-outline-primary myButton">Ask Statlete</button>
        <!--<button @click="saveChart" class="btn btn-outline-primary myButton">Save</button>-->
        <br>
        <br>
        <bar-chart :myLabels="chartLabels"
                    :myDatasets="chartDatasets"
                    id="resultBar"
                    class="statleteChart">
        </bar-chart>
        <line-chart :myLabels="chartLabels"
                    :myDatasets="chartDatasets"
                    id="resultLine"
                    class="statleteChart">
        </line-chart>
    </div>
</template>

<script>
  import { mapGetters } from 'vuex';
  import firebase from 'firebase'
  import jsPDF from 'jspdf'
import { setTimeout } from 'timers';

export default {
    data() {
        return {
            statTypes: ["none"],
            firstSelectedStat: '',
            secondSelectedStat: '',
            analysisResult: '',
            chartLabels: [],
            chartDatasets: []
        }
    },
    computed: {
        ...mapGetters({
            selectedTeamId: 'mainStore/selectedTeamId',
            selectedTeamSport: 'mainStore/selectedTeamSport',
            soccerStatsArr: 'statStore/soccerStatsArr',
            basketballStatsArr: 'statStore/basketballStatsArr'
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
        
    },
    methods: {
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
            console.log(res);
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
            var datasetStat2 = {
                label: second,
                backgroundColor: 'rgba(247,204,78, 0.9)',
                data: dataStat2
            }
            this.chartLabels = Object.keys(res.Games);
            this.chartDatasets = [datasetStat1, datasetStat2];
            jQuery('#resultBar').show();
            jQuery('#resultLine').hide();
        },
        processOneStatResponse: function(res, stat) {
            var arr = Object.values(res.Games);
            console.log(res);
            var dataStat = [];
            arr.forEach(function(item) {
                dataStat.push(item.Stat);
            })
            console.log(dataStat)
            var datasetStat = {
                label: stat,
                backgroundColor: 'rgba(224, 0, 16, 0.75)',
                data: dataStat
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
                alert('first')
                element = jQuery('#resultBar');
            }
            else if(firstOption === 'none' && secondOption === 'none'){
                alert('second')
                return;
            }
            else{
                alert('third')
                element = jQuery('#resultLine');
            }
            console.log(element)
            setTimeout(function() {
                pdf.fromHTML(element[0], 750, 500);
                pdf.save('chart-' + rand + '.pdf')
            }, 6000);
            
        }
    }
}
</script>

<style scoped>
    #AnalysisPage {
        
    }
    button {
        margin-top: 20px;
        cursor: pointer;
        color: white;
        background-color: rgb(255,158,0);
        border-color: rgb(224,0,16);
        color: rgb(224,0,16);
    }
    button:hover {
        background-color: rgb(242,209,24);
        border-color: rgb(224,0,16);
        color: rgb(180, 41, 102);
    }
    .myButton {
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

