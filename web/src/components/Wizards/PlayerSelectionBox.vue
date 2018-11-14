<template>
  <div class="playerSelectionBox" style="overflow:scroll; height:310px;">
    <table style="width:100%;">
      <tr v-for="i in playersList.length" :key="i">
        <td class="psb_td">Row: {{i}}</td>
        <td class="psb_td"><player-entry-box :key="uniqueID()" :index="i" :playerName="playersList[i-1].name" :playerNumber="playersList[i-1].num" @updatedPlayerInfo="updateInfo"></player-entry-box></td>
      </tr>
      <tr>
        <td class="psb_td"><p></p></td>
        <td class="psb_td"><p></p></td>
      </tr>
      <tr>
        <td class="psb_td"></td>
        <td class="psb_td"><button class="psb_button" @click="buttonClicked">Add Player</button></td>
      </tr>
    </table>
  </div>
</template>

<script>
  export default {
    name: 'playerSelectionBox',
    beforeDestroy() {
      var players = [];
      this.playersList.forEach( function (player) {
        if ('num' in player && !(player.num==='')) {
          players.push(player)
        }
        else if ('name' in player && !(player.name==='')) {
          players.push(player)
        }
      });
      
      this.$emit('playerInfo', players);
    },
    methods: {
      uniqueID: function () {
        var s = Math.random().toString(36).substr(2, 9);
        return s;
      },
      buttonClicked: function() {
        this.playersList.push({});
      },
      updateInfo: function(event) {
        this.playersList[event.idx - 1] = {
          name: event.name,
          num: event.num
        }
      }
    },
    props: {
      sport: {
        default: 'basketball',
        type: String
      },
      playersList: {}
    },
    mounted() {
      //do something after mounting vue instance
      var i;
      if(this.sport === 'soccer' && this.playersList.length < 20){
        for(i = this.playersList.length; i < 20; i++){
          this.playersList.push({});
        }
      }
      else if(this.sport === 'football' && this.playersList.length < 30){
        for(i = this.playersList.length; i < 30; i++){
          this.playersList.push({});
        }
      }
      else {
        for(i = this.playersList.length; i < 15; i++){
          this.playersList.push({});
        }
      }
    }
  }
</script>

<style scoped>
  #playerSelectionBox {
    height: 250px;
    width: auto;
    max-width: 500px;
    display: inline-block;
    overflow: scroll;
    border-style: solid;
    border-width: 3px;
  }

  .psb_button {
    margin-top: 20px;
    cursor: pointer;
    width: 150px;
    height: 50px;
    border-radius: 25px;
    margin-left: -110px;
  }

</style>
