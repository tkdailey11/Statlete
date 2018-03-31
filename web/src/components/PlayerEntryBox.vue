<template>
  <div class="PlayerEntryBox">
    <input class="numberBox" type="text" @blur="sendData" v-model="number" placeholder="#">
    <input class="nameBox" type="text" @blur="sendData" v-model="playerName" placeholder="Player Name"><br>
  </div>
</template>

<script>
  export default {
    name: 'player-entry-box',
    data: function() {
      return {
        playerName: '',
        number: ''
      }
    },
    methods: {
      sendData: function() {
        console.log('Name: ' + this.playerName + '  Number: ' + this.number);
      },
      uniqueID: function () {
        return Math.random().toString(36).substr(2, 9);
      }
    }
  }
</script>

<style scoped>
  .PlayerEntryBox {
    width: auto;
    background: red;
    display: inline-block;
  }
  .numberBox {
    width: 25%;
    float: left;
    padding: 0px;
    display: inline-block;
  }
  .nameBox {
    width: 75%;
    padding: 0px;
    display: inline-block;
  }
  input {
    padding: 0px;
    outline: 0;
    border: 2px solid black;
  }
</style>
