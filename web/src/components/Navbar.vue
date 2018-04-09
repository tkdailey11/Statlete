<template>
  <div id="navbar">
    <nav class="navbar navbar-dark bg-dark navbar-fixed-top">
      <button type="button" class="btn btn-default navbar-btn" @click="openNav">Open Nav</button>
      <button type="button" class="btn btn-default navbar-btn" @click="logout" style="float: right;">Logout</button>
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
      }
    }
  }
</script>

<style scoped>
#header h1{
    margin:0px;
}
</style>
