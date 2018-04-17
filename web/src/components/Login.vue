<template>
  <div class="login">
    <h1 style="color: rgba(250, 220, 127, 0.9);">Statlete</h1>
    <input type="text" v-model="email" placeholder="Email"><br>
    <input type="password" v-model="password" placeholder="Password"><br>
    <button class="btn btn-outline-primary btn-social" @click="signIn">Sign In</button><br>
    <button class="btn btn-outline-primary btn-social" @click="signInGoogle">Google</button><br>
    <p style="color: rgba(250, 220, 127, 0.9);">Don't have an account? <router-link to="/sign-up" style="color: rgb(180, 41, 102);">Click here to create one!</router-link></p>
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
    border-bottom: 3px solid rgb(180, 41, 102);
    color: white;
  }
  button {
    margin-top: 20px;
    width: 10%;
    cursor: pointer;
    color: white;
    background-color: rgb(180, 41, 102);
    border-color: rgb(180, 41, 102);
    color: rgba(250, 220, 127, 0.9);
  }

  button:hover {
    background-color: rgba(250, 220, 127, 0.9);
    border-color: rgba(250, 220, 127, 0.9);
    color: rgb(180, 41, 102);
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
  input:-webkit-autofill {
      -webkit-box-shadow:0 0 0 50px rgba(250, 220, 127, 0.9) inset; /* Change the color to your own background color */
      -webkit-text-fill-color: rgb(180, 41, 102);
      border-radius: 5px;
  }

  input:-webkit-autofill:focus {
      -webkit-box-shadow: /*your box-shadow*/,0 0 0 50px rgba(250, 220, 127, 0.9) inset;
      -webkit-text-fill-color: rgb(180, 41, 102);
      border-radius: 5px;
  }

  ::placeholder { /* Chrome, Firefox, Opera, Safari 10.1+ */
    color: rgba(250, 220, 127, 0.9);
    opacity: 1; /* Firefox */
}
</style>
