<template>
  <div id="SBdataEntry">
    <div id="title">
      <h2 align="center">Team/Player Stats</h2>
    </div>
    <div id="dataTable">
      <table width="100%">
        <tr v-for="obj in dataPoints">
          <td class="minusButton" @click="minusClicked(obj)">
            <img src="../assets/images/minusButton.png">
          </td>
          <td class="dataLabelCell" style="max-width: 120px; text-overflow:ellipsis;">
            <p class="dataLabel">{{obj}}</p>
          </td>
          <td class="plusButton" @click="plusClicked(obj)">
            <img src="../assets/images/plusButton.png">
          </td>
        </tr>
      </table>
    </div>
  </div>
</template>

<script>
  export default {
    name: 'GamesList',
    props: {
      dataPoints: {
        default(){
          return ['Goals', 'Assists', 'Shots', 'Yellow Cards1234567890', 'Red Cards', 'Saves', 'Shots', 'S.O.G.']
        }
      }
    },
    methods: {
      minusClicked(obj) {
        alert('Minus: ' + obj);
      },
      plusClicked(obj) {
        alert('Plus: ' + obj);
      }
    }
  }
</script>

<style scoped>
  #SBdataEntry {
    width: 310px;
    height: 500px;
    background: white;
    margin-left: 50px;
    border-width: 5px;
    border-color: orange;
    border-style: solid;
    border-radius: 35px;
    position: relative;
    margin: 50px 0px 50px 50px;
  }

  #title {
    width: 300px;
    height: 75px;
    background: white;
    border-radius: 35px 35px 0px 0px;
    border-bottom-color: orange;
    border-bottom-width: medium;
    border-bottom-style: solid;
    background-color: white;
  }

  #dataFooter {
    width: 300px;
    height: 75px;
    position: absolute;
    bottom: 0;
    background-color: white;
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

  #dataTable {
    width: 300px;
    max-height: 413px;
    height: 413px;
    background-color: white;
    overflow: scroll;
    border-radius: 0px 0px 30px 30px;
  }

  table, th {
    border: 1px solid orange;
  }

  td {
    border-bottom: 1px solid orange;
    color: rgb(180, 41, 102);
  }

  h2 {
    line-height: 75px;
    height: 75px;
    color: rgb(180, 41, 102);
    text-overflow: ellipsis;
    white-space: nowrap;

  }
  img {
    zoom: 50%;
  }
  .dataLabelCell {
    overflow: hidden;
  }
  .dataLabel {
    margin-top: 15px;
    font-size: 25px;
    line-height: 50px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    text-align: center;
vertical-align: middle;

  }
</style>
