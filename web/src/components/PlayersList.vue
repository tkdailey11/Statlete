<template>
  <div id="PlayersList">
    <div id="plTitle">
      <h1 align="center">{{ title }}</h1>
    </div>
    <div id="playersTable">
      <table cellpadding="10" width="100%">
        <tr v-for="key in Object.keys(players)" @click="trClicked(key)">
          <td>{{ key.replace('p', '#') }}</td>
          <td style="text-align:left;">{{players[key].trim()}}</td>
        </tr>
      </table>
    </div>
    <div id="plFooter" @click="$emit('addPlayerClicked')" v-if="addPlayerEnabled">
      Add New Player
    </div>
    <div id="plFooter" v-else>
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
        this.$emit('playerSelected');
      }
    }
  }
</script>

<style scoped>
  #PlayersList {
    width: 310px;
    height: 500px;
    background: rgb(180, 41, 102);
    margin-left: 50px;
    border-width: 5px;
    border-color: rgb(180, 41, 102);
    border-style: solid;
    border-radius: 35px;
    position: relative;
  }

  #plTitle {
    width: 300px;
    height: 75px;
    border-radius: 35px 35px 0px 0px;
    border-bottom-color: rgb(180, 41, 102);
    border-bottom-width: medium;
    border-bottom-style: solid;
    background-color: #fadc7f;
  }

  #plFooter {
    width: 300px;
    height: 75px;
    position: absolute;
    bottom: 0;
    background-color: #fadc7f;
    border-radius: 0px 0px 35px 35px;
    border-top-color: rgb(180, 41, 102);
    border-top-width: medium;
    border-top-style: solid;
    text-align: center;
    vertical-align: middle;
    line-height: 75px;
    font-size: 25px;
    color: rgb(180, 41, 102);
  }

  #playersTable {
    width: 300px;
    max-height: 350px;
    height: 350px;
    background-color: #fadc7f;
    overflow: scroll;
  }

  table, th {
    border: 1px solid rgb(180, 41, 102);
  }

  td {
    border-bottom: 1px solid rgb(180, 41, 102);
    color: rgb(180, 41, 102);
    background-color: #fadc7f;
  }

  h1 {
    line-height: 75px;
    height: 75px;
    color: rgb(180, 41, 102);
  }
</style>
