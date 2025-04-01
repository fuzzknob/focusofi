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
  if (user.role !== 'ADMIN') {
    setResponseStatus(event, 401)
    return { message: 'You don\'t have permission for this action' }
  }
  const id = getRouterParam(event, 'id')
  if (!id) {
    setResponseStatus(event, 400)
    return { message: 'There was an validation error' }
  }
  const db = useDrizzle()
  await db.delete(tables.backgrounds).where(eq(tables.backgrounds.id, Number(id)))
  return {
    message: 'success',
  }
})
