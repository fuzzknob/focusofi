<script setup lang="ts">
const user = useUser()
const { $api } = useNuxtApp()

async function handleLogout() {
  await $api('/auth/logout')
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
