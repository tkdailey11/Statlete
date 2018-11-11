<template>
    <div id="SideNav" class="sidenav">
      <div class="sn_info">
        <a href="javascript:void(0)" class="closebtn" @click="closeNav">&times;</a>
        <img src="../../assets/images/testUser.png" width="200px" height="200px">
        <h4 class="snH4">{{currentUserName}}</h4>
      </div>

      <!--Team Sportfolios -->
      <div class="sn_ts SBdataEntry">
        <div class="sn_title">
          <h5 align="center">Team Sportfolios</h5>
        </div>
        <div class="dataTable">
          <table width="100%">
            <tr class="sn_tr" v-for="t in teamSportfolios" @click="selectedTeam(t)">
              <td class="snTD">{{ t }}</td>
            </tr>
          </table>
        </div>
        <div class="sn_footer">
              <h6 class="snH6" align="center" @click="$emit('showTeam'); closeNav();">New Team Sportfolio</h6>
        </div>
      </div>
      <!--End of Team Sportfolios -->

      <!--Player Sportfolios -->
      <div class="sn_ps SBdataEntry">
        <div class="sn_title">
          <h5 align="center">Player Sportfolios</h5>
        </div>
        <div class="dataTable">
          <table width="100%">
            <tr class="sn_tr" v-for="p in playerSportfolios" @click="selectedPlayer(p)">
              <td>{{ p }}</td>
            </tr>
          </table>
        </div>
        <div class="sn_footer">
              <h6 class="snH6" align="center" @click="$emit('showPlayer'); closeNav();">New Player Sportfolio</h6>
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
        teamSportfolios: [],
        playerSportfolios: []
      }
    },
    computed: {
      ...mapGetters({
        currentUserName: 'mainStore/currentUserName'
      })
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
      z-index: 1; /* Stay on top */
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
    border-width: 3px;
    border-style: solid;
    border-radius: 25px;
    position: relative;
    margin: 10%;
    margin-bottom: 50px;
  }

  .sn_title {
    width: 194px;
    height: 50px;
    border-radius: 20px 20px 0px 0px;
    border-bottom-width: 2px;
    border-bottom-style: solid;
  }

  .dataTable {
    width: 194px;
    height: 146px;
    overflow: scroll;
  }

  .snTD {
    padding: 5px;
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
    cursor: pointer;
  }

  .snH6 {
    overflow-x: hidden;
    line-height: 50px;
    height: 50px;
  }

  .snH4 {
    margin-top: 20px;
  }

  .sn_info {
    margin-bottom: 40px;
  }

  .sn_footer {
    width: 100%;
    height: 50px;
    position: absolute;
    bottom: 0;
    border-radius: 0px 0px 20px 20px;
    border-top-width: 2px;
    border-top-style: solid;
    text-align: center;
    vertical-align: middle;
    line-height: 50px;
    overflow-x: hidden;
  }

  /* On smaller screens, where height is less than 450px, change the style of the sidenav (less padding and a smaller font size) */
  @media screen and (max-height: 450px) {
      .sidenav {padding-top: 15px;}
      .sidenav a {font-size: 18px;}
  }
</style>
