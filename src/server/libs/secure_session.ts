import type { H3Event } from 'h3'

export function useSecureSession(event: H3Event) {
  const config = useRuntimeConfig(event)
  return useSession(event, {
    password: config.cookiePassword,
    maxAge: 365 * 86400,
  })
}
