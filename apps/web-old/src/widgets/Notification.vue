<script setup lang="ts">
import { TimerStatus } from '@/types/types'
import { useTimerStore } from '@/stores/timer'

const notificationState = useCookie('notification-audio', {
  default: () => ({ mute: false }),
})

const audio = useTemplateRef('notification-audio')

const timerStore = useTimerStore()
const { time, status, previousStatus } = storeToRefs(timerStore)

watch(time, (_, prev) => {
  if (prev != 0 || previousStatus.value === TimerStatus.Idle) return

  const audioElement = audio.value

  if (audioElement == null) return

  const notificationSound = getNotificationSound()

  if (notificationSound == null) return

  audioElement.src = notificationSound

  audioElement.play()
})

onMounted(() => {
  const audioElement = audio.value

  if (audioElement == null) return

  audioElement.volume = 0.5

  audioElement.muted = notificationState.value.mute
})

function toggleMute() {
  const currentState = !notificationState.value.mute
  notificationState.value.mute = currentState
  audio.value!.muted = currentState
}

function getNotificationSound() {
  const base = 'assets/sounds/'

  if (status.value === TimerStatus.Working) return base + 'work_start.mp3'

  if (status.value === TimerStatus.ShortBreak) return base + 'short_break.mp3'

  if (status.value === TimerStatus.LongBreak) return base + 'long_break.mp3'
}
</script>

<template>
  <button
    class="flex"
    :title="notificationState.mute ? 'Unmute': 'Mute'"
    @click="toggleMute"
  >
    <Icon
      v-if="notificationState.mute"
      name="memory:volume-mute"
      size="30"
    />
    <Icon
      v-else
      name="memory:volume-high"
      size="30"
    />
    <audio
      ref="notification-audio"
      class="hidden"
    />
  </button>
</template>
