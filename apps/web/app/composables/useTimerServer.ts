import type { Timer } from '@/types'

export const useTimerServer = () => {
  const { $api } = useNuxtApp()

  async function fetchTimer(): Promise<Timer | undefined> {
    try {
      const data = await $api<Timer>('/timer')

      if (data == null) return

      const { currentSequence } = data

      return {
        ...data,
        startedAt: new Date(data.startedAt),
        currentSequence: {
          ...data.currentSequence,
          startTime: currentSequence.startTime && new Date(currentSequence.startTime),
          blocks: currentSequence.blocks.map(block => ({
            ...block,
            startTime: block.startTime && new Date(block.startTime),
          })),
        },
      }
    }
    catch (e) {
      console.error(e)
    }
  }

  async function startTimer(time: Date) {
    try {
      await $api('/timer/start', {
        method: 'POST',
        body: {
          time,
        },
      })
    }
    catch (e) {
      console.error(e)
    }
  }

  async function stopTimer(time: Date) {
    try {
      await $api('/timer/stop', {
        method: 'POST',
        body: {
          time,
        },
      })
    }
    catch (e) {
      console.error(e)
    }
  }

  async function resetTimer() {
    try {
      await $api('/timer/reset', {
        method: 'POST',
      })
    }
    catch (e) {
      console.error(e)
    }
  }

  async function pauseTimer(time: Date) {
    try {
      await $api('/timer/pause', {
        method: 'POST',
        body: {
          time,
        },
      })
    }
    catch (e) {
      console.error(e)
    }
  }

  async function resumeTimer(time: Date) {
    try {
      await $api('/timer/resume', {
        method: 'POST',
        body: {
          time,
        },
      })
    }
    catch (e) {
      console.error(e)
    }
  }

  async function skipTimer(time: Date) {
    try {
      await $api('/timer/skip', {
        method: 'POST',
        body: {
          time,
        },
      })
    }
    catch (e) {
      console.error(e)
    }
  }

  async function extendLength(length: number) {
    try {
      await $api('/timer/extend-length', {
        method: 'POST',
        body: {
          length,
        },
      })
    }
    catch (e) {
      console.error(e)
    }
  }

  return {
    startTimer,
    stopTimer,
    resetTimer,
    pauseTimer,
    resumeTimer,
    fetchTimer,
    skipTimer,
    extendLength,
  }
}
