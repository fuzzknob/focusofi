import { addMilliseconds, isBefore, differenceInSeconds, isEqual } from 'date-fns'

import { useDrizzle, tables, eq } from '~/server/services/drizzle'
import { type User, type Settings, type Timer, TimerStatus } from '@/types/types'

export default defineEventHandler(async (event) => {
  if (!event.context.user) {
    setResponseStatus(event, 401)
    return {
      message: 'not logged in',
    }
  }
  const user = event.context.user as User
  const db = useDrizzle()
  const timer = await db.query.timers.findFirst({
    where: (timers, { eq }) => eq(timers.userId, user.id),
  })
  if (!timer) return
  if (timer.status === TimerStatus.Paused) {
    return {
      status: timer.status,
      elapsedPrePause: timer.elapsedPrePause,
      successionCount: timer.successionCount,
      totalBreakTime: timer.breakTillStatusChange,
      totalWorkTime: timer.workTillStatusChange,
      startTime: timer.startTime,
    } as Timer
  }
  const settings = await db.query.settings.findFirst({
    where: (settings, { eq }) => eq(settings.userId, user.id),
  })
  if (!settings) return
  const current = calculateCurrentTimer({ timer: {
    startTime: timer.startTime,
    status: timer.status as TimerStatus,
    elapsedPrePause: timer.elapsedPrePause,
    successionCount: timer.successionCount,
    totalBreakTime: timer.breakTillStatusChange,
    totalWorkTime: timer.workTillStatusChange,
  }, settings })

  if (
    current.status !== timer.status
    || current.successionCount !== timer.successionCount
    || !isEqual(current.startTime, timer.startTime)
  ) {
    await db.update(tables.timers).set({
      startTime: current.startTime,
      status: current.status,
      successionCount: current.successionCount,
      elapsedPrePause: 0,
      breakTillStatusChange: current.totalBreakTime,
      workTillStatusChange: current.totalWorkTime,
    }).where(eq(tables.timers.userId, user.id))
  }
  return current
})

function calculateCurrentTimer({ settings, timer }: {
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
