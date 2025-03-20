import type { H3Event } from 'h3'
import type { SseEvent } from '@/types/types'

export async function sendEvent(event: H3Event, sseEvent: SseEvent) {
  const config = useRuntimeConfig(event)
  await $fetch(config.public.sseUrl, {
    method: 'POST',
    headers: {
      'Event-Token': config.sseEventSecret,
    },
    body: sseEvent,
  })
}
