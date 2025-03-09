import { useSecureSession } from '~/server/libs/secure_session'

export default defineEventHandler(async (event) => {
  if (!event.context.user) {
    setResponseStatus(event, 401)
    return {
      message: 'not logged in',
    }
  }
  const session = await useSecureSession(event)
  const authorization = session.data.authorization as string | undefined
  if (!authorization) {
    return
  }
  const token = authorization.replace('Bearer ', '')
  hubKV().del(token)
  await session.clear()
  return { message: 'logged out' }
})
