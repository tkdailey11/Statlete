<template>
  <div class="selectSportDialog">
    <div class="buttonGroup">
      <button id="basketball" :class="{selectedButton: basketballSelected, sportButton: '!basketballSelected'}" @click="selectSport('basketball')">Basketball</button>
      <button id="football" :class="{selectedButton: footballSelected, sportButton: '!footballSelected'}" @click="selectSport('football')">Football</button>
      <button id="soccer" :class="{selectedButton: soccerSelected, sportButton: '!soccerSelected'}" @click="selectSport('soccer')">Soccer</button>
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
    font-family: 'Avenir', Helvetica, Arial, sans-serif;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    text-align: center;
    color: #2c3e50;
    margin-top: 60px;
    width: 206px;
    height: 93px;
    border-width: 3px;
    border-color: rgb(224,0,16);
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
    background-color: white;
    color: rgb(224,0,16);
    width: 200px;
    border-style: solid;
    border-color: rgb(224,0,16);
  }
  .selectedButton {
    background-color: rgb(224,0,16);
    width: 200px;
    color: rgb(242,209,24);
  }
</style>
