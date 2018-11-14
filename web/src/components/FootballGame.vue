<template>
    <div class="FootballGame">
        <nav-component />
       
       <div class="column split left">
            <button v-if="activeButton === 'offense'" id="offenseButton" class="currPage" @click="offenseClicked">Offense</button>
            <button v-else id="offenseButton"  @click="offenseClicked">Offense</button><br>
            <button v-if="activeButton === 'defense'" id="defenseButton" class="currPage" @click="defenseClicked">Defense</button>
            <button v-else id="defenseButton"  @click="defenseClicked">Defense</button><br>

            <button v-if="activeButton === 'special'" id="specialButton" class="currPage" @click="specialClicked">Special Teams</button>
            <button v-else id="specialButton"  @click="specialClicked">Special Teams</button><br>

            <button id="statsButton" class="buttonPosession" @click="statsClicked">Team Stats</button><br>
            <button id="askButton" class="buttonPosession" @click="askClicked">Ask Statlete</button><br>
		    </div>
        <div class="split right">
            <football-offense v-if="activeButton === 'offense'"/>
            <football-defense v-if="activeButton === 'defense'"/>
            <football-special v-if="activeButton === 'special'"/>
        </div>
       
    </div>
</template>

<script>
export default {
  data() {
    return {
      activeButton: 'offense'
    }
    

  },
  methods: {
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
.currPage {
  padding: 10px 30px 10px 30px; 
  background-color: red; 
  text-decoration: none;
  color: white;
  border-radius: 3px;
  margin: 5px;
  border: 2px solid black;
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
    margin-top: 40px;
}

.left {
    left: 0;
    background: grey;
}

.right {
    right: 0;
    background: grey;
}
</style>


