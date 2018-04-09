<template>
  <div id="GameView">
    <button @click="goBack">Go Back</button>
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
    width: 100%;
    background-color: grey;
  }
</style>
