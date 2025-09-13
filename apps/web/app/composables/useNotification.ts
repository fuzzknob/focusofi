import { BlockType } from '../types'

export const useNotification = () => {
  const notificationEnabled = useCookie('notification-audio', {
    default: () => ({ mute: false }),
  })

  function playAudio(name: string) {
    if (notificationEnabled.value.mute) return

    const audio = new Audio(`assets/sounds/${name}`)
    audio.volume = 0.5
    audio.play()
  }

  function toggleMute() {
    notificationEnabled.value.mute = !notificationEnabled.value.mute
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
