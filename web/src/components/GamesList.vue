<template>
  <div id="GamesList">
    <div id="title">
      <h1 align="center">Games</h1>
    </div>
    <div id="gamesTable">
      <table cellpadding="10" width="100%">
        <tr v-for="idx in 20" @click="trClicked(idx)">
          <td>Test {{ idx }}</td>
        </tr>
      </table>
    </div>
    <div id="glFooter">
      <button @click="addGameClicked">Add Game</button>
    </div>
  </div>
</template>

<script>
  export default {
    name: 'GamesList',
    methods: {
      addGameClicked: function() {
        console.log("Add Game");
      },
      trClicked: function(idx) {
        console.log(idx + " clicked");
      }
    }
  }
</script>

<style scoped>
  #GamesList {
    width: 300px;
    height: 500px;
    background: blue;
    margin-left: 50px;
    border-radius: 40px;
    position: relative;
  }

  #title {
    width: 300px;
    height: 75px;
    background: gray;
    border-radius: 40px 40px 0px 0px;
    border-bottom-color: white;
    border-bottom-width: medium;
    border-bottom-style: solid;
  }

  #glFooter {
    width: 300px;
    height: 75px;
    position: absolute;
    bottom: 0;
    background: gray;
    border-radius: 0px 0px 40px 40px;
    border-top-color: white;
    border-top-width: medium;
    border-top-style: solid;
  }

  #gamesTable {
    width: 300px;
    max-height: 350px;
    height: 350px;
    background: red;
    overflow: scroll;
  }

  table, th, td {
    border: 1px solid black;
  }

  h1 {
    line-height: 75px;
    height: 75px;
  }
</style>
