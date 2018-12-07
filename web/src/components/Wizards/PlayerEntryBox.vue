<template>
  <div class="PlayerEntryBox">
    <input class="numberBox" type="text" @blur="sendData" v-model="pnum" placeholder="#">
    <!-- <input class="nameBox1" type="text" @blur="sendData" v-model="pname" placeholder="" v-if="pnum===''"> -->
    <input class="nameBox1" type="text" @blur="sendData" v-model="pname" placeholder="Player Name">
  </div>
</template>

<script>
  export default {
    name: 'player-entry-box',
    data: function() {
      return {
        pname: this.playerName,
        pnum: this.playerNumber
      }
    },
    props: {
      index: {
        default: 0
      },
      playerName: {
        default: '',
        type: String
      },
      playerNumber: {
        default: '',
        type: String
      }
    },
    methods: {
      sendData: function() {
        this.$emit('updatedPlayerInfo', {
          name: this.pname,
          num: this.pnum,
          idx: this.index
        });
      }
    },
    mounted() {
      //do something after mounting vue instance
      //var nameBoxes = jQuery('.nameBox1');
      // nameBoxes.each(function(nb) {
      //   if(Object.keys(nb)[0] === 'length' || Object.keys(nb)[0] ==='prevObject'){
          
      //   }
      //   else {
      //     jQuery(this).addClass('my-class');
      //     jQuery(this).prop('disabled', true);
      //   }
      // })
    },
    updated() {
      //do something before updating vue instance
      // var nameBoxes2 = jQuery('.nameBox2');
      // nameBoxes2.each(function(nb) {
      //   if(Object.keys(nb)[0] === 'length' || Object.keys(nb)[0] ==='prevObject'){
          
      //   }
      //   else {
      //     jQuery(this).addClass('my-class2');
      //     jQuery(this).prop('disabled', false);
      //   }
      // })

      // var nameBoxes1 = jQuery('.nameBox1');
      // nameBoxes1.each(function(nb) {
      //   if(Object.keys(nb)[0] === 'length' || Object.keys(nb)[0] ==='prevObject'){
          
      //   }
      //   else {
      //     jQuery(this).addClass('my-class');
      //     jQuery(this).prop('disabled', true);
      //   }
      // })
    }
  }
</script>

<style scoped>
  .PlayerEntryBox {
    width: auto;
    display: inline-block;
  }
  .numberBox {
    width: 25%;
    float: left;
    padding: 0px;
    display: inline-block;
    border: none;
    margin-bottom: 10px;
    border-bottom-width: 2px;
    border-bottom-style: solid;
  }

  .nameBox1 {
    width: 75%;
    padding: 0px;
    display: inline-block;
    border: none;
    margin-bottom: 10px;
    border-bottom-width: 2px;
    border-bottom-style: solid;
  }

  input {
    padding: 0px;
    outline: 0;
  }
</style>
