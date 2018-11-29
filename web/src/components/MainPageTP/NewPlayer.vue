<template>
<modal name="new-player" transition="pop-out" :width="modalWidth" :height="300">
  <div class="np_box">
      <div class="partition" id="partition-register">
        <div class="partition-title">ADD PLAYER</div>
        <div class="partition-form">
          <form autocomplete="false">

            <div class="autocomplete-fix">
              <input type="password">
            </div>

            <input id="playerNum" type="text" v-model="pnum" placeholder="#" style="margin: 20px; width: 10%;">
            <input id="playerName" type="text" v-model="pname" placeholder="Name" style="margin: 20px; width: 70%">
          </form>


          <button class="np_github-btn" style="width: 90%; margin-left: 20px;" @click="submit">SUBMIT</button>
        </div>
      </div>
  </div>
</modal>
</template>
<script>
const MODAL_WIDTH = 450

export default {
  name: 'DemoLoginModal',
  data () {
    return {
      modalWidth: MODAL_WIDTH,
      pnum: '',
      pname: ''
    }
  },
  created () {
    this.modalWidth = window.innerWidth < MODAL_WIDTH
      ? MODAL_WIDTH / 2
      : MODAL_WIDTH
  },
  methods: {
    submit() {
      var data = {
        num: this.pnum,
        name: this.pname
      }
      this.pnum = '';
      this.pname = '';
      this.$emit('newPlayerAdded', data);
    }
  }
}
</script>
<style lang="scss">
$background_color: #404142;
$github_color: #DBA226;

.np_box {
  background: white;
  overflow: hidden;
  width: 450px;
  height: 300px;
  border-radius: 2px;
  box-sizing: border-box;
  box-shadow: 0 0 40px black;
  font-size: 0;




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

  input[type=password],
  input[type=text] {
    box-sizing: border-box;
    margin-bottom: 4px;
    width: 100%;
    font-size: 12px;
    line-height: 2;
    border: 0;
    border-bottom: 1px solid #DDDEDF;
    padding: 4px 8px;
    font-family: inherit;
    transition: 0.5s all;
    outline: none;
  }

  button {
    border-radius: 4px;
    box-sizing: border-box;
    padding: 10px;
    letter-spacing: 1px;
    font-family: "Open Sans", sans-serif;
    font-weight: 400;
    min-width: 140px;
    margin-top: 8px;
    cursor: pointer;
    text-transform: uppercase;
    transition: 0.1s all;
    font-size: 10px;
    outline: none;
  }

  .button-set {
    margin-bottom: 8px;
  }

  #register-btn,
  #signin-btn {
    margin-left: 8px;
  }

  .autocomplete-fix {
    position: absolute;
    visibility: hidden;
    overflow: hidden;
    opacity: 0;
    width: 0;
    height: 0;
    left: 0;
    top: 0;
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
</style>
