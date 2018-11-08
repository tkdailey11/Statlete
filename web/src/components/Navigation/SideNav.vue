<template>
    <div id="SideNav" class="sidenav">
      <div style="height: 50px; width: 100%; background-color: blue;" />
      <!-- <a href="javascript:void(0)" class="closebtn" @click="closeNav">&times;</a> -->
      <div style="margin-bottom: 40px;">
        <img src="../../assets/images/testUser.png" width="100px" height="100px">
        <h4 style="margin-top: 10px; color: white;">{{currentUserEmail}}</h4>
      </div>

      <!--Team Sportfolios -->
      <div class="SBdataEntry">
        <div class="sn_title">
          <h5 align="center">Team Sportfolios</h5>
        </div>
        <div class="dataTable">
          <table width="100%">
            <tr class="sn_tr" v-for="t in teamSportfolios" @click="selectedTeam(t)">
              <td>{{ t }}</td>
            </tr>
            <tr class="sn_tr">
              <td @click="$emit('showTeam'); closeNav();">+ New Team Sportfolio</td>
            </tr>
          </table>
        </div>
      </div>
      <!--End of Team Sportfolios -->

      <!--Player Sportfolios -->
      <div class="SBdataEntry">
        <div class="sn_title">
          <h5 align="center">Player Sportfolios</h5>
        </div>
        <div class="dataTable">
          <table width="100%">
            <tr class="sn_tr" v-for="p in playerSportfolios" @click="selectedPlayer(p)">
              <td>{{ p }}</td>
            </tr>
            <tr class="sn_tr">
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
        });
      },
      selectedTeam(id){
        var self = this;
        firebase.database().ref('TeamSportfolios').child(id).once('value', function(snapshot){
          var obj = snapshot.val();
          console.log(obj)
          var name = obj.TeamName;
          var data = {
            Name: name,
            Id: id,
            Token: obj.Token,
            Sport: obj.Sport
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
          var sport = obj.Sport;
          var token = '';
          self.SET_SELECTED_TEAM({
            id,
            name,
            token,
            sport
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
      height: 100vh;
      width: 0;
      position: fixed; 
      z-index: 1; /* Stay on top */
      top: 0;
      left: 0;
      overflow-x: hidden; /* Disable horizontal scroll */
      transition: 0.5s; /* 0.5 second transition effect to slide in the sidenav */
  }

  /* The navigation menu links */
  .sidenav a {
      text-decoration: none;
      font-size: 25px;
      
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

  .sn_title {
    width: 190px;
    height: 50px;
    border-radius: 35px 35px 0px 0px;
    border-bottom-width: medium;
    border-bottom-style: solid;
  }

  .dataTable {
    width: 190px;
    max-height: 189px;
    height: 189px;
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

  .sn_tr:hover td {
    background-color: rgba(0, 224, 67, 0.404);
    cursor: pointer;
  }


  /* On smaller screens, where height is less than 450px, change the style of the sidenav (less padding and a smaller font size) */
  /* @media screen and (max-height: 450px) {
      .sidenav {padding-top: 15px;}
      .sidenav a {font-size: 18px;}
  } */
</style>
