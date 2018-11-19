<template>
  <div class="GamesList">
    <div class="gl_title">
      <h1 class="glH1" align="center">Games</h1>
    </div>
    <div id="gamesTable">
      <table class="gl_table" cellpadding="10" width="100%">
        <tr class="glTR" v-for="idx in gamesList.length" @click="trClicked(idx)" :key="'game-'+idx">
          <td class="glTD">{{ gamesList[idx-1] }}</td>
        </tr>
      </table>
    </div>
    <div class="glFooter" v-if="addGameEnabled" @click="addGameClicked">
      <h3 class="glH1" align="center">Add New Game</h3>
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
  .GamesList {
    border-width: 2px;
    border-style: solid; 
    border-radius: 20px; 
    position: relative;
    height: 70vh;
  }

  .gl_title {
    height: 15%;
    border-radius: 20px 20px 0px 0px;
    border-bottom-width: 2px;
    border-bottom-style: solid;
  }

  .glFooter {
    width: 100%;
    height: 15%;
    position: absolute;
    bottom: 0;
    border-radius: 0px 0px 20px 20px;
    border-top-width: 2px;
    border-top-style: solid;
    padding-top: 2.5%;
    overflow: hidden;
  }

  .glFooter:hover {
    cursor: pointer;
  }

  #gamesTable {
    width: 100%;
    height: 70%;
    overflow: scroll;
  }

  .glTR:hover .glTD {
    cursor: pointer;
  }

  .glTR {
    width: 100%;
  }

  .gl_table {
    width: 100%;
  }

  .glH1 {
    line-height: 160%;
    height: 160%;
    overflow-x: hidden;
  }

  .glTD {
    width: 100%;
    overflow-x: hidden;
  }

  @media screen and (max-width: 450px) {
    .GamesList {
      min-height: 400px;
      height: 400px;
      width: 300px;
    }
  }
</style>
