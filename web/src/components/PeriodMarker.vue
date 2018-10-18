<template>
    <div class="PeriodMarker">
        <img class="labelImg" v-if="this.filled" src="../assets/images/RedFilledCircle.png">
        <img class="labelImg" v-else src="../assets/images/RedHollowCircleThick.png">
        <h2>{{period}}</h2>
    </div>
</template>

<script>
export default {
    name: 'PeriodMarker',
    props: {
        filled: {
            default(){
                return false;
            }
        },
        period: {
            default(){
                return "1"
            }
        }
    }
}
</script>

<style scoped>
.PeriodMarker {
    float: left;
    width: 3vw;
}
    .labelImg {
        width: 25%;
        height: 25%;
    }
</style>