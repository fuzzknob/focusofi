// import type { H3Event } from 'h3'
import { useSecureSession } from '../libs/secure_session'
import { useDrizzle, eq, tables } from '../services/drizzle'

// const activeRoutes = [
//   '/auth/logout',
//   '/auth/me',
//   '/background/all',
//   '/background-POST',
// ]

// function getRoute(event: H3Event) {
//   const path = event.path.replace('/api', '')
//   if (event.method === 'GET') {
//     return path
//   }
//   return `${path}-${event.method}`
// }

export default defineEventHandler(async (event) => {
  // const route = getRoute(event)
  // if (!activeRoutes.includes(route)) {
  //   return
  // }
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
