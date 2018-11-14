<template>
  <div class="PlayerStatSelector" :style="height">
    <div class="plTitle">
      <h1 class="pssH1" align="center">{{ title }}</h1>
      </div>
      <div class="playersTable">
        <table cellpadding="10" width="100%">
          <tr v-for="key in Object.keys(players)" @click="trClicked(key)">
            <td class="pssTD" v-if="key === selectedPlayer" style="background-color: rgba(235,95,17,0.7); color: white;">{{ key.replace('p', '#') }}</td>
            <td class="pssTD" v-else>{{ key.replace('p', '#') }}</td>
            <td class="pssTD" v-if="key === selectedPlayer" style="text-align:left; background-color: rgba(235,95,17,0.7); color: white;">{{players[key].trim()}}</td>
            <td class="pssTD" v-else style="text-align:left;">{{players[key].trim()}}</td>
          </tr>
        </table>
      </div>
      <div class="pss_plFooter" @click="trClicked('otherTeam')" v-if="selectedPlayer === 'otherTeam'" style="background-color: rgba(235,95,17,0.7); color: white;">
        Opponent
      </div>
      <div class="pss_plFooter" @click="trClicked('otherTeam')" v-else>
        Opponent
      </div>
    </div>
  </div>
</template>

<script>
  export default {
    name: 'PlayerStatSelector',
    props: {
      players: {
      },
      addPlayerEnabled: {
        default: true
      },
      title: {
        default: 'Players'
      },
      height: {
        default: 'height: 500px;'
      }
    },
    data() {
      return {
        selectedPlayer: ''
      }
    },
    methods: {
      trClicked: function(idx) {
        if(this.selectedPlayer === idx){
          this.selectedPlayer = ''
        }
        else {
          this.selectedPlayer = idx;
        }
        this.$emit('playerSelected', this.selectedPlayer);
      }
    }
  }
</script>

<style scoped>
  .PlayerStatSelector {
    width: 310px;
    background: rgb(255,255,255);
    border-width: 5px;
    border-color: black;
    border-style: solid;
    border-radius: 40px; 
    position: relative;
    margin: 50px 0px 50px 50px;
    box-shadow: 1px 1px 1px 1px grey;
  }

  .plTitle {
    width: 100%;
    height: 75px;
    border-radius: 35px 35px 0px 0px;
    border-bottom-color: black;
    border-bottom-width: medium;
    border-bottom-style: solid;
    background-color: white;
  }

  .pss_plFooter {
    width: 300px;
    height: 75px;
    position: absolute;
    bottom: 0;
    /*background-color: white;*/
    border-radius: 0px 0px 35px 35px;
    border-top-color: black;
    border-top-width: medium;
    border-top-style: solid;
    text-align: center;
    vertical-align: middle;
    line-height: 75px;
    font-size: 25px;
  }
  .pss_plFooter:hover {
    cursor: pointer;
  }

  .playersTable {
    width: 300px;
    max-height: 350px;
    height: 340px;
    background-color: white;
    overflow: scroll;
    margin-bottom: 0px;
    margin: 0px;
    font-weight: bold;
    font-size: 150%;
  }

  table, th {
    border: 1px solid black;
  }

  .pssTD {
    border-bottom: 1px solid black;
  }

  tr {
    width: 500px;
  }

  tr:hover td {
    background-color: rgba(235,95,17,0.7);
    cursor: pointer;
    color: white;
  }

  .pssH1 {
    line-height: 75px;
    height: 75px;
    font-weight: bold;
  }
</style>
