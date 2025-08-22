<script lang="ts" setup>
const { getSettings, isSettingsFetched } = useSettings()
const { initTimerServer, initTimerClient } = useTimer()

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
</script>

<template>
  <div>
    <Head>
      <Title>Focusofi - Beta Version</Title>
    </Head>
    <NuxtPage />
  </div>
</template>
