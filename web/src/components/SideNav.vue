<template>
    <div id="SideNav" class="sidenav">
      <a href="javascript:void(0)" class="closebtn" @click="closeNav">&times;</a>
      <div style="margin-bottom: 40px;">
        <img src="../assets/images/testUser.png" width="100px" height="100px">
        <h4 style="margin-top: 10px; color: white;">{{currentUserEmail}}</h4>
      </div>

      <!--Team Sportfolios -->
      <div class="SBdataEntry">
        <div class="title">
          <h5 align="center">Team Sportfolios</h5>
        </div>
        <div class="dataTable">
          <table width="100%">
            <tr v-for="t in teamSportfolios" @click="selectedTeam(t)">
              <td>{{ t }}</td>
            </tr>
            <tr>
              <td @click="$emit('showTeam'); closeNav();">+ New Team Sportfolio</td>
            </tr>
          </table>
        </div>
      </div>
      <!--End of Team Sportfolios -->

      <!--Player Sportfolios -->
      <div class="SBdataEntry">
        <div class="title">
          <h5 align="center">Player Sportfolios</h5>
        </div>
        <div class="dataTable">
          <table width="100%">
            <tr v-for="p in playerSportfolios" @click="selectedPlayer(p)">
              <td>{{ p }}</td>
            </tr>
            <tr>
              <td @click="$emit('showPlayer'); closeNav();">+ New Player Sportfolio</td>
            </tr>
          </table>
        </div>
      </div>
      <!--End of Player Sportfolios -->

    </div>
</template>

<script>
  import firebase from 'firebase'
  import { mapGetters, mapMutations } from 'vuex';

  export default {
    name: 'SideNav',
    data() {
      return {
        loggedInUser: '',
        currentUserEmail: '',
        teamSportfolios: [],
        playerSportfolios: []
      }
    },
    methods: {
      ...mapMutations({
        SET_SELECTED_TEAM: 'mainStore/SET_SELECTED_TEAM'
      }),
      closeNav: function() {
        document.getElementById("mySidenav").style.width = "0";
      },
      getTeamSportfolios: function() {
        var emailStr = this.currentUserEmail;
        var email = emailStr.replace('.', '');
        console.log("EMAIL: " + email);
        var self = this
        firebase.database().ref('Users/' + email + '/AdminTeams').on('value', function(snapshot){
          var obj = snapshot.val()
          if (obj) {
            self.teamSportfolios = Object.keys(obj);
          }
          console.log("TEAM SPORTFOLIOS:");
          console.log(self.teamSportfolios);
        });
      },
      getPlayerSportfolios: function() {
        var emailStr = this.currentUserEmail;
        var email = emailStr.replace('.', '');
        console.log("EMAIL: " + email);
        var self = this
        firebase.database().ref('Users/' + email + '/PlayerTeams').on('value', function(snapshot){
          var obj = snapshot.val()
          if (obj) {
            self.playerSportfolios = Object.values(obj);
          }
          console.log("Player SPORTFOLIOS:");
          console.log(self.playerSportfolios);
        });
      },
      selectedTeam(id){
        var self = this;
        firebase.database().ref('TeamSportfolios').child(id).once('value', function(snapshot){
          var obj = snapshot.val();
          var name = obj.TeamName;
          var data = {
            Name: name,
            Id: id,
            Token: obj.Token
          }
          self.$emit('teamSelected', data);
          self.closeNav();
        });
      },
      selectedPlayer(id){
        var self = this;
        firebase.database().ref('PlayerSportfolios').child(id).once('value', function(snapshot){
          var obj = snapshot.val();
          var name = obj.Name;
          var id = obj.TeamID;
          var token = '';
          self.SET_SELECTED_TEAM({
            id,
            name,
            token
          });
          self.closeNav();
          self.$router.push('/playerhome')
        });
      }
    },
    mounted() {
      this.$nextTick(() => {
        console.log("NEXT TICK");
          this.loggedInUser = firebase.auth().currentUser;
          this.currentUserEmail = this.loggedInUser.email;
          this.getTeamSportfolios();
          this.getPlayerSportfolios();
      });
    }
  }
</script>

