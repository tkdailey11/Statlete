<template>
    <div class="AboutPage">
        <h1>About</h1>
        <h2>What is Statlete?</h2>
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

        <h2>Components in Statlete</h2>
        <ul class="myUl">
            <li style="font-weight: bold;">iOS Application</li>
            <p>The iOS application will be available for iPhone and iPad. A data entry view will allow users with authorization to input statistics for a game. A user linked to a team will have access to view live-time updates of game data. A basic analysis will be viewable through the mobile app.</p>
            <li style="font-weight: bold;">Web Interface</li>
            <p>In addition to the abilities provided by the mobile application, the web interface will also allow users to access detailed analysis and graphical data visualizations.</p>
        </ul>
        <p style="color: white;">test</p>


        <footer class="navbar fixed-bottom myNav">
            <div><router-link to="/login" class="link">Login</router-link></div>
            <div><router-link to="/sign-up" class="link">Signup</router-link></div>
            <div>About</div>
            <div><router-link to="/faq" class="link">FAQ</router-link></div>
        </footer>
    </div>
</template>

<script>
export default {
    
}
</script>

<style scoped>
.AboutPage {
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
  .link {
    color: rgb(224,0,16);
  }
  .link:hover {
    color: rgb(242,209,24);
  }
  .myP {
      text-align: left;
      margin-left: 5%;
      margin-right: 5%;
  }
  .myUl {
      text-align: left;
      margin-left: 3%;
      margin-right: 3%;
      margin-bottom: 5%;
  }
</style>
