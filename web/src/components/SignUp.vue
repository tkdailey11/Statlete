<template>
  <div class="sign-up">
    <h1 style="color: white;">Statlete</h1>
    <h2 style="color: white;">Create Account</h2>
    <input type="text" v-model="email" placeholder="Email Address"><br>
    <input type="password" v-model="password" placeholder="Password"><br>
    <input type="password" v-model="passwordConfirm" placeholder="Confirm Password"><br>
    <button class="btn btn-outline-primary" @click="signUp">Sign Up</button>
    <p style="color: white;">or go back to <router-link to="/login" style="color: rgb(242,209,24);">login</router-link>.</p>
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
  .signUp {
    margin-top: 40px;
  }
  input {
    margin: 10px 0;
    width: 30%;
    padding: 15px;
    border: 0;
    outline: 0;
    background: transparent;
    border-bottom: 3px solid rgb(224,0,16);
    color: white;
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
  input:-webkit-autofill {
      -webkit-box-shadow:0 0 0 50px white inset; /* Change the color to your own background color */
      -webkit-text-fill-color: rgb(224,0,16);
      border-radius: 5px;
  }

  input:-webkit-autofill:focus {
      -webkit-box-shadow: /*your box-shadow*/,0 0 0 50px white inset;
      -webkit-text-fill-color: rgb(224,0,16);
      border-radius: 5px;
  }

  ::placeholder { /* Chrome, Firefox, Opera, Safari 10.1+ */
    color: white;
    opacity: 1; /* Firefox */
}
</style>
