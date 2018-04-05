<template>
  <div class="playerSelectionBox" style="overflow:scroll; height:310px;">
    <table style="width:100%;">
      <tr v-for="i in numRows" :key="i">
        <td>Row: {{i}}</td>
        <td><player-entry-box></player-entry-box></td>
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
    data () {
      return {
        numRows: 10
      }
    },
    methods: {
      uniqueID: function () {
        return Math.random().toString(36).substr(2, 9);
      },
      buttonClicked: function() {
        this.numRows++;
        console.log("NUM ROWS: " + this.numRows);
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
