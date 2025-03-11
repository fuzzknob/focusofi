<script lang="ts" setup>
import { getMilliseconds } from 'date-fns'

import Time from './components/Time.vue'
import Report from './components/Report.vue'
import { TimerStatus } from '@/types/types'
import { useTimerStore } from '@/stores/timer'
import Button from '@/components/ButtonSquare.vue'

const timerStore = useTimerStore()
const { status } = storeToRefs(timerStore)

let timeout: NodeJS.Timeout | null = null
let expectedTimeout: number | null = null

watch(status, (status) => {
  if (import.meta.server) return
  if ([
    TimerStatus.Working,
    TimerStatus.LongBreak,
    TimerStatus.ShortBreak,
  ].includes(status)
  && !timeout) {
    tick()
    return
  }
  if ([TimerStatus.Stopped, TimerStatus.Paused].includes(status) && timeout) {
    clearTimeInterval()
  }
})

onMounted(() => {
  if ([
    TimerStatus.Working,
    TimerStatus.LongBreak,
    TimerStatus.ShortBreak,
  ].includes(status.value)
  && timerStore.startTime) {
    timerStore.tick()
    const start = getMilliseconds(timerStore.startTime)
    const current = (new Date()).getMilliseconds()
    const interval = start > current ? start - current : 1000 - current + start
    expectedTimeout = Date.now() + interval
    timeout = setTimeout(tick, interval)
    return
  }
})

function tick() {
  timerStore.tick()
  const interval = 1000
  let slippage = 0
  if (expectedTimeout) {
    slippage = Date.now() - expectedTimeout
    expectedTimeout += interval
  }
  else {
    expectedTimeout = Date.now() + interval
  }
  timeout = setTimeout(tick, interval - slippage)
}

function clearTimeInterval() {
  if (timeout) {
    clearInterval(timeout)
    expectedTimeout = null
    timeout = null
  }
}

function startTimer() {
  timerStore.start()
}

function stopTimer() {
  timerStore.stop()
}

function endBreak() {
  clearTimeInterval()
  timerStore.endBreak()
}

function pauseTimer() {
  timerStore.pause()
}

function resumeTimer() {
  timerStore.resume()
}
</script>

<template>
  <div>
    <div
      v-if="status === TimerStatus.Stopped"
      class="flex flex-col items-center gap-4"
    >
      <Report />
    </div>
    <template v-else>
      <Time />
      <div class="flex-center gap-6 text-3xl md:-mt-24 -mt-20">
        <Button
          v-if="status === TimerStatus.Idle"
          class="px-5 py-1"
          @click="startTimer"
        >
          START
        </Button>
        <template v-else>
          <Button
            v-if="status === TimerStatus.LongBreak || status === TimerStatus.ShortBreak"
            class="px-5 py-1"
            @click="endBreak"
          >
            END BREAK
          </Button>
          <Button
            v-else
            class="px-5 py-1"
            @click="status === TimerStatus.Paused ? resumeTimer() : pauseTimer()"
          >
            {{ status === TimerStatus.Paused ? 'RESUME' : 'PAUSE' }}
          </Button>
          <Button
            variant="danger"
            class="px-5 py-1"
            @click="stopTimer"
          >
            STOP
          </Button>
        </template>
        <!-- <Button
          class="px-5 py-1"
          @click="websocketTest"
        >
          WS
        </Button> -->
      </div>
    </template>
  </div>
</template>
