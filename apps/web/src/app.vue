<script setup lang="ts">
import { useSettingsStore } from '@/stores/settings'
import { useRequestApi } from '@/composables/useApi'

const fetch = useRequestApi()

const settingsStore = useSettingsStore()
const timerStore = useTimerStore()

await callOnce(async () => {
  await settingsStore.getSettings(fetch)
  await timerStore.getTimer(fetch)
})

onMounted(async () => {
  if (!settingsStore.hasFetched) {
    await settingsStore.getSettings(fetch)
    await timerStore.getTimer(fetch)
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
