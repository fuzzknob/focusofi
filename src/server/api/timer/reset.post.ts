import { tables, useDrizzle, eq } from '~/server/services/drizzle'
import type { User } from '~/types/types'

export default defineEventHandler(async (event) => {
  if (!event.context.user) {
    setResponseStatus(event, 401)
    return {
      message: 'not logged in',
    }
  }
  const user = event.context.user as User
  const db = useDrizzle()
  const timer = await db.delete(tables.timers).where(eq(
    tables.timers.userId,
    user.id,
  )).returning().get()
  if (!timer) {
    setResponseStatus(event, 400)
    return { message: 'There is no running timer' }
  }
  return {
    message: 'Reset Timer',
  }
})
