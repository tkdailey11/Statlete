<template>
  <div id="GamesList">
    <div id="title">
      <h1 align="center">Games</h1>
    </div>
    <div id="gamesTable">
      <table cellpadding="10" width="100%">
        <tr v-for="idx in Object.keys(games).length" @click="trClicked(idx)">
          <td>{{ games[idx-1] }}</td>
        </tr>
      </table>
    </div>
    <div id="glFooter" @click="addGameClicked">
      Add New Game
    </div>
  </div>
</template>

<script>
  export default {
    name: 'GamesList',
    props: {
      games: {
        default(){
          return [{gameID: 'game1'}, {gameID: 'game2'}]
        }
      }
    },
    methods: {
      addGameClicked: function() {
        console.log("Add Game");
        this.games.push({gameID: 'game'+(Object.keys(this.games).length + 1)})
      },
      trClicked: function(idx) {
        this.$emit('gameSelected', idx);
        console.log(idx + " clicked");
        console.log(this.games);
      }
    }
  }
</script>

<style scoped>
  #GamesList {
    width: 310px;
    height: 500px;
    background: black;
    margin-left: 50px;
    border-width: 5px;
    border-color: black;
    border-style: solid;
    border-radius: 35px;
    position: relative;
  }

  #title {
    width: 300px;
    height: 75px;
    background: white;
    border-radius: 35px 35px 0px 0px;
    border-bottom-color: black;
    border-bottom-width: medium;
    border-bottom-style: solid;

  }

  #glFooter {
    width: 300px;
    height: 75px;
    position: absolute;
    bottom: 0;
    background: white;
    border-radius: 0px 0px 35px 35px;
    border-top-color: black;
    border-top-width: medium;
    border-top-style: solid;
    text-align: center;
    vertical-align: middle;
    line-height: 75px;
    font-size: 25px;
  }

  #gamesTable {
    width: 300px;
    max-height: 350px;
    height: 350px;
    background: white;
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
