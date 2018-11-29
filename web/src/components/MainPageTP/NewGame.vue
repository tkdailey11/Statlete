<template>
    <modal name="new-game" transition="pop-out" :width="modalWidth" :height="'50%'">
        <div class="ng_box">
            <div class="partition" id="partition-register">
                <div class="partition-title">Add Game</div>
                <div class="partition-form">
                  <form>
                    <div>
                      <label>Opponent:</label>
                      <input class="ng_input" id="opponent" type="text" placeholder="Opponent" style="margin: 20px; width: 70%" v-model="oppName">
                    </div>
                    <div>
                      <label style="float: left; margin-right: 9%;">Period Length:</label>
                      <multiselect v-model="selectedPeriodLength"
                                  :options="periodLengths"
                                  :multiple="false"
                                  :close-on-select="true"
                                  placeholder="45"
                                  class="es_multiselect">
                      </multiselect>
                    </div>
                    <div>
                      <label style="float: left; margin-right: 9%;">Number of Periods:</label>
                      <segmented-control
                          :options="options"
                          label="label"
                          value="value"
                          color="#fff"
                          active-color="#e00010"
                          :multiple="false"
                          @select="onSelect"
                          class="ng_sc"
                      />
                    </div>
                    <div>
                      <label class="sceLabel">Shot Chart Enabled:</label>
                      <toggle-button :color="'#e00010'" v-model="scEnabled" />
                    </div>
                    <div>
                      <label class="sceLabel">Viewable with Team Code:</label>
                      <toggle-button :color="'#e00010'" v-model="teamCode" />
                    </div>
                  </form>
                <!-- <button class="btn ng_button" style="width: 90%; margin-left: 20px;" @click="submit">SUBMIT</button> -->
              </div>
            </div>
        </div>
    </modal>
</template>
<script>
const MODAL_WIDTH = 450;
import SegmentedControl from 'vue-segmented-control'

export default {
  components: {
        SegmentedControl
  },
  name: 'NewGame',
  data () {
    return {
      modalWidth: MODAL_WIDTH,
      oppName: '',
      scEnabled: false,
      teamCode: false,
      periodLengths: ['45', '40', '35', '30', '25', '20', '1'],
      selectedPeriodLength: 45,
      periodType: '',
      options: [
                { label: 'Halves', value: 2 },
                { label: 'Quarters', value: 4 }
      ],
      numPeriods: 2
    }
  },
  created () {
    this.modalWidth = window.innerWidth < MODAL_WIDTH
      ? MODAL_WIDTH / 2
      : MODAL_WIDTH
  },
  methods: {
    submit() {
        this.$emit('NewGame', {
          Opponent: this.oppName,
          SCEnabled: this.scEnabled,
          TeamCode: this.teamCode,
          PeriodLength: parseInt(this.selectedPeriodLength),
          NumPeriods: this.numPeriods
        })
    },
    change(value) {
      
    },
    onSelect(selectedOption){
      this.numPeriods = selectedOption[0].value;
    }
  }
}
</script>
<style lang="scss">
$background_color: #404142;
$github_color: #DBA226;

.ng_box {
  background: white;
  width: 450px;
  height: 50vh;
  border-radius: 10px;
  overflow-y: scroll;

  .partition {
    width: 100%;
    height: 100%;

    .partition-title {
      box-sizing: border-box;
      padding: 30px;
      width: 100%;
      text-align: center;
      letter-spacing: 1px;
      font-size: 20px;
      font-weight: 300;
    }

    .partition-form {
      padding: 0 20px;
      box-sizing: border-box;
    }
  }

}

.pop-out-enter-active,
.pop-out-leave-active {
  transition: all 0.5s;
}

.pop-out-enter,
.pop-out-leave-active {
  opacity: 0;
  transform: translateY(24px);
}

.ng_input {
  margin: 25px;
  border: 0;
  outline: 0;
  background: transparent;
  border-bottom-width: 1px;
  border-bottom-style: solid;
}

.ng_label {
    width: 20%;
    font-size: 15px;
}

.sceLabel {
    width: 75%;
}
.es_multiselect {
  width: 60%;
  margin-bottom: 15px;
  margin-top: -5px;
  float: left;
}
.ng_sc {
  float: left;
  height: 32px;
}

</style>
