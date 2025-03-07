import { z } from 'zod'
import { tables, useDrizzle } from '~/server/services/drizzle'
import type { User } from '~/types/types'

const requestLoginSchema = z.object({
  img: z.string().trim().url(),
})
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
  const result = await readValidatedBody(event, requestLoginSchema.safeParse)
  if (!result.success) {
    setResponseStatus(event, 400)
    return { message: 'There was an validation error', errors: result.error.issues }
  }
  const img = result.data.img
  const db = useDrizzle()
  const background = await db.insert(tables.backgrounds).values({ img }).returning().get()
  return background
})
