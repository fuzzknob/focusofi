import { useSecureSession } from '~/server/libs/secure_session'
import { eq, tables, useDrizzle } from '~/server/services/drizzle'
import type { User } from '~/types/types'

export default defineEventHandler(async (event) => {
  if (!event.context.user) {
    setResponseStatus(event, 401)
    return {
      message: 'not logged in',
    }
  }
  const user = event.context.user as User
  const session = await useSecureSession(event)
  await session.clear()
  const db = useDrizzle()
  await db.delete(tables.sessions).where(eq(tables.sessions.userId, Number(user.id)))
  return { message: 'logged out' }
})
