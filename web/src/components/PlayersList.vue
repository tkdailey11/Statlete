<template>
  <div id="PlayersList">
    <div id="plTitle">
      <h1 align="center">{{ title }}</h1>
    </div>
    <div id="playersTable">
      <table cellpadding="10" width="100%">
        <tr v-for="key in Object.keys(players)" @click="trClicked(key)">
          <td hover="background-color: rgb(235,95,17);">{{ key.replace('p', '#') }}</td>
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
        this.$emit('playerSelected', idx);
      }
    }
  }
</script>

<style scoped>
  #PlayersList {
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

  #plTitle {
    width: 100%;
    height: 75px;
    border-radius: 35px 35px 0px 0px;
    border-bottom-color: rgb(235,95,17);
    border-bottom-width: medium;
    border-bottom-style: solid;
    background-color: white;
  }

  #plFooter {
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
  #plFooter:hover {
    background-color: rgba(235,95,17,0.7);
    cursor: pointer;
    color: white;
  }

  #playersTable {
    width: 300px;
    max-height: 350px;
    height: 350px;
    background-color: white;
    overflow: scroll;
    margin-bottom: 0px;
    margin: 0px;
  }

  table, th {
    border: 1px solid rgb(235,95,17);
  }

  td {
    border-bottom: 1px solid rgb(235,95,17);
    color: rgb(224,0,16);
    background-color: white;
  }

  tr {
    width: 500px;
  }

  tr:hover td {
    background-color: rgba(235,95,17,0.7);
    cursor: pointer;
    color: white;
  }

  h1 {
    line-height: 75px;
    height: 75px;
    color: rgb(224,0,16);
  }
</style>
