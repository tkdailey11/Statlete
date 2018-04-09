<template>
  <div id="TeamSettings">
    <button @click="goBack">Go Back</button>
  </div>
</template>

<script>
  export default {
    name: 'TeamSettings',
    methods: {
      goBack: function() {
        this.$emit('TeamSettingsClose');
        console.log('CLOSE');
      }
    }
  }
</script>

<style scoped>
  #TeamSettings {
    width: 100%;
    background-color: blue;
  }
</style>
