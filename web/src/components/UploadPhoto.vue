<template>
  <transition name="modal-fade">
    <div class="modal-backdrop">
        <div class="modal-left-pane" @click="close">
        </div>
        <div class="modal-center">
            <div class="ng-modal-header" @click="close">
            </div>
            <div class="modal-body">
                <a class="btn" @click="toggleShow">Select New Image</a>
                <my-upload field="img"
                    @crop-success="cropSuccess"
                    @crop-upload-success="cropUploadSuccess"
                    @crop-upload-fail="cropUploadFail"
                    v-model="show"
                    :width="200"
                    :height="200"
                    url=""
                    :params="params"
                    :headers="headers"
                    :langType="'en'"
                    img-format="png"></my-upload>
                <img :src="imgDataUrl">
                <a class="main_button" @click="close">Submit</a>
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
import myUpload from 'vue-image-crop-upload';

export default {
    name: 'photoModal',
    computed: {
        ...mapGetters({
            currentUserEmail: 'mainStore/currentUserEmail'
        })
    },
    methods: {
        close() {
            this.$emit('close');
        },
        toggleShow() {
            this.show = !this.show;
        },
        /**
         * crop success
         *
         * [param] imgDataUrl
         * [param] field
         */
        cropSuccess(imgDataUrl, field){
            this.imgDataUrl = imgDataUrl;
            var message = this.imgDataUrl;
            var ref = firebase.storage().ref();
            ref.child('/Users/').child(this.currentUserEmail.replace('.', '')).putString(message, 'data_url');
        },
        /**
         * upload success
         *
         * [param] jsonData  server api return data, already json encode
         * [param] field
         */
        cropUploadSuccess(jsonData, field){

        },
        /**
         * upload fail
         *
         * [param] status    server api return error status, like 500
         * [param] field
         */
        cropUploadFail(status, field){

        }
    },
    components: {
        'my-upload': myUpload
    },
    data() {
        return {
            show: true,
            params: {
                token: '123456798',
                name: 'avatar'
            },
            headers: {
                smail: '*_~'
            },
            imgDataUrl: '' // the datebase64 url of created image
        }
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
    }
</style>