<script lang="ts" setup>
import { TimerState, BlockType, Action } from '@/types'

import Time from './components/Time.vue'
import ExtendTime from './components/ExtendTime.vue'
import Report from './components/Report.vue'

const { timerState, currentBlock, startTimer, pauseTimer, resumeTimer, stopTimer, skipBlock } = useTimer()

const actionButtons = computed(() => {
  if (timerState.value === TimerState.idle) {
    return [Action.start]
  }

  if (timerState.value === TimerState.paused) {
    return [Action.resume, Action.skip, Action.stop, Action.extendLength]
  }

  if (timerState.value === TimerState.stopped) {
    return [Action.reset]
  }

  const blockType = currentBlock.value!.type

  if (blockType === BlockType.longBreak || blockType === BlockType.shortBreak) {
    return [Action.pause, Action.skip, Action.stop, Action.extendLength]
  }

  return [Action.pause, Action.skip, Action.stop, Action.extendLength]
})
</script>

<template>
  <div class="transition">
    <Time
      v-if="timerState !== TimerState.stopped"
    />
    <Report v-else />
    <div class="flex flex-col gap-5 text-3xl md:-mt-24 -mt-20">
      <div class="flex-center gap-4">
        <template
          v-for="action in actionButtons"
          :key="action"
        >
          <Button
            v-if="action === Action.start"
            class="px-5 py-1"
            title="Start Timer"
            @click="startTimer"
          >
            START
          </Button>
          <Icon
            v-if="action === Action.stop"
            name="ion:square-sharp"
            size="35"
            class="cursor-pointer hover:scale-110"
            title="Stop Timer"
            @click="stopTimer"
          />
          <Icon
            v-if="action === Action.pause"
            name="ion:md-pause"
            size="40"
            class="cursor-pointer hover:scale-110"
            title="Pause Timer"
            @click="pauseTimer"
          />
          <Icon
            v-if="action === Action.resume"
            name="ion:md-play"
            size="40"
            class="cursor-pointer hover:scale-110"
            title="Resume Timer"
            @click="resumeTimer"
          />
          <Icon
            v-if="action === Action.skip"
            name="ion:md-skip-forward"
            size="40"
            class="cursor-pointer hover:scale-110"
            :title="currentBlock?.type === BlockType.work ? 'Skip Work' : 'Skip Break'"
            @click="skipBlock"
          />
          <ExtendTime
            v-if="action === Action.extendLength"
          />
        </template>
      </div>
    </div>
  </div>
</template>
