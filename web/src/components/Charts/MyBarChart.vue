<script>
import { Bar } from 'vue-chartjs'

export default {
    extends: Bar,
    props: {
        myLabels: {
            type: Array,
            default: function(){
                return ['GameA', 'GameB']
            }
        },
        myDatasets: {
            type: Array,
            default: function() {
                return [
                    {
                    label: 'Data One',
                    backgroundColor: '#e00010',
                    data: [40, 9, 10, 40, 39, 80, 40]
                    }
                ]
            }
        },
        lineColor: {
            type: String,
            default: 'red'
        },
        lineSecondaryColor: {
            type: String,
            default: 'blue'
        },
        goalVal: {
            type: Number,
            default: 1
        },
        secondGoalVal: {
            type: Number,
            default: 2
        },
        showGoal: {
            type: Boolean,
            default: true
        },
        TSData: {
            type: Object,
            default: {}
        },
        forceUpdate: {
            type: Number,
            default: 0
        }
    },
    mounted () {
        this.renderBarChart();
    },
    methods: {
        renderBarChart: function() {
            var self = this;
            if(self.showGoal){
                this.addPlugin({
                    id: 'horizontalLine',
                    afterDraw: function(chart) {
                        if (typeof chart.config.options.lineAt != 'undefined' && (self.goalVal > 0 || self.secondGoalVal > 0)) {
                            var lineAt = chart.config.options.lineAt[0];
                            var ctxPlugin = chart.chart.ctx;
                            var xAxe = chart.scales[chart.config.options.scales.xAxes[0].id];
                            var yAxe = chart.scales[chart.config.options.scales.yAxes[0].id];
                    
                            if(yAxe.min != 0) return;
                            
                            if(self.goalVal > 0){
                                ctxPlugin.strokeStyle = self.lineColor;
                                ctxPlugin.beginPath();
                                lineAt = (lineAt - yAxe.min) * (100 / yAxe.max);
                                lineAt = (100 - lineAt) / 100 * (yAxe.height) + yAxe.top;
                                ctxPlugin.moveTo(xAxe.left, lineAt);
                                ctxPlugin.lineTo(xAxe.right, lineAt);
                                ctxPlugin.stroke();
                                chart.ctx.fillText('GOAL', xAxe.right - 35, lineAt - 10);
                            }
                            if(self.secondGoalVal > 0){
                                lineAt = chart.config.options.lineAt[1];
                                ctxPlugin.strokeStyle = self.lineSecondaryColor;
                                ctxPlugin.beginPath();
                                lineAt = (lineAt - yAxe.min) * (100 / yAxe.max);
                                lineAt = (100 - lineAt) / 100 * (yAxe.height) + yAxe.top;
                                ctxPlugin.moveTo(xAxe.left, lineAt);
                                ctxPlugin.lineTo(xAxe.right, lineAt);
                                ctxPlugin.stroke();
                                chart.ctx.fillText('GOAL', xAxe.right - 35, lineAt - 10);
                            }
                        }
                    }
                });
                this.renderChart({
                    labels: this.myLabels,
                    datasets: this.myDatasets
                }, {
                    responsive: true, 
                    maintainAspectRatio: false,
                    lineAt: [self.goalVal, self.secondGoalVal],
                    scales: {
                        yAxes: [{
                            ticks: {
                                min: 0
                            }
                        }]
                    }
                });
            }
            else{
                var labels = []
                if(self.TSData.labels === 'undefined' || self.TSData.labels == null){
                    labels = ['Goals', 'Assists', 'Shots', 'Shots on Goal', 'Fouls']
                }
                else{
                    labels = self.TSData.labels
                }
                var datasets = []
                if(self.TSData.datasets === 'undefined' || self.TSData.datasets == null){
                    datasets = [{
                        backgroundColor: '#0000ff',
                        data: [1,3,1,3,1]
                    }]
                }
                else{
                    datasets = self.TSData.datasets
                }

                console.log('RENDER:')
                console.log(labels)
                console.log(datasets)
                console.log('===============')
                this.renderChart({
                    labels: labels,
                    datasets: datasets
                }, {
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
                });
            }
        }
    },
    watch: {
        myLabels: function() {
            this.renderBarChart();
        },
        TSData: function(){
            this.renderBarChart();
        },
        forceUpdate: function(){
            this.renderBarChart();
        }
    }
}
</script>
