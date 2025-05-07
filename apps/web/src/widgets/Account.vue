<script setup lang="ts">
import { Icon } from '@iconify/vue'
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
    @click="handleLogout"
  >
    <Icon
      icon="memory:logout"
      width="25"
      :ssr="true"
    />
  </button>
  <NuxtLink
    v-else
    title="Login"
    to="/login"
  >
    <Icon
      icon="memory:login"
      width="25"
      :ssr="true"
    />
  </NuxtLink>
</template>
