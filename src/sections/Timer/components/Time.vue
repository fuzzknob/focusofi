<script lang="ts" setup>
import { ref } from 'vue'
import { padStart } from 'lodash'

import { formatSecondsToTime } from '@/libs/utils'

import { TimerStatus } from '@/types/types'
import { useTimerStore } from '@/stores/timer'

const timerStore = useTimerStore()

const { status, time, successionCount } = storeToRefs(timerStore)

const minutesHand = ref('00')
const secondsHand = ref('00')

const separatorVisible = computed(() => {
  return time.value % 2 === 0
})

const message = computed(() => {
  if (status.value === TimerStatus.Working) {
    return `${successionCount.value < 1 ? 'Long break' : 'Short break'} in...`
  }
  if ([TimerStatus.LongBreak, TimerStatus.ShortBreak].includes(status.value)) {
    return 'Break end in...'
  }
  if (status.value === TimerStatus.Paused) {
    return 'Timer paused'
  }
  return 'POMO TIMER'
})

const textColor = computed(() => {
  const statusValue = status.value
  if ([TimerStatus.ShortBreak, TimerStatus.LongBreak].includes(statusValue)) {
    return 'text-green-300'
  }
  if (statusValue === TimerStatus.Paused) {
    return 'text-blue-500'
  }
  return 'text-white'
})

watch(time, () => {
  const { minutes, seconds } = formatSecondsToTime(time.value)
  minutesHand.value = padStart(minutes.toString(), 2, '0')
  secondsHand.value = padStart(seconds.toString(), 2, '0')
}, {
  immediate: true,
})
</script>

<template>
  <div>
    <h1 class="-mb-36 text-4xl">
      {{ message }}
    </h1>
    <div
      class="time flex items-center"
      :class="textColor"
    >
      <div class="flex">
        {{ minutesHand }}
      </div>
      <div class="separator flex flex-center pb-4 pointer-events-none">
        <span :class="{ 'opacity-0': !separatorVisible }">:</span>
      </div>
      <div class="flex">
        {{ secondsHand }}
      </div>
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
