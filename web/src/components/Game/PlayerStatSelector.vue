<template>
  <div class="PlayerStatSelector" :style="height">
    <div class="plTitle">
      <h1 class="pssH1" align="center">{{ title }}</h1>
      </div>
      <div class="playersTable">
        <table cellpadding="10" width="100%">
          <tr v-for="key in Object.keys(players)" @click="trClicked(key)">
            <td class="pssTD_selected" v-if="key === selectedPlayer">{{ key.replace('p', '#') }}</td>
            <td class="pssTD" v-else>{{ key.replace('p', '#') }}</td>
            <td class="pssTD_selected" v-if="key === selectedPlayer" style="text-align:left;">{{players[key].trim()}}</td>
            <td class="pssTD" v-else style="text-align:left;">{{players[key].trim()}}</td>
          </tr>
        </table>
      </div>
      <div class="pss_plFooter_selected" @click="trClicked('otherTeam')" v-if="selectedPlayer === 'otherTeam'" >
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
    border-width: 5px;
    border-style: solid;
    border-radius: 40px; 
    position: relative;
    margin: 50px 0px 50px 50px;
  }

  .plTitle {
    width: 100%;
    height: 75px;
    border-radius: 35px 35px 0px 0px;
    border-bottom-width: medium;
    border-bottom-style: solid;
  }

  .pss_plFooter_selected {
        width: 300px;
    height: 75px;
    position: absolute;
    bottom: 0;
    border-radius: 0px 0px 35px 35px;
    border-top-width: medium;
    border-top-style: solid;
    text-align: center;
    vertical-align: middle;
    line-height: 75px;
    font-size: 25px;
    background-color: rgba(224, 0, 16, 0.5);
  }

  .pss_plFooter {
    width: 300px;
    height: 75px;
    position: absolute;
    bottom: 0;
    border-radius: 0px 0px 35px 35px;
    border-top-width: medium;
    border-top-style: solid;
    text-align: center;
    vertical-align: middle;
    line-height: 75px;
    font-size: 25px;
  }
  .pss_plFooter:hover {
    cursor: pointer;
    background-color: rgba(224, 0, 16, 0.5);
  }

  .playersTable {
    width: 300px;
    max-height: 350px;
    height: 340px;
    overflow: scroll;
    margin-bottom: 0px;
    margin: 0px;
    font-weight: bold;
    font-size: 150%;
    border-width: 1px;
    border-style: solid;
  }

  .pssTD {
    border-bottom-width: 2px;
    border-bottom-style: solid;
  }

  .pssTD_selected {
    border-bottom-width: 2px;
    border-bottom-style: solid;
    background-color: rgba(224, 0, 16, 0.5);
  }

  tr {
    width: 500px;
  }

  tr:hover td {
    cursor: pointer;
    background-color: rgba(224, 0, 16, 0.5);
  }

  .pssH1 {
    line-height: 75px;
    height: 75px;
    font-weight: bold;
  }
</style>
