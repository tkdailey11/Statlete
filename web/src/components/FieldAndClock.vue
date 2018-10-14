<template>
    <div class="FieldAndClock">
        <div class="TimeClock" @click="clockClicked">
          <period-marker class="pm" :period="1" :filled="activePeriod >= 1" style="margin-left: 10px;"></period-marker>
          <h1>{{currTime}}</h1>
          <period-marker class="pm" :period="2" :filled="activePeriod >= 2"></period-marker>
        </div>
    </div>
</template>

<script>
export default {
    
}
</script>

<style scoped>

</style>


