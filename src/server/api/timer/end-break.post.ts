import { z } from 'zod'
import { eq, tables, useDrizzle } from '~/server/services/drizzle'
import { sendEvent } from '~/server/services/event'
import { type User, TimerEvent, TimerStatus } from '~/types/types'

const endBreakSchema = z.object({
  startTime: z.coerce.date(),
  successionCount: z.number(),
  totalWorkTime: z.number(),
  totalBreakTime: z.number(),
})
export default defineEventHandler(async (event) => {
  if (!event.context.user) {
    setResponseStatus(event, 401)
    return {
      message: 'not logged in',
    }
  }
  const result = await readValidatedBody(event, endBreakSchema.safeParse)
  if (!result.success) {
    setResponseStatus(event, 400)
    return { message: 'There was an validation error', errors: result.error.issues }
  }
  const user = event.context.user as User
  const db = useDrizzle()
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
  const { data } = result
  await db.update(tables.timers).set({
    status: TimerStatus.Working,
    startTime: data.startTime,
    successionCount: data.successionCount,
    workTillStatusChange: data.totalWorkTime,
    breakTillStatusChange: data.totalBreakTime,
  }).where(eq(tables.timers.userId, user.id))
  if (timer != null) {
    sendEvent(event, user, {
      event: TimerEvent.EndBreak,
      timer: {
        startTime: data.startTime,
        status: TimerStatus.Working,
        successionCount: data.successionCount,
        totalBreakTime: data.totalBreakTime,
        totalWorkTime: data.totalWorkTime,
        elapsedPrePause: timer.elapsedPrePause,
      },
    })
  }
  return {
    message: 'Ended Break',
  }
})
