<template>
  <div id="GamesList">
    <div id="title">
      <h1 align="center">Games</h1>
    </div>
    <div id="gamesTable">
      <table cellpadding="10" width="100%">
        <tr v-for="idx in gamesList.length" @click="trClicked(idx)" :key="'game-'+idx">
          <td>{{ gamesList[idx-1] }}</td>
        </tr>
      </table>
    </div>
    <div id="glFooter" v-if="addGameEnabled" @click="addGameClicked">
      Add New Game
    </div>
  </div>
</template>

<script>
  import firebase from 'firebase'
  import { mapGetters, mapMutations } from 'vuex';

  export default {
    name: 'GamesList',
    props: {
      games: {
        default(){
          return [{gameID: 'game1'}, {gameID: 'game2'}]
        }
      },
      addGameEnabled: {
        default(){
          return true;
        }
      }
    },
    computed: {
      ...mapGetters({
        gamesList: 'mainStore/gamesList'
      })
    },
    methods: {
      addGameClicked: function() {
        this.$emit('AddGame');
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
    border-color: rgb(235,95,17);
    border-style: solid;
    border-radius: 40px;
    position: relative;
    box-shadow: 5px 5px 5px grey;
  }

  #title {
    width: 300px;
    height: 75px;
    background: white;
    border-radius: 35px 35px 0px 0px;
    border-bottom-color: rgb(235,95,17);
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
    border-top-color: rgb(235,95,17);
    border-top-width: medium;
    border-top-style: solid;
    text-align: center;
    vertical-align: middle;
    line-height: 75px;
    font-size: 25px;
    color: rgb(224,0,16);
  }

  #glFooter:hover {
    background-color: rgba(235,95,17,0.7);
    cursor: pointer;
    color: white;
  }

  #gamesTable {
    width: 300px;
    max-height: 350px;
    height: 350px;
    background-color: white;
    overflow: scroll;
  }

  tr:hover td {
    background-color: rgba(235,95,17,0.7);
    cursor: pointer;
    color: white;
  }

  table, th, td {
    border: 1px solid rgb(235,95,17);
  }

  td {
    border-bottom: 1px solid rgb(235,95,17);
    color: rgb(224,0,16);
    background-color: white;
  }

  h1 {
    line-height: 75px;
    height: 75px;
    color: rgb(224,0,16);
  }
</style>
