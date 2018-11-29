<script>
import { Line } from 'vue-chartjs'
export default {
    extends: Line,
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
                    backgroundColor: '#f87979',
                    data: [40, 9, 10, 40, 39, 80, 40]
                    }
                ]
            }
        },
        goalVal: {
            type: Number,
            default: 2
        },
        lineColor: {
            type: String,
            default: 'red'
        }
    },
    mounted () {
        this.renderLineChart();
    },
    methods: {
        renderLineChart: function() {
            var self = this;
            this.addPlugin({
                id: 'horizontalLine',
                afterDraw: function(chart) {
                    if (typeof chart.config.options.lineAt != 'undefined' && self.goalVal > 0) {
                        var lineAt = chart.config.options.lineAt;
                        var ctxPlugin = chart.chart.ctx;
                        var xAxe = chart.scales[chart.config.options.scales.xAxes[0].id];
                        var yAxe = chart.scales[chart.config.options.scales.yAxes[0].id];
                
                        if(yAxe.min != 0) return;
                        
                        ctxPlugin.strokeStyle = self.lineColor;
                        ctxPlugin.beginPath();
                        lineAt = (lineAt - yAxe.min) * (100 / yAxe.max);
                        lineAt = (100 - lineAt) / 100 * (yAxe.height) + yAxe.top;
                        ctxPlugin.moveTo(xAxe.left, lineAt);
                        ctxPlugin.lineTo(xAxe.right, lineAt);
                        ctxPlugin.stroke();
            
                        chart.ctx.fillText('GOAL', xAxe.right - 35, lineAt - 10);
                    }
                }
            });
            this.renderChart({
                labels: this.myLabels,
                datasets: this.myDatasets
            }, {
                responsive: true, 
                maintainAspectRatio: false,
                lineAt: self.goalVal,
                scales: {
                    yAxes: [{
                        ticks: {
                            min: 0
                        }
                    }]
                }
            });
        }
    },
    watch: {
        myLabels: function() {
            this.renderLineChart();
        }
    }
}
</script>
