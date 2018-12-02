<script>
import { Doughnut } from 'vue-chartjs'

export default {
    extends: Doughnut,
    props: {
        inputDatasets: {
            type: Array,
            default: () => [{ backgroundColor: [
                            '#E46651',
                            '#41B883'
                        ],
                        data: [59.46, 40.54]
                        }]
        },
        label: {
            type: String,
            default: ''
        },
        updateChart: {
            type: Number,
            default: 0
        }
    },
    mounted () {
        this.renderDoughnutChart();
    },
    methods: {
        renderDoughnutChart: function() {
            console.log('InputDataSets')
            console.log(this.inputDatasets)
            var self = this;
            this.addPlugin({
                id: 'innerLabel',
                afterDraw: function(chart) {
                    var width = chart.chart.width,
                    height = chart.chart.height;
                    var ctxPlugin = chart.chart.ctx;

                    var fontSize = (height / 150).toFixed(2);
                    ctxPlugin.font = fontSize + "em sans-serif";
                    ctxPlugin.textBaseline = "middle";
                    var text1 = self.label,
                        text1X = Math.round((width - ctxPlugin.measureText(text1).width) / 2),
                        text1Y = height / 2 - 10;
                    var text2 = self.inputDatasets[0].data[1] + '%',
                        text2X = Math.round((width - ctxPlugin.measureText(text2).width) / 2),
                        text2Y = height / 2 + 10;
                    
                    chart.ctx.fillText(text1, text1X, text1Y);
                    chart.ctx.fillText(text2, text2X, text2Y);
                }
            });
            this.renderChart({
            labels: ['Missed', 'Made'],
            datasets: this.inputDatasets
            }, 
            {
                responsive: true,
                maintainAspectRatio: false,
                legend: { display: false }
            })
        }
    },
    watch: {
        updateChart: function(){
            this.renderDoughnutChart();
        }
    }
}
</script>
