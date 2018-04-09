<template>
  <div class="sign-up">
    <h1>Statlete</h1>
    <h2>Create Account</h2>
    <input type="text" v-model="email" placeholder="Email Address"><br>
    <input type="password" v-model="password" placeholder="Password"><br>
    <input type="password" v-model="passwordConfirm" placeholder="Confirm Password"><br>
    <button class="btn btn-outline-primary" @click="signUp">Sign Up</button>
    <span>or go back to <router-link to="/login">login</router-link>.</span>
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
        firebase.auth().createUserWithEmailAndPassword(this.email, this.password).then(
          (user) => {
            this.$router.replace('main')
          },
          function (err) {
            alert('Oops. ' + err.message)
          }
        );
      }
    }
  }
</script>

<style scoped>
  .signUp {
    margin-top: 40px;
  }
  h1 {
    font-size: 60px;
  }
  input {
    margin: 10px 0;
    width: 30%;
    padding: 15px;
    border: 0;
    outline: 0;
    background: transparent;
    border-bottom: 2px solid rgb(109,8,8);
  }
  button {
    margin-top: 10px;
    width: 10%;
    cursor: pointer;
  }
  span {
    display: block;
    margin-top: 20px;
    font-size: 11px;
  }
  #btn {
    white-space: normal;
  }
</style>
