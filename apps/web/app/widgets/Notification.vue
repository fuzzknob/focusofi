<script setup lang="ts">
const { notificationEnabled, toggleMute } = useNotification()
</script>

<template>
  <button
    class="flex"
    :title="notificationEnabled.mute ? 'Unmute': 'Mute'"
    @click="toggleMute"
  >
    <Icon
      v-if="notificationEnabled.mute"
      name="memory:volume-mute"
      size="30"
    />
    <Icon
      v-else
      name="memory:volume-high"
      size="30"
    />
    <audio
      ref="notification-audio"
      class="hidden"
    />
  </button>
</template>
