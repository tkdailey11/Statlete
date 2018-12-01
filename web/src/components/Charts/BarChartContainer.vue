<template>
  <div class="container">
    <other-bar-chart
      v-if="loaded"
      :chartdata="chartdata"
      :options="options"
      :rerender="shouldRender"/>
  </div>
</template>

<script>
import firebase from 'firebase';

export default {
    name: 'BarChartContainer',
    data: () => ({
        loaded: false,
        chartdata: null,
        myTotals: [],
        oppTotals: [],
        options: null,
        shouldRender: 0
    }),
    async mounted () {
        this.loaded = false
        this.loadChart();
    },
    watch: {
        chartdata:{
            handler: function() {
                if(this.loaded){
                    this.shouldRender++;
                }
            },
            deep: true
        }
    },
    methods: {
        loadChart: async function(){
            alert('loading chart')
            var self = this;
            var ref = firebase.database().ref('/SoccerGames').child('tkd_rsl_1').child('tkd_rsl_1-13');
            var totalsRef = ref.child('MyTotals');
            var oppTotalsRef = ref.child('OpponentsTotals');

            var promiseArr = []

            await totalsRef.on('value', function(snapshot){
                self.myTotals = []
                self.myTotals.push(snapshot.val().Period1.Goals.Total + snapshot.val().Period2.Goals.Total)
                self.myTotals.push(snapshot.val().Period1.Assists.Total + snapshot.val().Period2.Assists.Total)
            })
            await oppTotalsRef.on('value', function(snapshot){
                self.oppTotals = []
                self.oppTotals.push(snapshot.val().Period1.Goals.Total + snapshot.val().Period2.Goals.Total)
                self.oppTotals.push(snapshot.val().Period1.Assists.Total + snapshot.val().Period2.Assists.Total)
            })

            var datasetStat1 = {
                label: 'My Team',
                backgroundColor: 'rgba(224, 0, 16, 0.75)',
                data: self.myTotals
            }
            var datasetStat2 = {
                label: 'Opponent',
                backgroundColor: 'rgba(247,204,78, 0.9)',
                data: self.oppTotals
            }

            this.chartdata = {
                labels: ['Goals', 'Assists'],
                datasets: [datasetStat1, datasetStat2]
            }

            this.options = {
                responsive: true, 
                legend: { display: false },
                maintainAspectRatio: false,
                scales: {
                    yAxes: [{
                        ticks: {
                            min: 0
                        }
                    }]
                }
            };
            alert('loaded')
            this.loaded = true;
            
        }
    }
}
</script>