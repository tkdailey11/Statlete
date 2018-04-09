<template>
  <div id="TeamStats">
    <button @click="goBack">Go Back</button>
  </div>
</template>

<script>
  export default {
    name: 'TeamStats',
    methods: {
      goBack: function() {
        this.$emit('TeamStatsClose');
        console.log('CLOSE');
      }
    }
  }
</script>

<style scoped>
  #TeamStats {
    width: 100%;
    background-color: orange;
  }
</style>
