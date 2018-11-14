<template>
  <div class="selectSportDialog">
    <div class="buttonGroup">
      <button id="basketball" v-if="basketballSelected" class="ss_selectedButton">Basketball</button>
      <button id="basketball" v-else class="sportButton" @click="selectSport('basketball')">Basketball</button>
      <button id="football" v-if="footballSelected" class="ss_selectedButton">Football</button>
      <button id="football" v-else class="sportButton" @click="selectSport('football')">Football</button>
      <button id="soccer" v-if="soccerSelected" class="ss_selectedButton">Soccer</button>
      <button id="soccer" v-else class="sportButton" @click="selectSport('soccer')">Soccer</button>
    </div>
  </div>
</template>

<script>
  export default {
    name: 'SelectSport',
    props: {
      initialSport: {
        default: 'basketball',
        type: String
      }
    },
    data: function() {
      return {
        basketballSelected: this.initialSport==='basketball',
        footballSelected: this.initialSport==='football',
        soccerSelected: this.initialSport==='soccer'
      }
    },
    methods: {
      selectSport(sport) {
        if(sport === 'basketball') {
          this.basketballSelected = true;
          this.footballSelected = false;
          this.soccerSelected = false;
          this.$emit('sportWasSelected', 'basketball');
        }
        else if (sport === 'football') {
          this.basketballSelected = false;
          this.footballSelected = true;
          this.soccerSelected = false;
          this.$emit('sportWasSelected', 'football');
        }
        else {
          this.basketballSelected = false;
          this.footballSelected = false;
          this.soccerSelected = true;
          this.$emit('sportWasSelected', 'soccer');
        }
      }
    }
  }
</script>

<style scoped>
  .selectSportDialog {
    text-align: center;
    margin-top: 60px;
    width: 206px;
    height: 93px;
    border-width: 3px;
    border-style: solid;
    border-radius: 19px;
  }
  #basketball {
    border-radius: 15px 15px 0px 0px;
    margin: 0 auto;
    display: block;
  }
  #soccer {
    border-radius: 0px 0px 15px 15px;
    margin: 0 auto;
    display: block;
  }
  #football {
    margin: 0 auto;
    display: block;
  }
  .sportButton {
    width: 200px;
    border-style: solid;
  }
  .ss_selectedButton {
    width: 200px;
  }
</style>
