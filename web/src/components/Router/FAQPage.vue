<template>
    <div class="FAQPage">
        <h1>Not yet implemented</h1>
        <footer class="navbar fixed-bottom myNav">
            <div><router-link to="/login" class="link">Login</router-link></div>
            <div><router-link to="/sign-up" class="link">Signup</router-link></div>
            <div><router-link to="/about" class="link">About</router-link></div>
            <div>FAQ</div>
        </footer>
    </div>
</template>

<script>
export default {
    
}
</script>

<style scoped>
  .myNav{
        background-color: white;
    color: rgb(224,0,16);
    padding-left: 25vw;
    padding-right: 25vw;
    padding-bottom: 25px;
    padding-top: 25px;
    border-top: 1px solid rgb(224,0,16);
    margin-top: 25px;
  }
  .link {
    color: rgb(224,0,16);
  }
  .link:hover {
    color: rgb(242,209,24);
  }
</style>
