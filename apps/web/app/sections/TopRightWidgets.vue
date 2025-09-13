<script setup lang="ts">
import Account from '@/widgets/Account.vue'
import Settings from '@/widgets/Settings.vue'
</script>

<template>
  <div class="fixed top-5 right-5">
    <div class="flex gap-4">
      <Settings />
      <Account />
    </div>
  </div>
</template>
