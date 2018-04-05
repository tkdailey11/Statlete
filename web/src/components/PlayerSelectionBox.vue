<template>
  <div class="playerSelectionBox" style="overflow:scroll; height:310px;">
    <table style="width:100%;">
      <tr v-for="i in Object.keys(players).length" :key="i">
        <td>Row: {{i}}</td>
        <td><player-entry-box :key="uniqueID()" :index="i" :playerName="players[i-1].name" :playerNumber="players[i-1].num" @updatedPlayerInfo="updateInfo"></player-entry-box></td>
      </tr>
      <tr>
        <td><p></p></td>
        <td><p></p></td>
      </tr>
      <tr>
        <td></td>
        <td><button @click="buttonClicked">Add Player</button></td>
      </tr>
    </table>
  </div>
</template>

<script>
  export default {
    name: 'playerSelectionBox',
    beforeDestroy() {
      var playersList = [];
      this.players.forEach( function (player) {
        if ('num' in player && !(player.num==='')) {
          playersList.push(player)
        }
        else if ('name' in player && !(player.name==='')) {
          playersList.push(player)
        }
      });

      this.$emit('playerInfo', playersList);
    },
    data () {
      return {
        numRows: 10,
        players: [{},{},{},{},{},{},{},{},{},{}]
      }
    },
    methods: {
      uniqueID: function () {
        var s = Math.random().toString(36).substr(2, 9);
        return s;
      },
      buttonClicked: function() {
        this.players.push({});
        this.numRows++;
      },
      updateInfo: function(event) {
        this.players[event.idx - 1] = {
          name: event.name,
          num: event.num
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
    background-color: rgb(109,8,8);
    overflow: scroll;
    border: 3px solid black;
    color: white;
  }
  th, td {
    border: 1px solid white;
  }
</style>
