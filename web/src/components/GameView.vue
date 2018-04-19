<template>
  <div id="GameView">
    <div class="TopBanner">
      <h2 style="float: left; margin: 30px 30px 0px 10px;">{{gameID}}</h2>
    </div>
    <player-stat-selector style="float: left;"></player-stat-selector>
    <sb-data-entry style="float: left;"></sb-data-entry>
    <div style="float: left;">
      <sb-field></sb-field>
      <sb-shot-type></sb-shot-type>
    </div>
  </div>
</template>

<script>
  export default {
    name: 'GameView',
    props: {
      gameID: ''
    }
  }
</script>

<style scoped>
  #GameView {
    width: 100vw;
    min-height: 100vh;
    background-color: white;
  }
  .TopBanner {
    width: 100vw;
    background-color: grey;
    min-height: 100px;
    margin-bottom: -20px;
    border: medium black solid;
  }
</style>
