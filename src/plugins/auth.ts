import type { User } from '~/types/types'

export default defineNuxtPlugin({
  name: 'auth',
  enforce: 'pre',
  async setup() {
    const fetch = useRequestFetch()
    const user = useUser()
    const token = useToken()
    if (user.value) return
    try {
      const data = await fetch<{ user: User, token: string }>('/api/auth/me?token=true')
      user.value = data.user
      token.value = data.token
    }
    catch {
      // ignored
    }
  },
})
