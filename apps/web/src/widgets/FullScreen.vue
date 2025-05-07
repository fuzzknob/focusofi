<script lang="ts" setup>
const { isFullscreen, toggle } = useFullscreen()
const { f } = useMagicKeys()

watch(f, () => {
  toggle()
})
</script>

<template>
  <button
    :title="isFullscreen ? 'Exit Fullscreen (F)' : 'Enter Fullscreen (F)'"
    @click="toggle"
  >
    <div class="icon">
      <img
        class="w-full"
        :src="isFullscreen ? '/assets/contract.png': '/assets/expand.png'"
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
