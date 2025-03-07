<script lang="ts" setup>
const isFullScreen = ref(false)

onMounted(() => {
  document.body.addEventListener('fullscreenchange', () => {
    isFullScreen.value = !!document.fullscreenElement
  })
})

async function toggleFullScreen() {
  if (document.fullscreenElement) {
    await document.exitFullscreen()
    return
  }
  await document.body.requestFullscreen()
}
</script>

<template>
  <button
    class="cursor-pointer"
    @click="toggleFullScreen"
  >
    <div class="icon">
      <img
        class="w-full"
        :src="isFullScreen ? '/assets/contract.png': '/assets/expand.png'"
      >
    </div>
  </button>
</template>

<style scoped>
.icon {
  width: 25px;
  height: 25px;

  img {
    image-rendering: crisp-edges;
  }
}
</style>
