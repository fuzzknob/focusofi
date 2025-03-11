<script lang="ts" setup>
import { reactive } from 'vue'
import { padStart } from 'lodash'

import { formatSecondsToTime } from '@/libs/utils'

import { TimerStatus } from '@/types/types'
import { useTimerStore } from '@/stores/timer'
import { useSettingsStore } from '@/stores/settings'

const timerStore = useTimerStore()
const settingsStore = useSettingsStore()

const { status, time, successionCount } = storeToRefs(timerStore)
const { breakSuccessions } = storeToRefs(settingsStore)

const minutesHand = ref(['O', 'O'])
const secondsHand = ref(['O', 'O'])

const separatorVisible = computed(() => {
  return time.value % 2 === 0
})

const activePattern = computed(() => {
  if (status.value === TimerStatus.Idle) return -1
  const total = (breakSuccessions.value * 2) - 1
  if (status.value === TimerStatus.LongBreak) return total
  const currentIndex = total - (successionCount.value * 2) + 1
  return [TimerStatus.Working, TimerStatus.Paused].includes(status.value) ? currentIndex : currentIndex - 1
})

const pattern = computed(() => {
  let pattern: string[] = []
  for (let i = 0; i < (breakSuccessions.value - 1); i++) {
    pattern = pattern.concat(['w', 's'])
  }
  pattern = pattern.concat(['w', 'l'])
  return pattern
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
  minutesHand.value = padStart(minutes.toString(), 2, '0').replaceAll('0', 'O').split('')
  secondsHand.value = padStart(seconds.toString(), 2, '0').replaceAll('0', 'O').split('')
}, {
  immediate: true,
})
</script>

<template>
  <div>
    <div class="md:-mb-28 -mb-20 flex justify-center">
      <div class="flex items-end text-2xl">
        <template
          v-for="(statusType, index) in pattern"
          :key="index"
        >
          <div
            v-if="statusType === 'w'"
            class="h-8 w-9 border-4 border-r-0 border-white flex-center"
            :class="{ 'border-l-0': index > 0, 'bg-white text-black': index === activePattern }"
          >
            W
          </div>
          <div
            v-else-if="statusType === 's'"
            class="h-10 border-4 border-white flex items-end"
            :class="{ 'bg-white text-black': index === activePattern }"
          >
            <div class="flex-center w-7 h-6">
              S
            </div>
          </div>
          <div
            v-else
            class="h-10 border-4 border-white flex items-end"
            :class="{ 'bg-white text-black': index === activePattern }"
          >
            <div class="flex-center w-7 h-6">
              L
            </div>
          </div>
        </template>
      </div>
    </div>
    <div
      class="flex items-center text-[13rem] md:text-[19rem]"
      :class="textColor"
    >
      <div class="flex">
        <div class="w-[90px] md:w-[135px] text-end">
          {{ minutesHand[0] }}
        </div>
        <div class="w-[90px] md:w-[135px] text-end">
          {{ minutesHand[1] }}
        </div>
      </div>
      <div class="w-[50px] md:w-[60px] flex flex-center pb-4 pointer-events-none">
        <span :class="{ 'opacity-0': !separatorVisible }">:</span>
      </div>
      <div class="flex">
        <div class="w-[90px] md:w-[135px] text-end">
          {{ secondsHand[0] }}
        </div>
        <div class="w-[90px] md:w-[135px] text-end">
          {{ secondsHand[1] }}
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.separator {
  width: 60px;

  span {
    margin-bottom: 15px;
  }
}
</style>
