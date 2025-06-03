<script lang="ts" setup>
import { getMilliseconds, isEqual } from 'date-fns'

import Time from './components/Time.vue'
import Report from './components/Report.vue'
import Button from '@/components/Button.vue'

import { TimerStatus, TimerAction, type SseEvent, type SettingsUpdatedEvent } from '@/types/types'
import { useTimerStore } from '@/stores/timer'

const user = useUser()
const runtimeConfig = useRuntimeConfig()
const timerStore = useTimerStore()
const { status } = storeToRefs(timerStore)

const settingStore = useSettingsStore()

let timeout: NodeJS.Timeout | number | null = null
let expectedTimeout: number | null = null
let eventSource: EventSource | null = null

onMounted(() => {
  adjustTimer()
})

onMounted(() => {
  if (user == null) return

  eventSource = new EventSource(`${runtimeConfig.public.apiBase}/events`, {
    withCredentials: true,
  })

  eventSource.addEventListener('timer-event', ({ data }: MessageEvent) => {
    if (data == null) return

    const { action, timer } = JSON.parse(data) as SseEvent

    if (action === TimerAction.Reset) {
      timerStore.reset({ noSend: true })
      return
    }

    if (
      timerStore.startTime
      && isEqual(timerStore.startTime, timer.startTime)
      && timerStore.status === timer.status
    ) {
      return
    }

    clearTimeInterval()

    timerStore.setTimer(timer)

    adjustTimer()
  })

  eventSource.addEventListener('settings-updated-event', ({ data }: MessageEvent) => {
    if (data == null) return

    const { settings, timer } = JSON.parse(data) as SettingsUpdatedEvent

    settingStore.setSettings(settings)

    if (timer == null) return

    clearTimeInterval()

    timerStore.setTimer(timer)

    adjustTimer()
  })
})

onUnmounted(() => {
  eventSource?.close()
  eventSource = null
})

function adjustTimer() {
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
}

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
  tick()
}

function stopTimer() {
  timerStore.stop()
  clearTimeInterval()
}

function endBreak() {
  clearTimeInterval()
  timerStore.endBreak()
  tick()
}

function pauseTimer() {
  timerStore.pause()
  clearTimeInterval()
}

function resumeTimer() {
  timerStore.resume()
  tick()
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
      </div>
    </template>
  </div>
</template>
