import type { User } from '~/types/types'

export default defineNuxtPlugin({
  name: 'init',
  enforce: 'pre',
  async setup() {
    const runtime = useRuntimeConfig()

    setBaseUrl(runtime.public.apiBase)

    const fetch = useRequestApi()
    const user = useUser()

    if (user.value) return

    try {
      const data = await fetch<User>('/auth/me')
      user.value = data
    }
    catch {
      // ignored
    }
  },
})
