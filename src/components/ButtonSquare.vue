<script setup lang="ts">
const variants = {
  primary: 'bg-purple-700 hover:bg-purple-500 disabled:bg-purple-400',
  secondary: 'bg-green-500 hover:bg-green-400 disabled:bg-green-300',
  danger: 'bg-red-500 hover:bg-red-400 disabled:bg-red-300',
}

const { type = 'button', disabled = false, variant = 'primary' } = defineProps<{
  variant?: 'primary' | 'secondary' | 'danger'
  type?: 'submit' | 'reset' | 'button'
  disabled?: boolean
}>()
const style = computed(() => {
  return variants[variant]
})
</script>

<template>
  <button
    :type="type"
    :disabled="disabled"
    :class="style"
    class="text-white px-4 py-1 cursor-pointer disabled:cursor-default"
  >
    <slot />
  </button>
</template>
