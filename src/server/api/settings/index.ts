import { useDrizzle } from '~/server/services/drizzle'
import type { User } from '~/types/types'

export default defineEventHandler(async (event) => {
  if (!event.context.user) {
    setResponseStatus(event, 401)
    return {
      message: 'not logged in',
    }
  }
  const db = useDrizzle()
  const user = event.context.user as User
  const settings = await db.query.settings.findFirst({
    where: (settings, { eq }) => eq(settings.userId, user.id),
  })
  return settings
})
