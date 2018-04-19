<template>
  <div class="SBshotType">
    <img src="../assets/images/Green_circle_filled.png" class="GCF" @click="gcfClicked"/>
  </div>
</template>

<script>
  export default {
    name: 'SBshotType',
    data() {
      return {
        activeType: 'gcf'
      }
    },
    methods: {
      gcfClicked: function() {
        activeType = 'gcf';
        alert('gcf');
      }
    }
  }
</script>

<style scoped>
  .SBshotType{
    width: 600px;
    height: 100px;
    background: white;
    margin-left: 50px;
    border-width: 5px;
    border-color: orange;
    border-style: solid;
    border-radius: 35px;
    margin: 50px;
    margin-top: 25px;
    opacity: 0.5;
  }
  .GCF {
    zoom: 25%;
    margin: 60px;
    margin-left: 500px;
    float:left;
  }
</style>
