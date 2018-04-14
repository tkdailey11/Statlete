<template>
    <div id="SideNav" class="sidenav">
      <a href="javascript:void(0)" class="closebtn" @click="closeNav">&times;</a>
      <img src="../assets/images/testUser.png" width="100px" height="100px">
      <button @click="$emit('showPlayer')" class="btn btn-outline-primary">New Player Account</button><br>
      <button @click="$emit('showTeam')" class="btn btn-outline-primary">New Team Account</button><br>

      <table style="background-color: white; margin: 10%; width: 80%;">
        <thead>
          <th></th>
          <th>Team Sportfolios</th>
        </thead>
        <tr v-for="i in 100">
          <td>S</td>
          <td>{{ i }}</td>
        </tr>
      </table>
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

  .sportButton {
    background-color: red;
    color: white;
    width: 150px;
    margin: 30px 0px 30px 0px;
    border-radius: 50px;
  }
</style>
