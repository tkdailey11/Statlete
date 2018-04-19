<template>
  <div class="SBfield">
    <div class="fill">
      <img src="../assets/images/soccerField.png" alt="" id="FieldIMG"/>
      <img v-for="shot in shots" src="../assets/images/Green_circle_filled.png" alt="" class="field_gcf" />
    </div>
  </div>
</template>

<script>
  export default {
    name: 'SBfield',
    data() {
      return {
        shots: []
      }
    },
    mounted() {
      //do something after mounting vue instance
      jQuery(document).ready(function() {
        jQuery('#FieldIMG').click(function(e) {
          var offset = jQuery(this).offset();
          alert(e.pageY - offset.top);
          //shots.push({left: e.pageX - offset.left, top: e.pageY - offset.top})
        });
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
      min-width: 97%;
      min-height: 97%;
      margin: 6px;
      border-radius: 35px;
      border: 5px #fadc7f solid;
      opacity: 0.5;
  }
  #FieldIMG {
    z-index: 1;
  }
</style>
