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
    height: 500px;
    margin-left: 50px;
    border-width: 2px;
    border-style: solid; 
    border-radius: 20px; 
    position: relative;
  }

  .plTitle {
    width: 100%;
    height: 75px;
    border-radius: 20px 20px 0px 0px;
    border-bottom-width: medium;
    border-bottom-style: solid;
  }

  .plFooter {
    width: 100%;
    height: 75px;
    position: absolute;
    bottom: 0;
    border-radius: 0px 0px 20px 20px;
    border-top-width: medium;
    border-top-style: solid;
    text-align: center;
    vertical-align: middle;
    line-height: 75px;
    overflow-x: hidden;
  }
  .plFooter:hover {
    cursor: pointer;
  }

  #playersTable {
    width: inherit;
    max-height: 350px;
    height: 344px;
    overflow: scroll;
    margin-bottom: 0px;
    margin: 0px;
  }

  tr {
    width: 500px;
  }

  .plTR:hover td{
    cursor: pointer;
  }

  .plH1 {
    line-height: 75px;
    height: 75px;
  }

  .plTD {
    font-size: 20px;
    overflow-x: hidden;
  }
</style>
