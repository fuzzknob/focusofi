export default defineNuxtRouteMiddleware(async () => {
  const user = useUser()

  if (user.value == null || user.value.role !== 'ADMIN') {
    return navigateTo('/')
  }
})
