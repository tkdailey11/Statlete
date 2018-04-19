<template>
  <div id="navbar">
    <nav class="navbar navbar-fixed-top myNav">
      <div class="OpenNavDiv" @click="openNav"><icon name="cog" scale="1.5" style="color: white;"></icon></div>
      <button @click="goBack">Go Back</button>
      <div class="LogoutDiv" @click="logout"><p style="display: inline-block; margin-right: 15px; color: white;"><b>Logout</b></p><icon name="sign-out-alt" scale="1.5" style="color: white; margin: -6px;"></icon></div>
    </nav>
  </div>
</template>

<script>
  export default {
    name: 'Navbar',
    methods: {
      openNav: function() {
        this.$emit('shouldOpenNav')
      },
      logout: function() {
        this.$emit('shouldLogout')
      },
      goBack: function() {
        this.$emit('GoBackClicked');
      }
    },
    mounted() {
      //do something after mounting vue instance
      jQuery('.OpenNavDiv').click(function(){
          jQuery(this).toggleClass('rotated');
      });
    }
  }
</script>

<style scoped>
  #header h1{
      margin:0px;
  }
  .myNav {
    background-color: orange;
  }
  .LogoutDiv{
    float: right;
    margin-bottom: -13px;
  }
  .LogoutDiv:hover {
    cursor: pointer;
    opacity: 0.5;
  }

  .OpenNavDiv {
    float: left;
    margin-bottom: -5px;
  }
  .OpenNavDiv:hover {
    cursor: pointer;
    opacity: 0.5;
  }
  .rotated {
    -webkit-transform: rotate(360deg);
    -moz-transform: rotate(360deg);
    -o-transform: rotate(360deg);
    -ms-transform: rotate(360deg);
    transform: rotate(360deg);
    -webkit-transition: all 1s ease;
  }
</style>
