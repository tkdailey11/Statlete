<script>
import { Bar } from 'vue-chartjs'

export default {
  extends: Bar,
  props: {
    chartdata: {
      type: Object,
      default: null
    },
    options: {
      type: Object,
      default: null
    },
    rerender: {
        type: Number,
        default: 0
    }
  },
  mounted () {
    //ChartData
    // {
    //     labels: labels,
    //     datasets: datasets
    // }
    this.renderChart(this.chartdata, this.options)
  },
  watch: {
      rerender: function(){
          console.log(this.chartdata)
          this.renderChart(this.chartdata, this.options)
      }
  }
}
</script>
