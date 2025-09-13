<script lang="ts" setup>
const { getSettings, isSettingsFetched } = useSettings()
const { initTimerServer, initTimerClient, syncWithEvent } = useTimer()

const user = useUser()
const runtimeConfig = useRuntimeConfig()

let eventSource: EventSource | null = null

await callOnce(async () => {
  await getSettings()
  await initTimerServer()
})

onMounted(async () => {
  if (!isSettingsFetched) {
    await getSettings()
  }

  initTimerClient()
})

onMounted(() => {
  if (user.value == null) return

  eventSource = new EventSource(`${runtimeConfig.public.apiBase}/events`, {
    withCredentials: true,
  })

  eventSource.addEventListener('timer-event', ({ data }: MessageEvent) => {
    if (data == null) return

    syncWithEvent(JSON.parse(data))
  })
})

onUnmounted(() => {
  eventSource?.close()
  eventSource = null
})
</script>

<template>
  <div>
    <Head>
      <Title>Focusofi - Beta Version</Title>
    </Head>
    <NuxtPage />
  </div>
</template>
