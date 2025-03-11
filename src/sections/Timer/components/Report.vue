<script setup lang="ts">
import { useTimerStore } from '@/stores/timer'
import { timeToText, formatSecondsToTime } from '@/libs/utils'

import Button from '@/components/ButtonSquare.vue'

const timerStore = useTimerStore()
const { report } = storeToRefs(timerStore)

const totalWorked = computed(() => {
  const time = formatSecondsToTime(report.value.totalWorked)
  return timeToText(time)
})

const totalBreak = computed(() => {
  const time = formatSecondsToTime(report.value.totalBreakTaken)
  return timeToText(time)
})

function resetTimer() {
  timerStore.reset()
}
</script>

<template>
  <div class="w-screen flex justify-center px-2">
    <div class="max-w-[550px] flex-1 bg-purple-600/60 px-7 py-5">
      <h3 class="text-4xl text-center">
        RESULTS
      </h3>
      <div class="text-3xl ">
        <div class="flex justify-between">
          <span>
            Worked:
          </span>
          <span>{{ totalWorked }}</span>
        </div>
        <div class="flex justify-between">
          <span>
            Break taken:
          </span>
          <span>{{ totalBreak }}</span>
        </div>
      </div>
      <div class="flex justify-center mt-6">
        <Button
          variant="secondary"
          class="text-2xl"
          @click="resetTimer"
        >
          DONE
        </Button>
      </div>
    </div>
  </div>
</template>
