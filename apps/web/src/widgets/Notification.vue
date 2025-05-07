<script setup lang="ts">
import { Icon } from '@iconify/vue'
import { TimerStatus } from '@/types/types'
import { useTimerStore } from '@/stores/timer'

const notificationState = useCookie('notification-audio', {
  default: () => ({ mute: false }),
})

const audio = useTemplateRef('notification-audio')

const timerStore = useTimerStore()
const { time, status } = storeToRefs(timerStore)

watch(time, (_, prev) => {
  if (prev != 0) return

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
    :title="notificationState.mute ? 'Unmute': 'Mute'"
    @click="toggleMute"
  >
    <Icon
      v-if="notificationState.mute"
      icon="memory:volume-mute"
      width="28"
      :ssr="true"
    />
    <Icon
      v-else
      icon="memory:volume-high"
      width="28"
      :ssr="true"
    />
    <audio
      ref="notification-audio"
      class="hidden"
    />
  </button>
</template>
