<template>
  <div id="PlayersList">
    <div id="plTitle">
      <h1 align="center">Players</h1>
    </div>
    <div id="playersTable">
      <table cellpadding="10" width="100%">
        <tr v-for="idx in Object.keys(players).length" @click="trClicked(idx)">
          <td>{{ players[idx-1].playerID }}</td>
        </tr>
      </table>
    </div>
    <div id="plFooter" @click="addPlayerClicked">
      Add New Player
    </div>
  </div>
</template>

<script>
  export default {
    name: 'PlayersList',
    props: {
      players: {
        default(){
          return [{playerID: 'player1'}, {playerID: 'player2'}]
        }
      }
    },
    methods: {
      addPlayerClicked: function() {
        console.log("Add Player");
        this.players.push({playerID: 'player'+(Object.keys(this.players).length + 1)})
      },
      trClicked: function(idx) {
        console.log(idx + " clicked");
        this.$emit('playerSelected');
      }
    }
  }
</script>

<style scoped>
  #PlayersList {
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

  #plTitle {
    width: 300px;
    height: 75px;
    background: white;
    border-radius: 35px 35px 0px 0px;
    border-bottom-color: black;
    border-bottom-width: medium;
    border-bottom-style: solid;

  }

  #plFooter {
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

  #playersTable {
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
