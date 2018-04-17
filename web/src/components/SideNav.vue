<template>
    <div id="SideNav" class="sidenav">
      <a href="javascript:void(0)" class="closebtn" @click="closeNav">&times;</a>
      <img src="../assets/images/testUser.png" width="100px" height="100px">
      <button @click="$emit('showPlayer')" class="btn btn-outline-primary">New Player Account</button><br>
      <button @click="$emit('showTeam')" class="btn btn-outline-primary">New Team Account</button><br>

      <div class="TableContainer">
        <table class="TeamTable" style="overflow: scroll;">
          <tr v-for="i in 100">
            <td>S</td>
            <td>{{ i }}</td>
          </tr>
        </table>


        <table class="PlayerTable">
          <tr v-for="i in 100">
            <td>S</td>
            <td>{{ i }}</td>
          </tr>
        </table>
      </div>
    </div>
</template>

<script>
  export default {
    name: 'SideNav',
    props: {
      sportfolios: {
        default(){
          return []
        }
      }
    },
    methods: {
      closeNav: function() {
        document.getElementById("mySidenav").style.width = "0";
      }
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
      background-color: #e64f52;
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
      color: rgba(250, 220, 127, 0.9);
  }

  .TeamTable {
    width: 80%;
    margin: 10%;
    background-color: white;
    height: 40%;
    max-height: 100px;
    overflow: scroll;
  }

  .PlayerTable {
    width: 80%;
    margin: 10%;
    background-color: blue;
    height: 40%;
    max-height: 100px;
    overflow: scroll;
  }

  .TableContainer {
    height: 450px;
    max-height: 450px;
    background-color: grey;

  }

</style>
