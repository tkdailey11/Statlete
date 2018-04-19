<template>
  <div id="TeamSettings">
    <div class="TextFieldContainer">
      <div class="TextField" align="left">
        <input class="MyText" type="text" v-model="teamID" :placeholder="id">
        <button class="btn btn-default navbar-btn myButton" @click="submitTeamID">Submit</button>
      </div>
      <div class="TextField" align="left">
        <input class="MyText" type="text" v-model="token" :placeholder="tok">
        <button class="btn btn-default navbar-btn myButton"@click="submitToken">Submit</button>
      </div>
    </div>
    <div class="ListContainer">
      <players-list :addPlayerEnabled="false"
                    :title="'Admins'"
                    style="float: left;"></players-list>
      <players-list :addPlayerEnabled="false"
                    style="float: left;"></players-list>
    </div>
    <button @click="goBack">Go Back</button>
  </div>
</template>

<script>
  export default {
    name: 'TeamSettings',
    data: function() {
      return {
        teamID: '',
        token: ''
      }
    },
    props: {
      id: {
        default: 'TeamID'
      },
      tok: {
        default: 'Token'
      }
    },
    methods: {
      goBack: function() {
        this.$emit('TeamSettingsClose');
        console.log('CLOSE');
      },
      submitTeamID: function() {
        console.log('Submit Team ID');
      },
      submitToken: function() {
        console.log('Submit Token');
      }
    }
  }
</script>

<style scoped>
  #TeamSettings {
    width: 100%;
    height: 100%;
    min-height: 100vh;
    background-color: white;
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
  .myButton {
    background-color: orange;
    color: rgb(180, 41, 102);
    margin-top: 10px;
    margin-left: 20px;
  }
  .myButton:hover {
    background-color: rgba(250, 220, 127, 0.9);
  }

  .TextFieldContainer {
    float: left;
    display: block;
    min-width: 1000px;
    margin:-20px 25px 50px 35px;
  }
  .TextField {
    color: white;
    margin: 20px;
  }
  .MyText {
    min-width: 46vw;
  }
  .ListContainer {
    min-width: 1000px;
    background-color: blue;
  }
</style>
