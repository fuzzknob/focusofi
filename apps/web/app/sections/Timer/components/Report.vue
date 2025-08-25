<script setup lang="ts">
import Button from '@/components/Button.vue'
import { BlockType } from '@/types'
import { timeToText, formatSecondsToTime } from '@/libs/utils'

const { resetTimer, sequence, accumulatedBreak, accumulatedWork } = useTimer()

const totalBreak = computed(() => {
  const currentSeqBreak = sequence.value.blocks
    .filter(block => [BlockType.shortBreak, BlockType.shortBreak].includes(block.type))
    .reduce((previous, block) => previous + block.elapsed, 0)

  return currentSeqBreak + accumulatedBreak.value
})

const totalWork = computed(() => {
  const currentSeqWork = sequence.value.blocks
    .filter(block => block.type === BlockType.work)
    .reduce((previous, block) => previous + block.elapsed, 0)

  return currentSeqWork + accumulatedWork.value
})

function formatTime(seconds: number) {
  return timeToText(formatSecondsToTime(seconds))
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
            Work Duration:
          </span>
          <span>{{ formatTime(totalWork) }}</span>
        </div>
        <div class="flex justify-between">
          <span>
            Break Duration:
          </span>
          <span>{{ formatTime(totalBreak) }}</span>
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
