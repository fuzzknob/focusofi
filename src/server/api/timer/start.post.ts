import { z } from 'zod'
import { tables, useDrizzle } from '~/server/services/drizzle'
import { sendEvent } from '~/server/services/event'
import { type User, TimerEvent, TimerStatus } from '~/types/types'

const startTimerSchema = z.object({
  startTime: z.coerce.date(),
})
export default defineEventHandler(async (event) => {
  if (!event.context.user) {
    setResponseStatus(event, 401)
    return {
      message: 'not logged in',
    }
  }
  const result = await readValidatedBody(event, startTimerSchema.safeParse)
  if (!result.success) {
    setResponseStatus(event, 400)
    return { message: 'There was an validation error', errors: result.error.issues }
  }
  const user = event.context.user as User
  const db = useDrizzle()
  let timer = await db
    .query
    .timers
    .findFirst({
      where: (timers, { eq }) => eq(timers.userId, user.id),
    })
  if (timer) {
    setResponseStatus(event, 400)
    return { message: 'Timer already started' }
  }
  const settings = await db.query.settings.findFirst({
    where: (settings, { eq }) => eq(settings.userId, user.id),
  })
  if (!settings) {
    setResponseStatus(event, 500)
    return { message: 'User settings not found' }
  }
  timer = await db.insert(tables.timers)
    .values({
      startTime: result.data.startTime,
      timerStartedAt: result.data.startTime,
      status: TimerStatus.Working,
      successionCount: settings.breakSuccessions,
      userId: user.id,
    }).returning().get()
  if (timer != null) {
    sendEvent(event, user, {
      event: TimerEvent.Start,
      timer: {
        startTime: timer.startTime,
        status: timer.status as TimerStatus,
        elapsedPrePause: timer.elapsedPrePause,
        successionCount: timer.successionCount,
        totalBreakTime: timer.breakTillStatusChange,
        totalWorkTime: timer.workTillStatusChange,
      },
    })
  }
  return {
    message: 'Started timer',
  }
})
