import { addMilliseconds, isBefore, differenceInSeconds } from 'date-fns'
import { type Settings, type Timer, TimerStatus } from '@/types/types'

export function calculateCurrentTimer({ settings, timer }: {
  settings: Settings
  timer: Timer
}) {
  const now = new Date()
  const state: Timer = {
    startTime: timer.startTime,
    status: timer.status,
    successionCount: timer.successionCount,
    totalWorkTime: timer.totalWorkTime,
    totalBreakTime: timer.totalBreakTime,
    elapsedPrePause: 0,
  }
  while (true) {
    if (state.status === TimerStatus.Working) {
      const endTime = addMilliseconds(state.startTime, settings.workLength * 1000)
      if (isBefore(endTime, now)) {
        if (state.successionCount <= 1) {
          state.status = TimerStatus.LongBreak
          state.successionCount = settings.breakSuccessions
        }
        else {
          state.status = TimerStatus.ShortBreak
          state.successionCount -= 1
        }
        state.totalWorkTime += settings.workLength
        state.startTime = endTime
        continue
      }
      state.totalWorkTime += settings.workLength - differenceInSeconds(endTime, now)
    }
    else if (state.status === TimerStatus.ShortBreak) {
      const endTime = addMilliseconds(state.startTime, settings.shortBreakLength * 1000)
      if (isBefore(endTime, now)) {
        state.status = TimerStatus.Working
        state.startTime = endTime
        state.totalBreakTime += settings.shortBreakLength
        continue
      }
      state.totalBreakTime += settings.shortBreakLength - differenceInSeconds(endTime, now)
    }
    else if (state.status === TimerStatus.LongBreak) {
      const endTime = addMilliseconds(state.startTime, settings.longBreakLength * 1000)
      if (isBefore(endTime, now)) {
        state.status = TimerStatus.Working
        state.startTime = endTime
        state.totalBreakTime += settings.longBreakLength
        continue
      }
      state.totalBreakTime += settings.longBreakLength - differenceInSeconds(endTime, now)
    }
    return state
  }
}
