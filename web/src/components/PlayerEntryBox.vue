<template>
  <div class="PlayerEntryBox">
    <input class="numberBox" type="text" @blur="sendData" v-model="pnum" placeholder="#">
    <input class="nameBox" type="text" @blur="sendData" v-model="pname" placeholder="Player Name">
  </div>
</template>

<script>
  export default {
    name: 'player-entry-box',
    data: function() {
      return {
        pname: this.playerName,
        pnum: this.playerNumber
      }
    },
    props: {
      index: {
        default: 0
      },
      playerName: {
        default: '',
        type: String
      },
      playerNumber: {
        default: '',
        type: String
      }
    },
    methods: {
      sendData: function() {
        this.$emit('updatedPlayerInfo', {
          name: this.pname,
          num: this.pnum,
          idx: this.index
        });
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
