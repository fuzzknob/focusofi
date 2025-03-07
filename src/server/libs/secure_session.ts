import type { H3Event } from 'h3'

export function useSecureSession(event: H3Event) {
  return useSession(event, {
    password: process.env.COOKIE_PASSWORD ?? 'oooh-its-the-password',
    maxAge: 365 * 86400,
  })
}
