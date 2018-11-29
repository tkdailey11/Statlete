<template>
    <div id="SideNav" class="sidenav">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <div class="sn_info">
        <a href="javascript:void(0)" class="closebtn" @click="closeNav">&times;</a>
        <img :src="photoURL" @click="changeImage" class="profileImg">
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
        playerSportfolios: [],
        isModalVisible: false,
        userImageURL: '../../assets/images/testUser.png'
      }
    },
    created() {
      
    },
    props: {
      photoURL: {
        type: String,
        default: '../../assets/images/testUser.png'
      }
    },
    mounted() {
      
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
      changeImage: function() {
        var message = "Do you want to upload a new image?"
        var options = {
          okText: 'YES',
          cancelText: 'NO',
          animation: 'bounce'
        }
        var self = this;
        self.$dialog.confirm(message, options).then(function() {
          self.$emit('ChangeImage')
        })
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
      height: 100vh;
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

  .profileImg {
    max-width: 100%;
    margin-top: 5%;
    border-radius: 50%;
  }

  /* On smaller screens, where height is less than 450px, change the style of the sidenav (less padding and a smaller font size) */
  @media screen and (max-width: 450px) {
      .sidenav {
        padding-top: 15px;
      }
  }

  /* iPhone 5/SE */
  @media screen and (max-width: 320px) and (min-width: 320px) and (min-height: 568px) and (max-height: 568px)  {
    .sidenav {
      height: 248vh;
    }
  }

  /* iPhone 6/7/8 */
  @media screen and (max-width: 375px) and (min-width: 375px) and (min-height: 667px) and (max-height: 667px) {
    .sidenav {
      height: 212vh;
    }
  }

  /* iPhone 6/7/8 Plus */
  @media screen and (max-width: 414px) and (min-width: 414px) and (min-height: 736px) and (max-height: 736px)  {
    .sidenav {
      height: 192.7vh;
    }
  }

  /* iPhone X */
  @media screen and (max-width: 375px) and (min-width: 375px) and (min-height: 812px) and (max-height: 812px)  {
    .sidenav {
      height: 174.3vh;
    }
  }

  /* iPad Pro */
  @media screen and (max-width: 1024px) and (min-width: 1024px) and (min-height: 1366px) and (max-height: 1366px)  {
    .sidenav {
      height: 221vh;
    }
  }

  /* iPad */
  @media screen and (max-width: 768px) and (min-width: 768px) and (min-height: 1024px) and (max-height: 1024px)  {
    .sidenav {
      height: 221vh;
    }
  }

  /* Pixel 2 */
  @media screen and (max-width: 411px) and (min-width: 411px) and (min-height: 731px) and (max-height: 731px)  {
    .sidenav {
      height: 194vh;
    }
  }

  /* Pixel 2XL */
  @media screen and (max-width: 411px) and (min-width: 411px) and (min-height: 823px) and (max-height: 823px)  {
    .sidenav {
      height: 172vh;
    }
  }

  /* Galaxy S5 */
  @media screen and (max-width: 360px) and (min-width: 360px) and (min-height: 640px) and (max-height: 640px)  {
    .sidenav {
      height: 221vh;
    }
  }
</style>
