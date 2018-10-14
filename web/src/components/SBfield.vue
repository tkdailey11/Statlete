<template>
  <div class="SBfield">
    <div class="fill">
      <img v-if="selectedTeamSport==='soccer'" @click="fieldClicked" src="../assets/images/soccerField.png" alt="" id="FieldIMG"/>
      <img v-else @click="fieldClicked" src="../assets/images/basketball-court.png" alt="" id="FieldIMG"/>      
      <div class="field_shot" v-for="shot in shotsList" :key="getRand() + shot.shotType">
        <img v-if="shot.shotType=='gcf'" src="../assets/images/RedFilledCircle.png" alt="" class="field_gcf" :style="[shot.style]"/>
        <img v-if="shot.shotType=='redx'" src="../assets/images/RedX.png" alt="" class="field_redx" :style="[shot.style]"/>
        <img v-if="shot.shotType=='ghollow'" src="../assets/images/RedHollowCircleThick.png" alt="" class="field_ghollow" :style="[shot.style]"/>
        <!--<img v-else src="../assets/images/redX.png" alt="" class="field_redx" style="left: 0px; top: 0px;"/>-->
      </div>
    </div>
  </div>
</template>

<script>
  import firebase from 'firebase'
  import { mapGetters, mapMutations } from 'vuex';

  export default {
    name: 'SBfield',
    props: {
      shots: null
    },
    data() {
      return {
        shotsList: [],
        shotsCount: 0
      }
    },
    computed: {
      ...mapGetters({
        activeGameId: 'mainStore/activeGameId',
        shotType: 'gameViewStore/shotType',
        selectedTeamSport: 'mainStore/selectedTeamSport'
      })
    },
    methods: {
      getRand(){
        return Math.random().toString(36).substring(2,7);
      },
      fieldClicked() {
        
      },
      //StdX is from 0...1
      getStdXfromOrX(xVal){
        return (xVal+290)/550;
      },
      getStdYfromOrY(yVal){
        return (yVal + 250)/470
      },
      getOrXfromStdX(xVal){
        return (xVal*550) - 290;
      },
      getOrYfromStdY(yVal){
        return (yVal*470) - 250;
      },
      getShots(){
        var self = this;
        var dbShots = [];
        var newShots = [];
        firebase.database().ref('/SoccerGames/' + self.activeGameId + '/Shots').on('value', function(snapshot){
          newShots = [];
          if(snapshot.val() == null){
            console.log('null')
            return;
          }
          else{
            console.log('not null')
          }
          
          dbShots = Object.values(snapshot.val());
          console.log(dbShots)
          var count = 0;
          dbShots.forEach(shot => {
            var left = self.getOrXfromStdX(shot.x) + 'px';
            var top = self.getOrYfromStdY(shot.y) + 'px';
            var _shotType = '';

            switch(shot.type) {
              case 0:
                _shotType = 'gcf';
                break;
              case 1:
                _shotType = 'redx';
                break;
              default:
                _shotType = 'ghollow';
            }
            var data = {
              style: {
                left,
                top
              },
              shotType : _shotType
            }
            var key = 's' + count;
            count++;

            newShots.push(data)
          });
          self.shotsList = newShots;
        })
      },
      submitShot(data){
        var key = 's' + this.shotsList.length;
        firebase.database().ref('SoccerGames').child(this.activeGameId).child('Shots').update({
          [key] : data
        })
      }
    },
    mounted() {
      //do something after mounting vue instancejQuery(document).ready(function() {
      this.getShots();
      var self = this;
      jQuery('#FieldIMG').click(function(e) {
        var offset = jQuery(this).offset();

        var OrLeft = e.pageX - offset.left - 300;
        var StdLeft = self.getStdXfromOrX(OrLeft);

        var OrRight = e.pageY - offset.top - 255;
        var StdRight = self.getStdYfromOrY(OrRight);
        var _shotType = 0;

        switch(self.shotType){
          case 'gcf':
            _shotType = 0;
            break;
          case 'redx':
            _shotType = 1;
            break;
          default:
            _shotType = 2;
        }
        var data = {
          type : _shotType,
          x : StdLeft,
          y : StdRight
        }

        self.submitShot(data);
      });
    }
  }
</script>

<style scoped>
  .SBfield {
    width: 600px;
    height: 500px;
    background: black;
    margin-left: 50px;
    border-width: 5px;
    border-color: black;
    border-style: solid;
    border-radius: 35px;
    margin: 50px;
    margin-bottom: 25px;
    box-shadow: 5px 5px 5px grey;
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
    border: 5px white solid;
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
  }
  .field_ghollow {
    position: absolute;
    min-width: 20px;
    min-height: 20px;
    max-height: 20px;
    max-width: 20px;
  }
  .field_redx {
    position: absolute;
    min-width: 20px;
    min-height: 20px;
    max-height: 20px;
    max-width: 20px;
  }
</style>
