<template>
  <div class="playerSelectionBox">
    <table style="width:100%">
      <tr v-for="i in 10">
        <td>Row: {{i}}</td>
        <td><player-entry-box></player-entry-box></td>
      </tr>
    </table>
  </div>
</template>

<script>
  export default {
    name: 'playerSelectionBox',
    data () {
      return {
      }
    },
    methods: {
      uniqueID: function () {
        return Math.random().toString(36).substr(2, 9);
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
