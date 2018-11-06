<template>
    <modal name="new-game" transition="pop-out" :width="modalWidth" :height="'50%'">
        <div class="ng_box">
            <div class="partition" id="partition-register">
                <div class="partition-title">Add Game</div>
                <div class="partition-form">
                    <form>
                        <!-- <label>Opponent:</label>
                        <input class="ng_input" id="opponent" type="text" placeholder="Opponent" style="margin: 20px; width: 70%" v-model="oppName"> -->
                         <!-- <div style="font-size: 12px;">
                            <scroll-picker-group class="flex">
                                <scroll-picker :options="periodLengths" @input="change" />
                                <scroll-picker :options="periodLengths" @input="change" />
                                <scroll-picker :options="periodLengths" @input="change" />
                            </scroll-picker-group>
                          </div> -->
                          <div id="appWheel" style="width: 100px; height: 100px; margin: 10px auto 0 auto">
                            <wheel-count-number :text="text"></wheel-count-number>
                          </div>
                        <!-- <div style="margin-left: 25%;">
                            <toggle-button :color="'#e00010'" v-model="scEnabled" /><label class="sceLabel">Shot Chart Enabled</label>
                        </div>
                        <div style="margin-left: 25%;">
                            <toggle-button :color="'#e00010'" v-model="teamCode" /><label class="sceLabel">Viewable with Team Code</label>
                        </div> -->
                    </form>
                    <button class="large-btn github-btn" style="width: 90%; margin-left: 20px;" @click="submit">SUBMIT</button>
                </div>
            </div>
        </div>
    </modal>
</template>
<script>
const MODAL_WIDTH = 450;


export default {
  name: 'NewGame',
  data () {
    return {
      modalWidth: MODAL_WIDTH,
      oppName: '',
      scEnabled: false,
      teamCode: false,
      currentState: 'all',
      periodLengths: ['45', '40', '35', '30', '25', '20', '1'],
      selected: 1,
      text: '998'
    }
  },
  created () {
    this.modalWidth = window.innerWidth < MODAL_WIDTH
      ? MODAL_WIDTH / 2
      : MODAL_WIDTH
  },
  methods: {
    submit() {
        alert(this.oppName + ' ' + this.scEnabled + ' ' + this.teamCode)
    },
    change(value) {
      console.log('*** ' + value + ' ***')
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
  border-bottom-width: 3px;
  border-bottom-style: solid;
}

.ng_label {
    width: 20%;
    font-size: 15px;
}

.sceLabel {
    width: 75%;
}

</style>
