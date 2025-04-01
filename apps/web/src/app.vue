<script setup lang="ts">
import { useSettingsStore } from '@/stores/settings'

const fetch = useRequestFetch()

const settingsStore = useSettingsStore()
const timerStore = useTimerStore()

await callOnce(async () => {
  await settingsStore.getSettings(fetch)
  await timerStore.getTimer(fetch)
})

onMounted(async () => {
  if (!settingsStore.hasFetched) {
    await settingsStore.getSettings(fetch)
  }
})
</script>

<template>
  <div>
    <Head>
      <Title>Pomo - Alpha Version</Title>
    </Head>
    <NuxtPage />
  </div>
</template>
