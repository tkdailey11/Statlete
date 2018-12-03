<template>
  <div class="login">
    <h1 class="loginH1">Statlete</h1>
    <input id="loginEmail" class="login_input" type="text" v-model="email" placeholder="Email"><br>
    <input id="loginPass" class="login_input" type="password" v-model="password" placeholder="Password"><br>
    <button id="signInBtn" class="btn btn-outline-primary btn-social login_button" @click="signIn">Sign In</button><br>
    <button class="btn btn-outline-primary btn-social login_button" @click="signInGoogle">Google</button><br>
    <p class="loginPtag">Don't have an account? <router-link to="/sign-up" class="link">Click here to create one!</router-link></p>
    <footer class="navbar fixed-bottom myBottomNav">
        <div>Login</div>
        <div><router-link to="/sign-up" class="ap_link">Signup</router-link></div>
        <div><router-link to="/about" class="ap_link">About</router-link></div>
        <div><router-link to="/faq" class="ap_link">FAQ</router-link></div>
    </footer>
  </div>
</template>

<script>
  import firebase from 'firebase'

  export default {
    name: 'login',
    data: function() {
      return {
        email: '',
        password: ''
      }
    },
    mounted() {
      // Get the input field
      var emailField = document.getElementById("loginEmail");
      var passwordField = document.getElementById("loginPass");

      emailField.addEventListener("keyup", function(event) {
        event.preventDefault();
        // Number 13 is the "Enter" key on the keyboard
        if (event.keyCode === 13) {
          document.getElementById("signInBtn").click();
        }
      });

      passwordField.addEventListener("keyup", function(event) {
        event.preventDefault();
        // Number 13 is the "Enter" key on the keyboard
        if (event.keyCode === 13) {
          document.getElementById("signInBtn").click();
        }
      });
    },
    methods: {
      aboutClicked: function(){
        this.$router.push('/about')
      },
      signupClicked: function(){
        this.$router.push('/sign-up')
      },
      signIn: function() {
        firebase.auth().signInWithEmailAndPassword(this.email, this.password).then(
          (user) => {
            this.$router.replace('main')
          },
          function(err) {
            alert('Oops. ' + err.message)
          }
        );
      },
      signInGoogle: function() {
        var provider = new firebase.auth.GoogleAuthProvider();
        firebase.auth().signInWithPopup(provider).then(
          (user) => {
            var usr = user.user;
            this.$router.replace('main');
          },
          function(err) {
            alert('Oops. ' + err.message)
          }
        );
      }
    }
  }
</script>

<style scoped>
  .login {
    height: 100vh;
  }

  .login_input {
    margin: 10px 0;
    width: 50%;
    padding: 15px;
    border: 0;
    outline: 0;
    border-bottom-width: 3px;
    border-bottom-style: solid;
  }
  .login_button {
    margin-top: 20px;
    width: 30%;
    cursor: pointer;
  }

  p {
    margin-top: 40px;
    font-size: 13px;
  }
  p a {
    text-decoration: underline;
    cursor: pointer;
  }
  h1 {
    font-size: 60px;
  }
  .myBottomNav{
    padding-left: 25vw;
    padding-right: 25vw;
    padding-bottom: 25px;
    padding-top: 25px;
    border-top-style: solid;
    border-top-width: 3px;
    margin-top: 25px;
  }
</style>
