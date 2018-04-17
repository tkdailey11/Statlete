<template>
  <div id="TeamSettings">
    <input type="text" v-model="teamID" :placeholder="id">
    <button @click="submitTeamID">Submit</button>
    <br>
    <br>
    <input type="text" v-model="token" :placeholder="tok">
    <button @click="submitToken">Submit</button>
    <br>
    <br>
    <players-list :addPlayerEnabled="false"
                  :title="'Admins'"
                  style="float: left;"></players-list>
    <players-list :addPlayerEnabled="false"
                  style="float: left;"></players-list>
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
    min-height: 720px;
    background-color: orange;
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
  button {
    margin-top: 20px;
    width: 10%;
    cursor: pointer;
  }
</style>
