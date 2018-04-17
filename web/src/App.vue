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
  background: rgb(240,138,59);
background: radial-gradient(circle, rgba(240,138,59,1) 0%, rgba(246,113,78,1) 53%, rgba(237,108,73,1) 77%);

margin: 0px;
/*
background: green;
*/
}

</style>
