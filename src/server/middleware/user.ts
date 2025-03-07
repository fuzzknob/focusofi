import { useSecureSession } from '../libs/secure_session'
import { useDrizzle, eq, tables } from '../services/drizzle'

export default defineEventHandler(async (event) => {
  const h3session = await useSecureSession(event)
  const authorization = h3session.data.authorization as string | undefined
  if (!authorization) {
    return
  }
  const token = authorization.replace('Bearer ', '')
  const db = useDrizzle()
  const session = await db.query.sessions.findFirst({
    where: eq(tables.sessions.token, token),
    with: {
      user: true,
    },
  })
  if (!session) return
  event.context.user = session.user
})
