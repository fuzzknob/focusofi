import { isEqual } from 'date-fns'

import { useDrizzle, tables, eq } from '~/server/services/drizzle'
import { type User, type Timer, TimerStatus } from '@/types/types'
import { calculateCurrentTimer } from '@/server/services/timer'

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
