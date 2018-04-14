<template>
  <div id="GameView">
    <button @click="goBack">Go Back</button>
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
    methods: {
      goBack: function() {
        this.$emit('GameViewClose');
      }
    }
  }
</script>

<style scoped>
  #GameView {
    width: 100vw;
    min-height: 100vh;
  }
</style>
