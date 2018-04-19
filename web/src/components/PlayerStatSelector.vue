<template>
  <div class="PlayerStatSelector">
    <div class="plTitle">
      <h1 align="center">{{ title }}</h1>
      </div>
      <div class="playersTable">
        <table cellpadding="10" width="100%">
          <tr v-for="key in Object.keys(players)" @click="trClicked(key)">
            <td v-if="key === selectedPlayer" hover="background-color: orange;" style="background-color: rgba(180, 41, 102, 0.5);">{{ key.replace('p', '#') }}</td>
            <td v-else hover="background-color: orange;" style="background-color: white;">{{ key.replace('p', '#') }}</td>
            <td v-if="key === selectedPlayer" style="text-align:left; background-color: rgba(180, 41, 102, 0.5);">{{players[key].trim()}}</td>
            <td v-else style="text-align:left; background-color: white;">{{players[key].trim()}}</td>
          </tr>
        </table>
      </div>
      <div class="plFooter" @click="trClicked('otherTeam')" v-if="selectedPlayer === 'otherTeam'" style="background-color: rgba(180, 41, 102, 0.5);">
        Opponent
      </div>
      <div class="plFooter" @click="trClicked('otherTeam')" v-else style="background-color: white;">
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
        default(){
          return {
            'p1': 'Tyler',
            'p2': 'Joe',
            'p3': 'Brandon',
            'p4': 'Taylor',
            'p5': 'Nate',
            'p6': 'Tyler2',
            'p7': 'Joe2',
            'p8': 'Brandon2',
            'p9': 'Taylor2',
            'p0': 'Nate2'
          }
        }
      },
      addPlayerEnabled: {
        default: true
      },
      title: {
        default: 'Players'
      }
    },
    data() {
      return {
        selectedPlayer: ''
      }
    },
    methods: {
      trClicked: function(idx) {
        this.selectedPlayer = idx;
        this.$emit('playerSelected', this.selectedPlayer);
        console.log(idx + ' Clicked');
      }
    }
  }
</script>

<style scoped>
  .PlayerStatSelector {
    width: 310px;
    height: 500px;
    background: white;
    border-width: 5px;
    border-color: orange;
    border-style: solid;
    border-radius: 40px;
    position: relative;
    margin: 50px 0px 50px 50px;
  }

  .plTitle {
    width: 100%;
    height: 75px;
    border-radius: 35px 35px 0px 0px;
    border-bottom-color: orange;
    border-bottom-width: medium;
    border-bottom-style: solid;
    background-color: white;
  }

  .plFooter {
    width: 300px;
    height: 75px;
    position: absolute;
    bottom: 0;
    /*background-color: white;*/
    border-radius: 0px 0px 35px 35px;
    border-top-color: orange;
    border-top-width: medium;
    border-top-style: solid;
    text-align: center;
    vertical-align: middle;
    line-height: 75px;
    font-size: 25px;
    color: rgb(180, 41, 102);
  }
  .plFooter:hover {
    background-color: rgba(255,165,0, 0.7);
  }

  .playersTable {
    width: 300px;
    max-height: 350px;
    height: 340px;
    background-color: white;
    overflow: scroll;
    margin-bottom: 0px;
    margin: 0px;
  }

  table, th {
    border: 1px solid orange;
  }

  td {
    border-bottom: 1px solid orange;
    color: rgb(180, 41, 102);
    /*background-color: white;*/
  }

  tr {
    width: 500px;
  }

  tr:hover td {
    background-color: rgba(255,165,0, 0.7);
    cursor: pointer;
  }

  h1 {
    line-height: 75px;
    height: 75px;
    color: rgb(180, 41, 102);
  }
</style>
