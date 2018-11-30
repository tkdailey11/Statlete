<template>
    <div class="FootballGame">
        <nav-component />
        <h1 class="mainH1">{{selectedTeamName}}</h1>
        <!-- <div><span class="item">{{myScore}}</span>
      <span class="period_item">
        1 <input type="radio" value="first" v-model="period">
        2 <input type="radio" value="second" v-model="period">
        3 <input type="radio" value="third" v-model="period">
        4 <input type="radio" value="fourth" v-model="period">
      </span>
      <span class="item">{{oppScore}}</span></div> -->
       <div class="column split left footballPosDiv">
            <button v-if="activeButton === 'offense'" id="offenseButton" class="currPage" @click="offenseClicked">Offense</button>
            <button v-else id="offenseButton" class="footballNotCurr" @click="offenseClicked">Offense</button><br>
            <button v-if="activeButton === 'defense'" id="defenseButton" class="currPage" @click="defenseClicked">Defense</button>
            <button v-else id="defenseButton" class="footballNotCurr" @click="defenseClicked">Defense</button><br>

            <button v-if="activeButton === 'special'" id="specialButton" class="currPage" @click="specialClicked">Special Teams</button>
            <button v-else id="specialButton" class="footballNotCurr" @click="specialClicked">Special Teams</button><br>

            <button id="statsButton" class="footballNotCurr" @click="statsClicked">Team Stats</button><br>
		    </div>

        <div class="split right footballStatDiv">
            <football-offense v-if="activeButton === 'offense'" @oppScore="incrementOpp"/>
            <football-defense v-if="activeButton === 'defense'"/>
            <football-special v-if="activeButton === 'special'"/>
        </div>
       
    </div>
</template>

<script>
import {mapGetters} from 'vuex';

export default {
  computed: {
    ...mapGetters({
      selectedTeamName: 'mainStore/selectedTeamName'
    })
  },

  data() {
    return {
      activeButton: 'offense',
      period: '',
      myScore: 0,
      oppScore: 0
    }
    

  },
  // props: {
  //   myScore: {
  //     type: Number, 
  //     default: 0
  //   },
  //   oppScore: {
  //     type: Number,
  //     default: 0
  //   }
  // },
  methods: {
    incrementOpp: function(data) {
      this.oppScore += parseInt(data);
    },
    offenseClicked: function() {
      jQuery("#getOffPosition").show();

      jQuery("#runForm").hide();
      jQuery("#passForm").hide();
      jQuery("#penaltyForm").hide();
      jQuery("#turnoverForm").hide();
      jQuery("#offenseButtons").hide();
      this.activeButton = 'offense';
    },
    defenseClicked: function() {
      jQuery("#getDefPosition").show();
      
      jQuery("#runDefForm").hide();
      jQuery("#passDefForm").hide();
      jQuery("#penaltyDefForm").hide();
      jQuery("#turnoverDefForm").hide();
      jQuery("#defenseButtons").hide();
      this.activeButton = 'defense';
      
    },
    specialClicked: function() {
      jQuery("#puntForm").hide();
      jQuery("#puntRetForm").hide();
      jQuery("#fg").hide();
      jQuery("#fgDef").hide();
      jQuery("#kickOff").hide();
      jQuery("#kickOffRet").hide();
      jQuery("#specialButtons").show();
      this.activeButton = 'special';
    },
    statsClicked: function() {
      alert("Stats Clicked");
    },
    askClicked: function() {
      alert("Ask Clicked");
    },
  },
  created() {
    jQuery("#runForm").hide();
    jQuery("#passForm").hide();
  }
}
</script>

<style scoped>
.currPage, .footballNotCurr {
  padding: 10px 30px 10px 30px; 
  
  text-decoration: none;
  
  border-radius: 15px;
  margin: 5px;
  
  text-decoration: none;
  text-align: center;
}



.split {
    height: 100%;
    width: 50%;
    position: fixed;
    z-index: 1;
    top: 0;
    overflow-x: hidden;
    padding-top: 80px;
    margin-top: 117px;
}

.left {
    left: 0;
}

.right {
    right: 0;
}

.item {
  font-size: 50px;
  flex-shrink: 3;
  align-content: flex-start;
  align-items: stretch;
  justify-content: space-between;
  flex-wrap: wrap;
  flex-direction: row;
  background-color: red;
}

.period_item {
  /* flex-shrink: 4;
  flex-grow: 10; */
  align-content: flex-start;
  align-items: flex-end;
  justify-content: space-between;
  flex-wrap: wrap;
  flex-direction: row;
}
</style>


