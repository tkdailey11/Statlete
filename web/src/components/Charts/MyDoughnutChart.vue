<script>
import { Doughnut } from 'vue-chartjs'

export default {
    extends: Doughnut,
    props: {
        
    },
    mounted () {
        this.renderDoughnutChart();
    },
    methods: {
        renderDoughnutChart: function() {
            this.renderChart({
            labels: ['Missed', 'Made'],
            datasets: [{ backgroundColor: [
                            '#E46651',
                            '#41B883'
                        ],
                        data: [59.46, 40.54]
                        }]
            }, {responsive: true, maintainAspectRatio: false})
        }
    },
    watch: {
 
    }
}
</script>
