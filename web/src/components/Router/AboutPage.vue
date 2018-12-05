<template>
    <div class="AboutPage">
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
            <v-container grid-list-md text-xs-center>
                <v-layout style="margin-bottom: 10vh;">
                    <v-flex xs12 sm12>
                        <v-card dark>
                            <v-card-title primary-title>
                                <div>
                                    <h1>What is Statlete?</h1>
                                </div>
                            </v-card-title>

                            <div style="padding-bottom: 15px;">
                                <p class="myP">
                                    Statlete is a tool for athletes and coaches to track and analyze statistics in order to make targeted improvements, with support for basketball, football, and soccer. This will help facilitate the development of youth teams and individual players by helping them isolate areas of strength and weakness. Existing methods for tracking performance require manual computation for in-depth analysis. The user interface will allow for quick entering of data points in live time.
                                </p>
                                <p class="myP">
                                    After creating an account, a user will be able to add sport-specified portfolios that will contain game data. Statlete introduces the concept of a “Sportfolio” to organize player or team activity. On creation, a Sportfolio will be designated as “team” or “player” by the user. A player-identified Sportfolio can enter personal data by creating a new Game or optionally link to an existing team, created by another user. If linked to a team, the data in the Sportfolio will be sourced from that team and disallow creation of personal games. Data for a team-identified Sportfolio will be entered by authorized users. A visual representation and select analysis of the data will be available on the mobile application. The web interface will provide a more detailed and thorough analysis.
                                </p>
                                <p class="myP">
                                    While there exists a wide variety of statistics across different sports, standard ones will be included by default. For example, in soccer, users will be able to record passing, shooting, goals, assists, etc. In addition, users will have the ability to enter custom statistics for specific areas they would like to monitor. These custom stats will be analyzed over a period of time and in correlation with other data points.
                                </p>
                                <p class="myP">
                                    The use of statistics and analytics in sports is not a new concept. The majority of professional sports teams currently utilize analytics teams or experts. Professional teams have seen notable improvement as a result of investing time, money, and effort into statistics and analytics. However, youth teams do not currently have the same resources to conduct these analyses. The goal of Statlete is to provide youth teams and athletes with a tool to effectively record and analyze statistics, thereby accelerating development and improving performance.
                                </p>
                            </div>
                        </v-card>
                    </v-flex>
                </v-layout>
            </v-container>

            <v-container grid-list-md text-xs-center>
                <v-layout style="margin-bottom: 10vh;">
                    <v-flex xs12 sm12>
                        <v-card dark>
                            <v-card-title primary-title>
                                <div>
                                    <h2>Components in Statlete</h2>
                                </div>
                            </v-card-title>

                            <div style="padding-bottom: 10px;">
                                <v-tabs
                                    v-model="active"
                                    dark>
                                    <v-tab ripple>
                                        iOS
                                    </v-tab>
                                    <v-tab ripple>
                                        Webpage
                                    </v-tab>
                                    <v-tab-item>
                                        <v-card flat>
                                            <v-card-text>{{ iosText }}</v-card-text>
                                        </v-card>
                                    </v-tab-item>
                                    <v-tab-item>
                                        <v-card flat>
                                            <v-card-text>{{ webText }}</v-card-text>
                                        </v-card>
                                    </v-tab-item>
                                </v-tabs>
                                <div class="text-xs-center mt-3">
                                    <v-btn @click="next">next tab</v-btn>
                                </div>
                            </div>
                        </v-card>
                    </v-flex>
                </v-layout>
            </v-container>
        </v-content>
    </div>
</template>

<script>
export default {
    data() {
        return {
            appTitle: 'Statlete',
            sidebar: false,
            menuItems: [
            { title: 'Login', path: '/login', icon: 'input' },
            { title: 'Sign Up', path: '/sign-up', icon: 'person_add' },
            { title: 'About', path: '/about', icon: 'info' },
            { title: 'FAQ', path: '/faq', icon: 'question_answer' }
            ],
            mini: true,
            active: null,
            iosText: 'The iOS application will be available for iPhone and iPad. A data entry view will allow users with authorization to input statistics for a game. A user linked to a team will have access to view live-time updates of game data. A basic analysis will be viewable through the mobile app.',
            webText: 'In addition to the abilities provided by the mobile application, the web interface will also allow users to access detailed analysis and graphical data visualizations.'
        }
    },
    methods: {
        next () {
            const active = parseInt(this.active)
            this.active = (active < 2 ? active + 1 : 0)
        },
        goTo: function(path) {
            this.$router.push(path)
        },
    }
}
</script>

<style scoped>
  .myBottomNav{
    padding-left: 25vw;
    padding-right: 25vw;
    padding-bottom: 25px;
    padding-top: 25px;
    border-top-style: solid;
    border-top-width: 3px;
    margin-top: 25px;
  }

  .myP {
      text-align: left;
      margin-left: 5%;
      margin-right: 5%;
  }

  .about_p {
      padding-top: 3%;
      border-width: 2px;
      border-style: solid;
      border-radius: 20px;
      margin: 5%;
  }
  .myUl {
      text-align: left;
      margin-left: 3%;
      margin-right: 3%;
      margin-bottom: 5%;
  }
  a, i {
    text-decoration: none;
  }
</style>
