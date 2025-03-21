export function playAudio(name: string) {
  const audio = new Audio(`assets/sounds/${name}`)
  audio.volume = 0.5
  audio.play()
}

export function notifyLongBreak() {
  playAudio('long_break.mp3')
}

export function notifyShortBreak() {
  playAudio('short_break.mp3')
}

export function notifyWorkStart() {
  playAudio('work_start.mp3')
}
