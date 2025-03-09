import { useSecureSession } from '../libs/secure_session'
import type { Session } from '~/types/types'

export default defineEventHandler(async (event) => {
  if (!useRuntimeConfig(event).cookiePassword) return
  const h3session = await useSecureSession(event)
  const authorization = h3session.data.authorization as string | undefined
  if (!authorization) {
    return
  }
  const token = authorization.replace('Bearer ', '')
  const session = await hubKV().get<Session>(token)
  if (!session) return
  event.context.user = session.user
})
