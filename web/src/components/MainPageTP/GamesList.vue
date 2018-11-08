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
  .GamesList {
    width: 304px;
    height: 500px;
    background: white;
    margin-left: 50px;
     border-width: 2px;
    border-style: solid; 
    border-radius: 20px; 
    position: relative;
    box-shadow: 1px 1px 1px grey;
  }

  .gl_title {
    width: 300px;
    height: 75px;
    background: white;
    border-radius: 35px 35px 0px 0px;
    border-bottom-width: 2px;
    border-bottom-style: solid;
    background-color: white;
  }

  .glFooter {
    width: 300px;
    height: 75px;
    position: absolute;
    bottom: 0;
    border-radius: 0px 0px 35px 35px;
    border-top-width: 2px;
    border-top-style: solid;
    text-align: center;
    vertical-align: middle;
    line-height: 75px;
    font-size: 25px;
  }

  .glFooter:hover {
    cursor: pointer;
  }

  #gamesTable {
    width: 300px;
    max-height: 350px;
    height: 350px;
    background-color: white;
    overflow: scroll;
  }

  .glTR:hover .glTD {
    cursor: pointer;
  }

  .gl_table {
    /* border-width: 1px;
    border-style: solid; */
  }

  .glTD {
    /* border-bottom-style: solid;
    border-bottom-width: 1px; */
    background-color: white;
  }

  .glH1 {
    line-height: 75px;
    height: 75px;
  }
</style>
