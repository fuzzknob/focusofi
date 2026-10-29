import { BlockType } from '../types'

export const useNotification = () => {
  const notificationEnabled = useCookie('notification-audio', {
    default: () => ({ mute: false }),
  })

  function playAudio(name: string) {
    if (notificationEnabled.value.mute) return

    const audio = document.getElementById('notification-player') as HTMLAudioElement

    audio.src = `assets/sounds/${name}`

    audio.volume = 0.5

    audio.play()
  }

  function toggleMute() {
    notificationEnabled.value.mute = !notificationEnabled.value.mute

    const audio = document.getElementById('notification-player') as HTMLAudioElement

    if (notificationEnabled.value.mute) {
      audio.volume = 0
    } else {
      audio.volume = 0.5
    }
  }

  function notifyLongBreak() {
    playAudio('long_break.mp3')
  }

  function notifyShortBreak() {
    playAudio('short_break.mp3')
  }

  function notifyWorkStart() {
    playAudio('work_start.mp3')
  }

  function notify(type: BlockType) {
    if (type === BlockType.shortBreak) {
      return notifyShortBreak()
    }

    if (type === BlockType.longBreak) {
      return notifyLongBreak()
    }

    return notifyWorkStart()
  }

  return {
    notificationEnabled,

    toggleMute,
    notify,
  }
}
