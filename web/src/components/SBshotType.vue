<template>
  <div class="SBshotType">
    <img src="../assets/images/Green_circle_filled.png" class="GCF" @click="gcfClicked"/>
    <img src="../assets/images/greenHollow.png" class="GHollow" @click="gHollowClicked"/>
    <img src="../assets/images/redX.png" class="redX" @click="redxClicked"/>
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
        this.$emit('ShotTypeChanged', 'gcf');
      },
      redxClicked: function() {
        this.$emit('ShotTypeChanged', 'redx');
      },
      gHollowClicked: function() {
        this.$emit('ShotTypeChanged', 'ghollow');
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
  }
  .GCF {
    zoom: 25%;
    margin: 60px;
    margin-left: 500px;
    float:left;
  }
  .redX {
    zoom: 25%;
    margin: 60px;
    margin-left: 300px;
    float:left;
  }
  .GHollow {
    zoom: 25%;
    margin: 60px;
    margin-left: 300px;
    float:left;
  }
</style>
