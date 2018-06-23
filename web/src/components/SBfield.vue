<template>
  <div class="SBfield">
    <div class="fill">
      <img @click="fieldClicked" src="../assets/images/soccerField.png" alt="" id="FieldIMG"/>
      <div class="field_shot" v-for="shot in shots">
        <img v-if="shot.shotType=='gcf'" src="../assets/images/Green_circle_filled.png" alt="" class="field_gcf" :style="[shot.style]"/>
        <img v-if="shot.shotType=='redx'" src="../assets/images/redX.png" alt="" class="field_redx" :style="[shot.style]"/>
        <img v-if="shot.shotType=='ghollow'" src="../assets/images/greenHollow.png" alt="" class="field_ghollow" :style="[shot.style]"/>
        <!--<img v-else src="../assets/images/redX.png" alt="" class="field_redx" style="left: 0px; top: 0px;"/>-->
      </div>
    </div>
  </div>
</template>

<script>
  export default {
    name: 'SBfield',
    props: ['fieldShotType'],
    data() {
      return {
        shots: []
      }
    },
    methods: {
      fieldClicked() {
        //alert(this.fieldShotType);
      }
    },
    mounted() {
      //do something after mounting vue instancejQuery(document).ready(function() {
      var self = this;
      jQuery('#FieldIMG').click(function(e) {
        var offset = jQuery(this).offset();
        //alert('Offset left: ' + offset.left + '\nOffset top: ' + offset.top);
        //alert('X: ' + e.pageX + ' Y: ' + e.pageY);
        //alert('left: ' + (e.pageX - offset.left - 290) + '  top: ' + (e.pageY - offset.top) + '  width: ' + e.width);

        self.shots.push({ style: { left: e.pageX - offset.left - 300 + 'px', top: e.pageY - offset.top - 255 + 'px' }, shotType: self.fieldShotType});
        console.log(self.shots);
      });
    }
  }
</script>

<style scoped>
  .SBfield {
    width: 600px;
    height: 500px;
    background: orange;
    margin-left: 50px;
    border-width: 5px;
    border-color: orange;
    border-style: solid;
    border-radius: 35px;
    margin: 50px;
    margin-bottom: 25px;
  }
  .fill {
    display: flex;
    justify-content: center;
    align-items: center;
    overflow: hidden;
  }
  .fill img {
      flex-shrink: 0;
      margin: 6px;
      border-radius: 35px;
  }
  #FieldIMG {
    border: 5px #fadc7f solid;
    width: 97%;
    height: 97%;
  }

  .field_shot {
    position: absolute;
  }

  .field_gcf {
    position: absolute;
    min-width: 20px;
    min-height: 20px;
    max-height: 20px;
    max-width: 20px;
    border: 1px white solid;
  }
  .field_ghollow {
    position: absolute;
    min-width: 20px;
    min-height: 20px;
    max-height: 20px;
    max-width: 20px;
    border: 1px white solid;
  }
  .field_redx {
    position: absolute;
    min-width: 20px;
    min-height: 20px;
    max-height: 20px;
    max-width: 20px;
    border: 1px white solid;
  }
</style>
