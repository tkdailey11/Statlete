<template>
  <modal name="player-detail-view" transition="pop-out" :width="modalWidth" :height="300">
  <div class="np_box">
    <div class="partition" id="partition-register">
      <v-card dark>
        <v-card-title>
          My Stats
          <v-spacer></v-spacer>
        </v-card-title>
            <v-data-table
              :headers="headers"
              :items="tableArr"
              class="elevation-1">
              <template slot="items" slot-scope="props">
                <td style="color: white;">{{ props.item.type }}</td>
                <td class="text-xs-right" v-for="type in statTypes" :key="'offense-' + type" style="color: white;">{{ props.item.total }}</td>
              </template>
            </v-data-table>
      </v-card>
    </div>
  </div>
</modal>
</template>

<script>
 import firebase from 'firebase'
  import { mapGetters, mapMutations } from 'vuex';
  const MODAL_WIDTH = 450
  export default {
    name: 'PlayerDetailView',
  data () {
    return {
      modalWidth: MODAL_WIDTH,
      pnum: '',
      pname: '',
      headers: [{
          text: 'Stat Type',
          align: 'left',
          sortable: false,
          value: 'type'
      },
      {
        text: 'Total',
        align: 'left',
        sortable: false,
        value: 'total'
      }],
      gameData : {},
        statTypes: ["Assists",
                    "Corners",
                    "Crosses",
                    "Fouls",
                    "Goals",
                    "Minutes",
                    "Offsides",
                    "Red Cards",
                    "Saves",
                    "Shots",
                    "Shots on Goal",
                    "Yellow Cards"],
        loggedInUser: '',
        currentUserEmail: '',
        scrollVertical: true,
        scrollHorizontal: true,
        syncHeaderScroll: true,
        deadAreaColor: "#DDDDDD",
        maxRows: 100,
        freezeFirstColumn: true,
        gameDataRef: null,
        playerDataArray: [],
        testArr: [],
        tableArr: []
    }
  },
  computed: {
    ...mapGetters({
        activeGameId: 'mainStore/activeGameId',
        players: 'mainStore/players',
        selectedTeamId: 'mainStore/selectedTeamId',
        selectedTeamSport: 'mainStore/selectedTeamSport',
        basketballPlayerStats: 'statStore/basketballPlayerStats',
        soccerPlayerStats: 'statStore/soccerPlayerStats'
      }),
      myPlayer: function(){
        return this.playerID.split(' ')[0].replace('#','p')
      }
  },
  watch: {
    playerData: {
      handler() {
      },
      deep: true
    },
    playerID: {
      handler() {
        var obj = null
        for(var i = 0; i < this.playerData.length; i++){
          if(this.playerData[i].name === this.myPlayer){
            obj = this.playerData[i]
            break;
          }
        }
        if(obj != null){
          var tArr = []
          delete obj['name']
          delete obj['value']
          Object.keys(obj).forEach(key => {
            tArr.push({'value': 'false', 'type': key, 'total': obj[key]})
          })
          this.tableArr = tArr
          console.log(this.tableArr)
        }

      },
      tableArr: {
        handler() {
          alert('changed')
        },
        deep: true
      }
    }
  },
  created() {
    this.modalWidth = window.innerWidth < MODAL_WIDTH
      ? MODAL_WIDTH / 2
      : MODAL_WIDTH
    this.loggedInUser = firebase.auth().currentUser;
    this.currentUserEmail = this.loggedInUser.email;
    
  },
  props: {
    playerID: {
      type: String,
      default: 'invalid'
    },
    playerData: {
      type: Array,
      default: () => []
    }
  }
  }
</script>

<style scoped>
  #PlayerDetailView {
    width: 100%;
  }


  .np_box{
    height: 80%;
  }
</style>
