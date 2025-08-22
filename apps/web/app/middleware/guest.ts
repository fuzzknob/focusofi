export default defineNuxtRouteMiddleware(async () => {
  const user = useUser()

  if (user.value != null) {
    return navigateTo('/')
  }
})
