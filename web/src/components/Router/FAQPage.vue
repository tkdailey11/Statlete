<template>
    <div class="FAQPage">
        <h1 class="faqHeader">FAQ</h1>
        <!-- <div class="vue-expand-panel">
            <ul>
                <li v-for="(item, index) in dataPoints" :key="index">
                    <expand-panel :title="item.header">
                        <div class="section-content">
                            <div class="col-txt col-1">{{item.body}}</div>
                        </div>
                    </expand-panel>
                </li>
            </ul>
        </div> -->
        <template>
            <v-expansion-panel
                :dark="true">
                <v-expansion-panel-content
                    v-for="(item,i) in dataPoints"
                    :key="i"
                >
                    <div slot="header" class="vcard_header">{{item.header}}</div>
                    <v-card>
                        <v-card-text class="vcard_txt">{{item.body}}</v-card-text>
                    </v-card>
                </v-expansion-panel-content>
            </v-expansion-panel>
        </template>
        <footer class="navbar fixed-bottom myBottomNav">
            <div><router-link to="/login" class="ap_link">Login</router-link></div>
            <div><router-link to="/sign-up" class="ap_link">Signup</router-link></div>
            <div><router-link to="/about" class="ap_link">About</router-link></div>
            <div>FAQ</div>
        </footer>
    </div>
</template>

<script>
export default {
    data() {
        return {
            dataPoints: [
                {
                    'header': 'How do I create an account?',
                    'body': 'Creating an account is easy.  Simply enter your name, email, and your desired password, and you are a ready to go. If you have a Google account, you may also sign in using your Google credentials.'
                },
                {
                    'header': 'What is a Sportfolio?',
                    'body': 'A Sportfolio is a collection of your tracked statistics for a given team.  You can make multiple Sportfolios and choose to dedicate them to Soccer, Basketball, or Football.  This keeps all of your stats nice and organized so you can easily find all of your data across all of your tracked teams. \n\n Creating a Team Sportfolio allows you to add players to your roster and puts you in charge of your team\'s stats.  Team admins can request an analysis of their cumulative game statistics in order to spot trends in performance.  Our game analysis aims to help coaches set goals tailored to their teams performance.'
                },
                {
                    'header': 'Creating a Sportfolio',
                    'body': 'From your user home screen, you are able to create either a Player or Team Sportfolio by clicking on the orange plus button on the right side of the page.  You then specify which of the three available sports you want this Sportfolio to be dedicated to, and click the Create button.'
                },
                {
                    'header': 'I created my Sportfolio, now what?',
                    'body': 'Now it\'s time to start a game!  By clicking on your Sportfolio in your user home screen, you will be taken to a list of all the games that have been tracked in this Sportfolio.  Initially this list will be empty of course, so to add one you simply press the small plus button on the right hand side of the screen.  Depending on the sport, you will be able to enter information about the game you are about to play, and after clicking the Create button you are ready to track your stats.'
                },
                {
                    'header': 'How can I see stats from previous games?',
                    'body': 'You can access the stats from any of your previously played games simply by clicking on them in your Games list.  While stat-tracking is only available for in-progress games, you can still view the stats from each game, as well as a play-by-play for a review of the action.'
                },
                {
                    'header': 'My team has played some games, but I think we can do better. How can you help me?',
                    'body': 'Statlete gives teams the opportunity to learn from the past and set goals to improve in the future.  Our game analysis allows coaches to request data from their tracked statistics and visualize their team\'s performance over time.  Inside each Team Sportfolio is an Analysis page, where team admins can select which stat(s) they are interested in.  By selecting two stats, we provide a side-by-side comparison in an effort to help visualize correlations between different statistics.\n\nAs a part of this analysis, we tell you on average what it takes for your team to win given the current statistic.  Whether thats how many assists your basketball team has per win, or how many passing yards your football team can give up to an opponent, we give you the ability to informed goals on your way to more success.'
                },
                {
                    'header': 'What is AskStatlete?',
                    'body': 'AskStatlete adds an additional layer to our game analysis, and provides football teams with suggestions on what types of plays should be ran in a given situation. Let\'s say your team has an important 3rd down and short they need to convert.  Ask Statlete compiles all of the plays your team has ran on 3rd and short, and quickly informs you of which play you have had the most success with, as well as the least amount of success with.  AskStatlete is available for all situations, ranging from 1st down plays to 4th and long and everything in between.'
                },
                {
                    'header': 'Can other teams see my data? I don\'t want to do their scouting report for them!',
                    'body': 'Your team\'s data is only visible to you and anyone you allow to link to your team.  You are in charge of who does and does not get to see your data.  Unless you have a spy within your own ranks, no other team can see what you have tracked.'
                },
                {
                    'header': 'Do I always have to use the same device? What if I lose my phone?',
                    'body': 'After creating a Statlete account, all of your tracked data is available to you, no matter how you choose to access our platform.  As you record your game stats, they are automatically pushed to our Google-hosted database, allowing you to sign in at any time and from any Internet connected device.'
                },
                {
                    'header': 'I don\'t have an iOS device, am I out of luck?',
                    'body': 'In an effort to bring our competitive analysis to as many as possible, Statlete is also available on the web!  Head over to Statlete.net, where all of the stat-tracking and analytical features of the app are also available.'
                }
            ]
        }
    }
}
</script>

<style scoped>

.FAQPage {
    height: 100vh;
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
