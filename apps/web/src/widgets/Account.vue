<script setup lang="ts">
import { useUser } from '@/composables/useUser'

const user = useUser()

async function handleLogout() {
  await api('/auth/logout')
  reloadNuxtApp()
}
</script>

<template>
  <button
    v-if="user"
    title="Logout"
    class="flex"
    @click="handleLogout"
  >
    <Icon
      name="memory:logout"
      size="25"
    />
  </button>
  <NuxtLink
    v-else
    title="Login"
    to="/login"
  >
    <Icon
      name="memory:login"
      size="25"
    />
  </NuxtLink>
</template>
