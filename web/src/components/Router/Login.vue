<template>
  <div class="login">
    <v-navigation-drawer
      v-model="sidebar"
      :mini-variant="mini"
      absolute
      dark
      temporary>
      <v-list class="pa-1">
        <v-list-tile v-if="mini" @click.stop="mini = false">
          <v-list-tile-action>
            <v-icon>chevron_right</v-icon>
          </v-list-tile-action>
        </v-list-tile>
        <v-list-tile v-else @click.stop="mini = true">
          <v-list-tile-action>
            <v-icon right>chevron_left</v-icon>
          </v-list-tile-action>
        </v-list-tile>
        <v-list-tile  v-for="item in menuItems"
                      :key="item.title"
                      @click.stop="goTo(item.path)">
          <v-list-tile >
            <v-list-tile-action>
              <v-icon>{{item.icon}}</v-icon>
            </v-list-tile-action>
            <v-list-tile-title>{{item.title}}</v-list-tile-title>
          </v-list-tile>
        </v-list-tile>
      </v-list>
    </v-navigation-drawer>
    <v-toolbar app dark>
      <v-toolbar-side-icon @click="sidebar = !sidebar">
      </v-toolbar-side-icon>
      <v-toolbar-title>
        {{appTitle}}
      </v-toolbar-title>
      <v-spacer></v-spacer>
      <v-toolbar-items class="hidden-xs-only">
        <v-btn
          flat
          v-for="item in menuItems"
          :key="item.title"
          :to="item.path">
          <v-icon left dark>{{ item.icon }}</v-icon>
          {{ item.title }}
        </v-btn>
      </v-toolbar-items>
    </v-toolbar>
    
    <v-content>
      <v-container fluid>
        <v-layout row wrap>
          <v-flex xs12 class="text-xs-center" mt-5>
            <h1 class="glH1">Sign In</h1>
          </v-flex>
          <v-flex xs12 sm6 offset-sm3 mt-3>
            <form>
              <v-layout column>
                <v-flex>
                  <v-text-field
                    name="email"
                    label="Email"
                    id="email"
                    type="email"
                    v-model="email"
                    :rules="emailRules"
                    dark style="margin-bottom: 15px;">
                  </v-text-field>
                </v-flex>
                <v-flex>
                  <v-text-field
                    name="password"
                    label="Password"
                    id="password"
                    type="password"
                    :rules="passwordRules"
                    :counter="6"
                    v-model="password"
                    dark>
                  </v-text-field>
                </v-flex>
                <v-flex class="text-xs-center" mt-5>
                  <v-btn dark @click="signIn">Sign In</v-btn>
                </v-flex>
              </v-layout>
            </form>
          </v-flex>
        </v-layout>
      </v-container>
    </v-content>
  </div>
</template>

<script>
  import firebase from 'firebase'

  export default {
    name: 'login',
    data: function() {
      return {
        email: '',
        password: '',
        appTitle: 'Statlete',
        sidebar: false,
        menuItems: [
          { title: 'Login', path: '/login', icon: 'input' },
          { title: 'Sign Up', path: '/sign-up', icon: 'person_add' },
          { title: 'About', path: '/about', icon: 'info' },
          { title: 'FAQ', path: '/faq', icon: 'question_answer' }
        ],
        mini: true,
        emailRules: [
          (v) => !!v || 'E-mail is required',
          (v) => /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(v) || 'E-mail must be valid'
        ],
        passwordRules: [
          (v) => !!v || 'Password is required',
          (v) => v.length >= 6 || 'Password must be at least 6 characters.'
        ],
        errorMsg: '',
        alert: false
      }
    },
    // mounted() {
    //   // Get the input field
    //   var emailField = document.getElementById("loginEmail");
    //   var passwordField = document.getElementById("loginPass");

    //   emailField.addEventListener("keyup", function(event) {
    //     event.preventDefault();
    //     // Number 13 is the "Enter" key on the keyboard
    //     if (event.keyCode === 13) {
    //       document.getElementById("signInBtn").click();
    //     }
    //   });

    //   passwordField.addEventListener("keyup", function(event) {
    //     event.preventDefault();
    //     // Number 13 is the "Enter" key on the keyboard
    //     if (event.keyCode === 13) {
    //       document.getElementById("signInBtn").click();
    //     }
    //   });
    // },
    methods: {
      goTo: function(path) {
        this.$router.push(path)
      },
      aboutClicked: function(){
        this.$router.push('/about')
      },
      signupClicked: function(){
        this.$router.push('/sign-up')
      },
      signIn: function() {
        var self = this
        if(/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(this.email) && this.password.length >= 6){
          firebase.auth().signInWithEmailAndPassword(this.email, this.password).then(
            (user) => {
              self.$router.replace('main')
            },
            function(err) {
              alert('ERROR. ' + err.message)
            }
          );
        }
      },
      signInGoogle: function() {
        var provider = new firebase.auth.GoogleAuthProvider();
        firebase.auth().signInWithPopup(provider).then(
          (user) => {
            var usr = user.user;
            this.$router.replace('main');
          },
          function(err) {
            alert('ERROR. ' + err.message)
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

  a, i {
    text-decoration: none;
  }

  .v-icon:hover {
    text-decoration: none;
  }

  .v-list__tile__action:hover {
    text-decoration: none;
  }

</style>
