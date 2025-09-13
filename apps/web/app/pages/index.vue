<script setup lang="ts">
import Timer from '@/sections/Timer/Timer.vue'
import Background from '@/sections/Background.vue'
import TopLeftWidgets from '@/sections/TopLeftWidgets.vue'
import TopRightWidgets from '@/sections/TopRightWidgets.vue'
import BottomLeftWidgets from '@/sections/BottomLeftWidgets.vue'
import BottomRightWidgets from '@/sections/BottomRightWidgets.vue'

useHead({
  link: [
    {
      rel: 'preload',
      href: 'assets/sounds/long_break.mp3',
      as: 'audio',
    },
    {
      rel: 'preload',
      href: 'assets/sounds/short_break.mp3',
      as: 'audio',
    },
    {
      rel: 'preload',
      href: 'assets/sounds/work_start.mp3',
      as: 'audio',
    },
  ],
})
</script>

<template>
  <main class="h-screen w-screen bg-black text-white flex-center">
    <Background />
    <TopLeftWidgets />
    <TopRightWidgets />

    <div class="absolute flex flex-col">
      <Timer />
    </div>

    <BottomLeftWidgets />
    <BottomRightWidgets />
  </main>
</template>
