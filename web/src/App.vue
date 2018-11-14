<template>
  <div id="app">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
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
  /*font-family: 'Avenir', Helvetica, Arial, sans-serif; */
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
}

.myNav {
      background: rgb(224,0,16);
}

body {
      height: 100vh;
      margin: 0px;
}

@font-face {
      font-family: 'MyWebFont';
      src: url('./assets/fonts/AvenirNext-UltraLight.woff') format('woff'), /* Chrome 6+, Firefox 3.6+, IE 9+, Safari 5.1+ */
      url('./assets/fonts/AvenirNext-UltraLight.ttf') format('truetype'); /* Chrome 4+, Firefox 3.5, Opera 10+, Safari 3—5 */
}  

</style>
