<template>
  <div id="PlayerDetailView">
    <button @click="goBack">Go Back</button>
  </div>
</template>

<script>
  export default {
    name: 'PlayerDetailView',
    methods: {
      goBack: function() {
        this.$emit('PlayerDetailViewClose');
        console.log('CLOSE');
      }
    }
  }
</script>

<style scoped>
  #PlayerDetailView {
    width: 100%;
    background-color: pink;
  }
</style>
