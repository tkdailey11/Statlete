<template>
  <div class="SBshotType">
    <div id="gcfDiv">
      <img v-if="this.activeType=='gcf'" src="../../assets/images/RedFilledCircle.png" class="GCF activeTypeClass" @click="gcfClicked" alt="Shot on Goal"/>
      <img v-else src="../../assets/images/RedFilledCircle.png" class="GCF" @click="gcfClicked" alt="Shot on Goal"/>
      <figcaption v-if="isSoccer" class="myCaption">Goal</figcaption>
      <figcaption v-else class="myCaption">FG Made</figcaption>
    </div>
    <div id="ghollowDiv" v-if="isSoccer">
      <img v-if="this.activeType=='ghollow'" src="../../assets/images/RedHollowCircleThick.png" class="GHollow activeTypeClass" @click="gHollowClicked"/>
      <img v-else src="../../assets/images/RedHollowCircleThick.png" class="GHollow" @click="gHollowClicked"/>
      <figcaption class="myCaption">Shot on Goal</figcaption>
    </div>
    <div id="redXDiv">
      <img v-if="this.activeType=='redx'" src="../../assets/images/RedX.png" class="redX activeTypeClass" @click="redxClicked"/>
      <img v-else src="../../assets/images/RedX.png" class="redX" @click="redxClicked"/>
      <figcaption class="myCaption" v-if="isSoccer">Shot</figcaption>
      <figcaption class="myCaption" v-else>FG Miss</figcaption>
    </div>
  </div>
</template>

<script>
  import { mapGetters } from 'vuex';
  export default {
    name: 'SBshotType',
    data() {
      return {
        activeType: 'gcf'
      }
    },
    computed: {
      ...mapGetters({
        selectedTeamSport: 'mainStore/selectedTeamSport'
      }),
      isSoccer: function() {
        return this.selectedTeamSport==1;
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
      }
    }
  }
</script>

<style scoped>
  .SBshotType{
    width: 120px;
    height: 500px;
    background: white;
    border: 5px black solid;
    border-radius: 35px;
    display: flex;
    flex-direction: column;
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
  .myCaption {
    font-weight: bold; 
    margin-top: 10px;
  }
</style>
