<template>
  <transition name="modal-fade">
    <div class="modal-backdrop">
        <div class="modal-left-pane" @click="close">
        </div>
        <div class="modal-center">
            <div class="ng-modal-header" @click="close">
            </div>
            <div class="modal-body">
                <a class="btn" @click="toggleShow">set avatar</a>
                <my-upload field="img"
                    @crop-success="cropSuccess"
                    @crop-upload-success="cropUploadSuccess"
                    @crop-upload-fail="cropUploadFail"
                    v-model="show"
                    :width="300"
                    :height="300"
                    url="/upload"
                    :params="params"
                    :headers="headers"
                    :langType="'en'"
                    img-format="png"></my-upload>
                <img :src="imgDataUrl">
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

import myUpload from 'vue-image-crop-upload';
export default {
    name: 'photoModal',
    methods: {
        close() {
            this.$emit('close');
        },
        onChange (image) {
            console.log('New picture selected!')
            if (image) {
                console.log('Picture loaded.')
                this.image = image
            } else {
                console.log('FileReader API not supported: use the <form>, Luke!')
            }
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
            console.log('-------- crop success --------');
            this.imgDataUrl = imgDataUrl;
        },
        /**
         * upload success
         *
         * [param] jsonData  server api return data, already json encode
         * [param] field
         */
        cropUploadSuccess(jsonData, field){
            console.log('-------- upload success --------');
            console.log(jsonData);
            console.log('field: ' + field);
        },
        /**
         * upload fail
         *
         * [param] status    server api return error status, like 500
         * [param] field
         */
        cropUploadFail(status, field){
            console.log('-------- upload fail --------');
            console.log(status);
            console.log('field: ' + field);
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