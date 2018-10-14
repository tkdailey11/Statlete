<template>
  <div class="SBshotType">
    <div id="gcfDiv">
      <img v-if="this.activeType=='gcf'" src="../assets/images/RedFilledCircle.png" class="GCF activeTypeClass" @click="gcfClicked" alt="Shot on Goal"/>
      <img v-else src="../assets/images/RedFilledCircle.png" class="GCF" @click="gcfClicked" alt="Shot on Goal"/>
      <figcaption>Goal</figcaption>
    </div>

    <div id="ghollowDiv">
      <img v-if="this.activeType=='ghollow'" src="../assets/images/RedHollowCircleThick.png" class="GHollow activeTypeClass" @click="gHollowClicked"/>
      <img v-else src="../assets/images/RedHollowCircleThick.png" class="GHollow" @click="gHollowClicked"/>
      <figcaption>Shot on Goal</figcaption>
    </div>

    <div id="redXDiv">
      <img v-if="this.activeType=='redx'" src="../assets/images/RedX.png" class="redX activeTypeClass" @click="redxClicked"/>
      <img v-else src="../assets/images/RedX.png" class="redX" @click="redxClicked"/>
      <figcaption>Shot</figcaption>
    </div>

    <!--<div id="sbst-undo" @click="undoClicked"><h3 style="margin: 30px; color: orange;">UNDO</h3></div>-->
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
    height: 120px;
    background: white;
    margin-left: 50px;
    border: 5px black solid;
    border-radius: 35px;
    margin: 50px;
    margin-top: 25px;
    box-shadow: 5px 5px 5px grey;
    display: flex;
  }
  #gcfDiv{
    flex-grow: 3;
  }
  #ghollowDiv{
    flex-grow: 3;
  }
  #redXDiv{
    flex-grow: 3;
  }
  .GCF {
    zoom: 8%;
    margin-top: 150px;
  }
  .redX {
    zoom: 8%;
    margin-top: 150px;
  }
  .GHollow {
    zoom: 8%;
    margin-top: 150px;
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
