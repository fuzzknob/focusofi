<script lang="ts" setup>
import { ref } from 'vue'
import { format } from 'date-fns'

const props = defineProps<{
  time: number
}>()

const separatorVisible = ref(false)
const minuteHand = ref('00')
const secondHand = ref('00')

watch(
  () => props.time,
  () => {
    const { time } = props
    minuteHand.value = format(time, 'HH')
    secondHand.value = format(time, 'mm')
    separatorVisible.value = !separatorVisible.value
  },
  {
    immediate: true,
  },
)
</script>

<template>
  <div class="time flex items-center">
    <div class="flex">
      {{ minuteHand }}
    </div>
    <div class="separator flex flex-center pb-4">
      <span v-if="separatorVisible">:</span>
    </div>
    <div class="flex">
      {{ secondHand }}
    </div>
  </div>
</template>

<style scoped>
.time {
  font-size: 19rem;
}
.separator {
  width: 60px;

  span {
    margin-bottom: 15px;
  }
}
</style>
