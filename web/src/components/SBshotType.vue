<template>
  <div class="SBshotType">
    <img v-if="this.activeType=='gcf'" src="../assets/images/Green_circle_filled.png" class="GCF activeTypeClass" @click="gcfClicked" alt="Shot on Goal"/>
    <img v-else src="../assets/images/Green_circle_filled.png" class="GCF" @click="gcfClicked" alt="Shot on Goal"/>

    <img v-if="this.activeType=='ghollow'" src="../assets/images/greenHollow.png" class="GHollow activeTypeClass" @click="gHollowClicked"/>
    <img v-else src="../assets/images/greenHollow.png" class="GHollow" @click="gHollowClicked"/>

    <img v-if="this.activeType=='redx'" src="../assets/images/redX.png" class="redX activeTypeClass" @click="redxClicked"/>
    <img v-else src="../assets/images/redX.png" class="redX" @click="redxClicked"/>

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
        this.activeType = 'gcf';
      },
      redxClicked: function() {
        this.$emit('ShotTypeChanged', 'redx');
        this.activeType = 'redx';
      },
      gHollowClicked: function() {
        this.$emit('ShotTypeChanged', 'ghollow');
        this.activeType = 'ghollow';
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
    box-shadow: 5px 5px 5px grey;
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
  .activeTypeClass {
    opacity: 0.4;
  }
</style>
