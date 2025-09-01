<script lang="ts" setup>
import { TimerState, BlockType, Action } from '@/types'

import Time from './components/Time.vue'
import Report from './components/Report.vue'

const { timerState, currentBlock, startTimer, pauseTimer, resumeTimer, stopTimer, skipBlock } = useTimer()

const actionButtons = computed(() => {
  if (timerState.value === TimerState.idle) {
    return [Action.start]
  }

  if (timerState.value === TimerState.paused) {
    return [Action.resume, Action.skip, Action.stop]
  }

  if (timerState.value === TimerState.stopped) {
    return [Action.reset]
  }

  const blockType = currentBlock.value!.type

  if (blockType === BlockType.longBreak || blockType === BlockType.shortBreak) {
    return [Action.skip, Action.stop]
  }

  return [Action.pause, Action.skip, Action.stop]
})
</script>

<template>
  <div>
    <Time v-if="timerState !== TimerState.stopped" />
    <Report v-else />
    <div class="flex-center gap-6 text-3xl md:-mt-24 -mt-20">
      <template
        v-for="action in actionButtons"
        :key="action"
      >
        <Button
          v-if="action === Action.start"
          class="px-5 py-1"
          @click="startTimer"
        >
          START
        </Button>

        <Button
          v-if="action === Action.skip"
          class="flex items-center"
          @click="skipBlock"
        >
          SKIP
        </Button>

        <Button
          v-if="action === Action.pause"
          class="px-5 py-1"
          @click="pauseTimer"
        >
          PAUSE
        </Button>

        <Button
          v-if="action === Action.resume"
          class="px-5 py-1"
          @click="resumeTimer"
        >
          RESUME
        </Button>

        <Button
          v-if="action === Action.stop"
          variant="danger"
          class="px-5 py-1"
          @click="stopTimer"
        >
          STOP
        </Button>
      </template>
    </div>
  </div>
</template>
