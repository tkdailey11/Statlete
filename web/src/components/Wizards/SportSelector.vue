<template>
  <v-item-group>
    <v-container grid-list-md>
      <v-layout wrap>
        <v-flex v-for="n in 3"
                :key="n"
          xs12>
          <v-item>
            <v-card
              slot-scope="{ active, toggle }"
              :color="active ? 'primary' : ''"
              class="d-flex align-center"
              :dark="darkMode" 
              height="200"
              @click="toggle">
              <v-scroll-y-transition>
                <div v-if="active"
                  class="display-3 text-xs-center">
                  Active
                </div>
              </v-scroll-y-transition>
            </v-card>
          </v-item>
        </v-flex>
      </v-layout>
    </v-container>
  </v-item-group>
</template>

<script>
  import { mapGetters } from 'vuex';
  export default {
    data () {
      return {
          
      }
    },
        computed: {
        ...mapGetters({
            darkMode: 'mainStore/darkMode'
        }),
  }

</script>