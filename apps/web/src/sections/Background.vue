<script lang="ts" setup>
import { ref } from 'vue'

const { data } = await useFetch('/api/background')

const image = ref(data.value?.img ?? '/1.gif')

async function refetchImage() {
  const { img } = await $fetch('/api/background')
  const imageElement = new Image()
  imageElement.onload = () => {
    image.value = img ?? ''
  }
  imageElement.src = img ?? ''
}

onMounted(() => {
  setInterval(() => {
    refetchImage()
  }, 300000)
})
</script>

<template>
  <div
    class="fixed inset-0"
    :style="{ background: `url(${image}) no-repeat`, backgroundSize: 'cover' }"
  >
    <div class="bg-black/40 w-full h-full">
      <!-- <button @click="() => console.log('some')">
        next
      </button> -->
    </div>
  </div>
</template>
