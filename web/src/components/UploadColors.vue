<template>
  <transition name="modal-fade">
    <div class="modal-backdrop">
        <div class="modal-left-pane" @click="close">
        </div>
        <div class="modal-center">
            <div class="ng-modal-header" @click="close">
            </div>
            <div class="modal-body">
                <div class="color_chooser">
                    <div style="float: left;">
                        <strong>Please choose a color for your team:</strong>
                    </div>
                    <div style="float: left; margin-left: 25px; margin-top: -10px;">
                        <swatches v-model="myColor"
                                  show-fallback
                                  popover-to="right">
                        </swatches>
                    </div>
                    <div style="float: left; margin-left: 75px;">
                        <strong>Please choose a secondary color for your team:</strong>
                    </div>
                    <div style="float: left; margin-left: 25px; margin-top: -10px;">
                        <swatches v-model="secondaryColor"
                                  show-fallback
                                  popover-to="right">
                        </swatches>
                    </div>
                </div>
                <div class="color_chooser">
                    <div style="float: left;">
                        <strong>Please choose a color for your opponents:</strong>
                    </div>
                    <div style="float: left; margin-left: 25px; margin-top: -10px;">
                        <swatches v-model="oppColor"
                                  show-fallback
                                  popover-to="right">
                        </swatches>
                    </div>
                </div>
                <a class="main_button" @click="submit">Submit</a>
            </div>
            <div class="ng-modal-footer" @click="close">
            </div>
        </div>
        <div class="modal-right-pane" @click="close">
        </div>
    </div>
  </transition>
</template>

<script>
import firebase from 'firebase';
import { mapGetters, mapMutations } from 'vuex';
import Swatches from 'vue-swatches'

export default {
    name: 'colorModal',
    computed: {
        ...mapGetters({
            currentUserEmail: 'mainStore/currentUserEmail'
        })
    },
    methods: {
        close() {
            this.$emit('close');
        },
        submit() {
            this.$emit('SubmitColors', {
                'myColor': this.myColor,
                'oppColor': this.oppColor,
                'secondaryColor': this.secondaryColor
            })
        }
    },
    data() {
        return {
            myColor: '',
            oppColor: '',
            secondaryColor: ''
        }
    },
    components: {
        Swatches
    }
    
  };
</script>
<style>
    .modal-backdrop {
        background-color: rgba(0, 0, 0, 0.3);
        display: flex;
    }

    .modal-right-pane {
        flex-basis: 10%;
    }

    .modal-left-pane {
        flex-basis: 10%;
    }

    .modal-center {
        display: flex;
        flex-direction: column;
        flex-basis: 80%;
    }

    .ng-modal-header, .ng-modal-footer {
        flex-basis: 10%;
    }

    .modal-body {
        flex-basis: 80%;
        border-radius: 20px;
        display: flex;
        flex-direction: column;
        border-width: 3px;
        border-style: solid;
    }

    .color_chooser {
        border-radius: 20px;
        border-width: 3px;
        border-style: solid;
        margin: 50px;
        padding: 25px;
    }

    .main_button {
        width: 50%;
        height: 5%;
        margin-left: 25%;
    }
</style>