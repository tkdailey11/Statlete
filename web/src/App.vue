<template>
  <div id="app">
    <router-view/>
  </div>
</template>

<script>
export default {
  name: 'App'
}
</script>

<style>
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
}
body {
  /*background: rgb(240,138,59);*/
/*background: radial-gradient(circle, rgba(240,138,59,1) 0%, rgba(246,113,78,1) 53%, rgba(237,108,73,1) 77%);
background-color: white;
*/
/***  CSS Gradient  ***/
/*  Chrome 1-9 and Safari 4-5.0  */
height: 100vh;
background-image: -webkit-gradient(linear, left top, left bottom,
      color-stop( 0.0, rgb(224, 0, 16) ),
      color-stop( 0.135, rgb(235, 95, 17) ),
      color-stop( 0.500, rgb(252, 102, 0) ),
      color-stop( 0.798, rgb(255, 158, 0) );

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



margin: 0px;
/*
background: green;
*/
}

</style>
