export default defineNuxtPlugin({
  name: 'auth',
  enforce: 'pre',
  async setup() {
    const fetch = useRequestFetch()
    const user = useUser()
    if (user.value) return
    try {
      const data = await fetch('/api/auth/me')
      user.value = data
    }
    catch {
      // ignored
    }
  },
})
