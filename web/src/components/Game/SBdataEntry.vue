<template>
  <div id="SBdataEntry" :style="height">
    <div id="sbde_title">
      <h2 align="center" class="sbdeH">Team/Player Stats</h2>
    </div>
    <div id="dataTable" :style="tableHeight">
      <table width="100%" class="sbde_table">
        <tr v-for="obj in dataTypes" class="sbde_tr">
          <td class="sbdeTD">
            <img v-if="isSoccer" src="../../assets/images/goal.png">
            <img v-else src="../../assets/images/basketball-hoop.png">
          </td>
          <td class="dataLabelCell sbdeTD" style="max-width: 120px; text-overflow:ellipsis;">
            <p class="dataLabel">{{obj}}</p>
          </td>
          <td class="plusButton sbdeTD" @click="plusClicked(obj)">
            <img :id="obj.split(' ').join('') + '-button'" src="../../assets/images/RedPlusButton.png" style="zoom: 5%;">
          </td>
        </tr>
      </table>
    </div>
  </div>
</template>

<script>
  import firebase from 'firebase';
  import { mapGetters, mapMutations } from 'vuex';
import { setTimeout } from 'timers';

  export default {
    name: 'GamesList',
    props: {
      gameID: '',
      height: {
        default: 'height: 500px;'
      },
      isActive: true
    },
    computed: {
      ...mapGetters({
        selectedTeamSport: 'mainStore/selectedTeamSport',
        selectedTeamId: 'mainStore/selectedTeamId'
      }),
      tableHeight() {
        var height = parseInt(this.height.split(' ')[1].split('p')[0]);
        var newHeight = height*0.826;
        return 'height: ' + newHeight + 'px;';
      },
      isSoccer() {
        return this.selectedTeamSport == 1;
      }
    },
    methods: {
      plusClicked(obj) {
        if(this.isActive){
          this.$emit('StatChange', 'plus:' + obj)
          var id = '#' + obj.split(' ').join('') + '-button';
          jQuery(id).css('opacity', '0.3');
          setTimeout(() => {
            jQuery(id).css('opacity', '1.0');
          }, 150);
        }
      }
    },
    data() {
      return {
        dataTypes: []
      }
    },
    mounted() {
      var self = this
      if(self.isSoccer) {
        var dbRef = firebase.database().ref('SoccerGames/' + self.selectedTeamId + '/' + self.gameID + '/MyTotals/Period1/');
        if(dbRef){
          dbRef.once('value', function(snapshot){
            var keys = []
            var obj = snapshot.val();
            if(Object){
              keys = Object.keys(obj)
            }
            self.dataTypes = keys;
          })
        }
      }
      else {
        var dbRef = firebase.database().ref('BasketballGames/' + self.selectedTeamId + '/' + self.gameID + '/MyTotals/Period1/');
        if(dbRef){
          dbRef.once('value', function(snapshot){
            var keys = []
            var obj = snapshot.val();
            if(Object){
              keys = Object.keys(obj)
            }
            self.dataTypes = keys;
          })
        }
      }
    }
  }
</script>

<style scoped>
  #SBdataEntry {
    width: 500px;
    height: 500px;
    border-width: 5px;
    border-style: solid;
    border-radius: 35px;
    position: relative;
    padding-left: 100px;
  }

  #sbde_title {
    width: 490px;
    height: 75px;
    border-radius: 35px 35px 0px 0px;
    border-bottom-width: medium;
    border-bottom-style: solid;
  }

  /* #dataFooter {
    width: 490px;
    height: 75px;
    position: absolute;
    bottom: 0;
    background-color: white;
    border-radius: 0px 0px 35px 35px;
    border-top-color: black;
    border-top-width: medium;
    border-top-style: solid;
    text-align: center;
    vertical-align: middle;
    line-height: 75px;
    font-size: 25px;
    color: rgb(224,0,16);
  } */

  #dataTable {
    width: 490px;
    overflow: scroll;
    border-radius: 0px 0px 30px 30px;
  }

  .sbde_table, .sbde_th {
    border-width: 1px;
    border-style: solid;
  }

  .sbdeTD {
    border-bottom-width: 2px;
    border-bottom-style: solid;
    padding-top: 5px;
    padding-bottom: 5px;
  }

  h2 {
    line-height: 75px;
    height: 75px;
    text-overflow: ellipsis;
    white-space: nowrap;

  }
  img {
    zoom: 50%;
  }
  .dataLabelCell {
    overflow: hidden;
    font-weight: bold;
  }
  .dataLabel {
    margin-top: 15px;
    font-size: 25px;
    line-height: 50px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    text-align: center;
vertical-align: middle;

  }
</style>
