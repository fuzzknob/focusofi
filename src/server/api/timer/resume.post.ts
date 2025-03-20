import { z } from 'zod'
import { tables, useDrizzle } from '~/server/services/drizzle'
import { sendEvent } from '~/server/services/event'
import { type User, TimerEvent, TimerStatus } from '~/types/types'

const resumeTimerSchema = z.object({
  startTime: z.coerce.date(),
})
export default defineEventHandler(async (event) => {
  if (!event.context.user) {
    setResponseStatus(event, 401)
    return {
      message: 'not logged in',
    }
  }
  const result = await readValidatedBody(event, resumeTimerSchema.safeParse)
  if (!result.success) {
    setResponseStatus(event, 400)
    return { message: 'There was an validation error', errors: result.error.issues }
  }
  const user = event.context.user as User
  const db = useDrizzle()
  const { data } = result
  const timer = await db
    .query
    .timers
    .findFirst({
      where: (timers, { eq }) => eq(timers.userId, user.id),
    })
  if (!timer) {
    setResponseStatus(event, 400)
    return { message: 'There is no running timer' }
  }
  if (timer.status !== TimerStatus.Paused) {
    setResponseStatus(event, 400)
    return { message: 'The timer is not paused' }
  }
  await db.update(tables.timers).set({
    startTime: data.startTime,
    status: TimerStatus.Working,
    elapsedPrePause: 0,
  })
  if (timer != null) {
    sendEvent(event, {
      event: TimerEvent.Resume,
      timer: {
        startTime: data.startTime,
        status: TimerStatus.Working,
        elapsedPrePause: 0,
        successionCount: timer.successionCount,
        totalWorkTime: timer.workTillStatusChange,
        totalBreakTime: timer.breakTillStatusChange,
      },
    })
  }
  return {
    message: 'Resumed Timer',
  }
})
