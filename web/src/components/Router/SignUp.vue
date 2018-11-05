<template>
  <div class="sign-up">
    <h1 style="color: rgb(224,0,16);">Statlete</h1>
    <h2 style="color: rgb(224,0,16);">Create Account</h2>
    <input type="text" v-model="email" placeholder="Email Address"><br>
    <input type="password" v-model="password" placeholder="Password"><br>
    <input type="password" v-model="passwordConfirm" placeholder="Confirm Password"><br>
    <button class="btn btn-outline-primary" @click="signUp">Sign Up</button>
    <p style="color: rgb(224,0,16);">or go back to <router-link to="/login" class="link">login</router-link>.</p>
    <footer class="navbar fixed-bottom myNav">
        <div><router-link to="/login" class="link">Login</router-link></div>
        <div>Signup</div>
        <div><router-link to="/about" class="link">About</router-link></div>
        <div><router-link to="/faq" class="link">FAQ</router-link></div>
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
    margin-top: 40px;
    color: rgb(224,0,16);
  }
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
  input {
    margin: 10px 0;
    width: 30%;
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
  
    .link {
    color: rgb(224,0,16);
  }
  .link:hover {
    color: rgb(242,209,24);
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
    color: rgb(224,0,16);
    opacity: 1; /* Firefox */
}
</style>
