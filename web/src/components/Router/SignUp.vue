<template>
  <div class="sign-up">
    <h1>Statlete</h1>
    <h2>Create Account</h2>
    <input type="text" v-model="email" placeholder="Email Address"><br>
    <input type="password" v-model="password" placeholder="Password"><br>
    <input type="password" v-model="passwordConfirm" placeholder="Confirm Password"><br>
    <button class="btn btn-outline-primary" @click="signUp">Sign Up</button>
    <p style="color: rgb(224,0,16);">or go back to <router-link to="/login" class="link">login</router-link>.</p>
    <footer class="navbar fixed-bottom myBottomNav">
        <div><router-link to="/login" class="ap_link">Login</router-link></div>
        <div>Signup</div>
        <div><router-link to="/about" class="ap_link">About</router-link></div>
        <div><router-link to="/faq" class="ap_link">FAQ</router-link></div>
    </footer>
  </div>
</template>

<script>
  import firebase from 'firebase'
  export default {
    name: 'signUp',
    data: function() {
      return {
        email: '',
        password: '',
        passwordConfirm: ''
      }
    },
    methods: {
      signUp: function() {
        if(this.password===this.passwordConfirm){
          firebase.auth().createUserWithEmailAndPassword(this.email, this.password).then(
            (user) => {
              this.$router.replace('flp')
            },
            function (err) {
              alert('Oops. ' + err.message)
            }
          );
        }
        else {
          alert('Passwords don\'t match');
        }
      }
    }
  }
</script>

<style scoped>
  .sign-up {
    height: 100vh;
  }
  .myBottomNav{
    padding-left: 25vw;
    padding-right: 25vw;
    padding-bottom: 25px;
    padding-top: 25px;
    border-top-width: 3px;
    border-top-style: solid;
    margin-top: 25px;
  }
  input {
    margin: 10px 0;
    width: 50%;
    padding: 15px;
    border: 0;
    outline: 0;
    background: transparent;
    border-bottom: 3px solid rgb(224,0,16);
    color: rgb(224,0,16);
  }
  button {
    margin-top: 20px;
    width: 10%;
    cursor: pointer;
    color: white;
    background-color: rgb(224,0,16);
    border-color: rgb(224,0,16);
    color: white;
  }

  button:hover {
    background-color: white;
    border-color: rgb(224,0,16);
    color: rgb(224,0,16);
  }

  p {
    margin-top: 10px;
    font-size: 13px;
  }
  p a {
    text-decoration: underline;
    cursor: pointer;
  }
  

  h1 {
    font-size: 60px;
  }

</style>
