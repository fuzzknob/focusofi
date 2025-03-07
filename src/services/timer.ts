import type { Fetch, Timer } from '~/types/types'

export async function fetchTimer(fetch: Fetch) {
  try {
    const data = await fetch<Timer>('/api/timer')
    return data
  }
  catch {
    // ignored
  }
}

export async function startTimer(startTime: Date) {
  await $fetch('/api/timer/start', {
    method: 'POST',
    body: {
      startTime,
    },
  })
}

export async function pauseTimer(body: {
  elapsedPrePause: number
  successionCount: number
  totalWorkTime: number
  totalBreakTime: number
}) {
  await $fetch('/api/timer/pause', {
    method: 'POST',
    body,
  })
}

export async function resumeTimer(startTime: Date) {
  await $fetch('/api/timer/resume', {
    method: 'POST',
    body: {
      startTime,
    },
  })
}

export async function endBreak(body: {
  startTime: Date
  successionCount: number
  totalWorkTime: number
  totalBreakTime: number
}) {
  await $fetch('/api/timer/end-break', {
    method: 'POST',
    body,
  })
}

export async function stopTimer(body: {
  endTime: Date
  totalWorkTime: number
  totalBreakTime: number
}) {
  await $fetch('/api/timer/stop', {
    method: 'POST',
    body,
  })
}

export async function resetTimer() {
  await $fetch('/api/timer/reset', {
    method: 'POST',
  })
}
