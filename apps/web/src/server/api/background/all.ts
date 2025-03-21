import type { User } from '~/types/types'
import { useDrizzle } from '~/server/services/drizzle'

export default defineEventHandler(async (event) => {
  if (!event.context.user) {
    setResponseStatus(event, 401)
    return {
      message: 'not logged in',
    }
  }
  const user = event.context.user as User
  if (user.role !== 'ADMIN') {
    setResponseStatus(event, 401)
    return { message: 'You don\'t have permission for this action' }
  }
  const db = useDrizzle()
  const backgrounds = await db.query.backgrounds.findMany()
  return backgrounds
})
