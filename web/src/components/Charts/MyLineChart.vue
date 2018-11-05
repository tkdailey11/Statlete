<script>
// import { Line, mixins } from 'vue-chartjs'
// export default {
//     extends: Line,
//     mixins: [mixins.reactiveData, mixins.reactiveProp],
//     mounted() {
//         this.renderChart({
//             labels: this.chartData.labels,
//             datasets: this.chartData.datasets
//         }, {responsive: true, maintainAspectRatio: false});
//     }
// }
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
        }
    },
    mounted () {
        this.renderLineChart();
    },
    methods: {
        renderLineChart: function() {
            this.renderChart({
                labels: this.myLabels,
                datasets: this.myDatasets
            }, {
                responsive: true, 
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
    },
    watch: {
        myLabels: function() {
            this.renderLineChart();
        }
    }
}
</script>
