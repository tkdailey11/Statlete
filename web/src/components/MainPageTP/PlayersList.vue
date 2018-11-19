<template>
  <div class="PlayersList">
    <div class="plTitle">
      <h1 class="plH1" align="center">{{ title }}</h1>
    </div>
    <div id="playersTable">
      <table class="pl_table" cellpadding="10" width="100%">
        <tr class="plTR" v-for="key in Object.keys(players)" @click="trClicked(key)" :key="key">
          <td class="plTD">{{ key.replace('p', '#') }}</td>
          <td class="plTD" style="text-align:left;">{{players[key].trim()}}</td>
        </tr>
      </table>
    </div>
    <div class="plFooter" @click="$emit('addPlayerClicked')" v-if="addPlayerEnabled">
      <h3 class="plH1" align="center">Add New Player</h3>
    </div>
    <div class="plFooter" v-else>
    </div>
  </div>
</template>

<script>
  export default {
    name: 'PlayersList',
    props: {
      players: {
        default(){
          return []
        }
      },
      addPlayerEnabled: {
        default: true
      },
      title: {
        default: 'Players'
      }
    },
    methods: {
      trClicked: function(idx) {
        console.log(idx + " clicked");
        this.$emit('playerSelected', idx);
      }
    }
  }
</script>

<style scoped>
  .PlayersList {
    height: 70vh;
    border-width: 2px;
    border-style: solid; 
    border-radius: 20px; 
    position: relative;
  }

  .plTitle {
    height: 15%;
    border-radius: 20px 20px 0px 0px;
    border-bottom-width: 2px;
    border-bottom-style: solid;
  }

  .plFooter {
    width: 100%;
    height: 15%;
    position: absolute;
    bottom: 0;
    border-radius: 0px 0px 20px 20px;
    border-top-width: 2px;
    border-top-style: solid;
    overflow: hidden;
    padding-top: 2.5%;
  }
  .plFooter:hover {
    cursor: pointer;
  }

  #playersTable {
    width: 100%;
    height: 70%;
    overflow: scroll;
  }

  tr {
    width: 100%;
  }

  .plTR:hover td{
    cursor: pointer;
  }

  .plH1 {
    line-height: 160%;
    height: 160%;
    overflow-x: hidden;
  }

  .plTD {
    width: 50%;
    overflow-x: hidden;
  }

    @media screen and (max-width: 450px) {
    .PlayersList {
      height: 400px;
      width: 300px;
    }
  }
</style>
