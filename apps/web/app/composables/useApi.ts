import type { AsyncDataOptions } from 'nuxt/app'

export function useApi<T>(
  path: string,
  options?: AsyncDataOptions<T>,
) {
  return useAsyncData<T>(path, () => useNuxtApp().$api<T>(path), options)
}
