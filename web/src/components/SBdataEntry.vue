<template>
  <div id="SBdataEntry" :style="height">
    <div id="title">
      <h2 align="center" style="color: white;">Team/Player Stats</h2>
    </div>
    <div id="dataTable" :style="tableHeight">
      <table width="100%">
        <tr v-for="obj in dataTypes">
          <td>
            <img v-if="isSoccer" src="../assets/images/goal.png">
            <img v-else src="../assets/images/basketball-hoop.png">
          </td>
          <td class="dataLabelCell" style="max-width: 120px; text-overflow:ellipsis;">
            <p class="dataLabel">{{obj}}</p>
          </td>
          <td class="plusButton" @click="plusClicked(obj)">
            <img :id="obj.split(' ').join('') + '-button'" src="../assets/images/RedPlusButton.png" style="zoom: 5%;">
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
      }
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
        this.$emit('StatChange', 'plus:' + obj)
        var id = '#' + obj.split(' ').join('') + '-button';
        jQuery(id).css('opacity', '0.3');
        setTimeout(() => {
          jQuery(id).css('opacity', '1.0');
        }, 150);
        
      }
    },
    data() {
      return {
        dataTypes: []
      }
    },
    mounted() {
      var self = this
      console.log("GAME ID: " + self.gameID);
      console.log("Sport: " + this.selectedTeamSport);
      if(self.isSoccer) {
        var dbRef = firebase.database().ref('SoccerGames/' + self.selectedTeamId + '/' + self.gameID + '/MyTotals/Period1/');
        if(dbRef){
          dbRef.once('value', function(snapshot){
            var keys = []
            var obj = snapshot.val();
            if(Object){
              keys = Object.keys(obj)
            }
            console.log('KEYS: ');
            console.log(keys);
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
            console.log('KEYS: ');
            console.log(keys);
            self.dataTypes = keys;
          })
        }
      }
    }
  }
</script>

<style scoped>
  #SBdataEntry {
    width: 310px;
    height: 500px;
    border-width: 5px;
    border-color: black;
    border-style: solid;
    border-radius: 35px;
    position: relative;
    box-shadow: 5px 5px 5px grey;
    padding-left: 100px;
    
  }

  #title {
    width: 300px;
    height: 75px;
    background: white;
    border-radius: 35px 35px 0px 0px;
    border-bottom-color: black;
    border-bottom-width: medium;
    border-bottom-style: solid;
    background-color: white;
  }

  #dataFooter {
    width: 300px;
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
  }

  #dataTable {
    width: 300px;
    background-color: white;
    overflow: scroll;
    border-radius: 0px 0px 30px 30px;
  }

  table, th {
    border: 1px solid black;
  }

  td {
    border-bottom: 1px solid black;
    color: rgb(224,0,16);
  }

  h2 {
    line-height: 75px;
    height: 75px;
    color: rgb(224,0,16);
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
