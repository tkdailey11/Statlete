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
    background: white;
    margin-left: 50px;
    border-width: 5px;
    border-color: orange;
    border-style: solid;
    border-radius: 40px;
    position: relative;
  }

  #title {
    width: 300px;
    height: 75px;
    background: white;
    border-radius: 35px 35px 0px 0px;
    border-bottom-color: orange;
    border-bottom-width: medium;
    border-bottom-style: solid;
    background-color: white;
  }

  #glFooter {
    width: 300px;
    height: 75px;
    position: absolute;
    bottom: 0;
    background-color: white;
    border-radius: 0px 0px 35px 35px;
    border-top-color: orange;
    border-top-width: medium;
    border-top-style: solid;
    text-align: center;
    vertical-align: middle;
    line-height: 75px;
    font-size: 25px;
    color: rgb(180, 41, 102);
  }

  #glFooter:hover {
    background-color: rgba(255,165,0, 0.7);
  }

  #gamesTable {
    width: 300px;
    max-height: 350px;
    height: 350px;
    background-color: white;
    overflow: scroll;
  }

  tr:hover td {
    background-color: rgba(255,165,0, 0.7);
    cursor: pointer;
  }

  table, th, td {
    border: 1px solid orange;
  }

  td {
    border-bottom: 1px solid orange;
    color: rgb(180, 41, 102);
    background-color: white;
  }

  h1 {
    line-height: 75px;
    height: 75px;
    color: rgb(180, 41, 102);
  }
</style>
