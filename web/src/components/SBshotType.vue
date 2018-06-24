<template>
  <div class="SBshotType">
    <img src="../assets/images/Green_circle_filled.png" class="GCF" @click="gcfClicked" alt="Shot on Goal"/>
    <img src="../assets/images/greenHollow.png" class="GHollow" @click="gHollowClicked"/>
    <img src="../assets/images/redX.png" class="redX" @click="redxClicked"/>
    <div id="sbst-undo" @click="undoClicked"><h3 style="margin: 30px; color: orange;">UNDO</h3></div>
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
      },
      undoClicked: function() {
        this.$emit('SBSTUndo');
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
    border: 5px orange solid;
    border-radius: 35px;
    margin: 50px;
    margin-top: 25px;
  }
  .GCF {
    zoom: 25%;
    margin-top: 60px;
    margin-left: 300px;
    float:left;
  }
  .redX {
    zoom: 25%;
    margin-top: 60px;
    margin-left: 300px;
    float:left;
  }
  .GHollow {
    zoom: 25%;
    margin-top: 60px;
    margin-left: 300px;
    float:left;
  }
  #sbst-undo {
    border-left: 5px orange solid;
    width: 25%;
    float:right;
    height: 90px;
  }
</style>
