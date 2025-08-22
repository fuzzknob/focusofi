<script lang="ts" setup>
import ClockView from './components/ClockView.vue'

const time = ref(300)

function tick() {
  time.value = Date.now()
}

onMounted(() => {
  tick()
  setInterval(() => {
    tick()
  }, 1000)
})
</script>

<template>
  <div>
    <ClockView :time="time" />
  </div>
</template>
