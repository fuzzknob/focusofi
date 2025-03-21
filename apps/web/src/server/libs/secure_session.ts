import type { H3Event } from 'h3'

export function useSecureSession(event: H3Event) {
  return useSession(event, {
    password: useRuntimeConfig(event).cookiePassword,
    maxAge: 365 * 86400,
  })
}
