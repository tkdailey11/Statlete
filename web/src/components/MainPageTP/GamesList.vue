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
    height: 500px;
    border-width: 2px;
    border-style: solid; 
    border-radius: 20px; 
    position: relative;
  }

  .gl_title {
    height: 75px;
    border-radius: 20px 20px 0px 0px;
    border-bottom-width: 2px;
    border-bottom-style: solid;
  }

  .glFooter {
    width: 100%;
    height: 75px;
    position: absolute;
    bottom: 0;
    border-radius: 0px 0px 20px 20px;
    border-top-width: 2px;
    border-top-style: solid;
    text-align: center;
    vertical-align: middle;
    line-height: 75px;
    overflow-x: hidden;
  }

  .glFooter:hover {
    cursor: pointer;
  }

  #gamesTable {
    width: inherit;
    height: 344px;
    overflow: scroll;
  }

  .glTR:hover .glTD {
    cursor: pointer;
  }

  .gl_table {
    /* border-width: 1px;
    border-style: solid; */
  }

  .glH1 {
    line-height: 75px;
    height: 75px;
  }

  .glTD {
    font-size: 20px;
    overflow-x: hidden;
  }
</style>
