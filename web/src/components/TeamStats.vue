<template>
  <div id="TeamStats">
    <button @click="goBack">Go Back</button>
<!--
Code here
-->
    <table id="Stats">
      <thead>
        <th />
        <th>
          Assists
        </th>
        <th>
          Corners
        </th>
        <th>
          Crosses
        </th>
        <th>
          Fouls
        </th>
        <th>
          Goals
        </th>
        <th>
          Offsides
        </th>
        <th>
          Yellow Cards
        </th>
        <th>
          Red Cards
        </th>
        <th>
          Saves
        </th>
        <th>
          Shots
        </th>
        <th>
          Shots On Goal
        </th>
      </thead>

      <tr v-for="i in 10">
          {{'Player ' + i}}
        <td v-for="i in 11">
          {{i}}
        </td>
      </tr>
    </table>
  </div>
</template>

<script>
  export default {
    name: 'TeamStats',
    methods: {
      goBack: function() {
        this.$emit('TeamStatsClose');
        console.log('CLOSE');
      },
      cellClick: function(x) {
        console.log(x);
      }
    }
  }
</script>

<style scoped>
  #TeamStats {
    width: 100%;
    background-color: orange;
  }
  #MyBox{
    width: 100px;
    height: 100px;
    background-color: red;
    float: left;
    margin: 10px;
  }
  #Stats {
    min-width: 300px;
    min-height: 300px;
    background-color: purple;
    color: white;
    border-style: solid;
    border-color: white;
    border-width: medium;
  }
  tr td {
    border-style: solid;
    border-color: white;
    border-width: medium;
  }
  th {
    border-style: solid;
    border-color: white;
    border-width: medium;
  }

</style>
