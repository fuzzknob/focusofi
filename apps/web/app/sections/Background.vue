<script lang="ts" setup>
import { ref } from 'vue'
import type { Background } from '@/types'

const { $api } = useNuxtApp()
const { data } = await useApi<Background>('/background')

const image = ref(data.value?.img ?? '/default.gif')

async function refetchImage() {
  const { img } = await $api<Background>('/background')
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
  <Head>
    <Link
      prefetch
      :href="image"
    />
  </Head>
  <div
    class="fixed inset-0"
    :style="{ background: `url(${image}) no-repeat`, backgroundSize: 'cover' }"
  >
    <div class="bg-black/40 w-full h-full">
      <!-- <button @click="refetchImage">
        next
      </button> -->
    </div>
  </div>
</template>
