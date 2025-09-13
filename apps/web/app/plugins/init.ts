import type { NitroFetchOptions, NitroFetchRequest } from 'nitropack/types'

export default defineNuxtPlugin({
  enforce: 'pre',
  async setup() {
    const config = useRuntimeConfig()

    const fetch = useRequestFetch()

    const api = <T>(path: string, options?: NitroFetchOptions<NitroFetchRequest>) => fetch<T>(path, {
      ...options,
      baseURL: config.public.apiBase,
      credentials: 'include',
    })

    return {
      provide: {
        api,
      },
    }
  },
})
