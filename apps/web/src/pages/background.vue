<script lang="ts" setup>
import Button from '@/components/ButtonSquare.vue'
import type { Background } from '@/types/types'

const newImg = ref('')
const isAdding = ref(false)

const { data: backgrounds } = await useApi<Background[]>('/background/all')

useHead({
  title: 'Background Config - Focusofi',
})

async function handleAdd() {
  const newImage = newImg?.value.trim() || ''
  const isPresent = !!(backgrounds.value?.filter(background => background.img.trim() === newImage).length)
  if (isPresent) {
    alert('Image already exist')
    return
  }
  isAdding.value = true
  try {
    const background = await api<Background>('/background', {
      method: 'POST',
      body: {
        img: newImage,
      },
    })
    backgrounds.value = [background].concat(backgrounds.value ?? [])
    newImg.value = ''
  }
  catch (e) {
    if (e instanceof Error) {
      alert(e.message)
    }
  }
  finally {
    isAdding.value = false
  }
}

async function handleDelete(id: number) {
  try {
    await api(`/background/${id}`, {
      method: 'DELETE',
    })
    backgrounds.value = backgrounds.value?.filter(background => background.id !== id) ?? []
  }
  catch (e) {
    if (e instanceof Error) {
      alert(e.message)
    }
  }
}
</script>

<template>
  <div class="flex flex-col gap-4 m-auto max-w-[1792px] mt-4">
    <form
      class="flex justify-center"
      @submit.prevent="handleAdd"
    >
      <input
        v-model="newImg"
        class="border px-2 py-1 w-2xl outline-none"
      >
      <Button type="submit">
        {{ isAdding ? 'ADDING...' : 'ADD' }}
      </Button>
    </form>
    <div class="flex flex-wrap">
      <div
        v-for="background in backgrounds"
        :key="background.id"
        :style="{ background: `url(${background.img}) no-repeat`, backgroundSize: 'cover' }"
        class="min-w-md h-[300px]"
      >
        <div class="flex-center w-full h-full text-white bg-black/30 opacity-0 hover:opacity-100">
          <button
            class="text-2xl cursor-pointer"
            @click="() => handleDelete(background.id)"
          >
            DELETE
          </button>
        </div>
      </div>
    </div>
  </div>
</template>
