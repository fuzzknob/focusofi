<script setup lang="ts">
import { useUser } from '@/composables/useUser'

const user = useUser()

async function handleLogout() {
  await $fetch('/api/auth/logout')
  reloadNuxtApp()
}
</script>

<template>
  <div class="text-2xl cursor-pointer hover:text-purple-200">
    <button
      v-if="user"
      @click="handleLogout"
    >
      LOGOUT
    </button>
    <NuxtLink
      v-else
      to="/login"
    >
      SIGN IN
    </NuxtLink>
  </div>
</template>
