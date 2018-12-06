<template>
  <div class="sign-up">
      <v-navigation-drawer
          v-model="sidebar"
          :mini-variant="mini"
          absolute
          :dark="darkMode"
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
            <v-list-tile
                @click="TOGGLE_DARK_MODE()">
                  <v-list-tile-action>
                    <v-icon>color_lens</v-icon>
                  </v-list-tile-action>
                  <v-list-tile-title v-text="'Toggle DarkMode'"></v-list-tile-title>
              </v-list-tile>
          </v-list>
        </v-navigation-drawer>
    <v-toolbar app :dark="darkMode">
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
          <v-icon left :dark="darkMode">{{ item.icon }}</v-icon>
          {{ item.title }}
        </v-btn>
      </v-toolbar-items>
    </v-toolbar>
    
    <v-content>
      <v-container fluid>
        <v-layout row wrap>
          <v-flex xs12 class="text-xs-center" mt-5>
            <h1 class="glH1">Create Account</h1>
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
                    required
                    :dark="darkMode"></v-text-field>
                </v-flex>
                <v-flex>
                  <v-text-field
                    name="password"
                    label="Password"
                    id="password"
                    type="password"
                    required
                    :dark="darkMode"></v-text-field>
                </v-flex>
                <v-flex>
                  <v-text-field
                    name="confirmPassword"
                    label="Confirm Password"
                    id="confirmPassword"
                    type="password"
                    required
                    :dark="darkMode"></v-text-field>
                </v-flex>
                <v-flex class="text-xs-center" mt-5>
                  <v-btn type="submit" :dark="darkMode">Submit</v-btn>
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
  import { mapGetters, mapMutations } from 'vuex';
  export default {
    name: 'signUp',
    data: function() {
      return {
        email: '',
        password: '',
        passwordConfirm: '',
        appTitle: 'Statlete',
        sidebar: false,
        menuItems: [
          { title: 'Login', path: '/login', icon: 'input' },
          { title: 'Sign Up', path: '/sign-up', icon: 'person_add' },
          { title: 'About', path: '/about', icon: 'info' },
          { title: 'FAQ', path: '/faq', icon: 'question_answer' }
        ],
        mini: true
      }
    },
    computed:{
      ...mapGetters({
        darkMode: 'mainStore/darkMode'
      })
    },
    methods: {
      ...mapMutations({
            TOGGLE_DARK_MODE: 'mainStore/TOGGLE_DARK_MODE'
        }),
      goTo: function(path) {
        this.$router.push(path)
      },
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

  p {
    margin-top: 10px;
    font-size: 13px;
  }

  h1 {
    font-size: 60px;
  }

  a, i {
    text-decoration: none;
  }

</style>
