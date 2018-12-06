<template>
    <div class="AnalysisPage">
        <nav-component />
        <v-card :dark="true" style="margin: 5vw 10vw 5vw 10vw;">
            <v-card-title>
              Request Analysis
              <v-spacer></v-spacer>
            </v-card-title>
                <v-flex xs6 d-flex>
                    <label for="firstDropdown">First Stat:</label>
                    <select id="firstDropdown">
                        <option v-for="type in statTypes" :key="'fd-' + type">{{type}}</option>
                    </select>
                    <label for="secondDropdown">Second Stat:</label>
                    <select id="secondDropdown">
                        <option v-for="type in statTypes" :key="'sd-' + type">{{type}}</option>
                    </select>
                </v-flex>
                <v-card-actions>
                  <v-btn flat color="red" @click.stop="submitResponse">Request</v-btn>
                </v-card-actions>
        </v-card>
        <v-card dark id="analysisCharts">
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
        </v-card>
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
            items: ['Foo', 'Bar', 'Fizz', 'Buzz']
        }
    },
    computed: {
        ...mapGetters({
            selectedTeamId: 'mainStore/selectedTeamId',
            selectedTeamSport: 'mainStore/selectedTeamSport',
            soccerStatsArr: 'statStore/soccerStatsArr',
            basketballStatsArr: 'statStore/basketballStatsArr',
            footballOffenseArr: 'statStore/footballOffenseArr',
            footballDefenseArr: 'statStore/footballDefenseArr',
            goals: 'statStore/goals',
            mySecondaryColor: 'mainStore/mySecondaryColor',
            myColor: 'mainStore/myColor'
        }),
        isSoccer: function() {
            return this.selectedTeamSport == 1;
        },
        isFootball: function() {
            return this.selectedTeamSport == 2;
        }
    },
    mounted(){
        jQuery('#resultBar').hide();
        jQuery('#resultLine').hide();
        if(this.isSoccer){
            this.statTypes = this.statTypes.concat(this.soccerStatsArr)
        }
        else if(this.isFootball){
            this.statTypes = this.statTypes.concat(this.footballOffenseArr).concat(this.footballDefenseArr)

            var filtered = this.statTypes.filter(function(value, index, arr){
                return (value !== 'Side') && (value !== 'INT') && (value !== 'TotalPassTD') && (value !== 'TotalPassYds') && (value !== 'TotalRushTD') && (value !== 'TotalRushYds');
            });

            this.statTypes = filtered;
            this.statTypes.push('INT Thrown')
            this.statTypes.push('INT Forced')
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
        getFootballStatType(stat){
            if(stat === 'INT Thrown'){
                return 'Offense'
            }
            else if(stat === 'INT Forced'){
                return 'Defense'
            }
            else if(this.footballOffenseArr.includes(stat)){
                return 'Offense'
            }
            else{
                return 'Defense'
            }
        },
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
                    else if(this.isFootball){
                        oneVarReq = firebase.functions().httpsCallable('getSingleStatFootball');
                    }
                    else {
                        oneVarReq = firebase.functions().httpsCallable('getSingleStatBasketball');
                    }
                     if(this.goals != null){
                        this.currGoal = this.goals[secondOption];
                    }
                    
                    if(!this.isFootball){
                        var self = this;
                        oneVarReq({
                            Stat: secondOption,
                            Team: this.selectedTeamId
                        }).then(function(result) {
                            console.log('JSON')
                            console.log(result.data)
                            self.analysisResult = JSON.parse(result.data);
                            self.processOneStatResponse(self.analysisResult, secondOption);
                        })
                    }
                    else {
                        var self = this;
                        var type = secondOption.substring(0, secondOption.length);
                        if(secondOption.startsWith('INT')){
                            type = 'INT'
                        }
                        oneVarReq({
                            Type: this.getFootballStatType(secondOption),
                            Stat: type,
                            Team: this.selectedTeamId
                        }).then(function(result) {
                            console.log('JSON')
                            console.log(result.data)
                            self.analysisResult = JSON.parse(result.data);
                            self.processOneStatResponse(self.analysisResult, secondOption);
                        })
                    }
                }
                else{
                    //process first stat
                    var oneVarReq = null;
                    if(this.isSoccer){
                        oneVarReq = firebase.functions().httpsCallable('getSingleStatSoccer');
                    }
                    else if(this.isFootball){
                        oneVarReq = firebase.functions().httpsCallable('getSingleStatFootball');
                    }
                    else {
                        oneVarReq = firebase.functions().httpsCallable('getSingleStatBasketball');
                    }
                    if(this.goals != null){
                        this.currGoal = this.goals[firstOption];
                    }
                    
                    if(!this.isFootball){
                        var self = this;
                        oneVarReq({
                            Stat: firstOption,
                            Team: this.selectedTeamId
                        }).then(function(result) {
                            console.log('JSON')
                            console.log(result.data)
                            self.analysisResult = JSON.parse(result.data);
                            self.processOneStatResponse(self.analysisResult, firstOption);
                        })
                    }
                    else {
                        var self = this;
                        var type = firstOption.substring(0, firstOption.length);
                        if(firstOption.startsWith('INT')){
                            type = 'INT'
                        }
                        oneVarReq({
                            Type: this.getFootballStatType(firstOption),
                            Stat: type,
                            Team: this.selectedTeamId
                        }).then(function(result) {
                            console.log('JSON')
                            console.log(result.data)
                            self.analysisResult = JSON.parse(result.data);
                            self.processOneStatResponse(self.analysisResult, firstOption);
                        })
                    }
                    
                }
            }
            else {
                var twoVarReq = null;
                if(this.isSoccer){
                    twoVarReq = firebase.functions().httpsCallable('getTwoStatsSoccer');
                }
                else if(this.isFootball){
                        twoVarReq = firebase.functions().httpsCallable('getTwoStatsFootball');
                }
                else {
                    twoVarReq = firebase.functions().httpsCallable('getTwoStatsBasketball');
                }
                if(this.goals != null){
                this.currGoal = this.goals[firstOption];
                this.secondaryGoal = this.goals[secondOption];
                }
                var self = this;
                if(!this.isFootball){
                    twoVarReq({
                        Stat1: firstOption,
                        Stat2: secondOption,
                        Team: this.selectedTeamId
                    }).then(function(result) {
                        self.analysisResult = JSON.parse(result.data);
                        self.processTwoStatResponse(self.analysisResult, firstOption, secondOption);
                    })
                }
                else {
                    var type1 = firstOption.substring(0, firstOption.length);
                    if(firstOption.startsWith('INT')){
                        type1 = 'INT'
                    }
                    var type2 = secondOption.substring(0, secondOption.length);
                    if(secondOption.startsWith('INT')){
                        type2 = 'INT'
                    }
                    twoVarReq({
                        Type1: this.getFootballStatType(firstOption),
                        Type2: this.getFootballStatType(secondOption),
                        Stat1: type1,
                        Stat2: type2,
                        Team: this.selectedTeamId
                    }).then(function(result) {
                        self.analysisResult = JSON.parse(result.data);
                        self.processTwoStatResponse(self.analysisResult, firstOption, secondOption);
                    })
                }
                
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
        min-height: 100vh;
        height: 100%;
    }
    .analysis_button {
        cursor: pointer;
        height: 50px;
        max-height: 50px;
        margin: 50px;
    }
    #firstDropdown {
        margin: 0px 50px 100px 5px;
        background-color: lightslategray;
    }
    #secondDropdown {
        margin: 0px 50px 100px 5px;
        background-color: lightslategray;
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
    #analysisCharts {
        margin: 0 10vw 5vh 10vw;
    }
</style>

