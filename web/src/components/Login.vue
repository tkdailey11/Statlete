<template>
  <div class="login">
    <h1>Statlete</h1>
    <input type="text" v-model="email" placeholder="Email"><br>
    <input type="password" v-model="password" placeholder="Password"><br>
    <button class="btn btn-outline-primary btn-social" @click="signIn">Sign In</button><br>
    <button class="btn btn-outline-primary btn-social" @click="signInGoogle">Google</button><br>
    <p>Don't have an account? <router-link to="/sign-up">Click here to create one!</router-link></p>
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
    methods: {
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
            console.log("USER: " + usr.email);
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
    margin-top: 40px;
  }
  input {
    margin: 10px 0;
    width: 30%;
    padding: 15px;
    border: 0;
    outline: 0;
    background: transparent;
    border-bottom: 3px solid rgb(109,8,8);
  }
  button {
    margin-top: 20px;
    width: 10%;
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
</style>
