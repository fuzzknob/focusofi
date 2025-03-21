import type { H3Event } from 'h3'
import type { SseEvent, User } from '@/types/types'

export async function sendEvent(event: H3Event, user: User, sseEvent: SseEvent) {
  const config = useRuntimeConfig(event)
  await $fetch(config.public.sseUrl, {
    method: 'POST',
    headers: {
      'Event-Token': config.sseEventSecret,
    },
    body: {
      user: user.email,
      event: sseEvent,
    },
  })
}