<style scoped>
  /* The side navigation menu */
  .sidenav {
      height: 100%; /* 100% Full-height */
      width: 0; /* 0 width - change this with JavaScript */
      position: fixed; /* Stay in place */
      z-index: 1; /* Stay on top */
      top: 0; /* Stay at the top */
      left: 0;
      background-color: orange;
      overflow-x: hidden; /* Disable horizontal scroll */
      padding-top: 60px; /* Place content 60px from the top */
      transition: 0.5s; /* 0.5 second transition effect to slide in the sidenav */
  }

  /* The navigation menu links */
  .sidenav a {
      padding: 8px 8px 8px 32px;
      text-decoration: none;
      font-size: 25px;
      color: #818181;
      display: block;
      transition: 0.3s;
  }

  /* When you mouse over the navigation links, change their color */
  .sidenav a:hover {
      color: rgb(240, 138, 59);
  }

  .sidenav a {
    color: rgba(250, 220, 127, 0.9);
  }

  /* Position and style the close button (top right corner) */
  .sidenav .closebtn {
      position: absolute;
      top: 0;
      right: 25px;
      font-size: 36px;
      margin-left: 50px;
      color: white;
  }

  .SBdataEntry {
    width: 200px;
    height: 250px;
    background: white;
    border-width: 5px;
    border-color: white;
    border-style: solid;
    border-radius: 35px;
    position: relative;
    margin: 10%;
    margin-bottom: 50px;
  }

  .title {
    width: 190px;
    height: 50px;
    background: white;
    border-radius: 35px 35px 0px 0px;
    border-bottom-color: white;
    border-bottom-width: medium;
    border-bottom-style: solid;
    background-color: rgb(252,102,0);
  }

  .dataTable {
    width: 190px;
    max-height: 189px;
    height: 189px;
    background-color: rgb(252,102,0);
    overflow: scroll;
    border-radius: 0px 0px 30px 30px;
  }

  table, th {
    border: 1px solid white;
  }

  td {
    border-bottom: 1px solid white;
    color: white;
  }

  h5 {
    line-height: 50px;
    height: 50px;
    color: white;
    text-overflow: ellipsis;
    white-space: nowrap;

  }
  img {
    zoom: 50%;
  }
  .dataLabelCell {
    overflow: hidden;
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

  tr:hover td {
    background-color: rgba(255,165,0, 0.7);
    cursor: pointer;
  }







.sidenav{
  height: 100vh;
  background-image: -webkit-gradient(linear, left top, left bottom,
        color-stop( 0.0, rgb(224, 0, 16) ),
        color-stop( 0.135, rgb(235, 95, 17) ),
        color-stop( 0.500, rgb(252, 102, 0) ),
        color-stop( 0.798, rgb(255, 158, 0) ),
        color-stop( 1.0, rgb(213, 213, 213) ));

        /***  CSS Gradient  ***/
        /*  Chrome 1-9 and Safari 4-5.0  */
        background-image: -webkit-gradient(linear, left top, left bottom,
              color-stop( 0.0, rgb(224, 0, 16) ),
              color-stop( 0.216, rgb(235, 95, 17) ),
              color-stop( 0.626, rgb(252, 102, 0) ),
              color-stop( 0.873, rgb(255, 158, 0) ),
              color-stop( 1.0, rgb(255, 158, 0) ));

        /*  Chrome 10+ Safari 5.1+ Mobile Safari  */
        background-image: -webkit-linear-gradient(top,
              rgb(224, 0, 16),
              rgb(235, 95, 17) 21.6%,
              rgb(252, 102, 0) 62.6%,
              rgb(255, 158, 0) 87.3%,
              rgb(255, 158, 0) );

        /*  Firefox 3.6+  */
        background-image: -moz-linear-gradient(top,
              rgb(224, 0, 16),
              rgb(235, 95, 17) 21.6%,
              rgb(252, 102, 0) 62.6%,
              rgb(255, 158, 0) 87.3%,
              rgb(255, 158, 0) );

        /*  IE 10+  */
        background-image: -ms-linear-gradient(top,
              rgb(224, 0, 16),
              rgb(235, 95, 17) 21.6%,
              rgb(252, 102, 0) 62.6%,
              rgb(255, 158, 0) 87.3%,
              rgb(255, 158, 0) );

        /*  Opera 11.10+  */
        background-image: -o-linear-gradient(top,
              rgb(224, 0, 16),
              rgb(235, 95, 17) 21.6%,
              rgb(252, 102, 0) 62.6%,
              rgb(255, 158, 0) 87.3%,
              rgb(255, 158, 0) );

        /*  W3C  */
        background-image: linear-gradient(top,
              rgb(224, 0, 16),
              rgb(235, 95, 17) 21.6%,
              rgb(252, 102, 0) 62.6%,
              rgb(255, 158, 0) 87.3%,
              rgb(255, 158, 0) );
            }
</style>
