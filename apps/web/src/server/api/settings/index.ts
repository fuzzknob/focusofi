import { useDrizzle } from '~/server/services/drizzle'
import type { User } from '~/types/types'

export default defineCachedEventHandler(async (event) => {
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
}, {
  // 30 days
  maxAge: 60 * 60 * 24 * 30,
  swr: true,
  getKey(event) {
    const userId = event.context.user.id
    return `/api/settings/${userId}`
  },
  shouldBypassCache(event) {
    return !event.context.user
  },
})
