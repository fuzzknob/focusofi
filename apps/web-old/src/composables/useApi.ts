import type { NitroFetchOptions, NitroFetchRequest } from 'nitropack/types'
import type { Fetch } from '~/types/types'

let baseURL = ''

export function setBaseUrl(url: string) {
  baseURL = url
}

export function useRequestApi(): Fetch {
  const fetch: Fetch = useRequestFetch()

  // eslint-disable-next-line
  // @ts-ignore
  return <T>(path: string, options?: NitroFetchOptions<NitroFetchRequest>) => {
    return fetch<T>(path, {
      ...options,
      baseURL,
      credentials: 'include',
    })
  }
}

export function useApi<T>(path: string) {
  const fetch = useRequestApi()
  return useAsyncData<T>(() => fetch<T>(path))
}

export async function api<T>(path: string, options?: NitroFetchOptions<NitroFetchRequest>) {
  return $fetch<T>(path, {
    ...options,
    baseURL,
    credentials: 'include',
  })
}
