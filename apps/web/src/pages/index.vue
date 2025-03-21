<script setup lang="ts">
import Timer from '~/sections/Timer/Timer.vue'
// import Clock from '~/sections/Clock/Clock.vue'
import Background from '~/sections/Background.vue'
import ToggleFullScreen from '~/sections/ToggleFullScreen.vue'
import Account from '~/sections/Account.vue'

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
    <Account class="fixed top-5 right-5" />
    <div class="absolute flex flex-col">
      <!-- <Clock /> -->
      <Timer />
    </div>
    <ToggleFullScreen class="absolute z-20 text-8xl bottom-5 right-5" />
  </main>
</template>
