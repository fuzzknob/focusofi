export default defineEventHandler(async (event) => {
  if (!event.context.user) {
    setResponseStatus(event, 401)
    return {
      message: 'not logged in',
    }
  }
  const { token } = getQuery<{ token?: boolean }>(event)
  if (token) {
    return {
      token: event.context.token,
      user: event.context.user,
    }
  }
  return event.context.user
})
